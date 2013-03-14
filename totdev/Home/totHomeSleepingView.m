//
//  totHomeSleepingView.m
//  totdev
//
//  Created by Lixing Huang on 5/5/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totHomeSleepingView.h"
#import "totTimerController.h"
#import "../AppDelegate.h"
#import "../Model/totModel.h"
#import "../Model/totEvent.h"
#import "../Model/totEventName.h"

#define NOT_SLEEP      0
#define SLEEPING       1

#define BUTTON_CLOSE   0
#define BUTTON_EDIT    1
#define BUTTON_START   2
#define BUTTON_END     3

@implementation totHomeSleepingView

@synthesize mParentView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.hidden = YES;

        mWidth = self.frame.size.width;
        mHeight= self.frame.size.height;
        mUseTimePicker = NO;

        totModel *model = global.model;
        NSMutableArray *sleepRecords = [model getEvent:global.baby.babyID event:EVENT_BASIC_SLEEP];
        if( [sleepRecords count] > 0 ) {
            totEvent *evt = [sleepRecords objectAtIndex:0];
            if( [evt.value isEqualToString:@"start"] ) {
                mState = SLEEPING;
            } else {
                mState = NOT_SLEEP;
            }
        } else {
            mState = NOT_SLEEP;
        }
  
        // time picker
        mClock = [[totTimerController alloc] init:self];
        mClock.view.frame = CGRectMake(0, 0, mClock.mWidth, mClock.mHeight);
        [mClock setMode:kTime];
        [mClock setDelegate:self];

        mReadyToSleepBckgrnd = [[totImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        mSleepingBckgrnd = [[totImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        [mReadyToSleepBckgrnd imageFilePath:@"backgrounds-sleepstart.png"];
        [mReadyToSleepBckgrnd setDelegate:self];
        [mSleepingBckgrnd imageFilePath:@"backgrounds-sleepduring.png"];
        [mSleepingBckgrnd setDelegate:self];
        
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)timerHandler {
    static bool timer_show_up = false;
    if (mState == NOT_SLEEP) {
        timer_show_up = false;
        return;
    }
    
    timer_show_up = true; // timer also show up
    if (timer_show_up) {
        // retrieve from db the starting time
        totModel *model = global.model;

        NSDate *now = [NSDate date];

        NSArray *events = [model getEvent:global.baby.babyID event:EVENT_BASIC_SLEEP limit:1];
        totEvent *event = (totEvent*)[events objectAtIndex:0];
        NSDate *event_date = event.datetime;

        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [calendar components:NSSecondCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit
                                                   fromDate:event_date
                                                     toDate:now
                                                    options:0];
        // format the duration accordingly
        NSString *duration = nil;
        if( components.hour == 0 )
            duration = [NSString stringWithFormat:@"%02d:%02d", components.minute, components.second];
        else
            duration = [NSString stringWithFormat:@"%02d:%02d:%02d", components.hour, components.minute, components.second];
        [mTimeLabel setTitle:duration forState:UIControlStateNormal];
        [calendar release];
    } else {
        [mTimeLabel setTitle:@"" forState:UIControlStateNormal];
    }
    //timer_show_up = !timer_show_up;
}

#pragma mark - totImageView delegate
- (void)touchesEndedDelegate:(NSSet *)touches withEvent:(UIEvent *)event {
    if (mState == NOT_SLEEP)
        [self clearNotSleepView];
    else if (mState == SLEEPING)
        [self clearSleepingView];
}

// get the current time
- (void)findCurrentTime {
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // extract hour and minute values
    NSArray *tokens = [[dateFormatter stringFromDate:now] componentsSeparatedByString:@" "];
    NSArray *comps1 = [[tokens objectAtIndex:0] componentsSeparatedByString:@"-"];
    NSArray *comps2 = [[tokens objectAtIndex:1] componentsSeparatedByString:@":"];
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    mYear   = [[f numberFromString:[comps1 objectAtIndex:0]] intValue];
    mMonth  = [[f numberFromString:[comps1 objectAtIndex:1]] intValue];
    mDay    = [[f numberFromString:[comps1 objectAtIndex:2]] intValue];
    mHour   = [[f numberFromString:[comps2 objectAtIndex:0]] intValue];
    mMinute = [[f numberFromString:[comps2 objectAtIndex:1]] intValue];
    mSecond = [[f numberFromString:[comps2 objectAtIndex:2]] intValue];
    [f release];
    
    [dateFormatter release];
}

// set the clock to the current time. the current time is got by calling findCurrentTime
- (void)tuneClockToCurrentTime {
    [self findCurrentTime];
    
    int h = mHour;
    if ( h > 11 ) mAp = 1;
    if ( h > 12 ) h = h - 12;
    else if ( h == 0 ) h = 12;
    [mClock setCurrentHour:h
                 andMinute:mMinute
                   andAmPm:mAp];
}

// display the time picker
- (void)showTimePicker {
    [mClock show];
}

// hide the time picker
- (void)hideTimePicker {
    [mClock dismiss];
}

// save the start time to db
- (void)saveTimeToDatabase:(BOOL)isStart {
    char now[256] = {0};
    sprintf(now, "%04d-%02d-%02d %02d:%02d:%02d", mYear, mMonth, mDay, mHour, mMinute, mSecond);
    printf("current time: %s\n", now);
    
    totModel *model = global.model;
    
    if (isStart) {
        printf("baby starts sleeping\n");
        [model addEvent:global.baby.babyID
                  event:EVENT_BASIC_SLEEP
         datetimeString:[NSString stringWithUTF8String:now]
                  value:@"start"];
    } else {
        printf("baby wakes up\n");
        [model addEvent:global.baby.babyID
                  event:EVENT_BASIC_SLEEP
         datetimeString:[NSString stringWithUTF8String:now]
                  value:@"end"];
    }
}

- (void)buttonPressed:(id)sender {
    UIButton *btn = (UIButton*)sender;
    switch (btn.tag) {
        case BUTTON_CLOSE:
            if (mState == NOT_SLEEP)
                [self clearNotSleepView];
            else if (mState == SLEEPING)
                [self clearSleepingView];
            break;
        case BUTTON_EDIT:
            [self tuneClockToCurrentTime];
            [self showTimePicker];
            break;
        case BUTTON_START:
            mState = SLEEPING;
            [self clearNotSleepView];
            if (!mUseTimePicker)
                [self findCurrentTime];
            [self saveTimeToDatabase:YES];
            [self showSleepingView];
            break;
        case BUTTON_END:
            mState = NOT_SLEEP;
            //[mSleepTimer invalidate];
            [self clearSleepingView];
            if (!mUseTimePicker)
                [self findCurrentTime];
            [self saveTimeToDatabase:NO];
            break;
        default:
            break;
    }
}

- (void)showSleepingView {
    // add timer
    mSleepTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                   target:self
                                                 selector:@selector(timerHandler)
                                                 userInfo:nil
                                                  repeats:YES];
    
    [self insertSubview:mSleepingBckgrnd belowSubview:mClock.view];
    
    //mCancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //[mCancelButton setTag:BUTTON_CLOSE];
    //[mCancelButton setFrame:CGRectMake(270, 40, 45, 45)];
    //[mCancelButton setImage:[UIImage imageNamed:@"icons-close.png"] forState:UIControlStateNormal];
    //[mCancelButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    //[self addSubview:mCancelButton];
    
    mEditButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mEditButton setTag:BUTTON_EDIT];
    [mEditButton setFrame:CGRectMake(191, 85, 32, 32)];
    [mEditButton setImage:[UIImage imageNamed:@"edit_2X.png"] forState:UIControlStateNormal];
    [mEditButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:mEditButton];
    
    mWakeupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mWakeupButton setTag:BUTTON_END];
    [mWakeupButton setFrame:CGRectMake(211, 43, 90, 68)];
    [mWakeupButton setImage:[UIImage imageNamed:@"wakeup_2X.png"] forState:UIControlStateNormal];
    [mWakeupButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    mTimeLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    [mTimeLabel setFrame:CGRectMake(215, 75, 90, 30)];
    [mTimeLabel.titleLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:12.0]];
    [mTimeLabel setTitleColor:[UIColor colorWithRed:0.5f green:0.51f blue:0.52 alpha:1.0f] forState:UIControlStateNormal];

    // press time label button is the same as wake up button
    [mTimeLabel setTag:BUTTON_END];
    [mTimeLabel addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self insertSubview:mWakeupButton aboveSubview:mSleepingBckgrnd];
    [self insertSubview:mTimeLabel aboveSubview:mWakeupButton];
    
    self.hidden = NO;

    // update time right away
    [self timerHandler];
}

