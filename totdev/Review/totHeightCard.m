//
//  totHeightCard.m
//  totdev
//
//  Created by Lixing Huang on 8/11/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import "totHeightCard.h"

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
    }
    return self;
}

- (void) dealloc {
    [super dealloc];
    [bgview release];
    [picker release];
    //[confirm_button release];
    //[cancel_button release];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [self createPicker];
    [self setBackground];
    [self loadButtons];
    
    // set this to last value in db
    selectedValueLabel.text = @"";
}

#pragma mark - Event handlers

- (void) confirm: (UIButton*) btn {
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
        return;
    
    // TODO change the datetime to user-selected datetime
    [global.model addEvent:global.baby.babyID event:event datetime:[NSDate date] value:value];
    
    // get the event id

    [parentView flip];
}
- (void) cancel: (UIButton*) btn {
    // delete this card without save
}

- (void)pickerView:(STHorizontalPicker *)picker didSelectValue:(CGFloat)value {
    NSString* str;
    if( type == HEIGHT || type == HEAD ) {
        // height or head
        str = [NSString stringWithFormat:@"%.2f inches",value];
    }
    else if( type == WEIGHT ) {
        // weight
        str = [NSString stringWithFormat:@"%.2f pound",value];
    }
    else
        return;
    selectedValueLabel.text = str;
}


#pragma mark - Helper functions

- (int) getWidth  { return 294; } // 13px for left and right margin
- (int) getHeight { return 400; }
+ (int) width  { return 308; }
+ (int) height { return 308; }

- (void) loadButtons {
    [self setTimestamp];
    if (type == HEIGHT) {
        [self setIcon:@"height_gray.png"];
        [self setTitle:@"Height"];
    } else if (type == WEIGHT) {
        [self setIcon:@"weight_gray.png"];
        [self setTitle:@"Weight"];
    } else if (type == HEAD) {
        [self setIcon:@"hc_gray.png"];
        [self setTitle:@"HC"];
    }
    
    selectedValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 30, 120, 30)];
    UIFont* font = [UIFont fontWithName:@"Roboto-Regular" size:16.0];
    selectedValueLabel.font = font;
    selectedValueLabel.textColor = [UIColor colorWithRed:128.0/255 green:130.0/255 blue:133.0/255 alpha:1];
    selectedValueLabel.textAlignment = NSTextAlignmentCenter;
    selectedValueLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:selectedValueLabel];

    //confirm_button = [UIButton buttonWithType:UIButtonTypeCustom];
    //confirm_button.frame = CGRectMake(self.width-20+2*(-60-10), bgview.frame.origin.y+bgview.frame.size.height+20, 60, 40);
    //cancel_button =  [UIButton buttonWithType:UIButtonTypeCustom];
    //cancel_button.frame = CGRectMake(self.width-20-60-10, bgview.frame.origin.y+bgview.frame.size.height+20, 60, 40);
    
    //self.width-20+2*(-60-10), bgview.frame.origin.y+bgview.frame.size.height+20, 60, 40)];
    
    //self.width-20-60-10, 350, 60, 40)];
    //[confirm_button setImage:[UIImage imageNamed:@"icons-ok"] forState:UIControlStateNormal];
    //[confirm_button setImage:[UIImage imageNamed:@"icons-ok_pressed"] forState:UIControlStateHighlighted];
    //[cancel_button setImage:[UIImage imageNamed:@"icons-close"] forState:UIControlStateNormal];
    //[cancel_button setImage:[UIImage imageNamed:@"icons-close_pressed"] forState:UIControlStateHighlighted];
    //[confirm_button addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    //[cancel_button addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    
    //[self.view addSubview:confirm_button];
    //[self.view addSubview:cancel_button];
}

- (void) setBackground {
    self.view.backgroundColor = [UIColor whiteColor];

    // add bg for the ruler
    UIImage* img = [UIImage imageNamed:@"height_bg"];
    bgview = [[UIImageView alloc] initWithImage:img];
    int picker_bg_x = (self.width-img.size.width)/2;
    bgview.frame = CGRectMake(picker_bg_x, 20, img.size.width, img.size.height);
    [self.view addSubview:bgview];
    [self.view sendSubviewToBack:bgview];
}

- (void)createPicker
{
    // viewdidload
    if( type == HEIGHT )
        picker = [STHorizontalPicker getPickerForHeight:CGRectMake(bgview.frame.origin.x+6, bgview.frame.origin.y+64, 190, 40)];
    else if( type == WEIGHT)
        picker = [STHorizontalPicker getPickerForWeight:CGRectMake(20, 50, 200, 50)];
    else if( type == HEAD )
        picker = [STHorizontalPicker getPickerForHeadC:CGRectMake(20, 50, 200, 50)];
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
    [self setIcon:@"height2.png" withCalendarDays:100];
    [self setTimestamp:@"40 Minutes ago"];
}

- (void)viewDidAppear:(BOOL)animated {
    // reload data
    [self getDataFromDB];
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
            description.text = [NSString stringWithFormat:@"%@ is %.2f inches taller than last time", global.baby.name, incr];
        }
    }
    
}

- (void) setBackground {
    self.view.backgroundColor = [UIColor whiteColor];
}

+ (int) height { return 150; }
+ (int) width { return 308; }


@end




