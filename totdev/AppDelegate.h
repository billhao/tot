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

@class totUITabBarController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    UIWindow *window;
    totLoginNavigationController *loginNavigationController;
    
    // global
    totImageCache *mCache;

}
@property (retain, nonatomic) totUITabBarController* mainTabController;
@property (retain, nonatomic) totImageCache *mCache;
@property (strong, nonatomic) UIWindow *window;

// determine the first view (new baby, login or homepage) and show it
- (BOOL)showFirstView;

- (void)showLoginView;
- (void)showHomeView;
- (void)showTutorial;

- (NSString*) isLoggedIn;

@end
