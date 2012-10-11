//
//  totHomeDiaperView.h
//  totdev
//
//  Created by Lixing Huang on 10/10/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "totTimerController.h"
#import "../Utility/totImageView.h"

@interface totHomeDiaperView : UIView <totImageViewDelegate, totTimerControllerDelegate> {
    UIImageView * mBackground;
    
    enum Selection {
        SELECTION_WET = 1,
        SELECTION_SOLID = 2,
        SELECTION_WETSOLID = 3,
    };
    enum Control {
        BUTTON_SHARE = 1,
        BUTTON_HISTORY = 2,
        BUTTON_CONFIRM = 3,
        BUTTON_TIME = 4,
        BUTTON_CLOSE = 5,
    };
    
    totTimerController * mClock;
    
    totImageView * mSelectionWet;
    totImageView * mSelectionSolid;
    totImageView * mSelectionWetSolid;
    
    UIButton * mControlShare;
    UIButton * mControlHistory;
    UIButton * mControlConfirm;
    UIButton * mTimeLabel;
    UIButton * mCloseButton;
    
    UIImageView * mSelectedIcon;
    
    int mYear, mMonth, mDay,
        mHour, mMinute, mSecond, mAp;
    int mDiaperType;
}

- (id)initWithFrame:(CGRect)frame;

- (void)showDiaperView;
- (void)hideDiaperView;

- (void)touchesEndedDelegate:(NSSet *)touches withEvent:(UIEvent *)event from:(int)tag;
- (void)buttonPressed:(id)sender;


@end
