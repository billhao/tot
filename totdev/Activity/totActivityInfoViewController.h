//
//  totActivityInfoViewController.h
//  totdev
//
//  Created by Lixing Huang on 4/15/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "totActivityRootController.h"

@class totSliderView;

@interface totActivityInfoViewController : UIViewController <UITextViewDelegate> {
    totActivityRootController *activityRootController;
    IBOutlet UITextView *mActivityDesc;
    totSliderView *mSliderView;
    UIImageView *mThumbnail;
    NSNumber* mCurrentActivityID;
}

@property (nonatomic, assign) totActivityRootController *activityRootController;
@property (nonatomic, retain) IBOutlet UITextView *mActivityDesc;
@property (nonatomic, retain) NSNumber *mCurrentActivityID;

// receive parameters passed by other module for initialization or customization
- (void)receiveMessage: (NSMutableDictionary*)message;
- (IBAction)save: (id)sender;

@end