- (void)clearSleepingView {
    [mSleepingBckgrnd removeFromSuperview];
    [mWakeupButton removeFromSuperview];
    [mTimeLabel removeFromSuperview];
    [mCancelButton removeFromSuperview];
    
    [mSleepTimer invalidate];
    
    self.hidden = YES;
}

- (void)showNotSleepView {
    // add timer
    mSleepTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                   target:self
                                                 selector:@selector(timerHandler)
                                                 userInfo:nil
                                                  repeats:YES];
    
    [self insertSubview:mReadyToSleepBckgrnd belowSubview:mClock.view];
    
    //mCancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //[mCancelButton setTag:BUTTON_CLOSE];
    //[mCancelButton setFrame:CGRectMake(270, 40, 45, 45)];
    //[mCancelButton setImage:[UIImage imageNamed:@"icons-close.png"] forState:UIControlStateNormal];
    //[mCancelButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    //[self addSubview:mCancelButton];

    mEditButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mEditButton setTag:BUTTON_EDIT];
    [mEditButton setFrame:CGRectMake(191, 85, 32, 32)];
    [mEditButton setImage:[UIImage imageNamed:@"edit_2X.png"] forState:UIControlStateNormal];
    //[mEditButton setFrame:CGRectMake(185, 80, 45, 45)];
    //[mEditButton setImage:[UIImage imageNamed:@"icons-sleep-edit.png"] forState:UIControlStateNormal];
    [mEditButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:mEditButton];
    
    mStartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mStartButton setTag:BUTTON_START];
    [mStartButton setFrame:CGRectMake(211, 43, 90, 68)];
    [mStartButton setImage:[UIImage imageNamed:@"start_2X.png"] forState:UIControlStateNormal];
    //[mLabelBckgrnd setFrame:CGRectMake(210, 50, 70, 50)];
    //[mLabelBckgrnd setImage:[UIImage imageNamed:@"icons-sleep-start.png"] forState:UIControlStateNormal];
    [mStartButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:mStartButton];
    
    self.hidden = NO;
}

