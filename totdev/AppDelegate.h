//
//  AppDelegate.h
//  totdev
//
//  Created by Lixing Huang on 4/11/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model/totModel.h"
#import "totImageCache.h"
#import "totLoginController.h"
#import "totNewBabyController.h"

@class totUITabBarController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    UIWindow *window;
	IBOutlet totUITabBarController *rootController;
	totLoginController    *loginController;
    
    // global
    totImageCache *mCache;
    totModel *mTotData;
    int mBabyId;
}

@property (retain, nonatomic) totImageCache *mCache;
@property (retain, nonatomic) IBOutlet totUITabBarController *rootController;
@property (retain, nonatomic) totLoginController *loginController;
@property (retain, nonatomic) totNewBabyController *newbabyController;
@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (assign, nonatomic) int mBabyId;

- (totModel*) getDataModel;

// determine the first view (new baby, login or homepage) and show it
- (BOOL)showFirstView;

- (void)showLoginView:(int)baby_id;
- (void)showHomeView;
- (NSString*) isLoggedIn;

@end
