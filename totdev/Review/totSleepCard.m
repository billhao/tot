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

+ (int) height { return 70; }
+ (int) width { return 308; }

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
    [self setIcon:@"sleep_gray.png"];
    [self setTitle:@"Sleep"];
    [self setTimestamp];
    
    start_button = [UIButton buttonWithType:UIButtonTypeCustom];
    start_button.backgroundColor = [UIColor greenColor];
    [start_button setTitle:@"Sleep" forState:UIControlStateNormal];
    [start_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [start_button setFrame:CGRectMake(200, 5, 60, 40)];
    [start_button addTarget:self action:@selector(startSleep:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:start_button];
    
    stop_button = [UIButton buttonWithType:UIButtonTypeCustom];
    stop_button.backgroundColor = [UIColor redColor];
    stop_button.hidden = YES;
    [stop_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [stop_button setTitle:@"Wake up" forState:UIControlStateNormal];
    [stop_button setFrame:CGRectMake(200, 5, 80, 40)];
    [stop_button addTarget:self action:@selector(stopSleep:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stop_button];
}

- (void)startSleep: (UIButton*)button {
    start_button.hidden = YES;
    stop_button.hidden = NO;
    
    [self.parentView.parent moveCard:self.parentView To:0];
    [self.parentView.parent moveToTop:self.parentView];
    
    [self saveTimeToDatabase:TRUE];
}

- (void)stopSleep: (UIButton*)button {
    // save to db
    [self saveTimeToDatabase:FALSE];

    //[parentView flip];
    // should be: 1. remove this card
    // 2. add the card under the summary card
    // 3. move the scroll view the the sleep show card.
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

+ (int) height { return 70; }
+ (int) width { return 308; }

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackground];
    [self setIcon:@"sleep2.png"];
}

-(void)viewWillAppear:(BOOL)animated {
    // If we load card from database, should not call this function again.
    // when loading from db, story_ will not be nil.
    if (story_) {
        [self getDataFromDB];
    } else {
        card_title.text = story_.mRawContent;
        description.text = @"";
        [self setTimestamp:[totTimeUtil getTimeDescriptionFromNow:story_.mWhen]];
    }
}


#pragma mark - Helper functions

- (void)getDataFromDB {
    // query db to get how long the baby had slept
    NSDate* date = [NSDate date];
    NSMutableArray* sleep = [global.model getPreviousEvent:global.baby.babyID event:EVENT_BASIC_SLEEP limit:1 current_event_date:date];
    if( sleep.count > 0 ) {
        //totEvent* e = sleep[0];
        totEvent* e = [sleep objectAtIndex:0];
        //NSLog(@"%d %@ - %d %@", e.event_id, e.datetime, story.mEventId, story.mWhen);
        
        // Get conversion to months, days, hours, minutes
        NSCalendar *sysCalendar = [NSCalendar currentCalendar];
        unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents *conversionInfo = [sysCalendar components:unitFlags fromDate:e.datetime  toDate:date options:0];
        
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
        card_title.text = text;
        description.text = @"";
    }
    else {
        card_title.text = @"";
        description.text = @"";
    }
}
@end

