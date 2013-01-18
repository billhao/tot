//
//  totHomeFeedingViewController.h
//  totdev
//
//  Created by Yifei Chen on 5/6/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "totHomeRootController.h"
#import "../Utility/totSliderView.h"
//#import "../Utility/STHorizontalPicker.h"
#import "../Model/totModel.h"
#import "totTimerController.h"
#import "../Utility/totNavigationBar.h"

#define DEFAULT_MENU 8

@interface totHomeFeedingViewController : UIViewController<UITextFieldDelegate,totSliderViewDelegate,totNavigationBarDelegate,totTimerControllerDelegate> {
    totHomeRootController* homeRootController;
    
    // according to current design, we need 3 slider views
    //   1 for recently used; 1 for categories; 1 for food chosen
    // plus one for food menu in pop ups

    totSliderView* mRecentlyUsedSlider;
    totSliderView* mCategoriesSlider;
    totSliderView* mFoodChosenSlider;
    
    //totNavigationBar* mNavigationBar;
    UIButton* mBackButton;
    
    UIButton* mOKButton; // final submission
    UIButton* mSummary;
    
    //for fodd input
    UIView* mChooseFoodView;
    totSliderView* mChooseFoodSlider; // note the difference between foodChosen and chooseFood
    UIButton* mChooseFoodOKButton;
    // STHorizontalPicker* picker_quantity; //no more picker! use an associative textfield
    UITextField *text_quantity;
    
    NSNumber* mCurrentFoodID;
    totModel* mTotModel;
    
    //UIImageView *mBackground;
    NSString *categoryChosen;
    
    // for date picker
    totTimerController* mClock;
    UIButton* mDatetime;

    int mWidth, mHeight;
    
    int foodSelected;
    float quantityList[8];
}

@property (nonatomic, assign) totHomeRootController* homeRootController;
@property (nonatomic, retain) totSliderView* mRecentlyUsedSlider;
@property (nonatomic, retain) totSliderView* mCategoriesSlider;
@property (nonatomic, retain) totSliderView* mFoodChosenSlider;
@property (nonatomic, retain) totSliderView* mChooseFoodSlider;
@property (nonatomic, retain) UITextField* text_quantity;
@property (nonatomic, assign) NSNumber* mCurrentFoodID;



// receive parameters passed by other module for initialization or customization
//- (void)receiveMessage: (NSMutableDictionary*)message;
//- (void)pickerView:(STHorizontalPicker *)picker didSelectValue:(CGFloat)value;
- (void)OKButtonClicked: (UIButton *)button;
- (void)SummaryButtonClicked: (UIButton *)button;
- (void)backButtonClicked: (UIButton *)button;


@end