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

@interface totHomeHeightViewController : UIViewController <STHorizontalPickerDelegate> {
    IBOutlet UITextField *mHeight;
    IBOutlet UITextField *mWeight;
    IBOutlet UITextField *mHead;
    IBOutlet UIButton    *mOKButton;
    IBOutlet UIButton    *mDatetime;
    IBOutlet UIButton    *mDatetimeImage;
    IBOutlet UIButton    *mSummary;
    
    totModel* model;
    STHorizontalPicker* picker_height;
    STHorizontalPicker* picker_weight;
    STHorizontalPicker* picker_head;
}

- (void)pickerView:(STHorizontalPicker *)picker didSelectValue:(CGFloat)value;
- (void)OKButtonClicked: (UIButton *)button;
- (void)DatetimeClicked: (UIButton *)button;

@end
