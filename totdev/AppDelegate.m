//
//  AppDelegate.m
//  totdev
//
//  Created by Lixing Huang on 4/11/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "AppDelegate.h"

#import "Model/Global.h"
#import "test_Model.h"
#import "totEventName.h"
#import "Utility/totUtility.h"

#import "totEvent.h"
#import "Tutorial/totTutorialViewController.h"
#import "totCameraViewController.h"
#import "totBookListViewController.h"

@implementation AppDelegate

@synthesize window, mCache, loginNavigationController, homeController;

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
    [totMediaLibrary checkMediaDirectory];
    
     // handle iphone 5 screen size
    CGRect windowFrame = [[UIScreen mainScreen] bounds];
    if( windowFrame.size.height > 480 ) {
        // iphone 5, put the frame in the middle of the screen
        int currentAppHeight = 480; // currently the app window is 480px in height
        windowFrame.origin.y += (windowFrame.size.height-currentAppHeight)/2;
        windowFrame.size.height = currentAppHeight;
    }

    if( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ) {
        windowFrame = CGRectMake(0, 0, 320, 480);
    }
    else {
        // for anything below ios7
        windowFrame = CGRectMake(0, 0, 320, 480);
        // use transparent status bar
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
//        loginNavigationController.wantsFullScreenLayout = TRUE;
    }
    
    self.window = [[[UIWindow alloc] initWithFrame:windowFrame] autorelease];

    // Override point for customization after application launch.
    
    // init the global variable before anything else
    // the global variable provides access to instances of totBaby and totUser
    global = [[[Global alloc] init] retain];
    
    // initialize the image cache
    mCache = [[totImageCache alloc] init];
    
    // init navigation controller for login, registration and new baby
    loginNavigationController = [[totLoginNavigationController alloc] init];
    loginNavigationController.navigationBarHidden = TRUE;
    loginNavigationController.view.frame = self.window.bounds;
//    loginNavigationController.view.autoresizesSubviews = false;  // for iphone 5 screen size
    
    self.window.rootViewController = loginNavigationController;
    //self.window.backgroundColor = [UIColor darkGrayColor];
    self.window.clipsToBounds = false;

    [self showFirstView];
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

// determine the first view (new baby, login or homepage) and show it
- (BOOL)showFirstView {
    
    //[loginNavigationController setViewControllers:nil];
    
    // get # accounts in db
    int account = [totUser getTotalAccountCount];

    // general method to test a code snippet, which could be just empty
//    test_Model* test = [[test_Model alloc] init];
//    BOOL re = [test test];
//    if( !re ) return FALSE;
    
    // output some system information
    NSLog(@"App data path = %@", [totModel GetDocumentDirectory]);
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

            [self showHomeView:TRUE];
        }
        else {
            [self showLoginView];
        }
    }
    
    return YES;
}

- (void)showNewBabyView {
    // remove all previous views
    //[loginNavigationController setViewControllers:nil];
    
    // show new baby
    CGRect frame = self.window.bounds;
    if( !SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ) {
        float statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        frame.size.height -= statusBarHeight;
    }

    totNewBabyController* newbabyController = [[totNewBabyController alloc] initWithNibName:@"totNewBabyController" bundle:nil];
    newbabyController.view.frame = frame;
    [loginNavigationController pushViewController:newbabyController animated:TRUE];
    [newbabyController release];
}

- (void)showLoginView {
    // remove all previous views
    //[loginNavigationController setViewControllers:nil];

    // show login
    totLoginController* loginController = [[totLoginController alloc] initWithNibName:@"totLoginController" bundle:nil];
    CGRect frame = self.window.bounds;
    if( !SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ) {
        float statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        frame.size.height -= statusBarHeight;
    }
    loginController.view.frame = frame;
    if( global.baby==nil || global.baby.babyID == -1 )
        loginController.newuser = FALSE;
    else {
        loginController.newuser = TRUE;
    }
    [loginNavigationController pushViewController:loginController animated:TRUE];
    [loginController release];
}

- (void)showHomeView:(BOOL)animated {
    // remove all previous views
    //[loginNavigationController setViewControllers:nil];
    // show home view
    //loginNavigationController.view.backgroundColor = [UIColor blueColor];

//    CGRect frame = self.window.bounds;
    
    if( !homeController )
        homeController = [[totHomeRootController alloc] init];
    [loginNavigationController pushViewController:self.homeController animated:animated];
    //self.homeController.view.backgroundColor = [UIColor grayColor];

    //totBookListViewController* book = [[totBookListViewController alloc] init];
    //book.view.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    //self.window.rootViewController = book;
    //[book release];
    
    
//    totUITabBarController* mainTabController = [[totUITabBarController alloc] initWithNibName:@"MainWindow" bundle:nil];
//    self.mainTabController = mainTabController;
//    CGRect frame = self.window.bounds;
//    mainTabController.view.frame = CGRectMake(0, 20, frame.size.width, frame.size.height);
//    [loginNavigationController pushViewController:mainTabController animated:TRUE];
//    [mainTabController release];
}

- (void)showTutorial {
    if( !homeController )
        homeController = [[totHomeRootController alloc] init];
    [loginNavigationController pushViewController:self.homeController animated:FALSE];
    [homeController switchTo:KTutorial withContextInfo:nil];
    return;
    
    CGRect frame = self.window.bounds;
    if( !SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ) {
        float statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        frame.size.height -= statusBarHeight;
    }
    totTutorialViewController* ttVC = [[totTutorialViewController alloc] initWithFrame:frame];
    [loginNavigationController pushViewController:ttVC animated:TRUE];
    [ttVC release];
}

- (void)popup {
    [loginNavigationController popViewControllerAnimated:false];
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
