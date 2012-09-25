//
//  totNewBabyController.h
//  totdev
//
//  Created by Hao Wang on 8/24/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface totNewBabyController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate> {
    IBOutlet UITextField *mName, *mBDay;
    IBOutlet UIButton *mBoy, *mGirl, *mSave, *mExistingAccount;
    IBOutlet UIDatePicker *mPicker;
    UIView *inputAccView;
    UIButton *btnDone;
    
    enum SEX {
        NA,          // N/A
        MALE,
        FEMALE
    } sex;
    NSDate* bday;
    
    
}

- (void)showLoginView;

- (void)ExistingAccountButtonClicked: (UIButton *)button;
- (void)BoyButtonClicked: (UIButton *)button;
- (void)GirlButtonClicked: (UIButton *)button;
- (void)SaveButtonClicked: (UIButton *)button;
- (void)changeDateInLabel:(id)sender;
- (IBAction) backgroundTap:(id) sender;
- (void)createInputAccessoryView;
- (void)doneTyping;

@end
