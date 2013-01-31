//
//  AppDelegate.m
//  totdev
//
//  Created by Lixing Huang on 4/11/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "AppDelegate.h"
#import "totUITabBarController.h"

#import "Model/Global.h"
#import "test_Model.h"
#import "totEventName.h"

@implementation AppDelegate

@synthesize mainTabController;
@synthesize window;
@synthesize mCache;

- (void)alloc {
    loginNavigationController = nil;
}

- (void)dealloc
{
    [window release];
    [super dealloc];
}

// get current logged in account, return nil if none
- (NSString*) isLoggedIn {
    return [global.model getPreferenceNoBaby:PREFERENCE_LOGGED_IN];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    
    // init the global variable before anything else
    // the global variable provides access to instances of totBaby and totUser
    global = [[[Global alloc] init] retain];
    
    // initialize the image cache
    mCache = [[totImageCache alloc] init];

    // init navigation controller for login, registration and new baby
    
    mainTabController = [[totUITabBarController alloc] initWithNibName:@"MainWindow" bundle:nil];
    mainTabController.view.frame = CGRectMake(0, 20, mainTabController.view.frame.size.width, mainTabController.view.frame.size.height);

    loginNavigationController = [[totLoginNavigationController alloc] initWithRootViewController:mainTabController];
    loginNavigationController.navigationBarHidden = TRUE;
    self.window.rootViewController = loginNavigationController;
    [self showFirstView];
    [self.window makeKeyAndVisible];
    return YES;
}

// determine the first view (new baby, login or homepage) and show it
- (BOOL)showFirstView {
    
    // get # accounts in db
    int account = [totUser getTotalAccountCount];

    // general method to test a code snippet, which could be just empty
//    test_Model* test = [[test_Model alloc] init];
//    BOOL re = [test test];
//    if( !re ) return FALSE;
    
    // output some system information
    NSLog(@"App data path = %@", [global.model GetDocumentDirectory]);
    NSLog(@"# Acc = %d", account);

    if( account == 0 ) {
        // show new baby view if no account exists
        [self showNewBabyView];
    }
    else {
        // if logged in then show home view, otherwise show login view
        totUser* user = [totUser getLoggedInUser];
        if( user != nil ) {
            global.user = user;
            // check if baby is set. it may be nil after register. get the default baby for user if baby is not set.
            if( global.baby == nil ) {
                global.baby = [global.user getDefaultBaby];
            }
            [global.baby printBabyInfo];

            [self showHomeView];
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
    if( global.baby==nil || global.baby.babyID == -1 )
        loginController.newuser = FALSE;
    else {
        loginController.newuser = TRUE;
    }
    [loginNavigationController pushViewController:loginController animated:TRUE];
    //[loginController release];
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
    [mCache release];
}

@end
