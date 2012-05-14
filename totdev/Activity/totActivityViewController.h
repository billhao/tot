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
#import "../Utility/totSliderView.h"
#import "../Utility/totNavigationBar.h"
#import "../Model/totEvent.h"
#import "../Model/totModel.h"

@class totSliderView;

@interface totActivityViewController : UIViewController <CameraViewDelegate, totSliderViewDelegate, totNavigationBarDelegate> {
    totActivityRootController *activityRootController;
    totSliderView *mSliderView;
    totNavigationBar *mNavigationBar;
    
    NSNumber *mCurrentActivityID;    
    NSMutableDictionary *mMessage;
    
    totModel *mTotModel;
    
    UIImageView *mBackground;
}

@property (nonatomic, assign) totActivityRootController *activityRootController;
@property (nonatomic, retain) totSliderView *mSliderView;
@property (nonatomic, retain) NSNumber *mCurrentActivityID;

// receive parameters passed by other module for initialization or customization
- (void)receiveMessage: (NSMutableDictionary*)message;
- (void)launchCamera:(id)sender;
- (void)launchVideo:(id)sender;

@end
