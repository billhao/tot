//
//  totReviewCardView.m
//  totdev
//
//  Created by Lixing Huang on 6/29/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import "totTimeline.h"
#import "totReviewCardView.h"
#import "totSummaryCard.h"
#import "totHeightCard.h"
#import "totDiaperCard.h"
#import "totLanguageCard.h"
#import "totSleepCard.h"
#import "totFeedCard.h"
#import "totTimeUtil.h"

// #######################################
// #######         Edit card       #######
// #######################################

@implementation totReviewEditCardView

@synthesize parentView, timeline, type, timeStamp;

- (id)init {
    self = [super init];
    if (self) {
        hour_button = nil;
        year_button = nil;
        timeStamp = nil;
        userHasSetDateTime = FALSE;
        
        timer_ = [[totTimer alloc] init];
        [timer_ setDelegate:self];
        
        contentYOffset = 64; // basically, this should be the y position of timeline_line
        margin_y = 10;
    }
    return self;
}

-(void)dealloc {
    [super dealloc];
    
    [timer_ stop];
    // release the timer.
    [timer_ release];
    if(timeStamp) [timeStamp release];
}

- (void)viewDidLoad {
    [self setBackground];
    self.view.clipsToBounds = TRUE;
}

- (void) setBackground {
    self.view.backgroundColor = [UIColor whiteColor];
}

//
// ----------Confirm Button Animation ----------
// This is a two-stage animation.
//
- (void) secondAnimationDidStop:(NSString*)animationID
                       finished:(NSNumber*)finished context:(void*)context {
    [self.parentView flip];
}

- (void) firstAnimationDidStart:(NSString*)animationID context:(void*)context {}

- (void) firstAnimationDidStop:(NSString*)animationID
                      finished:(NSNumber*)finished context:(void*)context {
    int future_x = icon_confirmed_button.frame.origin.x;
    int future_y = icon_confirmed_button.frame.origin.y;
    int future_size = icon_confirmed_button.frame.size.width;
    
    // replace the gray button with colorful button.
    [icon_confirmed_button setFrame:CGRectMake(icon_unconfirmed_button.frame.origin.x,
                                               icon_unconfirmed_button.frame.origin.y,
                                               icon_unconfirmed_button.frame.size.width,
                                               icon_unconfirmed_button.frame.size.height)];
    [icon_unconfirmed_button setHidden:YES];
    [icon_confirmed_button setHidden:NO];
    
    [UIView beginAnimations:@"pop_up_button" context:nil];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(secondAnimationDidStop:finished:context:)];
    {
        [icon_confirmed_button setFrame:CGRectMake(future_x, future_y, future_size, future_size)];
    }
    [UIView commitAnimations];
}

- (void)confirmIconHandler:(UIButton*)button {
    // Before we start the animation, do any customized things here.
    // If success, return true, so that we can perform the animation.
    if (![self clickOnConfirmIconButton]) {
        return;
    }
    // Change the icon.
    // This is a two-step animation:
    //   1. shrink the original button to a smaller size, change the button.
    //   2. pop it up with the original size.
    if (icon_confirmed_button) {
        // Shrink the original gray button.
        [UIView beginAnimations:@"shrink_gray_button" context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationWillStartSelector:@selector(firstAnimationDidStart:context:)];
        [UIView setAnimationDidStopSelector:@selector(firstAnimationDidStop:finished:context:)];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        {
            int shrinked_size = 10;
            int shrinked_x = icon_unconfirmed_button.frame.origin.x +
                                 (icon_unconfirmed_button.frame.size.width - shrinked_size) / 2;
            int shrinked_y = icon_unconfirmed_button.frame.origin.y +
                                 (icon_unconfirmed_button.frame.size.height - shrinked_size) / 2;
            [icon_unconfirmed_button setFrame:CGRectMake(shrinked_x, shrinked_y, shrinked_size, shrinked_size)];
        }
        [UIView commitAnimations];
    }
}


