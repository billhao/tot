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
#import "../Utility/STHorizontalPicker.h"
#import "../Model/totModel.h"
#import "totTimerController.h"
#import "../Utility/totNavigationBar.h"

#define DEFAULT_MENU 8

@interface totHomeFeedingViewController : UIViewController<STHorizontalPickerDelegate,totSliderViewDelegate,totNavigationBarDelegate,totTimerControllerDelegate> {
    totHomeRootController* homeRootController;
    
    // according to current design, we need 3 slider views
    //   1 for recently used; 1 for categories; 1 for food chosen
    // plus one for food menu in pop ups

    totSliderView* mRecentlyUsedSlider;
    totSliderView* mCategoriesSlider;
    totSliderView* mFoodChosenSlider;
    
    //totNavigationBar* mNavigationBar;
    
    UIButton* mOKButton;
    UIButton* mDatetime;
    UIButton* mSummary;
    
    //for fodd imput
    UIView* mChooseFoodView;
    totSliderView* mChooseFoodSlider; // note the difference between foodChosen and chooseFood
    UIButton* mChooseFoodOKButton;
    STHorizontalPicker* picker_quantity;
    
    //NSMutableDictionary *mMessage;
    
    NSNumber* mCurrentFoodID;
    totModel* mTotModel;
    
    //UIImageView *mBackground;
    
    
    // for date picker
    totTimerController* mClock;
    int mWidth, mHeight;
    
    int buttonSelected;
    float quantityList[8];
}

@property (nonatomic, assign) totHomeRootController* homeRootController;
@property (nonatomic, retain) totSliderView* mRecentlyUsedSlider;
@property (nonatomic, retain) totSliderView* mCategoriesSlider;
@property (nonatomic, retain) totSliderView* mFoodChosenSlider;
@property (nonatomic, retain) totSliderView* mChooseFoodSlider;

@property (nonatomic, assign) NSNumber* mCurrentFoodID;


// receive parameters passed by other module for initialization or customization
//- (void)receiveMessage: (NSMutableDictionary*)message;
- (void)pickerView:(STHorizontalPicker *)picker didSelectValue:(CGFloat)value;
- (void)OKButtonClicked: (UIButton *)button;
- (void)SummaryButtonClicked: (UIButton *)button;


@end