//
//  totReviewCardView.m
//  totdev
//
//  Created by Lixing Huang on 6/29/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import "totReviewCardView.h"
#import "totTestCard.h"
#import "totSummaryCard.h"

@implementation totReviewEditCardView

@synthesize parentView;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {}
    return self;
}

@end

@implementation totReviewShowCardView

@synthesize parentView;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {}
    return self;
}

@end


// ----------------- totReviewCardView -------------------
@implementation totReviewCardView

@synthesize mEditView;
@synthesize mShowView;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) { mEditView = nil; mShowView = nil; }
    return self;
}

// Loads existing card.
- (id)initWithType:(ReviewCardType)type andData:(NSString*)data {
    return nil;
}

// Creates empty card.
- (id)initWithType:(ReviewCardType)type {
    CGRect frame = [totReviewCardView getSizeOfType:type];
    self = [super initWithFrame:frame];
    if (self) {
        switch (type) {
            case TEST:
            {
                totTestEditCard* c1 = [[totTestEditCard alloc] initWithFrame:self.frame];
                totTestShowCard* c2 = [[totTestShowCard alloc] initWithFrame:self.frame];
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
    }
    return self;
}

- (void) flip {
    [UIView beginAnimations:@"Flip" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    if (mMode == EDIT) {
        mMode = SHOW;
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self cache:YES];
        [mEditView removeFromSuperview];
        [self addSubview:mShowView];
    } else {
        mMode = EDIT;
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
        [mShowView removeFromSuperview];
        [self addSubview:mEditView];
    }
    [UIView commitAnimations];
}

// Static methods.
// Different type of cards may need different size.
+ (CGRect) getSizeOfType:(ReviewCardType)type {
    int w, h;
    if (type == SUMMARY) {
        w = [totSummaryCard width];
        h = [totSummaryCard height];
        return CGRectMake((320 - w) / 2, 0, w, h);
    } else {
        return CGRectMake(0, 0, 320, 100);
    }
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
