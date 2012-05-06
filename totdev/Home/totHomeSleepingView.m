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
        mWidth = self.frame.size.width;
        mHeight = self.frame.size.height;
        
        mClock = [[totTimerController alloc] init];
        [mClock setDelegate:self];
        [self addSubview:mClock.view];
        mClock.view.frame = CGRectMake((mWidth-mClock.mWidth)/2, mHeight, mClock.mWidth, mClock.mHeight);
        
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

- (void)showTimePicker {
    mClockBtn.hidden = YES;
    [self setBackgroundColor:[UIColor blackColor]];
    [self setAlpha:0.8f];
    [UIView beginAnimations:@"swipe" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5f];
    mClock.view.frame = CGRectMake((mWidth-mClock.mWidth)/2, mHeight-mClock.mHeight, mClock.mWidth, mClock.mHeight);
    [UIView commitAnimations];
}

- (void)hideTimePicker {
    mClockBtn.hidden = NO;
    [self setBackgroundColor:[UIColor clearColor]];
    [UIView beginAnimations:@"swipe" context:nil];
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

- (void)startSleeping {
    self.hidden = NO;
    
    NSDate *now = [NSDate date];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *formattedDateString = [dateFormatter stringFromDate:now];
    [dateFormatter release];
    
    NSArray *tokens = [formattedDateString componentsSeparatedByString:@" "];
    NSArray *comps = [[tokens objectAtIndex:1] componentsSeparatedByString:@":"];
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *hourNum = [f numberFromString:[comps objectAtIndex:0]];
    NSNumber *minuteNum = [f numberFromString:[comps objectAtIndex:1]];
    [f release];
    
    int ap = 0;
    int hour = [hourNum intValue];
    int minute = [minuteNum intValue];
    if ( hour > 11 )
        ap = 1;
    if ( hour > 12 )
        hour = hour - 12;
    
    [mClock setCurrentHour:hour-1 andMinute:minute andAmPm:ap];
}

#pragma mark - totTimerControllerDelegate
-(void)saveCurrentTime:(NSString*)time {
    [self hideTimePicker];
}

-(void)cancelCurrentTime {
    [self hideTimePicker];
}

- (void)startTimer {}

- (void)makeNoView {
    self.hidden = YES;
}

- (void)dealloc {
    [mClock release];   
}

@end
