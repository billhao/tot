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
#import "totReviewStory.h"

@implementation totLanguageEditCard

- (id)init {
    self = [super init];
    if (self) {
        [self setBackground];
        [self loadIcons];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [self display];
}

- (void) setBackground {
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void) loadIcons {
    [self setTimestamp];
    [self setTitle:@"New Word"];
    [self setIcon:@"language_gray" confirmedIcon:@"language2"];
    //[self setCalendar:99];
    [self loadButtons];
}

- (void) loadButtons {    
    defaultTxt = @"what did the baby say?";
    
    float y = contentYOffset + margin_y;
    float h = 80;
    float w = 280;
    
    // add the cloud for the text
    CGRect f = CGRectMake(([self width]-w)/2, y, w, h);
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

- (int) height {
    CGRect f = textView.frame;
    return f.origin.y + f.size.height + margin_y;
}

- (int) width { return 308; }

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
        [super confirmIconHandler:nil]; // pretend the user clicked on the confirm button
        return NO;
    }
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView {
}

- (bool) clickOnConfirmIconButtonDelegate {
    /* Save text into database */
    NSString *text = [textView.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    if(textView.hasText == YES && (![text isEqualToString:defaultTxt]) ) {
        /* Get input text */
        /* Add to database */
        totModel* totModel = global.model;
        self.parentView.event_id = [totModel addEvent:global.baby.babyID event:EVENT_BASIC_LANGUAGE datetime:self.timeStamp value:text ];
        
        /* Hide keyboard */
        [textView resignFirstResponder];
        
        // update summary card
        [self.parentView.parent updateSummaryCard:LANGUAGE
                                        withValue:[NSString stringWithFormat:@"%@", text]];
        
        return TRUE;
    } else {
        [totUtility showAlert:@"What did the baby say?"];
        return FALSE;
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
}


- (void)viewWillAppear:(BOOL)animated {
    // If we load card from database, should not call this function again.
    // when loading from db, story_ will not be nil.
    if (!story_) {
        [self getDataFromDB];
    } else {
        card_title.text = [NSString stringWithFormat:@"%@", story_.mRawContent];
        description.text = @"";
        [self setTimestamp:[totTimeUtil getTimeDescriptionFromNow:story_.mWhen]];
    }
}

#pragma mark - Helper functions

- (void) getDataFromDB {
    NSString* event = EVENT_BASIC_LANGUAGE;
    
    // get the events
    totEvent* e0 = nil;
    if( parentView.event_id != NO_EVENT ) {
        self.e = [global.model getEventByID:parentView.event_id];
    }
    else {
        NSArray* events = [global.model getEvent:global.baby.babyID event:event limit:2];
        if( events.count > 0 ) {
            self.e = [events objectAtIndex:0];
//            if( events.count > 1 )
//                e0 = [events objectAtIndex:1];
        }
    }
    
    // update UI
    if( self.e ) {
        card_title.text = [NSString stringWithFormat:@"%@", e.value];
        [self setTimestampWithDate:e.datetime];
        description.text = [self GetOutputStr:self.e.value];
    }
    if( e0 ) {
        description.text = [NSString stringWithFormat:@"Learned last time: %@", e0.value];
    }

}

- (int) height { return 60; }
- (int) width { return 308; }

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
    NSMutableArray *lanEventThisMonth = [totModel getEvent:0
                                                     event:EVENT_BASIC_LANGUAGE
                                                 startDate:firstDayThisMonth
                                                   endDate:[NSDate date]];
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

- (void) updateCard { [self setTimestampWithDate:self.e.datetime]; }

@end

