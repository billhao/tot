//
//  totLanguageCard.m
//  totdev
//
//  Created by Lixing Huang on 8/11/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import "totLanguageCard.h"
#import "totTimeUtil.h"
#import "totTimeline.h"

@implementation totLanguageEditCard

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
    [self display];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.parentView.parent moveToTop:self.parentView];
}

- (void) setBackground {
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void) loadIcons {
    [self setTimestamp];
    [self setTitle:@"New Word"];
    [self setIcon:@"language_gray.png"];
    [self setCalendar:99];
    [self loadButtons];
}

/*
- (void) loadInputContent {
    //confirm_button = [UIButton buttonWithType:UIButtonTypeCustom];
    //confirm_button.backgroundColor = [UIColor greenColor];
    //[confirm_button setFrame:CGRectMake(10, 160, 100, 30)];
    //[confirm_button setTitle:@"Confirm" forState:UIControlStateNormal];
    //[confirm_button addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:confirm_button];
    
    // text input area
    new_words_input = [[UITextView alloc] initWithFrame:CGRectMake(10, 100, 290, 40)];
    new_words_input.backgroundColor = [UIColor clearColor];
    [self.view addSubview:new_words_input];
    // text input area background
    UIView* background = [[UIView alloc] initWithFrame:CGRectMake(10, 100, 290, 40)];
    background.backgroundColor = [UIColor yellowColor];
    [self.view insertSubview:background belowSubview:new_words_input];
    [background release];
}

- (void) confirm: (UIButton*)button {
    [self.parentView.parent moveToTop:self.parentView];
    [self setTitle:@"Language"];
    [self setIcon:@"language2.png" withCalendarDays:0];
}
 */

- (void) loadButtons {
    [self setTimestamp];
    
    defaultTxt = @"what did the baby say?";
    
    float margin_y = contentYOffset;
    float h = 80;
    float w = 280;
    
    // add the cloud for the text
    CGRect f = CGRectMake(([totLanguageEditCard width]-w)/2, margin_y, w, h);
    UIImage* bgImg = [UIImage imageNamed:@"lang_input_bg"];
    UIImageView* bgImgView = [[UIImageView alloc] initWithImage:bgImg];
    bgImgView.frame = f;
    [self.view addSubview:bgImgView];
    [bgImgView release];
    
    // Construct m_textField
    textView = [[UITextView alloc] initWithFrame:f];
    textView.editable = YES;
    textView.delegate = self;
    textView.textAlignment = UITextAlignmentCenter;
    textView.backgroundColor = [UIColor clearColor];
    textView.font = [UIFont fontWithName:@"Raleway" size:16.0];
    textView.textColor = [UIColor colorWithRed:100.0/255 green:100.0/255 blue:100.0/255 alpha:1.0];
    // disable auto correction, capitalization and etc
    textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textView.autocorrectionType = UITextAutocorrectionTypeNo;
    textView.spellCheckingType = UITextSpellCheckingTypeNo;
    [self.view addSubview:textView];
}

+ (int) height { return 200; }
+ (int) width { return 308; }

- (void) dealloc {
    [super dealloc];
    [textView release];
}

#pragma mark - Event handlers

// define the action when the textview is selected for editing
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView1
{
    NSString *text = [textView1.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    if ( [text isEqualToString:defaultTxt]) {
        textView1.text = @"";
    }
    [self.parentView.parent moveToTop:self.parentView];
    
    return YES;
}

// whenever the user types the keyboard
- (BOOL)textView:(UITextView*)textView1 shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if( [text isEqualToString:@"\n"] ) {
        [textView1 resignFirstResponder];
        return NO;
    }
    
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    [self confirm:nil];
}

