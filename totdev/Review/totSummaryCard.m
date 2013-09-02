//
//  totSummaryCard.m
//  totdev
//
//  Created by Lixing Huang on 8/11/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import "totSummaryCard.h"

@implementation totSummaryCard

+ (int) height { return 259; }
+ (int) width { return 308; }

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    // we don't need title and desc for summary card
//    [title removeFromSuperview];
//    [description removeFromSuperview];
    
    [self createBabyInfo];
    [self setBackground];
    [self loadIcons];
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadData];
}

- (void)setBackground {
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)loadIcons {
    int icon_x[] = {20, 112, 204, 20, 112, 204, 20};
    int icon_y[] = {112, 112, 112, 162, 162, 162, 212};
    int index = 0;
    
    float icon_w  = 41;
    float icon_h = 41;
    
    icon_height   = [[UIImageView alloc] initWithFrame:CGRectMake(icon_x[index], icon_y[index], icon_w, icon_h)]; ++index;
    icon_weight   = [[UIImageView alloc] initWithFrame:CGRectMake(icon_x[index], icon_y[index], icon_w, icon_h)]; ++index;
    icon_hc       = [[UIImageView alloc] initWithFrame:CGRectMake(icon_x[index], icon_y[index], icon_w, icon_h)]; ++index;
    icon_diaper   = [[UIImageView alloc] initWithFrame:CGRectMake(icon_x[index], icon_y[index], icon_w, icon_h)]; ++index;
    icon_language = [[UIImageView alloc] initWithFrame:CGRectMake(icon_x[index], icon_y[index], icon_w, icon_h)]; ++index;
    icon_sleep    = [[UIImageView alloc] initWithFrame:CGRectMake(icon_x[index], icon_y[index], icon_w, icon_h)]; ++index;
    icon_feed     = [[UIImageView alloc] initWithFrame:CGRectMake(icon_x[index], icon_y[index], icon_w, icon_h)]; ++index;

    icon_height.image = [UIImage imageNamed:@"height2.png"];
    icon_diaper.image = [UIImage imageNamed:@"diaper2.png"];
    icon_weight.image = [UIImage imageNamed:@"weight2.png"];
    icon_sleep.image = [UIImage imageNamed:@"sleep2.png"];
    icon_hc.image = [UIImage imageNamed:@"hc2.png"];
    icon_language.image = [UIImage imageNamed:@"language2.png"];
    icon_feed.image = [UIImage imageNamed:@"food2.png"];
    
    [self.view addSubview:icon_height];
    [self.view addSubview:icon_weight];
    [self.view addSubview:icon_hc];
    [self.view addSubview:icon_language];
    [self.view addSubview:icon_sleep];
    [self.view addSubview:icon_diaper];
    [self.view addSubview:icon_feed];

    // loadLabels
    
    // baby name
    label_babyName = [[UILabel alloc] initWithFrame:CGRectMake(129, 42, 170, 32)];
    UIFont* font1 = [UIFont fontWithName:@"Raleway" size:36];
    label_babyName.font = font1;
    label_babyName.textColor = [UIColor colorWithRed:100.0/255 green:100.0/255 blue:100.0/255 alpha:1.0];
    label_babyName.text = @"Grace";
    [self.view addSubview:label_babyName];

    // baby age
    label_babyAge = [[UILabel alloc] initWithFrame:CGRectMake(129+2, 78, 170, 14)];
    UIFont* font2 = [UIFont fontWithName:@"Raleway" size:12];
    label_babyAge.font = font2;
    label_babyAge.textColor = [UIColor colorWithRed:141.0/255 green:141.0/255 blue:141.0/255 alpha:1.0];
    label_babyAge.text = @"140 days";
    [self.view addSubview:label_babyAge];
    
//    [self enableBorder:label_babyName];
//    [self enableBorder:label_babyAge];

    
    int label_x[7]; // = {55, 210, 55, 210, 55, 210, 55};  // should be the value in the x array in loadIcons + 50
    int label_y[7]; // = {80, 80, 160, 160, 240, 240, 310};  // should be the same as the y array in loadIcons
    NSMutableArray* label_text = [[NSMutableArray alloc] initWithObjects:
                                  @"height", @"weight", @"head", @"diaper", @"language", @"sleep", @"feeding", nil];
    int cnt = sizeof(icon_x)/sizeof(icon_x[0]);
    for( int i=0; i<cnt; i++ ) {
        label_x[i] = icon_x[i] + 44;
        label_y[i] = icon_y[i] + 16;
    }
    index = 0;
    
    float label_h = 30;
    float label_w = 44;
    label_height   = [[UILabel alloc] initWithFrame:CGRectMake(label_x[index], label_y[index], label_w, label_h)]; ++index;
    label_weight   = [[UILabel alloc] initWithFrame:CGRectMake(label_x[index], label_y[index], label_w, label_h)]; ++index;
    label_hc       = [[UILabel alloc] initWithFrame:CGRectMake(label_x[index], label_y[index], label_w, label_h)]; ++index;
    label_diaper   = [[UILabel alloc] initWithFrame:CGRectMake(label_x[index], label_y[index], label_w, label_h)]; ++index;
    label_language = [[UILabel alloc] initWithFrame:CGRectMake(label_x[index], label_y[index], label_w, label_h)]; ++index;
    label_sleep    = [[UILabel alloc] initWithFrame:CGRectMake(label_x[index], label_y[index], label_w, label_h)]; ++index;
    label_feed     = [[UILabel alloc] initWithFrame:CGRectMake(label_x[index], label_y[index], 220, label_h)]; ++index;
    
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
    
    label_height.text = @"height";
    label_weight.text = @"weight";
    label_hc.text = @"head";
    label_diaper.text = @"diaper";
    label_language.text = @"langauge";
    label_sleep.text = @"sleep";
    label_feed.text = @"feeding";
    
    [self.view addSubview:label_height];
    [self.view addSubview:label_weight];
    [self.view addSubview:label_hc];
    [self.view addSubview:label_sleep];
    [self.view addSubview:label_diaper];
    [self.view addSubview:label_language];
    [self.view addSubview:label_feed];
    
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
    [label_babyAge release];
}

// create UI elements for basic baby info like name, photo and bday
- (void)createBabyInfo {
    UIView* headView = [[UIView alloc] initWithFrame:CGRectMake(21, 6, 88, 88)];
    
    UIImage* defaultHeadImg = [UIImage imageNamed:@"summary_head_default"];
    UIImageView* headImg = [[UIImageView alloc] initWithImage:defaultHeadImg];
    headImg.frame = headView.bounds;
    headImg.layer.masksToBounds = TRUE;
    headImg.layer.cornerRadius = headImg.frame.size.width/2;
    [headView addSubview:headImg];
    
    UIImage* headImgBg = [UIImage imageNamed:@"summary_head_bg"];
    UIImageView* headBgView = [[UIImageView alloc] initWithImage:headImgBg];
    headBgView.frame = headView.bounds;
//    headBgView.backgroundColor = [UIColor greenColor];
    [headView addSubview:headBgView];
    
    [self.view addSubview:headView];
    [headBgView release];
    [headView release];
}

- (void)enableBorder:(UIView*)v {
    v.layer.borderWidth = 1;
    v.layer.borderColor = [UIColor grayColor].CGColor;
}

@end
