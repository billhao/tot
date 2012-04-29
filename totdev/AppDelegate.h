//
//  AppDelegate.h
//  totdev
//
//  Created by Lixing Huang on 4/11/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model/totModel.h"

@class totUITabBarController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    UIWindow *window;
	IBOutlet totUITabBarController *rootController;
    
    // global
    totModel *mTotData;
    int mBabyId;
}

@property (retain, nonatomic) IBOutlet totUITabBarController *rootController;
@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (assign, nonatomic) int mBabyId;

- (totModel*) getDataModel;

@end