- (void) confirm: (UIButton*)button {
    /* Save text into database */
    NSString *text = [textView.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    if(textView.hasText == YES && (![text isEqualToString:defaultTxt]) ) {
        /* Get current date */
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate* curDate = [NSDate date];
        NSString *formattedDateString = [dateFormatter stringFromDate:curDate];
        [dateFormatter release];
        
        /* Get input text */
        /* Add to database */
        totModel* totModel = global.model;
        [totModel addEvent:global.baby.babyID event:EVENT_BASIC_LANGUAGE datetimeString:formattedDateString value:text ];
        
        /* Clear textview text */
        textView.text = defaultTxt;
        
        /* Hide keyboard */
        [textView resignFirstResponder];
        
        // flip to display card
        [parentView flip];
        
        // TODO update summary card
        
    } else {
    }
}


#pragma mark - Helper functions

- (void)display
{
    /* Init and display textView */
    textView.text = defaultTxt;
}

@end




@implementation totLanguageShowCard

- (id) init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackground];
    [self setIcon:@"language2.png"];
    [self setTimestamp:@"40 Minutes ago"];
}


- (void)viewWillAppear:(BOOL)animated {
    // reload data
    [self getDataFromDB];
}

#pragma mark - Helper functions

- (void) getDataFromDB {
    NSString* event = EVENT_BASIC_LANGUAGE;
    
    NSArray* events = [global.model getEvent:global.baby.babyID event:event limit:2];
    
    if( events.count > 0 ) {
        totEvent* currEvt = [events objectAtIndex:0];
        card_title.text = [NSString stringWithFormat:@"%@", currEvt.value];
        description.text = [self GetOutputStr:currEvt.value];

//        if( events.count > 1 ) {
//            totEvent* prevEvt = [events objectAtIndex:1];
//            description.text = [NSString stringWithFormat:@"Learned last time: %@", prevEvt.value];
//        }
    }
}

+ (int) height { return 200; }
+ (int) width { return 308; }

- (NSString*) GetOutputStr: (NSString*) inputStr
{
    // Get total words learnd so far
    totModel* totModel = global.model;
    NSMutableArray *lanEventAll = [totModel getEvent: 0 event: EVENT_BASIC_LANGUAGE];
    int num_word_all = lanEventAll.count;
    
    // Get words learnd since the 1st day of this month
    NSDateFormatter *curDateFormatter = [[NSDateFormatter alloc] init];
    [curDateFormatter setDateFormat:@"yyyy"];
    int year = [[curDateFormatter stringFromDate:[NSDate date]] intValue];  // current year
    [curDateFormatter setDateFormat:@"MM"];
    int month = [[curDateFormatter stringFromDate:[NSDate date]] intValue];  // current month
    [curDateFormatter release];
    NSString *curMonthStr = [NSString stringWithFormat:@"%d-%d-01 00:00:00", year, month];  // needs to fig out time zone offset
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *firstDayThisMonth = [formatter dateFromString:curMonthStr];
    NSMutableArray *lanEventThisMonth = [totModel getEvent:0 event:EVENT_BASIC_LANGUAGE startDate:firstDayThisMonth endDate:[NSDate date]];
    int num_word_this_month = lanEventThisMonth.count;
    
    // Decide the output to user
    NSString *outputStr = nil;
    if ( [inputStr caseInsensitiveCompare:@"mom"] == 0 || [inputStr caseInsensitiveCompare:@"dad"] == 0 ||
        [inputStr caseInsensitiveCompare:@"mama"] == 0 || [inputStr caseInsensitiveCompare:@"dada"] == 0 ||
        [inputStr caseInsensitiveCompare:@"mommy"] == 0 || [inputStr caseInsensitiveCompare:@"daddy"] == 0 ) {
        outputStr = [NSString stringWithFormat:@"Wow, %@ just said %@!", global.baby.name, inputStr];
    } else if (num_word_all % 50 == 0 ) {
        outputStr = [NSString stringWithFormat:@"%@ has learnd %d words in total. Great milestone!", global.baby.name, num_word_all];
    } else if ( num_word_this_month >= 5 ) {
        outputStr = [NSString stringWithFormat:@"Bravo! %@ has learnd %d words this month!", global.baby.name, num_word_this_month];
    } else {
        outputStr = [NSString stringWithFormat:@"%@ has learnd %d words in total. Keep going!", global.baby.name, num_word_all];
    }
    [formatter release];
    return outputStr;
}


@end

