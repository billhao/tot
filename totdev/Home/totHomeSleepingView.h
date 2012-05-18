//
//  totHomeSleepingView.h
//  totdev
//
//  Created by Lixing Huang on 5/5/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "totTimerController.h"


@interface totHomeSleepingView : UIView <totTimerControllerDelegate> {
    UIView *mParentView;
    
    totTimerController *mClock;
    int mWidth, mHeight;
    bool mIsSleeping;
    
    UIButton *mClockBtn, *mConfirmButton;
    UIImageView *mBackground, *mDisplayBackground;
    UILabel *mTimeLabel, *mDisplayLabel;
    
    NSTimer *mSleepTimer;
    
    int _year, _month, _day;
    int _hour, _minute, _second, _ap;
}

@property (nonatomic, readonly) bool mIsSleeping;

- (id)initWithFrame:(CGRect)frame andParentView:(UIView*)parent;
- (void)startSleeping;
- (void)stopSleeping;

- (void)animationFinished:(NSString*)animationID finished:(NSNumber*)finished context:(void*)context;
- (void)calculateDisplayedTime:(int)gap;
- (void)handleTime;
- (void)makeNoView;
- (void)makeFullView;
- (void)makeDisplayView;

@end
