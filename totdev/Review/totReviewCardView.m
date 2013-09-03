//
//  totReviewCardView.m
//  totdev
//
//  Created by Lixing Huang on 6/29/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import "totTimeline.h"
#import "totReviewCardView.h"
#import "totTestCard.h"
#import "totSummaryCard.h"
#import "totHeightCard.h"
#import "totDiaperCard.h"
#import "totLanguageCard.h"
#import "totSleepCard.h"
#import "totFeedCard.h"
#import "totTimeUtil.h"

@implementation totReviewEditCardView

@synthesize parentView;
@synthesize timeline;

- (id)init {
    self = [super init];
    if (self) {
        timer_ = [[totTimer alloc] init];
        [timer_ setDelegate:self];
    }
    return self;
}

- (void)viewDidLoad {
    [self setBackground];
}

- (void) setBackground {
    self.view.backgroundColor = [UIColor whiteColor];
}

//
// ------------------- Animation -------------------
//
- (void) secondAnimationDidStop:(NSString*)animationID finished:(NSNumber*)finished context:(void*)context {}

- (void) animationDidStart:(NSString*)animationID context:(void*)context {}

- (void) animationDidStop:(NSString*)animationID finished:(NSNumber*)finished context:(void*)context {
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
        [UIView setAnimationWillStartSelector:@selector(animationDidStart:context:)];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
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
- (void) setIcon:(NSString*)icon_name confirmedIcon:(NSString*)confirmed_icon_name {
    [self setIcon:icon_name];
    icon_confirmed_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [icon_confirmed_button setFrame:CGRectMake(5, 5, 50, 50)];
    [icon_confirmed_button setImage:[UIImage imageNamed:confirmed_icon_name] forState:UIControlStateNormal];
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
    label_day.textAlignment = NSTextAlignmentCenter;
    [label_day setText:[NSString stringWithFormat:@"%d", days]];
    [label_day setTextColor:[UIColor colorWithRed:136/255.0 green:212/255.0 blue:173/255.0 alpha:1.0f]];
    [label_day setFont:[UIFont fontWithName:@"Raleway-SemiBold" size:16]];
    [label_day setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:label_day];
    [label_day release];
}

- (void)setIcon:(NSString*)icon_name {
    // Icon.
    icon_unconfirmed_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [icon_unconfirmed_button setFrame:CGRectMake(5, 5, 50, 50)];
    [icon_unconfirmed_button setImage:[UIImage imageNamed:icon_name] forState:UIControlStateNormal];
    [icon_unconfirmed_button addTarget:self action:@selector(confirmIconHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:icon_unconfirmed_button];
}

- (void)setTitle:(NSString *)desc {
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 150, 30)];
    [title setText:desc];
    [title setBackgroundColor:[UIColor clearColor]];
    [title setTextColor:[UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1.0f]];
    [title setFont:[UIFont fontWithName:@"Raleway-SemiBold" size:20]];
    [self.view addSubview:title];
    [title release];
    
    // since this function will always be called, add the line here.
    UIImageView* line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_line"]];
    line.frame = CGRectMake(0, 60, [totSummaryCard width], line.frame.size.height);
    [self.view addSubview:line];
}

- (void)setTimestamp {
    // Initializes timestamp.
    Walltime now; [totTimeUtil now:&now];
    // Right after we get the current time, start the timer, so that we
    // can refresh the time button in time. Stop the timer when we save the
    // entry to database or we cancel the card.
    [timer_ startWithInternalInSeconds:60];
    
    // Inserts hour/minute button.
    hour_button = [UIButton buttonWithType:UIButtonTypeCustom];
    // Sets hour/minute.
    [hour_button setFrame:CGRectMake(55, 30, 60, 30)];
    [hour_button setTitleColor:[UIColor colorWithRed:128.0/255 green:130.0/255 blue:130.0/255 alpha:1.0]
                      forState:UIControlStateNormal];
    [hour_button setTitle:[NSString stringWithFormat:@"%02d:%02d", now.hour, now.minute]
                 forState:UIControlStateNormal];
    [hour_button.titleLabel setFont:[UIFont fontWithName:@"Raleway" size:13]];
    [hour_button setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:hour_button];
    
    // Inserts year/month/day button.
    year_button = [UIButton buttonWithType:UIButtonTypeCustom];
    // Sets year/month/day.
    [year_button setFrame:CGRectMake(95, 30, 100, 30)];
    [year_button setTitleColor:[UIColor colorWithRed:128.0/255 green:130.0/255 blue:130.0/255 alpha:1.0]
                      forState:UIControlStateNormal];
    [year_button setTitle:[NSString stringWithFormat:@"%02d/%02d/%04d", now.month, now.day, now.year]
                 forState:UIControlStateNormal];
    [year_button.titleLabel setFont:[UIFont fontWithName:@"Raleway" size:13]];
    [year_button setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:year_button];
}

