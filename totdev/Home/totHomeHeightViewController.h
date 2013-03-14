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
#import "totNavigationBar.h"

@class totHomeRootController;

@interface totHomeHeightViewController : UIViewController <STHorizontalPickerDelegate, totTimerControllerDelegate, totNavigationBarDelegate> {
    totHomeRootController *homeRootController;
    
    IBOutlet UITextField *mHeightPlaceHolder;
    IBOutlet UITextField *mWeightPlaceHolder;
    IBOutlet UITextField *mHeadPlaceHolder;
    IBOutlet UIButton    *mOKButton;
    IBOutlet UIButton    *mCloseButton;
    IBOutlet UIButton    *mDatetime;
    IBOutlet UIButton    *mDatetimeImage;
    IBOutlet UILabel     *mSelectedValue;
    IBOutlet UIButton    *mLabel0Button; // the top button
    IBOutlet UIButton    *mLabel1Button;
    IBOutlet UIButton    *mLabel2Button;
    IBOutlet UILabel     *mLabel0;
    IBOutlet UILabel     *mLabel1;
    IBOutlet UILabel     *mLabel2;
    
    // for the summary
    UIImageView* mSummaryView;
    UILabel* mSummaryLabel;
    UIButton* mSummaryCover; // used to cover the view when showing the summary view
    
    totModel* model;
    
    // height, weight and head pickers
    STHorizontalPicker* picker_height;
    STHorizontalPicker* picker_weight;
    STHorizontalPicker* picker_head;
    
    // for date picker
    totTimerController *mClock;
    int mWidth, mHeight;
    bool mStart;
    
    totNavigationBar *mNavigationBar;

    // arrays to save info for three measures
    NSMutableArray* all_imgs;
    NSMutableArray* all_imgs_grey;
    NSMutableArray* all_numbers;
    NSMutableArray* all_pickers;
    
}

@property (nonatomic, assign) totHomeRootController *homeRootController;
@property (nonatomic, assign) int initialPicker; // the id in all_pickers for the picker to show when view first appears
@property (nonatomic, retain) NSDate* selectedDate; // currently selected date, this will be used when saving an event to db. this should be a private property, not accessible outside of this class


- (void)pickerView:(STHorizontalPicker *)picker didSelectValue:(CGFloat)value;
- (void)OKButtonClicked: (UIButton *)button;
- (void)CloseButtonClicked: (UIButton *)button;
- (void)DatetimeClicked: (UIButton *)button;
- (void)LabelButtonClicked: (UIButton *)button;
- (void)setContent:(int)i button:(UIButton*)button label:(UILabel*)label top:(BOOL)top; // set the content of a component (height/weight/hc)
- (void)loadPicker:(int)i currentPicker:(int)currentPicker;

// for date picker
- (void)showTimePicker;
- (void)hideTimePicker;

- (NSString*)getDateString:(NSDate*)date;

@end
