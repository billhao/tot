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

#define DEFAULT_HEIGHT 200

@implementation totFeedEditCard

- (int) height {
    CGRect f = addBtn.frame;
    int hh = f.origin.y + f.size.height + margin_y;
    return MAX(DEFAULT_HEIGHT, hh);
}
- (int) width { return 308; }

- (id)init {
    self = [super init];
    if (self) {
        margin_x = 6;
        margin_y = 10;
        x = 20;
        y = contentYOffset + margin_y;
        w1 = 140;
        w2 = 60;
//        w3 = 40;
        h = 30;
        
        foodBoxes = [[NSMutableArray alloc] init];
        quanBoxes = [[NSMutableArray alloc] init];
//        unitBoxes = [[NSMutableArray alloc] init];
        inputViews = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    [mQuantity release];
    
    [super dealloc];
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
    
    CGRect f = addBtn.frame;
    if( f.origin.y+f.size.height > self.view.bounds.size.height ) {
        // refresh the timeline to reflect height change
        [self.parentView.parent refreshView];
    }
}

- (void)deleteBtnPressed:(id)sender {
    int tag = ((UIButton*)sender).superview.tag;
    // delete input boxes at i
    [((UIView*)inputViews[tag]) removeFromSuperview];
    
    // delete the text fields
    [foodBoxes removeObjectAtIndex:tag];
    [quanBoxes removeObjectAtIndex:tag];
//    [unitBoxes removeObjectAtIndex:tag];
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
            ((UITextField*)quanBoxes[i]).tag = i;
        }
        // update y of add button
        int yy = y + (inputViews.count-1)*(h+margin_y);
        int xx = x + w1 + w2 + h + 3*margin_x;
        CGRect f = CGRectMake(xx, yy, h, h);
        addBtn.frame = f;
    }
    
    // keep space for at least 3 rows
    if( foodBoxes.count >= 3 ) {
        // refresh the timeline to reflect height change
        [self.parentView.parent refreshView];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    //if( textField.tag > 1 )
    {
        int i = textField.tag;
        [self ensureVisible:((UIView*)inputViews[i]).frame];
    }
    
    // this is a quantity text field
    if( textField.inputView == mQuantity.view ) {
        currentEditingQuantityTextField = textField;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    currentEditingQuantityTextField = nil;
    [textField resignFirstResponder];
    return YES;
}

- (void)ensureVisible:(CGRect)f {
    // scroll it up
    float yy = self.parentView.frame.origin.y;
    float offset = self.parentView.parent.contentOffset.y;
    float navbar_h = 42;
    float y1 = f.origin.y;
    float h1 = f.size.height;
    float bottom = yy - offset + y1 + h1 + navbar_h;
    
    float h2 = mQuantity.mQuantityPicker.frame.size.height;
    float h3 = mQuantity.inputAccessoryView.frame.size.height;
    float inputview_top = self.parentView.parent.frame.size.height - h2 - h3;
    float d = bottom - inputview_top;
    offset = yy + (y1+h1+margin_y - inputview_top);
    NSLog(@"textfield bottom = %.0f, inputview = %.0f, d = %.0f, offset = %0.f", bottom, inputview_top, d, offset);
    //if( d > 0 )
    {
        CGPoint pt = CGPointMake(0, offset);
        [parentView.parent setContentOffset:pt animated:TRUE];
    }
}

// Check the input. If it's valid return true, otherwise, return false.
- (bool)clickOnConfirmIconButtonDelegate {
    NSArray* foodList = [self getFoodList];
    if( (!foodList) || ([foodList count] == 0) ) {
        [totUtility showAlert:@"Type in food name and choose quantity to continue"];
        return false; // invalid input
    }
    
    NSString* json = [self saveToDB:foodList];
    
    [self.parentView.parent updateSummaryCard:FEEDING withValue:[totFeedShowCard formatValue:json]];
    
    return true;
}


#pragma mark - Helper functions

- (void)createUI {
    addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:[UIImage imageNamed:@"feeding_add"] forState:UIControlStateNormal];
    [addBtn setImage:[UIImage imageNamed:@"feeding_add"] forState:UIControlStateHighlighted];
    [addBtn addTarget:self action:@selector(addBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    
    // initialize quantity picker.
    mQuantity = [[totQuantityController alloc] init:self.view];
    mQuantity.view.frame = CGRectMake(0, 480, mQuantity.mWidth, mQuantity.mHeight);
    [mQuantity setDelegate:self];
    [self.timeline.controller.view addSubview:mQuantity.view];

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
    UITextField* quan = [self createInputBox:f parentView:v];
    quan.tag = i;
    quan.inputView = mQuantity.view;
    quan.inputAccessoryView = mQuantity.inputAccessoryView;
    [quanBoxes addObject:quan];

//    f.origin.x += w2 + margin_x;
//    f.size.width = w3;
//    [unitBoxes addObject:[self createInputBox:f parentView:v]];
    
    // create delete button
    f.origin.x += w2 + margin_x;
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
    int xx = x + w1 + w2 + h + 3*margin_x;
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
    textView.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
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
        // check if input is valid
        NSString* food = ((UITextField*)foodBoxes[i]).text;
        NSString* quantity = ((UITextField*)quanBoxes[i]).text;
        // remove whitespaces
        food = [food stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        quantity = [quantity stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if( food.length == 0 || quantity.length == 0 ) {
            continue;
        }
        
        // add this food item
        NSMutableDictionary *foodItem = [[NSMutableDictionary alloc] init];
        [foodItem setObject:food forKey:@"name"];
        [foodItem setObject:quantity forKey:@"quantity"];
//        [foodItem setObject:((UITextField*)unitBoxes[i]).text forKey:@"unit"];
        [foodItem setObject:@"" forKey:@"category"];
        [list addObject:foodItem];
        [foodItem release];
    }
    return list;
}

- (NSString*)saveToDB:(NSArray*)list {
    NSString* json = [totHomeFeedingViewController ObjectToJSON:list];
    [global.model addEvent:global.baby.babyID event:EVENT_BASIC_FEEDING datetime:self.timeStamp value:json];
    return json;
}

-(void)saveQuantity:(NSString *)qu{
    currentEditingQuantityTextField.text = qu;
    [currentEditingQuantityTextField resignFirstResponder];
}

-(void)cancelQuantity {
    [currentEditingQuantityTextField resignFirstResponder];
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
        self.e = [currEvt retain];
        [self setTimestampWithDate:currEvt.datetime];
        [self updateUI:currEvt.value];
        [self setTimestamp:currEvt.getTimeText];
    }
}

- (void)updateUI:(NSString*)value {
    NSString* text = [totFeedShowCard formatValue:value];
    if( text.length > 0 ) {
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
        text = [NSString stringWithFormat:@"%@ %@ %@", text, item[@"name"], item[@"quantity"]];
    }
    return text;
}

@end