//
// ------------------- Layout ----------------------
//
- (void)setIcon:(NSString*)icon_name {
    icon_unconfirmed_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [icon_unconfirmed_button setFrame:CGRectMake(5, 5, 50, 50)];
    [icon_unconfirmed_button setImage:[UIImage imageNamed:icon_name] forState:UIControlStateNormal];
    [icon_unconfirmed_button addTarget:self action:@selector(confirmIconHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:icon_unconfirmed_button];
}

- (void) setIcon:(NSString*)icon_name confirmedIcon:(NSString*)confirmed_icon_name {
    [self setIcon:icon_name];
    icon_confirmed_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [icon_confirmed_button setFrame:CGRectMake(5, 5, 50, 50)];
    [icon_confirmed_button setImage:[UIImage imageNamed:confirmed_icon_name]
                           forState:UIControlStateNormal];
    [icon_confirmed_button setHidden:YES];
    [self.view addSubview:icon_confirmed_button];
}

- (void)setCalendar:(int)days {
    // Calendar.
    UIImageView* calendar_icon = [[UIImageView alloc] initWithFrame:CGRectMake(250, 0, 45, 50)];
    calendar_icon.image = [UIImage imageNamed:@"calendar.png"];
    [self.view addSubview:calendar_icon];
    [calendar_icon release];

    UILabel* label_day = [[UILabel alloc] initWithFrame:CGRectMake(253, 26, 40, 20)];
    [label_day setTextAlignment:NSTextAlignmentCenter];
    [label_day setText:[NSString stringWithFormat:@"%d", days]];
    [label_day setTextColor:[UIColor colorWithRed:136/255.0 green:212/255.0 blue:173/255.0 alpha:1.0f]];
    [label_day setFont:[UIFont fontWithName:@"Raleway-SemiBold" size:16]];
    [label_day setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:label_day];
    [label_day release];
}

- (void)setTitle:(NSString *)desc {
    if(!title) {
        title = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 200, 30)];
        //[totUtility enableBorder:title];
        [title setBackgroundColor:[UIColor clearColor]];
        [title setTextColor:[UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1.0f]];
        [title setFont:[UIFont fontWithName:@"Raleway-SemiBold" size:20]];
        [self.view addSubview:title];
        
        // since this function will always be called, add the separator line here.
        line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_line"]];
        line.frame = CGRectMake(0, 60, line.frame.size.width, line.frame.size.height);
        [self.view addSubview:line];
        [line release];
    }
    title.text = desc;
}

