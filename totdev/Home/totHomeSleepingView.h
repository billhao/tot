//
//  totHomeSleepingView.h
//  totdev
//
//  Created by Lixing Huang on 5/5/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "totTimerController.h"
#import "../Utility/totImageView.h"

@interface totHomeSleepingView : UIView <totTimerControllerDelegate, totImageViewDelegate> {
    UIView *mParentView;
    NSTimer *mSleepTimer;
    
    totTimerController *mClock;
    int mWidth, mHeight, mState;
    int mYear, mMonth, mDay,
        mHour, mMinute, mSecond, mAp;
    BOOL mUseTimePicker;
    // UI
    UIImageView *mReadyToSleepBckgrnd;
    UIImageView *mSleepingBckgrnd;
    UIButton *mCancelButton;
    UIButton *mEditButton;
    UIButton *mLabelBckgrnd;
    UIButton *mTimeLabel;
}

@property (nonatomic, assign) UIView *mParentView;

- (id)initWithFrame:(CGRect)frame;
- (void)trigger;

- (void)showNotSleepView;
- (void)showSleepingView;
- (void)clearNotSleepView;
- (void)clearSleepingView;

- (void)findCurrentTime;

@end
