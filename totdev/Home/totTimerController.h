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

typedef enum {
    kDate = 0,
    kTime
} DATETIMEPICKERMODE;

@protocol totTimerControllerDelegate <NSObject>

@optional
-(void)saveCurrentTime:(NSString*)time datetime:(NSDate*)datetime;
-(void)cancelCurrentTime;

@end

@interface totTimerController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
    
    NSMutableArray *mHour, *mMinute, *mAmPm;
    NSMutableArray *mYear, *mMonth, *mDay;
    
    int mMode;
    
    int mComponentWidth, mComponentHeight;
    int mWidth, mHeight;
    int mCurrentHourIdx, mCurrentMinuteIdx, mCurrentAmPm;
    int mCurrentYearIdx, mCurrentMonthIdx, mCurrentDayIdx;
    id<totTimerControllerDelegate> delegate;
    
    // keep the superview and hidden textview on the superview so we can use its InputView and InputAccessoryView
    UIView* mSuperView;
    UITextView* mHiddenText;
    
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
@property (nonatomic, retain) UIPickerView *mTimePicker;
@property (nonatomic, retain) NSDate* datetime;

// must init with a super view
- (id)init:(UIView*)superView;

- (void)setCurrentTime;

// set the current time
// h: 1-12
// m: 0-59
// ap: 0: am, 1: pm
- (void)setCurrentHour:(int)h andMinute:(int)m andAmPm:(int)ap;
- (void)setCurrentYear:(int)y andMonth:(int)m andDay:(int)d;

- (void)setMode: (int)m;

// return "May" from 5
+ (NSString*)getMonthString:(int)month;

// for the ok and cancel button
- (UIView*)createInputAccessoryView;

// show and dismiss this picker
- (void)show;
- (void)dismiss;

@end