- (void)setConfirmAndCancelButtons:(int)y {
    //confirm_button = [UIButton buttonWithType:UIButtonTypeCustom];
    //confirm_button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    //confirm_button.contentVerticalAlignment = UIControlContentHorizontalAlignmentFill;
    //[confirm_button setFrame:CGRectMake(260, y, 30, 30)];
    //[confirm_button setImage:[UIImage imageNamed:@"card_confirm"] forState:UIControlStateNormal];
    //[self.view addSubview:confirm_button];

    //cancel_button = [UIButton buttonWithType:UIButtonTypeCustom];
    //[cancel_button setImage:[UIImage imageNamed:@"card_cancel"] forState:UIControlStateNormal];
    //[cancel_button setFrame:CGRectMake(280, y, 30, 30)];
    //[self.view addSubview:cancel_button];
}

- (bool) clickOnConfirmIconButton {
    if ([self clickOnConfirmIconButtonDelegate]) {
        [timer_ stop];
        return true;
    }
    return false;
}

- (bool) clickOnConfirmIconButtonDelegate { return true; }

//
// ---------- Time ----------------
//
- (NSString*) getTimestampInString {
    NSArray* comp1   = [hour_button.titleLabel.text componentsSeparatedByString:@":"];
    NSString* hour   = [comp1 objectAtIndex:0];
    NSString* minute = [comp1 objectAtIndex:1];
    
    NSArray* comp2   = [year_button.titleLabel.text componentsSeparatedByString:@"/"];
    NSString* month  = [comp2 objectAtIndex:0];
    NSString* day    = [comp2 objectAtIndex:1];
    NSString* year   = [comp2 objectAtIndex:2];
    
    NSString* timestamp = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:%s", year, month, day, hour, minute, "00"];
    return timestamp;
}

# pragma totTimer delegate
- (void)timerCallback:(totTimer *)timer {
    Walltime now; [totTimeUtil now:&now];
    [hour_button setTitle:[NSString stringWithFormat:@"%02d:%02d", now.hour, now.minute]
                 forState:UIControlStateNormal];
    [year_button setTitle:[NSString stringWithFormat:@"%02d/%02d/%04d", now.month, now.day, now.year]
                 forState:UIControlStateNormal];
}

- (void)dealloc {
    [super dealloc];
    [cancel_button release];
    [confirm_button release];
    [hour_button release];
    [year_button release];
    [timer_ stop];
}

@end




@implementation totReviewShowCardView

@synthesize parentView;
@synthesize timeline;
@synthesize card_title;
@synthesize description;

- (id) init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void) viewDidLoad {
    [self setBackground];
    
    [self setTitle:@""];
    
    description = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 260, 60)];
    description.text = @"description";
    description.layer.borderWidth = 1;
    description.layer.borderColor = [UIColor grayColor].CGColor;
    [self.view addSubview:description];
}

- (void) setCalendar:(int)days {
    // Calendar.
    UIImageView* calendar_icon = [[UIImageView alloc] initWithFrame:CGRectMake(250, 0, 45, 50)];
    calendar_icon.image = [UIImage imageNamed:@"calendar.png"];
    [self.view addSubview:calendar_icon];
    [calendar_icon release];
    
    UILabel* label_day = [[UILabel alloc] initWithFrame:CGRectMake(253, 26, 40, 20)];
    label_day.textAlignment = NSTextAlignmentCenter;
    [label_day setText:[NSString stringWithFormat:@"%d", days]];
    [label_day setTextColor:[UIColor colorWithRed:136/255.0 green:212/255.0 blue:173/255.0 alpha:1.0f]];
    [label_day setFont:[UIFont fontWithName:@"Raleway-SemiBold" size:16]];
    [label_day setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:label_day];
    [label_day release];
}

