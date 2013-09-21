//
//  totSleepCard.m
//  totdev
//
//  Created by Lixing Huang on 8/11/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import "totSleepCard.h"
#import "totTimeUtil.h"
#import "totReviewCardView.h"
#import "totTimeline.h"
#import "totUtility.h"
#import "totReviewStory.h"

@implementation totSleepEditCard

- (int) height { return 60; }
- (int) width { return 308; }

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadIcons];
}

- (void)viewWillAppear:(BOOL)animated {
}

- (void)loadIcons {
    [self setIcon:@"sleep2"];
    [self setTitle:@"Sleep"];
    [self setTimestamp];
    
    line.hidden = TRUE; // we don't need line for sleep;
    
    UIFont* font = [UIFont fontWithName:@"Raleway" size:20.0];
    
    start_button = [UIButton buttonWithType:UIButtonTypeCustom];
    float w = 90;
    float h = 40;
    float x = 210;
    float y = ([self height]-h)/2;
    start_button.frame = CGRectMake(x,y,w,h);
    start_button.backgroundColor = [UIColor lightGrayColor];
//    start_button.alpha = 0.8;
    start_button.layer.cornerRadius = 2;
    start_button.titleLabel.font = font;
    [start_button setTitle:@"sleep" forState:UIControlStateNormal];
    [start_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [start_button addTarget:self action:@selector(startSleep:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:start_button];
    
    stop_button = [UIButton buttonWithType:UIButtonTypeCustom];
    stop_button.frame = CGRectMake(x,y,w,h);
    stop_button.backgroundColor = [UIColor lightGrayColor];
    stop_button.layer.cornerRadius = 2;
    stop_button.titleLabel.font = font;
    stop_button.hidden = YES;
//    start_button.alpha = 0.7;
    start_button.titleLabel.font = font;
    [stop_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [stop_button setTitle:@"wake up" forState:UIControlStateNormal];
    [stop_button addTarget:self action:@selector(stopSleep:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stop_button];
}

- (void)startSleep: (UIButton*)button {
    start_button.hidden = YES;
    stop_button.hidden = NO;
    
    self.parentView.parent.sleeping = TRUE;
    
    [self.parentView.parent moveCard:self.parentView To:0];
    [self.parentView.parent moveToTop:self.parentView];
    
    [self saveTimeToDatabase:TRUE];
}

- (void)stopSleep: (UIButton*)button {
    self.parentView.parent.sleeping = FALSE;

    // Save to db.
    [self saveTimeToDatabase:FALSE];
    
    [self.parentView.parent moveCard:self.parentView To:1];
    [self.parentView flip];
    
    // Update the summary card.
    NSMutableArray* events = [global.model getEvent:global.baby.babyID event:EVENT_BASIC_SLEEP limit:2];
    if( events.count==2 ) {
        totEvent* e1 = events[0];
        totEvent* e0 = events[1];
        if( [e1.value isEqualToString:@"end"] && [e0.value isEqualToString:@"start"] ) {
            NSString* label = [totSleepShowCard formatValue:e0.datetime d2:e1.datetime];
            [self.parentView.parent updateSummaryCard:SLEEP withValue:label];
        }
    }
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark - Helper functions

// save the start time to db
- (void)saveTimeToDatabase:(BOOL)isStart {
//    char now[256] = {0};
//    sprintf(now, "%04d-%02d-%02d %02d:%02d:%02d", mYear, mMonth, mDay, mHour, mMinute, mSecond);
//    printf("current time: %s\n", now);
    
    NSDate* now = [NSDate date];
    
    totModel *model = global.model;
    
    if (isStart) {
        [model addEvent:global.baby.babyID
                  event:EVENT_BASIC_SLEEP
               datetime:now
                  value:@"start"];
    } else {
        [model addEvent:global.baby.babyID
                  event:EVENT_BASIC_SLEEP
               datetime:now
                  value:@"end"];
    }
}


@end


@implementation totSleepShowCard

@synthesize sleepStartEvent;

- (int) height { return 60; }
- (int) width { return 308; }

- (id)init {
    self = [super init];
    if (self) {
        e = nil;
        sleepStartEvent = nil;
    }
    return self;
}

-(void)dealloc {
    [super dealloc];
    if( e ) [e release];
    if( sleepStartEvent ) [sleepStartEvent release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackground];
    [self setIcon:@"sleep2"];

    line.hidden = TRUE; // we don't need line for sleep;
}

-(void)viewWillAppear:(BOOL)animated {
    // If we load card from database, should not call this function again.
    // when loading from db, story_ will not be nil.
    if (!story_) {
        [self getDataFromDB];
    } else {
        [self getSleepStart];
    }
    
    [self updateUI];
}


#pragma mark - Helper functions

- (void)getDataFromDB {
    // query db to get how long the baby had slept
    NSDate* date = [NSDate date];
    NSMutableArray* events = [global.model getEvent:global.baby.babyID event:EVENT_BASIC_SLEEP limit:2];
    if( events.count==2 ) {
        totEvent* e1 = events[0];
        totEvent* e0 = events[1];
        if( [e1.value isEqualToString:@"end"] && [e0.value isEqualToString:@"start"] ) {
            sleepStartEvent = [e0 retain];
            e = [e1 retain];
        }
    }
}

- (void)getSleepStart {
    NSMutableArray* events = [global.model getEvent:global.baby.babyID event:EVENT_BASIC_SLEEP limit:1 offset:-1 startDate:nil endDate:story_.mWhen];
    if( events.count == 1 ) {
        totEvent* e0 = events[0];
        if( [e0.value isEqualToString:@"start"] ) {
            sleepStartEvent = [e0 retain];
        } else {
            NSLog(@"there is a problem with sleep record %d %d", story_.mEventId, e.event_id);
        }
    }
}

- (void)updateUI {
    if( e == nil || sleepStartEvent == nil ) return;
    
    // Get conversion to months, days, hours, minutes
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *conversionInfo = [sysCalendar components:unitFlags
                                                      fromDate:sleepStartEvent.datetime
                                                        toDate:e.datetime options:0];
    
    int h = [conversionInfo hour];
    int m = [conversionInfo minute];
    //int s = [conversionInfo second];
    
    NSString* text;
    if( h>0 && m<10 ) {
        if( h==1 )
            text = [NSString stringWithFormat:@"%@ slept for about an hour", global.baby.name];
        else
            text = [NSString stringWithFormat:@"%@ slept for about %d hours", global.baby.name, h];
    }
    else if( m>50 ) {
        if( h==0 )
            text = [NSString stringWithFormat:@"%@ slept for about an hour", global.baby.name];
        else
            text = [NSString stringWithFormat:@"%@ slept for about %d hours", global.baby.name, h+1];
    }
    else if( h==0 && m==0 )
        text = [NSString stringWithFormat:@"%@ slept for less than a minute", global.baby.name];
    else if( h==0 && m==1 )
        text = [NSString stringWithFormat:@"%@ slept for a minute", global.baby.name];
    else if( h==0 && m>1 )
        text = [NSString stringWithFormat:@"%@ slept for %d minutes", global.baby.name, m];
    else if( h>=15 )
        text = [NSString stringWithFormat:@"%@ slept for %d hours. Really?", global.baby.name, h];
    else
        text = [NSString stringWithFormat:@"%@ slept for %d hours %d minutes", global.baby.name, h, m];
    
    card_title.font = [UIFont fontWithName:@"Raleway-SemiBold" size:14];
    card_title.numberOfLines = 0;
    card_title.text = text;
    description.text = @"";
//    card_title.text = [totSleepShowCard formatValue:sleepStartEvent.datetime d2:story_.mWhen];
    
    [self setTimestamp:[totTimeUtil getTimeDescriptionFromNow:sleepStartEvent.datetime]];
}

// d2 is the later date
+ (NSString*)formatValue:(NSDate*)d1 d2:(NSDate*)d2 {
    // Get conversion to months, days, hours, minutes
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *conversionInfo = [sysCalendar components:unitFlags fromDate:d1  toDate:d2 options:0];
    
    int h = [conversionInfo hour];
    int m = [conversionInfo minute];
    
    if( h > 0 )
        return [NSString stringWithFormat:@"%d hr %d min", h, m];
    else
        return [NSString stringWithFormat:@"%d min", m];
}

@end

