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

@implementation totHomeSleepingView

@synthesize mIsSleeping;
@synthesize mParentView;

static int gInterval = 0;
static NSString *justSleepString = @"Just slept :)";

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.hidden = YES;
        
        mWidth = self.frame.size.width;
        mHeight= self.frame.size.height;
  
        // time picker
        mClock = [[totTimerController alloc] init];
        mClock.view.frame = CGRectMake((mWidth-mClock.mWidth)/2, mHeight, mClock.mWidth, mClock.mHeight);
        [mClock setMode:kTime];
        [mClock setDelegate:self];
        [self addSubview:mClock.view];
        
        /* inside the cloud */
        
        // bubble background
        mBackground = [[UIImageView alloc] initWithFrame:CGRectMake(120+200, 40, 220, 100)];
        [mBackground setImage:[UIImage imageNamed:@"message_cloud.png"]];
        [self addSubview:mBackground];
        
        // label
        mTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(190+200, 75, 100, 20)];
        mTimeLabel.backgroundColor = [UIColor clearColor];
        mTimeLabel.text = @"";
        [mTimeLabel setFont:[UIFont fontWithName:@"Arial" size:13.0]];
        [self insertSubview:mTimeLabel aboveSubview:mBackground];
        
        // clock button
        mClockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        mClockBtn.frame = CGRectMake(140+200, 55, 25, 25);
        [mClockBtn setImage:[UIImage imageNamed:@"clock.png"] forState:UIControlStateNormal];
        [mClockBtn addTarget:self action:@selector(clockButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self insertSubview:mClockBtn aboveSubview:mBackground];
        
        // confirm button
        mConfirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        mConfirmButton.frame = CGRectMake(180+200, 140, 55, 37);
        [mConfirmButton setImage:[UIImage imageNamed:@"message_cloud_revised-02.png"] forState:UIControlStateNormal];
        [mConfirmButton addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
        [self insertSubview:mConfirmButton aboveSubview:mBackground];
        
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)addTimeDisplayLabel {
    if( !mParentView ) {
        printf("assign parent view first\n");
        return;
    }
    
    mDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 120-200, 100, 30)];
    mDisplayLabel.backgroundColor = [UIColor clearColor];
    mDisplayLabel.text = @"";
    [mDisplayLabel setFont:[UIFont fontWithName:@"Arial" size:13.0]];
    [mParentView addSubview:mDisplayLabel];
    
    // check whether we need setup a timer or not
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    totModel *model = [delegate getDataModel];
    NSMutableArray *sleepRecords = [model getEvent:delegate.mBabyId event:EVENT_BASIC_SLEEP];
    if( [sleepRecords count] > 0 ) {
        totEvent *evt = [sleepRecords objectAtIndex:0];
        if( [evt.value isEqualToString:@"start"] ) {
            mIsSleeping = YES;
            
            // find the interval
            NSTimeInterval lastDiff = [evt.datetime timeIntervalSinceNow];
            gInterval = -(int)lastDiff;
            
            // start the timer
            mSleepTimer = [NSTimer scheduledTimerWithTimeInterval:60 
                                                           target:self 
                                                         selector:@selector(handleTime) 
                                                         userInfo:nil 
                                                          repeats:YES];
            [self makeDisplayLabelView];
        }
    }
}

/// gap: the number of seconds
- (void)calculateDisplayedTime:(int)gap {
    char desc[64] = {0};
    if( gap == 1 ) {
        mDisplayLabel.text = @"1 minute ago";
    } else {
        if ( gap < 60 ) {
            sprintf(desc, "%d minutes ago", gap);
            mDisplayLabel.text = [NSString stringWithUTF8String:desc];
        } else {
            if( gap < 120 )
                mDisplayLabel.text = @"1 hour ago";
            else {
                sprintf(desc, "%d hours ago", (int)gap/60);
                mDisplayLabel.text = [NSString stringWithUTF8String:desc];
            }
        }
    }
}

