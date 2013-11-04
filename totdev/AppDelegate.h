//
//  AppDelegate.h
//  totdev
//
//  Created by Lixing Huang on 4/11/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model/Global.h"
#import "totImageCache.h"
#import "totLoginController.h"
#import "totNewBabyController.h"
#import "totLoginNavigationController.h"

/*
 *  System Versioning Preprocessor Macros
 */
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


// x, y, width and height for the window
#define WINDOW_X 0
#define WINDOW_Y 0
#define WINDOW_W 320
#define WINDOW_H 460

@class totUITabBarController;
@class totHomeRootController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    UIWindow *window;
    
    
    // global
    totImageCache *mCache;

}
@property (strong, nonatomic) totLoginNavigationController *loginNavigationController;
@property (retain, nonatomic) totHomeRootController* homeController;
@property (retain, nonatomic) totUITabBarController* mainTabController;
@property (retain, nonatomic) totImageCache *mCache;
@property (strong, nonatomic) UIWindow *window;

// determine the first view (new baby, login or homepage) and show it
- (BOOL)showFirstView;

- (void)showLoginView;
- (void)showHomeView;
- (void)showTutorial;
- (void)popup;

- (NSString*) isLoggedIn;

@end