- (void)setTimestamp {
    // Right after we get the current time, start the timer, so that we
    // can refresh the time button in time. Stop the timer when we save the
    // entry to database or we cancel the card.
    [timer_ startWithInternalInSeconds:1];
    
    int x = 70; // align with title vertically
    int y = 30;
    int w = 60;
    int h = 30;
    int margin_x = 0;
    // Inserts hour/minute button.
    if(!hour_button) {
        hour_button = [UIButton buttonWithType:UIButtonTypeCustom];
        // Sets hour/minute.
        [hour_button setFrame:CGRectMake(x, y, w, h)];
        [hour_button setTitleColor:[UIColor colorWithRed:128.0/255 green:130.0/255 blue:130.0/255 alpha:1.0]
                          forState:UIControlStateNormal];
        [hour_button.titleLabel setFont:[UIFont fontWithName:@"Raleway" size:13]];
        hour_button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        hour_button.titleLabel.textAlignment = NSTextAlignmentLeft;
        [hour_button setBackgroundColor:[UIColor clearColor]];
        [hour_button addTarget:self action:@selector(timeStampButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:hour_button];
    }
    
    x += w + margin_x;
    w = 100;
    // Inserts year/month/day button.
    if(!year_button) {
        year_button = [UIButton buttonWithType:UIButtonTypeCustom];
        // Sets year/month/day.
        [year_button setFrame:CGRectMake(x, y, w, h)];
        [year_button setTitleColor:[UIColor colorWithRed:128.0/255 green:130.0/255 blue:130.0/255 alpha:1.0]
                          forState:UIControlStateNormal];
        [year_button.titleLabel setFont:[UIFont fontWithName:@"Raleway" size:13]];
        year_button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        year_button.titleLabel.textAlignment = NSTextAlignmentLeft;
        [year_button setBackgroundColor:[UIColor clearColor]];
        [year_button addTarget:self action:@selector(timeStampButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:year_button];
    }
    
    self.timeStamp = [NSDate date];
    [self updateDate];
    [self updateTime];
    
    // reset
    userHasSetDateTime = FALSE;
}

- (bool) clickOnConfirmIconButton {
    if ([self clickOnConfirmIconButtonDelegate]) {
        [timer_ stop];
        return true;
    }
    return false;
}

- (bool) clickOnConfirmIconButtonDelegate { return true; }

- (void)timeStampButtonPressed:(id)sender {
    userHasSetDateTime = TRUE;
    [timer_ stop];
    UIButton* btn = (UIButton*)sender;
    if( btn == hour_button ) {
        [parentView.parent.controller showTimePicker:self mode:kTime datetime:timeStamp];
    }
    else if( btn == year_button ) {
        [parentView.parent.controller showTimePicker:self mode:kDate datetime:timeStamp];
    }
}

#pragma mark - totTimerControllerDelegate
-(void)saveCurrentTime:(NSString*)time datetime:(NSDate*)datetime {
    NSLog(@"%@", time);
    self.timeStamp = datetime;
    if( parentView.parent.controller.mClock.mMode == kDate ) {
        [self updateDate];
    }
    else if( parentView.parent.controller.mClock.mMode == kTime ) {
        [self updateTime];
    }
    [parentView.parent.controller hideTimePicker];
}

-(void)cancelCurrentTime {
    [parentView.parent.controller hideTimePicker];
}

- (void)updateDate {
    [year_button setTitle:[totTimeUtil getDateString:timeStamp] forState:UIControlStateNormal];
}

- (void)updateTime {
    [hour_button setTitle:[totTimeUtil getTimeString:timeStamp] forState:UIControlStateNormal];
}

//
// ---------- Time ------------
//
- (NSString*) getTimestampInString {
    NSArray* comp1   = [hour_button.titleLabel.text componentsSeparatedByString:@":"];
    NSString* hour   = [comp1 objectAtIndex:0];
    NSString* minute = [comp1 objectAtIndex:1];
    
    NSArray* comp2   = [year_button.titleLabel.text componentsSeparatedByString:@"/"];
    NSString* month  = [comp2 objectAtIndex:0];
    NSString* day    = [comp2 objectAtIndex:1];
    NSString* year   = [comp2 objectAtIndex:2];
    
    NSString* timestamp =
        [NSString stringWithFormat:@"%@-%@-%@ %@:%@:%s", year, month, day, hour, minute, "00"];
    return timestamp;
}

# pragma totTimer delegate
- (void)timerCallback:(totTimer *)timer {
    if( userHasSetDateTime ) return; // do not respond if user has modified date or time
    
    self.timeStamp = [NSDate date];
    [self updateDate];
    [self updateTime];
}

- (int) height { return 0; }
- (int) width  { return 0; }

@end


// #######################################
// #######         Show card       #######
// #######################################
@implementation totReviewShowCardView

@synthesize parentView;
@synthesize timeline;
@synthesize card_title;
@synthesize description;
@synthesize story_, e, type;

- (id) init {
    self = [super init];
    if (self) {
        e = nil;
    }
    return self;
}

- (void) viewDidLoad {
    [self setBackground];
    self.view.clipsToBounds = TRUE;
    
    // add title
    card_title = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 230, 30)];
    [card_title setText:@""];
    [card_title setBackgroundColor:[UIColor clearColor]];
    [card_title setTextColor:[UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1.0f]];
    [card_title setFont:[UIFont fontWithName:@"Raleway-SemiBold" size:20]];
    [self.view addSubview:card_title];
    
    // add description
    description = [[UILabel alloc] initWithFrame:CGRectMake(8, 60, 260, 60)];
    description.text = @"";
    description.textAlignment = NSTextAlignmentLeft;
    description.backgroundColor = [UIColor clearColor];
    description.numberOfLines = 0;
    [description setFont:[UIFont fontWithName:@"Raleway" size:13]];
    [description setTextColor:[UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1.0f]];
    [self.view addSubview:description];
    
    // add timestamp
    timestamp = [[UILabel alloc] initWithFrame:CGRectMake(70, 30, 180, 30)];
    timestamp.textAlignment = NSTextAlignmentLeft;
    timestamp.text = @"";
    [timestamp setTextColor:[UIColor colorWithRed:128.0/255 green:130.0/255 blue:130.0/255 alpha:1.0]];
    [timestamp setFont:[UIFont fontWithName:@"Raleway" size:15]];
    [timestamp setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:timestamp];
    
    // add separator
    line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_line"]];
    line.frame = CGRectMake(0, 60, line.frame.size.width, line.frame.size.height);
    [self.view addSubview:line];
}

