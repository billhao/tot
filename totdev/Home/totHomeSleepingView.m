//
//  totHomeSleepingView.m
//  totdev
//
//  Created by Lixing Huang on 5/5/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totHomeSleepingView.h"
#import "totTimerController.h"


@implementation totHomeSleepingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        
        mWidth = self.frame.size.width;
        mHeight= self.frame.size.height;
        
        mClock = [[totTimerController alloc] init];
        mClock.view.frame = CGRectMake((mWidth-mClock.mWidth)/2, mHeight, mClock.mWidth, mClock.mHeight);
        [mClock setMode:kTime];
        [mClock setDelegate:self];
        [self addSubview:mClock.view];
        
        mClockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        mClockBtn.frame = CGRectMake(100, 100, 25, 25);
        [mClockBtn setImage:[UIImage imageNamed:@"clock.png"] forState:UIControlStateNormal];
        [mClockBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:mClockBtn];
        
        [self setBackgroundColor:[UIColor clearColor]];
        self.hidden = YES;
    }
    return self;
}

- (void)setParentView:(UIView *)parent {
    mParentView = parent;
}

- (void)showTimePicker {
    mClockBtn.hidden = YES;
//    [self setBackgroundColor:[UIColor blackColor]];
//    [self setAlpha:0.8f];
    [UIView beginAnimations:@"showPicker" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5f];
    mClock.view.frame = CGRectMake((mWidth-mClock.mWidth)/2, mHeight-mClock.mHeight-60, mClock.mWidth, mClock.mHeight);
    [UIView commitAnimations];
}

- (void)animationFinished:(NSString*)animationID finished:(NSNumber*)finished context:(void*)context {
    if( [animationID isEqualToString:@"hidePicker"] ) {
        self.hidden = YES;
    }
}

- (void)hideTimePicker {
    mClockBtn.hidden = NO;
    [self setBackgroundColor:[UIColor clearColor]];
    
    [UIView beginAnimations:@"hidePicker" context:nil];
	[UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5f];
    mClock.view.frame = CGRectMake((mWidth-mClock.mWidth)/2, mHeight, mClock.mWidth, mClock.mHeight);
    [UIView commitAnimations];
}

- (void)buttonPressed: (id)sender {
    [self showTimePicker];
}

- (void)stopSleeping {
    
}

- (void)startTimer {
    
}

- (void)startSleeping {
    self.hidden = NO;
    
    NSDate *now = [NSDate date];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *formattedDateString = [dateFormatter stringFromDate:now];
    [dateFormatter release];
    
    // extract hour and minute values
    NSArray *tokens = [formattedDateString componentsSeparatedByString:@" "];
    NSArray *comps = [[tokens objectAtIndex:1] componentsSeparatedByString:@":"];
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *hourNum = [f numberFromString:[comps objectAtIndex:0]];
    NSNumber *minuteNum = [f numberFromString:[comps objectAtIndex:1]];
    [f release];
    
    // initialize the picker view to display the current time
    int ap = 0;
    int hour = [hourNum intValue];
    int minute = [minuteNum intValue];
    if ( hour > 11 ) ap = 1;
    if ( hour > 12 )
        hour = hour - 12;
    else if ( hour == 0 )
        hour = 12;
    
    [mClock setCurrentHour:hour andMinute:minute andAmPm:ap];
    
    [self startTimer];
}

- (void)makeNoView {
    self.hidden = YES;
}

#pragma mark - totTimerControllerDelegate
-(void)saveCurrentTime:(NSString*)time {
    [self hideTimePicker];
}

-(void)cancelCurrentTime {
    [self hideTimePicker];
}

- (void)dealloc {
    [mClock release];   
}

@end
