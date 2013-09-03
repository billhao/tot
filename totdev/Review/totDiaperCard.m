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
#import "totUtility.h"

@implementation totDiaperEditCard

- (id)init {
    self = [super init];
    if (self) {
        x = 30;
        y = 70;
        w = 200;
        h = 20;
        margin_y = 10;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackground];
    [self loadIcons];
}

- (void) dealloc {
    [super dealloc];
    [confirm_button release];
    [cancel_button release];
    [mSelectedIcon release];
}


#pragma mark - Event handlers

- (void) confirm: (UIButton*)btn {
    // save to database
    if (mDiaperType != -1) {
        [self saveToDatabase:mDiaperType];
    }

    [self.parentView flip];
}

- (void) cancel: (UIButton*)btn {
    [timer_ stop];
}

//- (void)touchesEndedDelegate:(NSSet *)touches withEvent:(UIEvent *)event from:(int)tag {
- (void)buttonPressed:(id)sender {
    int tag = ((UIButton*)sender).tag;

    printf("pressed button %d in diaper view\n", tag);
    mDiaperType = tag;
    
    [self showSelection:tag];
}


#pragma mark - Helper functions

- (void) setBackground {
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void) loadIcons {
    [self setIcon:@"diaper_gray.png" confirmedIcon:@"diaper2.png"];
    [self setCalendar:999];
    [self setTimestamp];
    [self setTitle:@"Diaper"];
    
    // Initializes UI.
    UIButton* wetBtn       = [self createButton:y];
    UIButton* soiledBtn    = [self createButton:y+(h+margin_y)*1];
    UIButton* wetSoiledBtn = [self createButton:y+(h+margin_y)*2];
    
    [wetBtn setTitle:@"wet" forState:UIControlStateNormal];
    [soiledBtn setTitle:@"soiled" forState:UIControlStateNormal];
    [wetSoiledBtn setTitle:@"wet soiled" forState:UIControlStateNormal];
    
    wetBtn.tag = SELECTION_WET;
    soiledBtn.tag = SELECTION_SOILED;
    wetSoiledBtn.tag = SELECTION_WETSOILED;

    [self.view addSubview:wetBtn];
    [self.view addSubview:soiledBtn];
    [self.view addSubview:wetSoiledBtn];
    
    //[totUtility enableBorder:wetBtn];
    
    mSelectedIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icons-ok"]];
    mSelectedIcon.frame = CGRectMake(-1, -1, 0, 0);
    [self.view addSubview:mSelectedIcon];
    
    mDiaperType = -1;
}

- (UIButton*)createButton:(float)yy {
    UIFont* font = [UIFont fontWithName:@"Raleway" size:20.0];
    UIButton* wetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    wetBtn.frame = CGRectMake(x, yy, w, h);
    wetBtn.titleLabel.font = font;

    [wetBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [wetBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, w-h)];
    [wetBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [wetBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [wetBtn setImage:[UIImage imageNamed:@"Diaper_checkbox"] forState:UIControlStateNormal];
    [wetBtn setImage:[UIImage imageNamed:@"Diaper_checkbox"] forState:UIControlStateHighlighted];
    [wetBtn setTitle:@"" forState:UIControlStateNormal];
    [wetBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [wetBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return wetBtn;
}

+ (int) height { return 200; }
+ (int) width { return 308; }

- (void)showSelection:(int)tag {
    int ww = h; // the check icon is a square
    int yy = y;
    if (tag == SELECTION_WET) {
    } else if (tag == SELECTION_SOILED) {
        yy = y + (h+margin_y)*1;
    } else if (tag == SELECTION_WETSOILED) {
        yy = y + (h+margin_y)*2;
    }
    [mSelectedIcon setFrame:CGRectMake(x, yy, ww, h)];
}

// save to database.
- (void)saveToDatabase:(int)selection {
    NSString * now = [self getTimestampInString];
    printf("current time: %s selection: %d\n", [now UTF8String], selection);
    
    totModel *model = global.model;
    if (selection == SELECTION_WET) {
        [model addEvent:global.baby.babyID
                  event:EVENT_BASIC_DIAPER
         datetimeString:now
                  value:@"wet"];
    } else if (selection == SELECTION_SOILED) {
        [model addEvent:global.baby.babyID
                  event:EVENT_BASIC_DIAPER
         datetimeString:now
                  value:@"soiled"];
    } else if (selection == SELECTION_WETSOILED) {
        [model addEvent:global.baby.babyID
                  event:EVENT_BASIC_DIAPER
         datetimeString:now
                  value:@"wet soiled"];
    }
}

- (bool) clickOnConfirmIconButtonDelegate {
    // save to database
    if (mDiaperType != -1) {
        [self saveToDatabase:mDiaperType];
        [self.parentView flip];
        return true;
    }
    return false;
}

@end



@implementation totDiaperShowCard

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackground];
    [self loadIcons];
}

-(void)viewWillAppear:(BOOL)animated {
    [self getDataFromDB];
}

- (void) dealloc {
    [timestamp_label release];
    [diaper_status_label release];
    [super dealloc];
    
}


#pragma mark - Helper functions

+ (int) height { return 300; }
+ (int) width { return 308; }

- (void) setBackground {
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void) loadIcons {
    // Load icon.
    [self setIcon:@"diaper2.png"];
    
    /*
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
     */
}

- (void) getDataFromDB {
    NSString* event = EVENT_BASIC_DIAPER;
    
    NSArray* events = [global.model getEvent:global.baby.babyID event:event limit:2];
    
    if( events.count > 0 ) {
        totEvent* currEvt = [events objectAtIndex:0];
        card_title.text = [NSString stringWithFormat:@"%@", currEvt.value];
        if( events.count > 1 ) {
            totEvent* prevEvt = [events objectAtIndex:1];
            description.text = [NSString stringWithFormat:@"The diaper last time is %@", prevEvt.value];
        }
        [self setTimestamp:[totTimeUtil getTimeDescriptionFromNow:currEvt.datetime]];
    }
}


@end



