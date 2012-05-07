//
//  totHomeHeightViewController.h
//  totdev
//
//  Created by Hao on 5/5/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "totModel.h"
#import "STHorizontalPicker.h"
#import "totTimerController.h"

@class totHomeRootController;

@interface totHomeHeightViewController : UIViewController <STHorizontalPickerDelegate, totTimerControllerDelegate> {
    totHomeRootController *homeRootController;
    
    IBOutlet UITextField *mHeightPlaceHolder;
    IBOutlet UITextField *mWeightPlaceHolder;
    IBOutlet UITextField *mHeadPlaceHolder;
    IBOutlet UIButton    *mOKButton;
    IBOutlet UIButton    *mDatetime;
    IBOutlet UIButton    *mDatetimeImage;
    IBOutlet UIButton    *mSummary;
    
    totModel* model;
    
    // height, weight and head pickers
    STHorizontalPicker* picker_height;
    STHorizontalPicker* picker_weight;
    STHorizontalPicker* picker_head;
    
    // for date picker
    totTimerController *mClock;
    int mWidth, mHeight;
    bool mStart;
}

@property (nonatomic, assign) totHomeRootController *homeRootController;

- (void)pickerView:(STHorizontalPicker *)picker didSelectValue:(CGFloat)value;
- (void)OKButtonClicked: (UIButton *)button;
- (void)DatetimeClicked: (UIButton *)button;

// for date picker
- (void)showTimePicker;
- (void)hideTimePicker;

@end
