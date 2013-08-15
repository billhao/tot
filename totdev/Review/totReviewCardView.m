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


@implementation totReviewEditCardView

@synthesize parentView;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackground];
    }
    return self;
}

- (void) setBackground {
    self.backgroundColor = [UIColor whiteColor];
}

@end

@implementation totReviewShowCardView

@synthesize parentView;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackground];
    }
    return self;
}

- (void) setBackground {
    self.backgroundColor = [UIColor whiteColor];
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
    return YES;
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

- (void) deleteSelf: (totReviewCardView*)card {
    [self.parent deleteCard:card];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) { mEditView = nil; mShowView = nil; }
    return self;
}

// Loads existing card.
- (id)initWithType:(ReviewCardType)type andData:(NSString*)data {
    // Don't forget to register gesture recognizer.
    return nil;
}

// Creates empty card.
// Default is edit card.
- (id)initWithType:(ReviewCardType)type {
    origin_x = GAP_BETWEEN_CARDS;
    self = [super initWithFrame:[totReviewCardView getEditCardSizeOfType:type]];
    if (self) {
        switch (type) {
            case TEST:
            {
                totTestEditCard* c1 = [[totTestEditCard alloc] initWithFrame:self.frame];
                totTestShowCard* c2 = [[totTestShowCard alloc] initWithFrame:[totReviewCardView getShowCardSizeOfType:type]];
                self.mEditView = c1;
                self.mShowView = c2;
                self.mEditView.parentView = self;
                self.mShowView.parentView = self;
                [c1 release];
                [c2 release];
                break;
            }
            case SUMMARY:
            {
                totSummaryCard* c = [[totSummaryCard alloc] initWithFrame:self.frame];
                self.mShowView = c;
                self.mShowView.parentView = self;
                [c release];
                break;
            }
            case HEIGHT:
            {
                totHeightEditCard* c1 = [[totHeightEditCard alloc] initWithFrame:self.frame];
                totHeightShowCard* c2 = [[totHeightShowCard alloc] initWithFrame:[totReviewCardView getShowCardSizeOfType:type]];
                self.mEditView = c1;
                self.mShowView = c2;
                self.mEditView.parentView = self;
                self.mShowView.parentView = self;
                [c1 release];
                [c2 release];
                break;
            }
            case DIAPER:
            {
                totDiaperEditCard* c1 = [[totDiaperEditCard alloc] initWithFrame:self.frame];
                totDiaperShowCard* c2 = [[totDiaperShowCard alloc] initWithFrame:[totReviewCardView getShowCardSizeOfType:type]];
                self.mEditView = c1;
                self.mShowView = c2;
                self.mEditView.parentView = self;
                self.mShowView.parentView = self;
                [c1 release];
                [c2 release];
                break;
            }
            default:
                break;
        }
        // When creating a new card, the default view is editting view.
        // except for summary card.
        if (type == SUMMARY) {
            [self addSubview:self.mShowView];
            mMode = SHOW;
        } else {
            [self addSubview:self.mEditView];
            mMode = EDIT;
        }
        // Register gesture recognizer.
        [self registerGestures];
    }
    return self;
}

- (void) flip {
    // TODO(lxhuang) we should hide the delete button when the animation starts, and display it again after
    // the animation finishes.
    [UIView beginAnimations:@"Flip" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    if (mMode == EDIT) {
        mMode = SHOW;
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self cache:YES];
        [mEditView removeFromSuperview];
        [self addSubview:mShowView];
        // Change the frame size.
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, mShowView.frame.size.width, mShowView.frame.size.height);
    } else {
        mMode = EDIT;
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
        [mShowView removeFromSuperview];
        [self addSubview:mEditView];
        // Change the frame size.
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, mEditView.frame.size.width, mEditView.frame.size.height);
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
    } else if (type == HEIGHT) {
        w = [totHeightEditCard width];
        h = [totHeightEditCard height];
    } else if (type == DIAPER) {
        w = [totDiaperEditCard width];
        h = [totDiaperEditCard height];
    }
    return CGRectMake(0, 0, w, h);
}

+ (CGRect) getShowCardSizeOfType:(ReviewCardType)type {
    int w = 310, h = 100;
    if (type == SUMMARY) {
        w = [totSummaryCard width];
        h = [totSummaryCard height];
    } else if (type == HEIGHT) {
        w = [totHeightShowCard width];
        h = [totHeightShowCard height];
    } else if (type == DIAPER) {
        w = [totDiaperShowCard width];
        h = [totDiaperShowCard height];
    }
    return CGRectMake(0, 0, w, h);
}

+ (totReviewCardView*) createEmptyCard:(ReviewCardType)type {
    totReviewCardView* view = [[totReviewCardView alloc] initWithType:type];
    return view;
}

+ (totReviewCardView*) loadCard:(ReviewCardType)type data:(NSString*)data {
    totReviewCardView* view = [[totReviewCardView alloc] initWithType:type andData:data];
    return view;
}

@end