- (void) setCalendar:(int)days {
    // Calendar.
    if (calendar_icon_) {
        calendar_icon_ = [[UIImageView alloc] initWithFrame:CGRectMake(250, 0, 45, 50)];
        calendar_icon_.image = [UIImage imageNamed:@"calendar.png"];
        [self.view addSubview:calendar_icon_];
    }
    if (calendar_text_) {
        [calendar_text_ setText:[NSString stringWithFormat:@"%d", days]];
    } else {
        calendar_text_ = [[UILabel alloc] initWithFrame:CGRectMake(253, 26, 40, 20)];
        [calendar_text_ setTextAlignment:NSTextAlignmentCenter];
        [calendar_text_ setText:[NSString stringWithFormat:@"%d", days]];
        [calendar_text_ setTextColor:[UIColor colorWithRed:136/255.0
                                                     green:212/255.0
                                                      blue:173/255.0
                                                     alpha:1.0f]];
        [calendar_text_ setFont:[UIFont fontWithName:@"Raleway-SemiBold" size:16]];
        [calendar_text_ setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:calendar_text_];
    }
}

- (void) setIcon:(NSString*)icon_name {
    UIImageView* icon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
    icon.image = [UIImage imageNamed:icon_name];
    [self.view addSubview:icon];
    [icon release];
}

- (void) setTimestamp:(NSString*)time {
    timestamp.text = time;
}

- (void) setTimestampWithDate:(NSDate*)datetime {
    timestamp.text = [totTimeUtil getTimeDescriptionFromNow:datetime];
}

- (void) setBackground {
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void) dealloc {
    [super dealloc];
    [card_title release];
    [description release];
    [timestamp release];
    [calendar_text_ release];
    [calendar_icon_ release];
    
    if( e ) [e release];
}

- (int) height { return 0; }
- (int) width  { return 0; }

@end


// Combine the edit card and show card.
//
// ----------------- totReviewCardView -------------------
//
@implementation totReviewCardView

@synthesize mEditView;
@synthesize mShowView;
@synthesize parent;
@synthesize associated_delete_button;
@synthesize mMode;

//
// ----------------- Gesture delegates --------------------
//
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if( self.mShowView.type == SUMMARY ) return NO; // no delete for summary card
    
    // do not allow scroll if in height/weight/head cards' picker
    if( mMode == EDIT && (self.mEditView.type == HEIGHT || self.mEditView.type == WEIGHT || self.mEditView.type == HEAD ) ) {
        totHeightEditCard* hcard = (totHeightEditCard*)self.mEditView;
        STHorizontalPicker* picker = [hcard getPicker];
        if( [picker pointInside:[gestureRecognizer locationInView:picker] withEvent:nil] )
            return NO;
    }
    return YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch {
    return YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void) performAnimation: (bool)deleted {
    float d;
    if (!deleted)
        d = 0.3;
    else
        d = 0.5;
    [UIView beginAnimations:@"review_card_animation" context:&deleted];
    [UIView setAnimationDuration:d];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    if (!deleted) {
        self.frame = CGRectMake(associated_delete_button.frame.origin.x,
                                self.frame.origin.y,
                                self.frame.size.width, self.frame.size.height);
    } else {
        int n = associated_delete_button.frame.origin.x + associated_delete_button.bounds.size.width;
        self.frame = CGRectMake(n,
                                self.frame.origin.y,
                                self.frame.size.width, self.frame.size.height);
    }
    [UIView commitAnimations];
}

