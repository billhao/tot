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

- (void)loadIcons {
    [self setIcon:@"sleep_gray.png"];
    [self setTitle:@"Sleep"];
    [self setTimestamp];
    
    //stop_button = [UIButton buttonWithType:UIButtonTypeCustom];
    //stop_button.backgroundColor = [UIColor redColor];
    //stop_button.hidden = YES;
    //[stop_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[stop_button setTitle:@"Wake up" forState:UIControlStateNormal];
    //[stop_button setFrame:CGRectMake(200, 5, 80, 40)];
    //[stop_button addTarget:self action:@selector(stopSleep:) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:stop_button];
}

- (void)startSleep: (UIButton*)button {
    //start_button.hidden = YES;
    //stop_button.hidden = NO;
    [self.parentView.parent moveCard:self.parentView To:0];
    [self.parentView.parent moveToTop:self.parentView];
}

- (void)stopSleep: (UIButton*)button {}

- (void)dealloc {
    [super dealloc];
    //[time_button release];
    //[start_button release];
    //[stop_button release];
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
}

@end