- (void) setIcon:(NSString*)icon_name {
    // Icon.
    UIImageView* icon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
    icon.image = [UIImage imageNamed:icon_name];
    [self.view addSubview:icon];
    [icon release];
}

- (void) setTitle:(NSString *)desc {
    card_title = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 150, 30)];
    [card_title setText:desc];
    [card_title setBackgroundColor:[UIColor clearColor]];
    [card_title setTextColor:[UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1.0f]];
    [card_title setFont:[UIFont fontWithName:@"Raleway-SemiBold" size:20]];
    [self.view addSubview:card_title];
    
    // since this function will always be called, add the line here.
    UIImageView* line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_line"]];
    line.frame = CGRectMake(0, 60, [totSummaryCard width], line.frame.size.height);
    [self.view addSubview:line];
}

- (void) setTimestamp:(NSString*)time {
    UIButton* time_button = [UIButton buttonWithType:UIButtonTypeCustom];

    // Sets hour/minute.
    [time_button setFrame:CGRectMake(64, 30, 120, 30)];
    [time_button setTitleColor:[UIColor colorWithRed:128.0/255 green:130.0/255 blue:130.0/255 alpha:1.0]
                       forState:UIControlStateNormal];
    [time_button setTitle:time forState:UIControlStateNormal];
    [time_button.titleLabel setFont:[UIFont fontWithName:@"Raleway" size:15]];
    [time_button setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:time_button];
}

- (void) setBackground {
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void) dealloc {
    [super dealloc];
    [card_title release];
    [description release];
}

@end




// ----------------- totReviewCardView -------------------
@implementation totReviewCardView

@synthesize mEditView;
@synthesize mShowView;
@synthesize parent;
@synthesize associated_delete_button;

// Gesture delegates
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    UIViewController* vc = (mMode==EDIT)?self.mEditView:self.mShowView;
    UIView* v = [vc.view hitTest:[gestureRecognizer locationInView:vc.view ] withEvent:nil];
    NSLog(@"%@", v.class);
    // add this condition to avoid moving the view while scrolling the height picker
    if( v.class == self.mEditView.class || v.class == self.mShowView.class || v.class == nil )
        return YES;
    else
        return NO;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void) performAnimation: (bool)deleted {
    [UIView beginAnimations:@"review_card_animation" context:&deleted];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    if (!deleted) {
        self.frame = CGRectMake(origin_x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    } else {
        self.frame = CGRectMake(self.frame.size.width / 2, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    }
    [UIView commitAnimations];
}

- (void) handlePan:(UIGestureRecognizer*) gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:UIPanGestureRecognizer.class]) {
        UIPanGestureRecognizer* pan = (UIPanGestureRecognizer*)gestureRecognizer;
        CGPoint pos = [pan translationInView:self];
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
            touch_x = pos.x;
            touch_y = pos.y;
        } else {
            if ( fabs(pos.y - touch_y) * 4 > fabs(pos.x - touch_x) )
                return;
            float new_x = self.frame.origin.x + (pos.x - touch_x);
            self.frame = CGRectMake(new_x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
            touch_x = pos.x;
            touch_y = pos.y;
        }
        if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
            printf("%f %f\n", self.frame.origin.x, self.frame.size.width);
            if (self.frame.origin.x > self.frame.size.width / 2) {
                [self performAnimation:YES];
            } else {
                [self performAnimation:NO];
            }
        }
    }
}

- (void) registerGestures {
    // Register pan gesture recognizers.
    UIPanGestureRecognizer* pan =
        [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [pan setDelegate:self];
    [self addGestureRecognizer:pan];
    [pan release];
    
    touch_x = -1.0f;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) { mEditView = nil; mShowView = nil; }
    return self;
}

// Loads existing card.
- (id)initWithType:(ReviewCardType)type andData:(NSString*)data timeline:(totTimeline*)timeline {
    // Don't forget to register gesture recognizer.
    return nil;
}

