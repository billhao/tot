//
//  totFeedCard.m
//  totdev
//
//  Created by Lixing Huang on 8/11/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import "totFeedCard.h"
#import "totReviewCardView.h"
#import "totTimeUtil.h"
#import "totHomeFeedingViewController.h"
#import "totTimeline.h"
#import "totUtility.h"
#import "totReviewStory.h"
#import "totTimeline.h"

@implementation totFeedEditCard

- (int) height { return 200; }
- (int) width { return 308; }

- (id)init {
    self = [super init];
    if (self) {
        margin_x = 6;
        margin_y = 10;
        x = 20;
        y = contentYOffset + margin_y;
        w1 = 120;
        w2 = 40;
        w3 = 40;
        h = 30;
        
        foodBoxes = [[NSMutableArray alloc] init];
        quanBoxes = [[NSMutableArray alloc] init];
        unitBoxes = [[NSMutableArray alloc] init];
        inputViews = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackground];
    [self setIcon:@"food_gray" confirmedIcon:@"food2"];
    [self setTitle:@"Feeding"];
    [self setTimestamp];
    [self createUI];
}

#pragma mark - Event handlers

- (void)addBtnPressed:(id)sender {
    [self addNewInputBox];
}

- (void)deleteBtnPressed:(id)sender {
    int tag = ((UIButton*)sender).superview.tag;
    // delete input boxes at i
    [((UIView*)inputViews[tag]) removeFromSuperview];
    
    // delete the text fields
    [foodBoxes removeObjectAtIndex:tag];
    [quanBoxes removeObjectAtIndex:tag];
    [unitBoxes removeObjectAtIndex:tag];
    [inputViews removeObjectAtIndex:tag];
    
    if( inputViews.count == 0 )
        [self addNewInputBox];
    else {
        // update y
        for( int i=0; i<inputViews.count; i++ ) {
            ((UIView*)inputViews[i]).tag = i;
            int yy = y + i*(h+margin_y);
            CGRect f = CGRectMake(0, yy, [self width] - h - margin_x, h);
            ((UIView*)inputViews[i]).frame = f;
        }
        // update y of add button
        int yy = y + (inputViews.count-1)*(h+margin_y);
        int xx = x + w1 + w2 + w3 + h + 3*margin_x;
        CGRect f = CGRectMake(xx, yy, h, h);
        addBtn.frame = f;
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [parentView.parent moveToTop:self.parentView];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

// Check the input. If it's valid return true, otherwise, return false.
- (bool)clickOnConfirmIconButtonDelegate {
    NSArray* foodList = [self getFoodList];
    if ([foodList count] == 0)
        return false;
    
    [self saveToDB:foodList];
    
    NSString* label = @"";
    for (int i = 0; i < [foodList count]; ++i) {
        NSDictionary* dict = (NSDictionary*)[foodList objectAtIndex:i];
        NSString* name = [dict objectForKey:@"name"];
        NSString* quantity = [dict objectForKey:@"quantity"];
        NSString* unit = [dict objectForKey:@"unit"];
        label = [label stringByAppendingFormat:@"%@ %@ %@", name, quantity, unit];
    }
    [self.parentView.parent updateSummaryCard:FEEDING withValue:label];
    
    return true;
}


#pragma mark - Helper functions

- (void)createUI {
    addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:[UIImage imageNamed:@"feeding_add"] forState:UIControlStateNormal];
    [addBtn setImage:[UIImage imageNamed:@"feeding_add"] forState:UIControlStateHighlighted];
    [addBtn addTarget:self action:@selector(addBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    
    [self addNewInputBox];
}

- (void)addNewInputBox {
    int i = foodBoxes.count;
    int yy = y + i*(h+margin_y);
    
    CGRect f = CGRectMake(0, yy, [self width] - h - margin_x, h);
    UIView* v = [[UIView alloc] initWithFrame:f];
    v.clipsToBounds = TRUE;

    f = CGRectMake(x, 0, w1, h);
    [foodBoxes addObject:[self createInputBox:f parentView:v]];

    f.origin.x += w1 + margin_x;
    f.size.width = w2;
    [quanBoxes addObject:[self createInputBox:f parentView:v]];

    f.origin.x += w2 + margin_x;
    f.size.width = w3;
    [unitBoxes addObject:[self createInputBox:f parentView:v]];
    
    // create delete button
    f.origin.x += w3 + margin_x;
    f.size.width = h;
    UIButton* deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setImage:[UIImage imageNamed:@"feeding_delete"] forState:UIControlStateNormal];
    [deleteBtn setImage:[UIImage imageNamed:@"feeding_delete"] forState:UIControlStateHighlighted];
    deleteBtn.frame = f;
    [deleteBtn addTarget:self action:@selector(deleteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:deleteBtn];

    v.tag = i;
    [inputViews addObject:v];
    [self.view addSubview:v];

    yy = y + i*(h+margin_y);
    int xx = x + w1 + w2 + w3 + h + 3*margin_x;
    f = CGRectMake(xx, yy, h, h);
    addBtn.frame = f;
}

- (UITextField*)createInputBox:(CGRect)f parentView:(UIView*)v {
    UIImage* bgImg = [UIImage imageNamed:@"lang_input_bg"];
    UIImageView* bgImgView = [[UIImageView alloc] initWithImage:bgImg];
    bgImgView.frame = f;
    [v addSubview:bgImgView];
    [bgImgView release];
    
    // Construct m_textField
    UITextField* textView = [[UITextField alloc] initWithFrame:f];
    textView.delegate = self;
    textView.textAlignment = UITextAlignmentCenter;
    textView.backgroundColor = [UIColor clearColor];
    textView.font = [UIFont fontWithName:@"Raleway" size:16.0];
    textView.textColor = [UIColor colorWithRed:100.0/255 green:100.0/255 blue:100.0/255 alpha:1.0];
    // disable auto correction, capitalization and etc
    textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textView.autocorrectionType = UITextAutocorrectionTypeNo;
    textView.spellCheckingType = UITextSpellCheckingTypeNo;
    [v addSubview:textView];
    
    return textView;
}

- (NSMutableArray*) getFoodList {
    NSMutableArray* list = [[[NSMutableArray alloc] init] autorelease];
    for (int i=0; i<foodBoxes.count; i++) {
        // add a food item
        NSMutableDictionary *foodItem = [[NSMutableDictionary alloc] init];
        [foodItem setObject:((UITextField*)foodBoxes[i]).text forKey:@"name"];
        [foodItem setObject:((UITextField*)quanBoxes[i]).text forKey:@"quantity"];
        [foodItem setObject:((UITextField*)unitBoxes[i]).text forKey:@"unit"];
        [foodItem setObject:@"" forKey:@"category"];
        [list addObject:foodItem];
        [foodItem release];
    }
    return list;
}

- (void)saveToDB:(NSArray*)list {
    // TODO datetime
    NSDate* date = [NSDate date];

    NSString* json = [totHomeFeedingViewController ObjectToJSON:list];
    [global.model addEvent:global.baby.babyID event:EVENT_BASIC_FEEDING datetime:date value:json];
}

@end


@implementation totFeedShowCard

- (int) height { return 120; }
- (int) width { return 308; }

- (id)init {
    self = [super init];
    if (self) {}
    return self;
}

- (void) loadIcons {
    [self setIcon:@"food2.png"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackground];
    [self loadIcons];
}

- (void)viewWillAppear:(BOOL)animated {
    // If we load card from database, should not call this function again.
    // when loading from db, story_ will not be nil.
    if (!story_) {
        [self getDataFromDB];
    } else {
        [self updateUI:story_.mRawContent];
        [self setTimestamp:[totTimeUtil getTimeDescriptionFromNow:story_.mWhen]];
    }
}

#pragma mark - Helper functions

- (void) getDataFromDB {
    NSString* event = EVENT_BASIC_FEEDING;
    
    NSArray* events = [global.model getEvent:global.baby.babyID event:event limit:2];
    if( events.count > 0 ) {
        totEvent* currEvt = [events objectAtIndex:0];
        [self updateUI:currEvt.value];
        [self setTimestamp:currEvt.getTimeText];
    }
}

- (void)updateUI:(NSString*)value {
    NSArray* list = [totHomeFeedingViewController JSONToObject:value];
    NSString* text = @"";
    for( int i=0; i<list.count; i++ ) {
        NSDictionary* item = list[i];
        if( text.length > 0 ) text = [NSString stringWithFormat:@"%@,", text];
        text = [NSString stringWithFormat:@"%@ %@ %@ %@", text, item[@"name"], item[@"quantity"], item[@"unit"]];
    }
    if( list.count > 1 ) {
        card_title.text = @"Feeding";
        description.text = text;
    }
    else {
        card_title.text = text;
        // TODO update self's height to 60
    }
}

+ (NSString*)formatValue:(NSString*)value {
    NSArray* list = [totHomeFeedingViewController JSONToObject:value];
    NSString* text = @"";
    for( int i=0; i<list.count; i++ ) {
        NSDictionary* item = list[i];
        if( text.length > 0 ) text = [NSString stringWithFormat:@"%@,", text];
        text = [NSString stringWithFormat:@"%@ %@ %@ %@", text, item[@"name"], item[@"quantity"], item[@"unit"]];
    }
    return text;
}

@end

