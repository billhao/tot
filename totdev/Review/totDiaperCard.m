//
//  totDiaperCard.m
//  totdev
//
//  Created by Lixing Huang on 8/11/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import "totDiaperCard.h"
#import "totTimeUtil.h"
#import "totImageView.h"

@implementation totDiaperEditCard

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

+ (int) height { return 200; }
+ (int) width { return 308; }

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackground];
    [self loadIcons];
    [self loadInputContent];
}

- (void) setBackground {
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void) loadIcons {
    [self setIcon:@"diaper_gray.png" withCalendarDays:999];
    [self setTimestamp];
    [self setTitle:@"Diaper"];
    [self setConfirmAndCancelButtons:140];
}

- (void) loadInputContent {
    int x = 68;
    wet = [[totImageView alloc] initWithFrame: CGRectMake(x, 75, 193, 28)];
    [wet imageFilePath:@"icons-diaper-wet_new"];
    [self.view addSubview:wet];

    solid = [[totImageView alloc] initWithFrame:CGRectMake(x, 105, 193, 28)];
    [solid imageFilePath:@"icons-diaper-solid_new"];
    [self.view addSubview:solid];

    wet_solid = [[totImageView alloc] initWithFrame:CGRectMake(x, 135, 193, 28)];
    [wet_solid imageFilePath:@"icons-diaper-wetandsolid_new"];
    [self.view addSubview:wet_solid];
}

- (void) confirm: (UIButton*)btn {
    [self.parentView flip];
}
- (void) cancel: (UIButton*)btn {}

- (void) dealloc {
    [super dealloc];
    [wet release];
    [solid release];
    [wet_solid release];
}

@end




@implementation totDiaperShowCard

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

+ (int) height { return 300; }
+ (int) width { return 308; }

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadIcons];
    [self setBackground];
}


- (void) setBackground {
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void) loadIcons {
    // Load icon.
    UIImageView* icon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
    icon.image = [UIImage imageNamed:@"circle_icon.jpg"];
    [self.view addSubview:icon];
    [icon release];
    
    // Load the calendar icon.
    UIImageView* calendar = [[UIImageView alloc] initWithFrame:CGRectMake(260, 5, 40, 40)];
    calendar.image = [UIImage imageNamed:@"circle_icon.jpg"];
    [self.view addSubview:calendar];
    [calendar release];
    
    // Initialize the days label.
    age_in_days_label = [[UILabel alloc] initWithFrame:CGRectMake(265, 10, 20, 20)];
    age_in_days_label.backgroundColor = [UIColor greenColor];
    age_in_days_label.text = @"165";
    [age_in_days_label setFont:[UIFont fontWithName:@"Roboto-Regular" size:12]];
    [self.view addSubview:age_in_days_label];
    
    // Initialize the status label.
    diaper_status_label = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 70, 50)];
    diaper_status_label.text = @"Wet";
    diaper_status_label.backgroundColor = [UIColor blueColor];
    [diaper_status_label setTextColor:[UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1.0f]];
    [diaper_status_label setFont:[UIFont fontWithName:@"Roboto-Regular" size:12]];
    [self.view addSubview:diaper_status_label];
    
    // Initialize the timestamp label.
    timestamp_label = [[UILabel alloc] initWithFrame:CGRectMake(60, 70, 60, 30)];
    timestamp_label.text = @"50 minutes ago";
    timestamp_label.backgroundColor = [UIColor greenColor];
    [timestamp_label setTextColor:[UIColor colorWithRed:0.6f green:0.6f blue:0.6f alpha:1.0f]];
    [timestamp_label setFont:[UIFont fontWithName:@"Roboto-Regular" size:12]];
    [self.view addSubview:timestamp_label];
    
    // Initialize the description label.
    description = [[UILabel alloc] initWithFrame:CGRectMake(5, 120, 300, 50)];
    description.text = @"This is the third time today.";
    description.backgroundColor = [UIColor grayColor];
    [self.view addSubview:description];
}

- (void) dealloc {
    [description release];
    [timestamp_label release];
    [diaper_status_label release];
    [age_in_days_label release];
    [super dealloc];
    
}

@end



