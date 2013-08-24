//
//  totSummaryCard.m
//  totdev
//
//  Created by Lixing Huang on 8/11/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import "totSummaryCard.h"

@implementation totSummaryCard

+ (int) height { return 380; }
+ (int) width { return 310; }

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackground];
        [self loadIcons];
        [self loadLabels];
        
        [self loadData];
    }
    return self;
}

- (void)setBackground {
    [self setBackgroundColor:[UIColor whiteColor]];
}

- (void)loadIcons {
    int x[] = {5, 160, 5, 160, 5, 160, 5};
    int y[] = {80, 80, 160, 160, 240, 240, 320};
    int index = 0;
    
    icon_height = [[UIImageView alloc] initWithFrame:CGRectMake(x[index], y[index], 40, 40)]; ++index;
    icon_diaper = [[UIImageView alloc] initWithFrame:CGRectMake(x[index], y[index], 40, 40)]; ++index;
    icon_weight = [[UIImageView alloc] initWithFrame:CGRectMake(x[index], y[index], 40, 40)]; ++index;
    icon_sleep = [[UIImageView alloc] initWithFrame:CGRectMake(x[index], y[index], 40, 40)]; ++index;
    icon_hc = [[UIImageView alloc] initWithFrame:CGRectMake(x[index], y[index], 40, 40)]; ++index;
    icon_language = [[UIImageView alloc] initWithFrame:CGRectMake(x[index], y[index], 40, 40)]; ++index;
    icon_feed = [[UIImageView alloc] initWithFrame:CGRectMake(x[index], y[index], 40, 40)]; ++index;

    icon_height.image = [UIImage imageNamed:@"height2.png"];
    icon_diaper.image = [UIImage imageNamed:@"diaper2.png"];
    icon_weight.image = [UIImage imageNamed:@"weight2.png"];
    icon_sleep.image = [UIImage imageNamed:@"sleep2.png"];
    icon_hc.image = [UIImage imageNamed:@"hc2.png"];
    icon_language.image = [UIImage imageNamed:@"language2.png"];
    icon_feed.image = [UIImage imageNamed:@"food2.png"];
    
    [self addSubview:icon_height];
    [self addSubview:icon_weight];
    [self addSubview:icon_hc];
    [self addSubview:icon_language];
    [self addSubview:icon_sleep];
    [self addSubview:icon_diaper];
    [self addSubview:icon_feed];
}

- (void)loadLabels {
    label_babyName = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 200, 40)];
    
    int x[] = {55, 210, 55, 210, 55, 210, 55};  // should be the value in the x array in loadIcons + 50
    int y[] = {80, 80, 160, 160, 240, 240, 310};  // should be the same as the y array in loadIcons
    int index = 0;
    
    label_height = [[UILabel alloc] initWithFrame:CGRectMake(x[index], y[index], 100, 40)]; ++index;
    label_diaper = [[UILabel alloc] initWithFrame:CGRectMake(x[index], y[index], 100, 40)]; ++index;
    label_weight = [[UILabel alloc] initWithFrame:CGRectMake(x[index], y[index], 100, 40)]; ++index;
    label_sleep = [[UILabel alloc] initWithFrame:CGRectMake(x[index], y[index], 100, 40)]; ++index;
    label_hc = [[UILabel alloc] initWithFrame:CGRectMake(x[index], y[index], 100, 40)]; ++index;
    label_language = [[UILabel alloc] initWithFrame:CGRectMake(x[index], y[index], 100, 40)]; ++index;
    label_feed = [[UILabel alloc] initWithFrame:CGRectMake(x[index], y[index], 255, 60)]; ++index;
    
    // color them.
    //label_height.backgroundColor = [UIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:0.8f];
    //label_diaper.backgroundColor = [UIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:0.8f];
    //label_weight.backgroundColor = [UIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:0.8f];
    //label_sleep.backgroundColor = [UIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:0.8f];
    //label_hc.backgroundColor = [UIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:0.8f];
    //label_language.backgroundColor = [UIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:0.8f];
    //label_feed.backgroundColor = [UIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:0.8f];
    
    UIColor* fontColor = [UIColor grayColor];
    [label_height setFont:[UIFont fontWithName:@"Roboto-Regular" size:15]];
    [label_height setTextColor:fontColor];
    [label_diaper setFont:[UIFont fontWithName:@"Roboto-Regular" size:15]];
    [label_diaper setTextColor:fontColor];
    [label_weight setFont:[UIFont fontWithName:@"Roboto-Regular" size:15]];
    [label_weight setTextColor:fontColor];
    [label_sleep setFont:[UIFont fontWithName:@"Roboto-Regular" size:15]];
    [label_sleep setTextColor:fontColor];
    [label_hc setFont:[UIFont fontWithName:@"Roboto-Regular" size:15]];
    [label_hc setTextColor:fontColor];
    [label_language setFont:[UIFont fontWithName:@"Roboto-Regular" size:15]];
    [label_language setTextColor:fontColor];
    [label_feed setFont:[UIFont fontWithName:@"Roboto-Regular" size:15]];
    [label_feed setTextColor:fontColor];
    
    [self addSubview:label_height];
    [self addSubview:label_weight];
    [self addSubview:label_hc];
    [self addSubview:label_sleep];
    [self addSubview:label_diaper];
    [self addSubview:label_language];
    [self addSubview:label_feed];
    
    [self addSubview:label_babyName];
}

- (void) loadData {
    [label_height setText:@"100cm"];
    [label_diaper setText:@"Wet"];
    [label_weight setText:@"5kg"];
    [label_sleep setText:@"10hr"];
    [label_hc setText:@"25cm"];
    [label_language setText:@"Mom"];
    [label_feed setText:@"milk 2oz, apple 3pc"];
}

- (void) dealloc {
    [super dealloc];
    
    [icon_height release];
    [icon_weight release];
    [icon_hc release];
    [icon_sleep release];
    [icon_language release];
    [icon_feed release];
    [icon_diaper release];
    
    [label_height release];
    [label_weight release];
    [label_hc release];
    [label_sleep release];
    [label_language release];
    [label_feed release];
    [label_diaper release];
    [label_babyName release];
}

@end
