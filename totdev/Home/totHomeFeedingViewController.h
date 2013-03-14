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
    
    NSMutableArray *inventory;
    NSMutableArray *inventoryGrey;

    // according to current design, we need 3 slider views
    //   1 for recently used; 1 for categories; 1 for food chosen
    // plus one for food menu in pop ups

    totSliderView* mRecentlyUsedSlider;
    totSliderView* mCategoriesSlider;
    totSliderView* mFoodChosenSlider;
    totSliderView* mChooseFoodSlider; // note the difference between foodChosen and chooseFood
    
    //totNavigationBar* mNavigationBar;
    UIButton* mBackButton;
    UIButton* mOKButton; // final submission
    UIButton* mSummary;
    
    //for fodd input
    UIView* mChooseFoodView;
    UIButton* mChooseFoodOKButton;
    UITextField *text_quantity;
    
    totModel* mTotModel;
    
    NSString *categoryChosen;
    
    // for date picker
    totTimerController* mClock;
    UIButton* mDatetime;

    int mWidth, mHeight;
    int foodSelected;
    
    NSMutableArray *foodChosenList;
}

@property (nonatomic, assign) totHomeRootController* homeRootController;


// receive parameters passed by other module for initialization or customization
//- (void)receiveMessage: (NSMutableDictionary*)message;
//- (void)pickerView:(STHorizontalPicker *)picker didSelectValue:(CGFloat)value;
- (void)OKButtonClicked: (UIButton *)button;
- (void)SummaryButtonClicked: (UIButton *)button;
- (void)backButtonClicked: (UIButton *)button;

+ (NSArray*)stringToJSON:(NSString*) jsonstring;

@end