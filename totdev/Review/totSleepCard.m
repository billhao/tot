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
+ (int) width { return 310; }

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
    UIImageView* icon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
    icon.image = [UIImage imageNamed:@"sleep2.png"];
    [self.view addSubview:icon];
    [icon release];
    
    Walltime now; [totTimeUtil now:&now];
    
    time_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [time_button setFrame:CGRectMake(TIME1_X, TIME_Y, TIME1_W, TIME_H)];
    [time_button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [time_button setTitle:[NSString stringWithFormat:@"%02d:%02d", now.hour, now.minute]
                 forState:UIControlStateNormal];
    [time_button.titleLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:20]];
    [self.view addSubview:time_button];
    
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
}

- (void)stopSleep: (UIButton*)button {}

- (void)dealloc {
    [super dealloc];
    [time_button release];
    [start_button release];
    [stop_button release];
}

@end



@implementation totSleepShowCard

+ (int) height { return 70; }
+ (int) width { return 310; }

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