- (void)removeDisplayLabelView {
    [UIView beginAnimations:@"removeDisplay" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
        mDisplayLabel.frame = CGRectMake(220, 120-200, 100, 30);
    [UIView commitAnimations];
}

- (void)makeDisplayLabelView {
    if( mIsSleeping ) {
        if( gInterval == 0 )
            [mDisplayLabel setText:justSleepString];
        else
            [self calculateDisplayedTime:gInterval];
        
        [UIView beginAnimations:@"showDisplay" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.5];
            mDisplayLabel.frame = CGRectMake(220, 120, 100, 30);
        [UIView commitAnimations];
    }
}

- (void)makeNoView {
    [UIView beginAnimations:@"hideSleepView" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5f];
        mBackground.frame = CGRectMake(120+200, 40, 220, 100);
        mTimeLabel.frame = CGRectMake(190+200, 75, 100, 20);
        mClockBtn.frame = CGRectMake(140+200, 55, 25, 25);
        mConfirmButton.frame = CGRectMake(180+200, 140, 55, 37);
    [UIView commitAnimations];
}

- (void)makeFullView {
    [UIView beginAnimations:@"showSleepView" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5f];
        mBackground.frame = CGRectMake(120, 40, 220, 100);
        mTimeLabel.frame = CGRectMake(190, 75, 100, 20);
        mClockBtn.frame = CGRectMake(140, 55, 25, 25);
        mConfirmButton.frame = CGRectMake(180, 140, 55, 37);
    [UIView commitAnimations];
}

- (void)animationFinished:(NSString*)animationID finished:(NSNumber*)finished context:(void*)context {
    if( [animationID isEqualToString:@"hidePicker"] ) {
        mClockBtn.hidden = NO;
    } else if( [animationID isEqualToString:@"hideSleepView"] ) {
        self.hidden = YES;
        
        for(UIView *subview in [mParentView subviews]) {
            if( [subview isKindOfClass:[UIButton class]] )
                subview.hidden = NO;
        }
        [self makeDisplayLabelView];
    }
}

- (void)showTimePicker {
    mClockBtn.hidden = YES;
    [UIView beginAnimations:@"showPicker" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5f];
        mClock.view.frame = CGRectMake((mWidth-mClock.mWidth)/2, mHeight-mClock.mHeight-60, mClock.mWidth, mClock.mHeight);
    [UIView commitAnimations];
}

- (void)hideTimePicker {
    [UIView beginAnimations:@"hidePicker" context:nil];
	[UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5f];
        mClock.view.frame = CGRectMake((mWidth-mClock.mWidth)/2, mHeight, mClock.mWidth, mClock.mHeight);
    [UIView commitAnimations];
}

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
    _year   = [[f numberFromString:[comps1 objectAtIndex:0]] intValue];
    _month  = [[f numberFromString:[comps1 objectAtIndex:1]] intValue];
    _day    = [[f numberFromString:[comps1 objectAtIndex:2]] intValue];
    _hour   = [[f numberFromString:[comps2 objectAtIndex:0]] intValue];
    _minute = [[f numberFromString:[comps2 objectAtIndex:1]] intValue];
    _second = [[f numberFromString:[comps2 objectAtIndex:2]] intValue];
    
    [dateFormatter release];
    [f release];
}

- (void)clockButtonPressed: (id)sender {
    int h = _hour;
    if ( h > 11 ) _ap = 1;
    if ( h > 12 ) h = h - 12;
    else if ( h == 0 ) h = 12;
    [mClock setCurrentHour:h
                 andMinute:_minute
                   andAmPm:_ap];
    
    [self showTimePicker];
}

- (void)cancel {
    mIsSleeping = NO;
    
    [self makeNoView];
}

- (void)handleTime {
    gInterval = gInterval+1;
    
    [self calculateDisplayedTime:gInterval];
}

- (void)confirm {
    char now[256] = {0};
    sprintf(now, "%04d-%02d-%02d %02d:%02d:%02d", _year, _month, _day, _hour, _minute, _second);
    printf("sleeping time: %s\n", now);
    
    // save it into db
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    totModel *model = [delegate getDataModel];
    [model addEvent:delegate.mBabyId event:EVENT_BASIC_SLEEP datetimeString:[NSString stringWithUTF8String:now] value:@"start"];
    
    // start a NSTimer to refresh the time label
    mSleepTimer = [NSTimer scheduledTimerWithTimeInterval:60 
                                                   target:self 
                                                 selector:@selector(handleTime) 
                                                 userInfo:nil 
                                                  repeats:YES];
    mIsSleeping = YES;
    gInterval = 0;
    
    [self makeNoView];
}

- (void)startSleeping {
    self.hidden = NO;
    
    // remove all button in the parent view
    for(UIView *subview in [mParentView subviews]) {
        if( [subview isKindOfClass:[UIButton class]] )
            subview.hidden = YES;
    }
    
    [self makeFullView];
    
    [self findCurrentTime];
    
    char now[256] = {0};
    sprintf(now, "Sleep: %02d:%02d", _hour, _minute);
    [mTimeLabel setText:[NSString stringWithUTF8String:now]];
}

- (void)stopSleeping {
    char now[256] = {0};
    
    [self findCurrentTime];
    sprintf(now, "%04d-%02d-%02d %02d:%02d:%02d", _year, _month, _day, _hour, _minute, _second);
    printf("sleep end: %s\n", now);

    // insert into db
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    totModel *model = [delegate getDataModel];
    [model addEvent:delegate.mBabyId event:EVENT_BASIC_SLEEP datetimeString:[NSString stringWithUTF8String:now] value:@"end"];
    
    // clear the timer
    [mSleepTimer invalidate];
    
    // clean the label from parent view
    [self removeDisplayLabelView];
    
    mIsSleeping = NO;
}

#pragma mark - totTimerControllerDelegate
-(void)saveCurrentTime:(NSString*)time {
    [self hideTimePicker];
    
    _hour = mClock.mCurrentHourIdx;
    _minute = mClock.mCurrentMinuteIdx;
    _ap = mClock.mCurrentAmPm;
    if ( _ap == 1 && _hour != 12 )
        _hour += 12;
    
    char now[256] = {0};
    sprintf(now, "Sleep: %02d:%02d", _hour, _minute);
    [mTimeLabel setText:[NSString stringWithUTF8String:now]];
}

-(void)cancelCurrentTime {
    [self hideTimePicker];
}

- (void)dealloc {
    [mClock release];
    [mDisplayLabel release];
    [mBackground release];
    [mTimeLabel release];
    [mDisplayLabel release];
}

@end
