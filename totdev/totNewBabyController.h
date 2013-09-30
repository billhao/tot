//
//  totNewBabyController.h
//  totdev
//
//  Created by Hao Wang on 8/24/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Model/totBaby.h"

@class AppDelegate;

@interface totNewBabyController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate> {
    IBOutlet UITextField *mName, *mBDay, *mCurrentControl;
    IBOutlet UIButton *mBoy, *mGirl, *mSave, *mExistingAccount;
    IBOutlet UIImageView *mBoyImg, *mGirlImg;
    IBOutlet UIDatePicker *mPicker;
    IBOutlet UIButton*    mPrivacy;
    UIView *inputAccView;
    UIButton *btnDone;
    UIImage *mBoySelected, *mGirlSelected;
    
    enum SEX sex;
    NSDate* bday;
}

- (void)showLoginView;

- (void)ExistingAccountButtonClicked: (UIButton *)button;
- (void)BoyButtonClicked: (UIButton *)button;
- (void)GirlButtonClicked: (UIButton *)button;
- (void)SaveButtonClicked: (UIButton *)button;
- (void)changeDateInLabel:(id)sender;
- (void)pickerDoneClicked: (UIButton *)button;
- (IBAction) backgroundTap:(id) sender;
- (UIView*)createInputAccessoryView;
- (void)doneTyping;

- (AppDelegate*) getAppDelegate;

@end
