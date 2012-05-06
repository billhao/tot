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
    UIButton *mClockBtn;
    totTimerController *mClock;
    int mWidth, mHeight;
    bool mStart;
}

- (void)startSleeping;
- (void)stopSleeping;

@end