//static int nn = 0;
- (void) handlePan:(UIGestureRecognizer*) gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:UIPanGestureRecognizer.class]) {
        UIPanGestureRecognizer* pan = (UIPanGestureRecognizer*)gestureRecognizer;
        CGPoint translation = [pan translationInView:self];
        //NSLog(@"%d \t tx=%d \t ty=%d \t x=%.0f y=%.0f \t %d", nn, (int)touch_x, (int)touch_y, translation.x, translation.y, gestureRecognizer.state);
        //nn++;
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
            NSLog(@"move began");
//            touch_x = translation.x;
//            touch_y = translation.y;
            origin_x = self.frame.origin.x;
            endGesture = FALSE;
        } else
        {
            if ( fabs(translation.y) * 4 > fabs(translation.x) ) {
                //NSLog(@"return tx=%.1f ty=%.1f x=%.1f y=%.1f", translation.x, translation.y, touch_x, touch_y);
                endGesture = TRUE;
            }
            else if( !endGesture ) {
                CGRect f = self.frame;
                f.origin.x = origin_x + translation.x;
                self.frame = f;
                //[pan setTranslation:CGPointMake(0, 0) inView:self];
            }
//            touch_x = translation.x;
//            touch_y = translation.y;
        }
        if ( endGesture || (gestureRecognizer.state == UIGestureRecognizerStateEnded) ) {
            printf("move the review card: %f %f\n", self.frame.origin.x, self.frame.size.width);
            int n = associated_delete_button.frame.origin.x + associated_delete_button.bounds.size.width;
            if (self.frame.origin.x >= n) {
                [self performAnimation:YES];
            } else {
                [self performAnimation:NO];
            }
        }
    }
}

- (void) registerGestures {
    UIPanGestureRecognizer* pan =
        [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [pan setDelegate:self];
    [self addGestureRecognizer:pan];
    [pan release];
    
    touch_x = -1.0f;
    endGesture = FALSE;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) { mEditView = nil; mShowView = nil; }
    return self;
}

// totReviewStory contains all necessary information to visualize a tot event.
- (id)initWithType:(ReviewCardType)type withData:(totReviewStory*)story timeline:(totTimeline*)timeline {
    self = [super init];
    if (self) {
        totReviewShowCardView* c = nil;
        switch (type) {
            case HEIGHT:
            case WEIGHT:
            case HEAD:
            {
                c = (totReviewShowCardView*)[[totHeightShowCard alloc] init:type];
                break;
            }
            case DIAPER:
            {
                c = (totReviewShowCardView*)[[totDiaperShowCard alloc] init];
                break;
            }
            case LANGUAGE:
            {
                c = (totReviewShowCardView*)[[totLanguageShowCard alloc] init];
                break;
            }
            case SLEEP:
            {
                c = (totReviewShowCardView*)[[totSleepShowCard alloc] init];
                break;
            }
            case FEEDING:
            {
                c = (totReviewShowCardView*)[[totFeedShowCard alloc] init];
                break;
            }
            default:
                break;
        }
        if (c) {
            self.frame = CGRectMake(0, 0, [c width], [c height]);
            c.view.frame = self.bounds;
            c.timeline = timeline;
            c.story_ = story;
            self.mShowView = c;
            self.mShowView.parentView = self;
            [c release];
            
            [self addSubview:self.mShowView.view];
            mMode = SHOW;
            
            // Register gesture recognizer.
            [self registerGestures];
        }
    }
    return self;
}

