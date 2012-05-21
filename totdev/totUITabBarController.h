//
//  totUITabBarController.h
//  totdev
//
//  Created by Lixing Huang on 4/11/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "totHomeRootController.h"
#import "totActivityRootController.h"
#import "totReviewRootController.h"
#import "totSettingRootController.h"

@class totCameraViewController;
@class albumViewController;
@class totPhotoView;

@interface totUITabBarController : UITabBarController {
    totHomeRootController* homeController;
    totActivityRootController* activityController;
    totReviewRootController* reviewController;
    totSettingRootController* settingController;

    totCameraViewController *cameraView;
    albumViewController *albumView;
    totPhotoView *photoView;
}

@property (nonatomic, retain) totCameraViewController *cameraView;
@property (nonatomic, retain) albumViewController *albumView;
@property (nonatomic, retain) totPhotoView *photoView;

@end