// Creates empty card.
// Default is edit card.
- (id)initWithType:(ReviewCardType)type timeline:(totTimeline*)timeline {
    origin_x = GAP_BETWEEN_CARDS;
    self = [super initWithFrame:[totReviewCardView getEditCardSizeOfType:type]];
    if (self) {
        totReviewEditCardView* c1 = nil;
        totReviewShowCardView* c2 = nil;
        switch (type) {
            case TEST:
            {
                c1 = [[totTestEditCard alloc] init];
                c2 = [[totTestShowCard alloc] init];
                break;
            }
            case SUMMARY:
            {
                totSummaryCard* c = [[totSummaryCard alloc] init];
                c.timeline = timeline;
                c.view.frame = self.frame;
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
            c1.view.frame = self.bounds;
            c2.view.frame = [totReviewCardView getShowCardSizeOfType:type];
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
        CGRect f = CGRectMake(self.frame.origin.x, self.frame.origin.y, mShowView.view.frame.size.width, mShowView.view.frame.size.height);
        self.frame = f;
        mShowView.view.frame = self.bounds;
    } else {
        mMode = EDIT;
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
        [mShowView.view removeFromSuperview];
        [self addSubview:mEditView.view];
        // Change the frame size.
        CGRect f = CGRectMake(self.frame.origin.x, self.frame.origin.y, mEditView.view.frame.size.width, mEditView.view.frame.size.height);
        self.frame = f;
        mEditView.view.frame = self.bounds;
    }
    // Need refresh the whole timeline view.
    [self.parent refreshView];
    [UIView commitAnimations];
}

// Static methods.
// Different type of cards may need different size.
+ (CGRect) getEditCardSizeOfType:(ReviewCardType)type {
    int w = 310, h = 100;
    if (type == SUMMARY) {
        w = [totSummaryCard width];
        h = [totSummaryCard height];
    } else if (type == HEIGHT||type == WEIGHT||type == HEAD) {
        w = [totHeightEditCard width];
        h = [totHeightEditCard height];
    } else if (type == DIAPER) {
        w = [totDiaperEditCard width];
        h = [totDiaperEditCard height];
    } else if (type == LANGUAGE) {
        w = [totLanguageEditCard width];
        h = [totLanguageEditCard height];
    } else if (type == SLEEP) {
        w = [totSleepEditCard width];
        h = [totSleepEditCard height];
    } else if (type == FEEDING) {
        w = [totFeedEditCard width];
        h = [totFeedEditCard height];
    } else {
        printf("please add size info to getEditCardSizeOfType\n");
        exit(-1);
    }
    return CGRectMake(0, 0, w, h);
}

+ (CGRect) getShowCardSizeOfType:(ReviewCardType)type {
    int w = 310, h = 100;
    if (type == SUMMARY) {
        w = [totSummaryCard width];
        h = [totSummaryCard height];
    } else if (type == HEIGHT||type == WEIGHT||type == HEAD) {
        w = [totHeightShowCard width];
        h = [totHeightShowCard height];
    } else if (type == DIAPER) {
        w = [totDiaperShowCard width];
        h = [totDiaperShowCard height];
    } else if (type == LANGUAGE) {
        w = [totLanguageShowCard width];
        h = [totLanguageShowCard height];
    } else if (type == SLEEP) {
        w = [totSleepShowCard width];
        h = [totSleepShowCard height];
    } else if (type == FEEDING) {
        w = [totFeedShowCard width];
        h = [totFeedShowCard height];
    } else {
        printf("please add size info to getShowCardSizeOfType\n");
        exit(-1);
    }
    return CGRectMake(0, 0, w, h);
}

+ (totReviewCardView*) createEmptyCard:(ReviewCardType)type timeline:(totTimeline*)timeline {
    totReviewCardView* view = [[totReviewCardView alloc] initWithType:type timeline:timeline];
    return view;
}

+ (totReviewCardView*) loadCard:(ReviewCardType)type data:(NSString*)data timeline:(totTimeline*)timeline {
    totReviewCardView* view = [[totReviewCardView alloc] initWithType:type andData:data timeline:timeline];
    return view;
}

@end