// Creates empty card.
// Default is edit card.
- (id)initWithType:(ReviewCardType)type timeline:(totTimeline*)timeline {
    origin_x = GAP_BETWEEN_CARDS;
    self = [super init];
    if (self) {
        totReviewEditCardView* c1 = nil;
        totReviewShowCardView* c2 = nil;
        switch (type) {
            case TEST:
            {
                printf("Do not use test card any more.\n");
                break;
            }
            case SUMMARY:
            {
                totSummaryCard* c = [[totSummaryCard alloc] init];
                c.type = type;
                c.timeline = timeline;
                self.frame = CGRectMake(0, 0, [c width], [c height]);
                c.view.frame = self.bounds;
                self.mShowView = c;
                self.mShowView.parentView = self;
                [c release];
                break;
            }
            case HEIGHT:
            case WEIGHT:
            case HEAD:
            {
                c1 = (totReviewEditCardView*) [[totHeightEditCard alloc] init:type];
                c2 = (totReviewShowCardView*) [[totHeightShowCard alloc] init:type];
                break;
            }
            case DIAPER:
            {
                c1 = (totReviewEditCardView*) [[totDiaperEditCard alloc] init];
                c2 = (totReviewShowCardView*) [[totDiaperShowCard alloc] init];
                break;
            }
            case LANGUAGE:
            {
                c1 = (totReviewEditCardView*) [[totLanguageEditCard alloc] init];
                c2 = (totReviewShowCardView*) [[totLanguageShowCard alloc] init];
                break;
            }
            case SLEEP:
            {
                c1 = (totReviewEditCardView*) [[totSleepEditCard alloc] init];
                c2 = (totReviewShowCardView*) [[totSleepShowCard alloc] init];
                break;
            }
            case FEEDING:
            {
                c1 = (totReviewEditCardView*) [[totFeedEditCard alloc] init];
                c2 = (totReviewShowCardView*) [[totFeedShowCard alloc] init];
            }
            default:
                break;
        }
        if( c1 != nil && c2 != nil ) {
            self.frame = CGRectMake(0, 0, [c1 width], [c1 height]);
            c1.view.frame = self.bounds;
            c2.view.frame = CGRectMake(0, 0, [c2 width], [c2 height]);
            c1.type = type;
            c2.type = type;
            c1.timeline = timeline;
            c2.timeline = timeline;
            self.mEditView = c1;
            self.mShowView = c2;
            self.mEditView.parentView = self;
            self.mShowView.parentView = self;
            [c1 release];
            [c2 release];
        }

        // When creating a new card, the default view is editting view.
        // except for summary card.
        if (type == SUMMARY) {
            [self addSubview:self.mShowView.view];
            mMode = SHOW;
        } else {
            [self addSubview:self.mEditView.view];
            mMode = EDIT;
        }
        // Register gesture recognizer.
        [self registerGestures];
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

//
// ----------------- Card Flip Animation ---------------------
//
- (void) animationDidStart:(NSString*)animationID context:(void*)context {
    self.associated_delete_button.hidden = YES;
}

- (void) animationDidStop:(NSString*)animationID finished:(NSNumber*)finished context:(void*)context {
    self.associated_delete_button.hidden = NO;
}

- (void) flip {
    [UIView beginAnimations:@"review_card_flip" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationWillStartSelector:@selector(animationDidStart:context:)];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    if (mMode == EDIT) {
        mMode = SHOW;
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self cache:YES];
        [mEditView.view removeFromSuperview];
        [self addSubview:mShowView.view];
        // Change the frame size.
        CGRect f = CGRectMake(self.frame.origin.x,
                              self.frame.origin.y,
                              mShowView.view.frame.size.width, mShowView.view.frame.size.height);
        self.frame = f;
        mShowView.view.frame = self.bounds;
    } else {
        mMode = EDIT;
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
        [mShowView.view removeFromSuperview];
        [self addSubview:mEditView.view];
        // Change the frame size.
        CGRect f = CGRectMake(self.frame.origin.x,
                              self.frame.origin.y,
                              mEditView.view.frame.size.width, mEditView.view.frame.size.height);
        self.frame = f;
        mEditView.view.frame = self.bounds;
    }
    // Need refresh the whole timeline view.
    [self.parent refreshView];
    [UIView commitAnimations];
    
    
}

// Static methods.
// Different type of cards may need different size.
//+ (CGRect) getEditCardSizeOfType:(ReviewCardType)type {
//    int w = 308, h = 100;
//    if (type == SUMMARY) {
//        w = [totSummaryCard width];
//        h = [totSummaryCard height];
//    } else if (type == HEIGHT||type == WEIGHT||type == HEAD) {
//        w = [totHeightEditCard width];
//        h = [totHeightEditCard height];
//    } else if (type == DIAPER) {
//        w = [totDiaperEditCard width];
//        h = [totDiaperEditCard height];
//    } else if (type == LANGUAGE) {
//        w = [totLanguageEditCard width];
//        h = [totLanguageEditCard height];
//    } else if (type == SLEEP) {
//        w = [totSleepEditCard width];
//        h = [totSleepEditCard height];
//    } else if (type == FEEDING) {
//        w = [totFeedEditCard width];
//        h = [totFeedEditCard height];
//    } else {
//        printf("please add size info to getEditCardSizeOfType\n");
//        exit(-1);
//    }
//    return CGRectMake(0, 0, w, h);
//}

//+ (CGRect) getShowCardSizeOfType:(ReviewCardType)type {
//    int w = 308, h = 100;
//    if (type == SUMMARY) {
//        w = [totSummaryCard width];
//        h = [totSummaryCard height];
//    } else if (type == HEIGHT||type == WEIGHT||type == HEAD) {
//        w = [totHeightShowCard width];
//        h = [totHeightShowCard height];
//    } else if (type == DIAPER) {
//        w = [totDiaperShowCard width];
//        h = [totDiaperShowCard height];
//    } else if (type == LANGUAGE) {
//        w = [totLanguageShowCard width];
//        h = [totLanguageShowCard height];
//    } else if (type == SLEEP) {
//        w = [totSleepShowCard width];
//        h = [totSleepShowCard height];
//    } else if (type == FEEDING) {
//        w = [totFeedShowCard width];
//        h = [totFeedShowCard height];
//    } else {
//        printf("please add size info to getShowCardSizeOfType\n");
//        exit(-1);
//    }
//    return CGRectMake(0, 0, w, h);
//}

+ (totReviewCardView*) createEmptyCard:(ReviewCardType)type timeline:(totTimeline*)timeline {
    totReviewCardView* view = [[totReviewCardView alloc] initWithType:type timeline:timeline];
    return view;
}

+ (totReviewCardView*) loadCard:(NSString*)type story:(totReviewStory*)story timeline:(totTimeline*)timeline {
    NSArray* tokens = [type componentsSeparatedByString:@"/"];
    NSString* category = [tokens objectAtIndex:0];
    
    if ([category isEqualToString:@"basic"]) {
        NSString* basic_type = [tokens objectAtIndex:1];
        ReviewCardType card_type = TEST;
        if ([basic_type isEqualToString:@"diaper"]) {
            card_type = DIAPER;
        } else if ([basic_type isEqualToString:@"height"]) {
            card_type = HEIGHT;
        } else if ([basic_type isEqualToString:@"weight"]) {
            card_type = WEIGHT;
        } else if ([basic_type isEqualToString:@"head"]) {
            card_type = HEAD;
        } else if ([basic_type isEqualToString:@"sleep"]) {
            card_type = SLEEP;
        } else if ([basic_type isEqualToString:@"language"]) {
            card_type = LANGUAGE;
        } else if ([basic_type isEqualToString:@"feeding"]) {
            card_type = FEEDING;
        } else {
            return nil;
        }
        totReviewCardView* view = [[totReviewCardView alloc] initWithType:card_type
                                                                 withData:story
                                                                 timeline:timeline];
        return view;
    } else {
        return nil;
    }
}

@end
