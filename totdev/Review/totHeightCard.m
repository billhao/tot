//
//  totHeightCard.m
//  totdev
//
//  Created by Lixing Huang on 8/11/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import "totHeightCard.h"
#import "totReviewStory.h"
#import "totTimeline.h"

@implementation totHeightEditCard

@synthesize type;

- (id)init:(ReviewCardType)cardType
{
    // check card type
    if( !(cardType == HEIGHT || cardType == HEAD || cardType == WEIGHT) )
        [NSException raise:@"Invalid card type"
                    format:@"Invalid card type to totHeightEditCard: %d. Only height, weight and HC are allowed.", cardType];

    self = [super init];
    if (self) {
        // init
        type = cardType;
        picker = nil;
        
        [self setBackground];
        [self createPicker];
        [self loadButtons];
    }
    return self;
}

- (void) dealloc {
    [super dealloc];
    [bgview release];
    [picker release];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    // set this to last value in db
    selectedValueLabel.text = @"";
}

#pragma mark - Event handlers

- (bool) clickOnConfirmIconButtonDelegate {
    // save to db
    NSString* value = selectedValueLabel.text;
    NSString* event = nil;
    if( type == HEIGHT )
        event = EVENT_BASIC_HEIGHT;
    else if ( type == WEIGHT )
        event = EVENT_BASIC_WEIGHT;
    else if( type == HEAD )
        event = EVENT_BASIC_HEAD;
    else
        return FALSE;
    
    // TODO change the datetime to user-selected datetime
    [global.model addEvent:global.baby.babyID event:event datetime:[NSDate date] value:value];
    
    // Update the summary card.
    [self.parentView.parent updateSummaryCard:type withValue:value];
    
    return TRUE;
}

- (void) cancel: (UIButton*) btn {
    // delete this card without save
}

- (void)pickerView:(STHorizontalPicker *)picker didSelectValue:(CGFloat)value {
    NSString* str;
    if( type == HEIGHT || type == HEAD ) {
        str = [NSString stringWithFormat:@"%.2f inches",value];
    } else if( type == WEIGHT ) {
        str = [NSString stringWithFormat:@"%.2f pound",value];
    } else
        return;
    selectedValueLabel.text = str;
}


#pragma mark - Helper functions

- (int) width  { return 308; } // 13px for left and right margin
- (int) height {
    CGRect f = bgview.frame;
    return f.origin.y + f.size.height + margin_y;
}

- (void) loadButtons {
    [self setTimestamp];
    if (type == HEIGHT) {
        [self setIcon:@"height_gray" confirmedIcon:@"height2"];
        [self setTitle:@"Height"];
    } else if (type == WEIGHT) {
        [self setIcon:@"weight_gray" confirmedIcon:@"weight2"];
        [self setTitle:@"Weight"];
    } else if (type == HEAD) {
        [self setIcon:@"hc_gray" confirmedIcon:@"hc2"];
        [self setTitle:@"Head Circumference"];
    }
}

- (void) setBackground {
    self.view.backgroundColor = [UIColor whiteColor];

    // add bg for the ruler
    float y = contentYOffset + margin_y;
    UIImage* img = [UIImage imageNamed:@"height_bg"];
    bgview = [[UIImageView alloc] initWithImage:img];
    int picker_bg_x = ([self width]-img.size.width)/2;
    bgview.frame = CGRectMake(picker_bg_x, y, img.size.width, img.size.height);
    [self.view addSubview:bgview];
    [self.view sendSubviewToBack:bgview];
    //[totUtility enableBorder:bgview];

    // add label for selected value
    selectedValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(64, y+11, 170, 32)];
    UIFont* font = [UIFont fontWithName:@"Raleway" size:24.0];
    selectedValueLabel.font = font;
    selectedValueLabel.textColor = [UIColor colorWithRed:128.0/255 green:130.0/255 blue:133.0/255 alpha:1];
    selectedValueLabel.textAlignment = NSTextAlignmentCenter;
    selectedValueLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:selectedValueLabel];
    //[totUtility enableBorder:selectedValueLabel];
}

- (void)createPicker {
    float x = bgview.frame.origin.x+6;
    float yy = bgview.frame.origin.y+64;
    float w = 190;
    float h = 40;

    // create picker
    if( type == HEIGHT )
        picker = [STHorizontalPicker getPickerForHeight:CGRectMake(x, yy, w, h)];
    else if( type == WEIGHT)
        picker = [STHorizontalPicker getPickerForWeight:CGRectMake(x, yy, w, h)];
    else if( type == HEAD )
        picker = [STHorizontalPicker getPickerForHeadC :CGRectMake(x, yy, w, h)];
    [picker setDelegate:self];
    [self.view addSubview:picker];
    [self.view sendSubviewToBack:picker];
}

@end



@implementation totHeightShowCard

@synthesize type;

- (id) init:(ReviewCardType)cardType {
    self = [super init];
    if (self) {
        type = cardType;
    }
    return self;
}

- (void) dealloc {
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackground];
    if (type == HEIGHT) {
        [self setIcon:@"height2"];
    } else if (type == WEIGHT) {
        [self setIcon:@"weight2"];
    } else if (type == HEAD) {
        [self setIcon:@"hc2"];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    // If we load card from database, should not call this function again.
    // when loading from db, story_ will not be nil.
    if (!story_) {
        [self getDataFromDB];
    } else {
        card_title.text = story_.mRawContent;
        description.text = @"";
        [self setTimestamp:[totTimeUtil getTimeDescriptionFromNow:story_.mWhen]];
        // set calendar days here.
        //[self setCalendar:166];
    }
}

#pragma mark - Helper functions

- (void) getDataFromDB {
    NSString* event = nil;
    if( type == HEIGHT )
        event = EVENT_BASIC_HEIGHT;
    else if ( type == WEIGHT )
        event = EVENT_BASIC_WEIGHT;
    else if( type == HEAD )
        event = EVENT_BASIC_HEAD;
    else
        return;

    NSArray* events = [global.model getEvent:global.baby.babyID event:event limit:2];
    
    if( events.count > 0 ) {
        totEvent* currEvt = [events objectAtIndex:0];
        card_title.text = [NSString stringWithFormat:@"%@", currEvt.value];
        if( events.count > 1 ) {
            totEvent* prevEvt = [events objectAtIndex:1];
            float incr = [currEvt.value floatValue] - [prevEvt.value floatValue];
            if( type == HEIGHT )
                description.text = [NSString stringWithFormat:@"%@ is %.2f inches taller than last time", global.baby.name, incr];
            else if ( type == WEIGHT )
                description.text = [NSString stringWithFormat:@"%@ weighs %.2f pound more than last time", global.baby.name, incr];
            else if( type == HEAD )
                description.text = [NSString stringWithFormat:@"%@'s head circumference is %.2f inches longer than last time", global.baby.name, incr];
        }
    }
    
}

- (void) setBackground {
    self.view.backgroundColor = [UIColor whiteColor];
}

- (int) height { return 60; }
- (int) width { return 308; }


@end




