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

@interface totActivityInfoViewController : UIViewController <UITextViewDelegate,totSliderViewDelegate> {
    totActivityRootController *activityRootController;
}

@property (nonatomic, assign) totActivityRootController *activityRootController;
@property (nonatomic, retain) IBOutlet UITextView *mActivityDesc;

- (void)setInfo: (NSMutableDictionary*)info;

@end
