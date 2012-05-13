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
#import "../STHorizontalPicker.h"
#import "../Model/totModel.h"
#import "totTimerController.h"


@interface totHomeFeedingViewController : UIViewController<STHorizontalPickerDelegate,totSliderViewDelegate> {
    totHomeRootController *homeRootController;
    totSliderView *mSliderView;
    UINavigationBar *navigationBar;
    UIButton *mOKButton;
    UIButton *mDatetime;
    
    NSMutableDictionary *mMessage;
    
    NSNumber *mCurrentFoodID;    
    totModel *mTotModel;
    
    UIImageView *mBackground;
    
    STHorizontalPicker* picker_quantity;
    
    // for date picker
    totTimerController *mClock;
    int mWidth, mHeight;


}

@property (nonatomic, assign) totHomeRootController *homeRootController;
@property (nonatomic, retain) totSliderView *mSliderView;
@property (nonatomic, retain) NSNumber *mCurrentFoodID;
@property (nonatomic, retain) UINavigationBar* navigationBar;
@property (nonatomic, retain) UIButton* mOKButton;
@property (nonatomic, retain) UIButton* mDatetime;


// receive parameters passed by other module for initialization or customization
//- (void)receiveMessage: (NSMutableDictionary*)message;
- (void)pickerView:(STHorizontalPicker *)picker didSelectValue:(CGFloat)value;
- (void)OKButtonClicked: (UIButton *)button;


@end