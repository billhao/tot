//
//  totTimerController.h
//  totdev
//
//  Created by Lixing Huang on 5/5/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    kButtonOK = 0,
    kButtonCancel = 1
};

enum {
    kPickerHour = 0,
    kPickerMinute = 1,
    kPickerAmPm = 2
};

@protocol totTimerControllerDelegate <NSObject>

@optional
-(void)saveCurrentTime:(NSString*)time;
-(void)cancelCurrentTime;

@end

@interface totTimerController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
    UIPickerView *mTimePicker;
    NSMutableArray *mHour, *mMinute, *mAmPm;
    int mComponentWidth, mComponentHeight;
    int mWidth, mHeight;
    int mCurrentHourIdx, mCurrentMinuteIdx, mCurrentAmPm;
    id<totTimerControllerDelegate> delegate;
}

@property (nonatomic, assign) int mWidth;
@property (nonatomic, assign) int mHeight;
@property (nonatomic, assign) int mComponentWidth;
@property (nonatomic, assign) int mComponentHeight;
@property (nonatomic, retain) id<totTimerControllerDelegate> delegate;

// set the current time
// h: 1-12
// m: 0-59
// ap: 0: am, 1: pm
- (void)setCurrentHour:(int)h andMinute:(int)m andAmPm:(int)ap;

@end
