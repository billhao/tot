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

@implementation totReviewEditCardView

@synthesize parentView;

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [self setBackground];
}

- (void) setBackground {
    self.view.backgroundColor = [UIColor whiteColor];
}

@end

@implementation totReviewShowCardView

@synthesize parentView;

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [self setBackground];

    title = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 260, 60)];
    title.text = @"title";
    title.layer.borderWidth = 1;
    title.layer.borderColor = [UIColor grayColor].CGColor;
    [self.view addSubview:title];
    
    description = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 260, 60)];
    description.text = @"description";
    description.layer.borderWidth = 1;
    description.layer.borderColor = [UIColor grayColor].CGColor;
    [self.view addSubview:description];
}

- (void) setBackground {
    self.view.backgroundColor = [UIColor whiteColor];
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
