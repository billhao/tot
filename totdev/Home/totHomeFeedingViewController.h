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
    totHomeRootController *homeRootController;
    totSliderView *mSliderView;
    //UINavigationBar *navigationBar;
    totNavigationBar *mNavigationBar;
    
    UIButton *mOKButton;
    UIButton *mDatetime;
    UIButton *mSummary;
    
    //NSMutableDictionary *mMessage;
    
    NSNumber *mCurrentFoodID;    
    totModel *mTotModel;
    
    //UIImageView *mBackground;
    
    STHorizontalPicker* picker_quantity;
    
    // for date picker
    totTimerController *mClock;
    int mWidth, mHeight;
    
    int buttonSelected;
    float quantityList[8]; 

}

@property (nonatomic, assign) totHomeRootController *homeRootController;
@property (nonatomic, retain) totSliderView *mSliderView;
@property (nonatomic, retain) NSNumber *mCurrentFoodID;
//@property (nonatomic, retain) UINavigationBar* navigationBar;
//@property (nonatomic, retain) UIButton* mOKButton;
//@property (nonatomic, retain) UIButton* mDatetime;
//@property (nonatomic, retain) UIButton* mSummary;


// receive parameters passed by other module for initialization or customization
//- (void)receiveMessage: (NSMutableDictionary*)message;
- (void)pickerView:(STHorizontalPicker *)picker didSelectValue:(CGFloat)value;
- (void)OKButtonClicked: (UIButton *)button;
- (void)SummaryButtonClicked: (UIButton *)button;


@end