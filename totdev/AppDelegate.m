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

@synthesize mainTabController;
//@synthesize window;
@synthesize mCache;
@synthesize baby, user;

- (void)alloc {
    loginNavigationController = nil;
    baby = nil;
    user = nil;
}

- (void)dealloc
{
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
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    // init navigation controller for login, registration and new baby
    loginNavigationController = [[totLoginNavigationController alloc] initWithRootViewController:nil];
    loginNavigationController.navigationBarHidden = TRUE;
    self.window.rootViewController = loginNavigationController;
    [self showFirstView];
    [self.window makeKeyAndVisible];
    return YES;
}

// determine the first view (new baby, login or homepage) and show it
- (BOOL)showFirstView {
    // initialize the image cache
    mCache = [[totImageCache alloc] init];
    
    // initialize database
    mTotData = [[totModel alloc] init];
    
    // add reference to db
    [totUser setModel:mTotData];
    [totBaby setModel:mTotData];
    
    // get # accounts in db
    int account = [totUser getTotalAccountCount];

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
            // baby.babyID = ??
        }
        else {
            [self showLoginView];
        }
    }
    return YES;
}

- (void)showNewBabyView {
    // remove all previous views
    [loginNavigationController setViewControllers:nil];
    // show new baby
    totNewBabyController* newbabyController = [[totNewBabyController alloc] initWithNibName:@"totNewBabyController" bundle:nil];
    newbabyController.view.frame = CGRectMake(0, 20, newbabyController.view.frame.size.width, newbabyController.view.frame.size.height);
    [loginNavigationController pushViewController:newbabyController animated:TRUE];
    [newbabyController release];
}

- (void)showLoginView {
    // remove all previous views
    [loginNavigationController setViewControllers:nil];
    // show login
    totLoginController* loginController = [[totLoginController alloc] initWithNibName:@"totLoginController" bundle:nil];
    loginController.view.frame = CGRectMake(0, 20, loginController.view.frame.size.width, loginController.view.frame.size.height);
    if( baby==nil || baby.babyID == -1 )
        loginController.newuser = FALSE;
    else {
        loginController.newuser = TRUE;
    }
    [loginNavigationController pushViewController:loginController animated:TRUE];
    [loginController release];
}

- (void)showHomeView {
    // remove all previous views
    [loginNavigationController setViewControllers:nil];
    // show home view
    mainTabController = [[totUITabBarController alloc] initWithNibName:@"MainWindow" bundle:nil];
    mainTabController.view.frame = CGRectMake(0, 20, mainTabController.view.frame.size.width, mainTabController.view.frame.size.height);
    [loginNavigationController pushViewController:mainTabController animated:TRUE];
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
    if( loginNavigationController != nil ) [loginNavigationController release];
    [mTotData release];
    [mCache release];
    if( baby != nil ) [baby release];
    if( user != nil ) [user release];
}

@end
