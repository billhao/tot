//
//  totSummaryCard.m
//  totdev
//
//  Created by Lixing Huang on 8/11/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import "totSummaryCard.h"
#import "totTimeline.h"
#import "totFeedCard.h"
#import "totSleepCard.h"
#import "Global.h"
#import "totImageView.h"

@implementation totSummaryCard

- (int) height { return 330; }
- (int) width { return 308; }

- (id)init {
    self = [super init];
    if (self) {
        physicalLabels = nil;
    }
    return self;
}

- (void)viewDidLoad {
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
    
    line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_line"]];
    line.frame = CGRectMake(0, 100, [self width], line.frame.size.height);
    [self.view addSubview:line];
}

- (void)loadIcons {
    // physical icons (as buttons)
    int icon_x[] = {10, 150, 10, 150, 10, 150, 10};
    int icon_y[] = {112, 112, 162, 162, 212, 212, 262};
    NSMutableArray* icon_img_filename =
        [[NSMutableArray alloc] initWithObjects: @"height_gray",
                                                 @"weight_gray",
                                                 @"hc_gray",
                                                 @"diaper_gray",
                                                 @"language_gray",
                                                 @"sleep_gray", @"food_gray", nil];

    NSString* not_available = NSLocalizedString(@"N/A", @"Not available.");
    
    NSMutableArray* label_text = [[NSMutableArray alloc] initWithObjects: not_available,
                                                                          not_available,
                                                                          not_available,
                                                                          not_available,
                                                                          not_available,
                                                                          not_available,
                                                                          not_available, nil];
    float icon_w = 41;
    float icon_h = 41;
    int cnt = sizeof(icon_x)/sizeof(icon_x[0]);
    
    if (physicalButtons != nil) [physicalButtons release];
    physicalButtons = [[NSMutableArray alloc] initWithCapacity:cnt];
    for( int i=0; i<cnt; i++ ) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(icon_x[i], icon_y[i], icon_w, icon_h);
        btn.tag = i;
        [btn setImage:[UIImage imageNamed:icon_img_filename[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(physicalIconBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [physicalButtons addObject:btn];
    }
    
    // baby name
    label_babyName = [[UILabel alloc] initWithFrame:CGRectMake(129, 42, 170, 32)];
    UIFont* font1 = [UIFont fontWithName:@"Raleway" size:36];
    label_babyName.font = font1;
    label_babyName.textColor = [UIColor colorWithRed:100.0/255 green:100.0/255 blue:100.0/255 alpha:1.0];
    label_babyName.text = @"Grace";
    [self.view addSubview:label_babyName];

    // sex
    sexImgView = [[UIImageView alloc] init];
    [self.view addSubview:sexImgView];

    // baby age
    label_babyAge = [[UILabel alloc] initWithFrame:CGRectMake(129+2, 78, 170, 14)];
    UIFont* font2 = [UIFont fontWithName:@"Raleway" size:14];
    label_babyAge.font = font2;
    label_babyAge.textColor = [UIColor colorWithRed:141.0/255 green:141.0/255 blue:141.0/255 alpha:1.0];
    label_babyAge.text = @"140 days";
    [self.view addSubview:label_babyAge];
    
//    [self enableBorder:label_babyName];
//    [self enableBorder:label_babyAge];

    // loadLabels
    float label_h = 30;
    float label_w = 90;

    UIFont* font3 = [UIFont fontWithName:@"Raleway" size:14];
    UIColor* fontColor = [UIColor grayColor];
    
    if( physicalLabels != nil ) [physicalLabels release];
    physicalLabels = [[NSMutableArray alloc] initWithCapacity:cnt];
    for( int i=0; i<cnt; i++ ) {
        int label_x = icon_x[i] + 44;
        int label_y = icon_y[i] + 10;
        float h = label_h;
        float w = label_w;
        if( i==cnt-1 ) {  // tune the position of feeding label.
            label_y = label_y - 15;
            w = 200;  // make it longer for feeding
            h = 60;   // make it high enough to hold multiple lines.
        }
        UILabel *label   = [[UILabel alloc] initWithFrame:CGRectMake(label_x, label_y, w, h)];
        if (i==cnt-1) {
            label.numberOfLines = 0;
            label.lineBreakMode = NSLineBreakByWordWrapping;
        }
        label.font = font3;
        label.textColor = fontColor;
        label.text = label_text[i];
        label.backgroundColor = [UIColor clearColor];
        [self.view addSubview:label];
        [physicalLabels addObject:label];
        [label release];
    }
    
    [label_text release];
    [icon_img_filename release];
}

- (void) updateLabel:(ReviewCardType)type withValue:(NSString*)value {
    if (type < 0 || type >= [physicalLabels count]) {
        printf("Invalid card type when update the summary card.\n");
        return;
    }
    
    // Update the icon if necessary.
    int i = (int)type;
    UILabel* curr_label = (UILabel*)[physicalLabels objectAtIndex:i];
    if ([curr_label.text isEqualToString:@"N/A"]) {
        UIButton* curr_button = (UIButton*)[physicalButtons objectAtIndex:i];
        NSMutableArray* icon_img_filename = [[NSMutableArray alloc] initWithObjects:
                                             @"height", @"weight", @"hc", @"diaper", @"language", @"sleep", @"food", nil];
        [curr_button setImage:[UIImage imageNamed:[icon_img_filename objectAtIndex:i]]
                     forState:UIControlStateNormal];
        [icon_img_filename release];
    }
    
    curr_label.text = value;
}

// load data from db
- (void) loadData {
    // set baby avatar
    headImg.image = global.baby.avatar;
    
    // set baby name
    label_babyName.text = global.baby.name;
    [label_babyName sizeToFit];
    
    // set sex
    UIImage* sexImg;
    if( global.baby.sex == MALE )
        sexImg = [UIImage imageNamed:@"male"];
    else
        sexImg = [UIImage imageNamed:@"female"];
    sexImgView.image = sexImg;
    CGRect f = label_babyName.frame;
    sexImgView.frame = CGRectMake(f.origin.x+f.size.width, f.origin.y, sexImg.size.width, sexImg.size.height);

    // set baby age
    label_babyAge.text = [global.baby formatAge];
    
    // set physical values
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
    
    // sleep
    if( self.timeline.sleeping ) {
        [values addObject:@"sleeping"];
    } else {
        // get last sleep time
        events = [global.model getEvent:global.baby.babyID event:EVENT_BASIC_SLEEP limit:2];
        if( events.count == 2 ) {
            NSString* str = [totSleepShowCard formatValue:((totEvent*)events[1]).datetime d2:((totEvent*)events[0]).datetime];
            [values addObject:str];
        } else {
            [values addObject:[NSNull null]];
        }
    }
    
    events = [global.model getEvent:global.baby.babyID event:EVENT_BASIC_FEEDING limit:1];
    if( events.count == 1 ) {
        // format the values
        NSString* str = [totFeedShowCard formatValue:((totEvent*)events[0]).value];
        [values addObject:str];
    } else {
        [values addObject:[NSNull null]];
    }
    
    NSMutableArray* icon_img_filename = [[NSMutableArray alloc] initWithObjects:
                                         @"height", @"weight", @"hc", @"diaper", @"language", @"sleep", @"food", nil];
    for( int i=0; i<physicalLabels.count; i++ ) {
        if( ![values[i] isKindOfClass:NSNull.class] ) {
            NSString* value = values[i];
            ((UILabel*)physicalLabels[i]).text = value;
            [((UIButton*)physicalButtons[i]) setImage:[UIImage imageNamed:[icon_img_filename objectAtIndex:i]]
                                             forState:UIControlStateNormal];
        }
    }
    [icon_img_filename release];
    [values release];
}

- (void) dealloc {
    if( physicalLabels != nil ) {
        for( UILabel* label in physicalLabels )
            [label release];
        [physicalLabels release];
    }
    if (physicalButtons != nil) {
        [physicalButtons release];
    }

    [label_babyName release];
    [label_babyAge release];

    [headView release];
    headView = nil;

    [headImg release];
    headImg = nil;
    [super dealloc];
}

// create UI elements for basic baby info like name, photo and bday
- (void)createBabyInfo {
    headView = [[UIView alloc] initWithFrame:CGRectMake(21, 6, 88, 88)];
    
    UIImage* defaultHeadImg = global.baby.avatar;
    headImg = [[[totImageView alloc] initWithImage:defaultHeadImg] autorelease];
    headImg.frame = headView.bounds;
    headImg.layer.masksToBounds = TRUE;
    headImg.layer.cornerRadius = headImg.frame.size.width/2;
    [headView addSubview:headImg];
    
    UIImage* headImgBg = [UIImage imageNamed:@"summary_head_bg"];
    UIImageView* headBgView = [[UIImageView alloc] initWithImage:headImgBg];
    headBgView.frame = headView.bounds;
    [headView addSubview:headBgView];
    
    UIButton* headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    headBtn.frame = CGRectMake(0, 0, 88, 88);
    headBtn.backgroundColor = [UIColor clearColor];
    [headBtn addTarget:self action:@selector(headButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:headBtn];
    
    [self.view addSubview:headView];
    [headBgView release];
}


#pragma mark - Event handlers

// tap this icon to add a new card
- (void)physicalIconBtnPressed:(id)sender {
    // add a new card
    int tag = ((UIButton*)sender).tag;
    
    // prevent from sleeping again
    if( tag == SLEEP && self.parentView.parent.sleeping ) {
        totReviewCardView* sleepcard = [self.parentView.parent getSleepCard];
        if( sleepcard )
            [self.parentView.parent moveToTop:sleepcard]; // ask timeline to move sleep card to top
        return;
    }
    
    totReviewCardView* card = [self.timeline addEmptyCard:tag];
    [self.parentView.parent moveToTop:card]; // ask timeline to move this card to top
}

- (void)headButtonPressed:(id)sender {
    [global.cameraView setDelegate:self];
     global.cameraView.saveToDB = FALSE;
     global.cameraView.cropWidth  = headView.frame.size.width;
     global.cameraView.cropHeight = headView.frame.size.height;
    [global.cameraView launchCamera:self.parentView.parent.controller withEditing:TRUE];
}

#pragma mark - CameraViewDelegate

- (void) cameraView:(id)cameraView didFinishSavingMedia:(MediaInfo*)mediaInfo {
    [headImg imageFromFileContent:[totMediaLibrary getMediaPath:mediaInfo.filename]];

    // save the image filename to db
    [global.model updatePreference:global.baby.babyID preference:PREFERENCE_BABY_AVATAR value:mediaInfo.filename];
}

@end
