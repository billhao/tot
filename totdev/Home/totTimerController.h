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

enum {
    kPickerYear = 0,
    kPickerMonth = 1,
    kPickerDay
};

enum {
    kDate = 0,
    kTime
};

@protocol totTimerControllerDelegate <NSObject>

@optional
-(void)saveCurrentTime:(NSString*)time;
-(void)cancelCurrentTime;

@end

@interface totTimerController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
    UIPickerView *mTimePicker;
    
    NSMutableArray *mHour, *mMinute, *mAmPm;
    NSMutableArray *mYear, *mMonth, *mDay;
    
    int mMode;
    
    int mComponentWidth, mComponentHeight;
    int mWidth, mHeight;
    int mCurrentHourIdx, mCurrentMinuteIdx, mCurrentAmPm;
    int mCurrentYearIdx, mCurrentMonthIdx, mCurrentDayIdx;
    id<totTimerControllerDelegate> delegate;
}

@property (nonatomic, readonly) int mMode;
@property (nonatomic, readonly) int mCurrentHourIdx;
@property (nonatomic, readonly) int mCurrentMinuteIdx;
@property (nonatomic, readonly) int mCurrentAmPm;
@property (nonatomic, readonly) int mCurrentYearIdx;
@property (nonatomic, readonly) int mCurrentMonthIdx;
@property (nonatomic, readonly) int mCurrentDayIdx;
@property (nonatomic, assign) int mWidth;
@property (nonatomic, assign) int mHeight;
@property (nonatomic, retain) id<totTimerControllerDelegate> delegate;

- (void)setCurrentTime;

// set the current time
// h: 1-12
// m: 0-59
// ap: 0: am, 1: pm
- (void)setCurrentHour:(int)h andMinute:(int)m andAmPm:(int)ap;
- (void)setCurrentYear:(int)y andMonth:(int)m andDay:(int)d;

- (void)setMode: (int)m;

@end
