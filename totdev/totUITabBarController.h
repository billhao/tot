//
//  totUITabBarController.h
//  totdev
//
//  Created by Lixing Huang on 4/11/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class totCameraViewController;

@interface totUITabBarController : UITabBarController {
    totCameraViewController *cameraView;
}

@property (nonatomic, retain) totCameraViewController *cameraView;

@end
