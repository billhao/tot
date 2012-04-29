//
//  totActivityViewController.h
//  totdev
//
//  Created by Lixing Huang on 4/15/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "totActivityRootController.h"
#import "../Utility/totCameraViewController.h"

@class totSliderView;

@interface totActivityViewController : UIViewController <CameraViewDelegate> {
    totActivityRootController *activityRootController;
    totSliderView *mSliderView;
    
    NSMutableArray *mActivityMemberImages;
    NSMutableArray *mActivityMemberMargin;
    
    UIButton *mCameraButton, *mVideoButton;
}

@property (nonatomic, assign) totActivityRootController *activityRootController;
@property (nonatomic, retain) totSliderView *mSliderView;

// receive parameters passed by other module for initialization or customization
- (void)receiveMessage: (NSMutableDictionary*)message;

@end