- (void)clearNotSleepView {
    [mReadyToSleepBckgrnd removeFromSuperview];
    [mCancelButton removeFromSuperview];
    [mEditButton removeFromSuperview];
    [mStartButton removeFromSuperview];
    
    [mSleepTimer invalidate];
    
    self.hidden = YES;
}

// maintain a state machine
// NOT_SLEEP -> READY_TO_SLEEP -> SLEEPING
- (void)trigger {
    switch (mState) {
        case NOT_SLEEP: {
            [self showNotSleepView];
            break;
        }
        case SLEEPING: {
            [self showSleepingView];
            break;
        }
        default:
            break;
    }
}

#pragma mark - totTimerControllerDelegate
-(void)saveCurrentTime:(NSString*)time datetime:(NSDate*)datetime {
    [self hideTimePicker];
    
    mAp     = mClock.mCurrentAmPm;
    mHour   = mClock.mCurrentHourIdx+1;
    mMinute = mClock.mCurrentMinuteIdx;
    if ( mAp == 1 && mHour != 12 ) mHour += 12;

    char now[256] = {0};
    sprintf(now, "%02d:%02d", mHour, mMinute);
    printf("tune time to: %s\n", now);

    mUseTimePicker = YES;
}

-(void)cancelCurrentTime {
    [self hideTimePicker];
    mUseTimePicker = NO;
}

// release
- (void)dealloc {
    [mClock release];
    [mReadyToSleepBckgrnd release];
    [mSleepingBckgrnd release];
    [super dealloc];
}

@end
