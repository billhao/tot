//
//  totSummaryCard.m
//  totdev
//
//  Created by Lixing Huang on 8/11/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import "totSummaryCard.h"
#import "totTimeline.h"

@implementation totSummaryCard

+ (int) height { return 259; }
+ (int) width { return 308; }

- (id)init {
    self = [super init];
    if (self) {
        physicalLabels = nil;
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
    
    [self loadData];
}

// bug - not called
//- (void)viewWillAppear:(BOOL)animated {
//    [self loadData];
//}
//
//- (void)viewDidAppear:(BOOL)animated {
//    [self loadData];    
//}

- (void)setBackground {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView* line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_line"]];
    line.frame = CGRectMake(0, 100, [totSummaryCard width], line.frame.size.height);
    [self.view addSubview:line];
}

- (void)loadIcons {
    // physical icons (as buttons)
    int icon_x[] = {20, 112, 204, 20, 112, 204, 20};
    int icon_y[] = {112, 112, 112, 162, 162, 162, 212};
    NSMutableArray* icon_img_filename = [[NSMutableArray alloc] initWithObjects:
                                  @"height2", @"weight2", @"hc2", @"diaper2", @"language2", @"sleep2", @"food2", nil];
    NSMutableArray* label_text = [[NSMutableArray alloc] initWithObjects:
                                  @"height", @"weight", @"head", @"diaper", @"language", @"sleep", @"feeding", nil];
    
    float icon_w  = 41;
    float icon_h = 41;
    int cnt = sizeof(icon_x)/sizeof(icon_x[0]);
    
    for( int i=0; i<cnt; i++ ) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(icon_x[i], icon_y[i], icon_w, icon_h);
        btn.tag = i;
        [btn setImage:[UIImage imageNamed:icon_img_filename[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(physicalIconBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
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

    // loadLabels    
    float label_h = 30;
    float label_w = 44;

    UIFont* font3 = [UIFont fontWithName:@"Raleway" size:8];
    UIColor* fontColor = [UIColor grayColor];
    
    if( physicalLabels != nil ) [physicalLabels release];
    physicalLabels = [[NSMutableArray alloc] initWithCapacity:cnt];
    for( int i=0; i<cnt; i++ ) {
        int label_x = icon_x[i] + 44;
        int label_y = icon_y[i] + 16;
        UILabel *label   = [[UILabel alloc] initWithFrame:CGRectMake(label_x, label_y, label_w, label_h)];
        label.font = font3;
        label.textColor = fontColor;
        label.text = label_text[i];
        [self.view addSubview:label];
        [physicalLabels addObject:label];
    }
}

// load data from db
- (void) loadData {
    NSMutableArray* values = [[NSMutableArray alloc] initWithCapacity:physicalLabels.count];
    
    NSMutableArray* events;
    events = [global.model getEvent:global.baby.babyID event:EVENT_BASIC_HEIGHT limit:1];
    if( events.count == 1 )
        [values addObject:((totEvent*)events[0]).value];
    else
        [values addObject:[NSNull null]];

    events = [global.model getEvent:global.baby.babyID event:EVENT_BASIC_WEIGHT limit:1];
    if( events.count == 1 )
        [values addObject:((totEvent*)events[0]).value];
    else
        [values addObject:[NSNull null]];
    
    events = [global.model getEvent:global.baby.babyID event:EVENT_BASIC_HEAD limit:1];
    if( events.count == 1 )
        [values addObject:((totEvent*)events[0]).value];
    else
        [values addObject:[NSNull null]];
    
    events = [global.model getEvent:global.baby.babyID event:EVENT_BASIC_DIAPER limit:1];
    if( events.count == 1 )
        [values addObject:((totEvent*)events[0]).value];
    else
        [values addObject:[NSNull null]];
    
    events = [global.model getEvent:global.baby.babyID event:EVENT_BASIC_LANGUAGE limit:1];
    if( events.count == 1 )
        [values addObject:((totEvent*)events[0]).value];
    else
        [values addObject:[NSNull null]];
    
    events = [global.model getEvent:global.baby.babyID event:EVENT_BASIC_SLEEP limit:1];
    if( events.count == 1 )
        [values addObject:((totEvent*)events[0]).value];
    else
        [values addObject:[NSNull null]];
    
    events = [global.model getEvent:global.baby.babyID event:EVENT_BASIC_FEEDING limit:1];
    if( events.count == 1 )
        [values addObject:((totEvent*)events[0]).value];
    else
        [values addObject:[NSNull null]];
    
    for( int i=0; i<physicalLabels.count; i++ ) {
        if( ![values[i] isKindOfClass:NSNull.class] ) {
            NSString* value = values[i];
            ((UILabel*)physicalLabels[i]).text = value;
        }
    }
    [values release];
}

- (void) dealloc {
    [super dealloc];
    
    if( physicalLabels != nil ) {
        for( UILabel* label in physicalLabels )
            [label release];
    }

    [label_babyName release];
    [label_babyAge release];
}

// tap this icon to add a new card
- (void)physicalIconBtnPressed:(id)sender {
    // add a new card
    int tag = ((UIButton*)sender).tag;
    [self.timeline addEmptyCard:tag];
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

@end
