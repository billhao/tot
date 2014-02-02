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
#import "totReviewStory.h"
#import "totTimeline.h"

@implementation totDiaperEditCard

- (id)init {
    self = [super init];
    if (self) {
        x = 30;
        y = contentYOffset + margin_y;
        w = 200;
        h = 20;
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
    [mSelectedIcon release];
}


#pragma mark - Event handlers
- (void)buttonPressed:(id)sender {
    int tag = ((UIButton*)sender).tag;

    printf("pressed button %d in diaper view\n", tag);
    mDiaperType = tag;
    
    [self showSelection:tag];
}


#pragma mark - Helper functions
- (int) height { return contentYOffset + margin_y + 3*(h+margin_y); }
- (int) width { return 308; }

- (void) setBackground {
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void) loadIcons {
    [self setIcon:@"diaper_gray" confirmedIcon:@"diaper2"];
    //[self setCalendar:999];
    [self setTimestamp];
    [self setTitle:@"Diaper" ];
    
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
    NSString* diaper;
    if (selection == SELECTION_WET) {
        diaper = @"wet";
    } else if (selection == SELECTION_SOILED) {
        diaper = @"soiled";
    } else if (selection == SELECTION_WETSOILED) {
        diaper = @"wet soiled";
    }
    else
        return;
    [model addEvent:global.baby.babyID event:EVENT_BASIC_DIAPER datetime:self.timeStamp value:diaper];
}

- (bool) clickOnConfirmIconButtonDelegate {
    // save to database
    if (mDiaperType != -1 && mDiaperType >= SELECTION_WET && mDiaperType <= SELECTION_WETSOILED) {
        [self saveToDatabase:mDiaperType];
        
        // update the summary card.
        if (mDiaperType == SELECTION_WET)
            [self.parentView.parent updateSummaryCard:DIAPER withValue:@"wet"];
        else if (mDiaperType == SELECTION_SOILED)
            [self.parentView.parent updateSummaryCard:DIAPER withValue:@"soiled"];
        else if (mDiaperType == SELECTION_WETSOILED)
            [self.parentView.parent updateSummaryCard:DIAPER withValue:@"wet soiled"];
        
        return true;
    } else {
        [totUtility showAlert:@"Anything on the diaper?"];
        return false;
    }
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
    // If we load card from database, should not call this function again.
    // when loading from db, story_ will not be nil.
    if (!story_) {
        [self getDataFromDB];
    } else {
        card_title.text = story_.mRawContent;
        description.text = @"";
        [self setTimestamp:[totTimeUtil getTimeDescriptionFromNow:story_.mWhen]];
    }
}

- (void) dealloc {
    [super dealloc];
}


#pragma mark - Helper functions

- (int) height { return 60; }
- (int) width { return 308; }

- (void) setBackground {
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void) loadIcons {
    [self setIcon:@"diaper.png"];
}

- (void) getDataFromDB {
    NSString* event = EVENT_BASIC_DIAPER;
    
    NSArray* events = [global.model getEvent:global.baby.babyID event:event limit:2];
    
    if( events.count > 0 ) {
        totEvent* currEvt = [events objectAtIndex:0];
        self.e = currEvt;
        card_title.text = [NSString stringWithFormat:@"%@", currEvt.value];
        [self setTimestampWithDate:currEvt.datetime];
        if( events.count > 1 ) {
            totEvent* prevEvt = [events objectAtIndex:1];
            description.text = [NSString stringWithFormat:@"The diaper was %@ last time.", prevEvt.value];
        }
        [self setTimestamp:[totTimeUtil getTimeDescriptionFromNow:currEvt.datetime]];
    }
}

- (void) updateCard { [self setTimestampWithDate:self.e.datetime]; }

@end



