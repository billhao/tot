//
//  AppDelegate.m
//  totdev
//
//  Created by Lixing Huang on 4/11/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "AppDelegate.h"
#import "totUITabBarController.h"

#import "test_Model.h"
#import "totEventName.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize rootController, loginController, newbabyController;
@synthesize mBabyId;
@synthesize mCache;

- (void)alloc {
    loginController = nil;
}

- (void)dealloc
{
    if(loginController!=nil) [loginController release];
    [rootController release];
    [_window release];
    [super dealloc];
}

- (totModel*) getDataModel {
    return mTotData;
}

// get current logged in account, return nil if none
- (NSString*) isLoggedIn {
    return [mTotData getPreferenceNoBaby:PREFERENCE_LOGGED_IN];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    
    //self.window.backgroundColor = [UIColor whiteColor];
    return [self showFirstView];
}

// determine the first view (new baby, login or homepage) and show it
- (BOOL)showFirstView {
    // default baby id
    mBabyId = PREFERENCE_NO_BABY;
    
    // initialize the image cache
    mCache = [[totImageCache alloc] init];
    
    // initialize database
    mTotData = [[totModel alloc] init];
    
    // get # accounts in db
    int account = [mTotData getAccountCount];

    // general method to test a code snippet, which could be just empty
//    test_Model* test = [[test_Model alloc] init];
//    BOOL re = [test test];
//    if( !re ) return FALSE;
    
    // output some system information
    NSLog(@"App data path = %@", [mTotData GetDocumentDirectory]);
    NSLog(@"# Acc = %d", account);

    if( account == 0 ) {
        // show new baby view if no account exists
        [self showNewBabyView];
    }
    else {
        // if logged in then show home view, otherwise show login view
        NSString* email = [self isLoggedIn];
        BOOL loggedin = (email!=nil);
        if( loggedin ) {
            [self showHomeView];
            
            // TODO get active baby id
            mBabyId = 1;
        }
        else {
            [self showLoginView:-1];
        }
    }
    return YES;
}

- (void)showNewBabyView {
    // remove all other sub views
    for (UIView* view in self.window.subviews) {
        [view removeFromSuperview];
    }
    
    // show new baby
    newbabyController = [[totNewBabyController alloc] initWithNibName:@"totNewBabyController" bundle:nil];
    [self.window addSubview:newbabyController.view];
    [self.window makeKeyAndVisible];
}

- (void)showLoginView:(int)baby_id {
    // remove newbabycontroller and all other sub views
    if( newbabyController != nil ) {
        [newbabyController release];
        newbabyController = nil;
    }
    for (UIView* view in self.window.subviews) {
        [view removeFromSuperview];
    }

    // show login
    loginController = [[totLoginController alloc] initWithNibName:@"totLoginController" bundle:nil];
    if( baby_id == -1 )
        loginController.newuser = FALSE;
    else {
        [loginController setBabyIDforNewUser:baby_id];
        loginController.newuser = TRUE;
    }
    [self.window addSubview:loginController.view];
    [self.window makeKeyAndVisible];
}

- (void)showHomeView {
    // remove login view first if exists
    if( loginController != nil ) {
        [loginController release];
        loginController = nil;
    }
    
    [self.window addSubview:rootController.view];    
    [self.window makeKeyAndVisible];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    [mTotData release];
    [mCache release];
}

@end
