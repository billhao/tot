//
//  totActivityInfoViewController.h
//  totdev
//
//  Created by Lixing Huang on 4/15/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "totActivityRootController.h"
#import "../Utility/totSliderView.h"
#import "../Utility/totNavigationBar.h"
#import "../Model/totModel.h"

@class totSliderView;

@interface totActivityInfoViewController : UIViewController <UITextViewDelegate, totSliderViewDelegate, UIAlertViewDelegate, totNavigationBarDelegate> {
    totActivityRootController *activityRootController;
    totNavigationBar * mNavigationBar;
    IBOutlet UITextView * mActivityDesc;
    totSliderView * mSliderView;
    UIImageView * mThumbnail;
    
    NSDictionary * mState;
    
    char mEventName[256];
    char mImagePath[256];
    char mVideoPath[256];

    totModel *mTotModel;
    
    int mCurrentActivityID;
    bool mIsVideo;
}

@property (nonatomic, assign) totActivityRootController *activityRootController;
@property (nonatomic, retain) IBOutlet UITextView *mActivityDesc;

// receive parameters passed by other module for initialization or customization
- (void)receiveMessage: (NSMutableDictionary*)message;

@end
