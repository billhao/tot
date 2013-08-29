//
//  totTimeline.m
//  totdev
//
//  Created by Lixing Huang on 6/29/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import "totTimeline.h"

#define INIT_HEIGHT 1000

@implementation totTimeline

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentSize = CGSizeMake(320, INIT_HEIGHT);
        mCards = [[NSMutableArray alloc] init];
        [self setBackground];
    }
    return self;
}

// Change the background of the timeline
- (void) setBackground {
    [self setBackgroundColor:[UIColor colorWithRed:0.7f green:0.7f blue:0.7f alpha:1.0f]];
}

- (void) addEmptyCard:(ReviewCardType)type {
    totReviewCardView* card = [totReviewCardView createEmptyCard:type];
    card.parent = self;
    [mCards addObject:card];
    [card release];
    [self addSubview:[mCards lastObject]];
    [self refreshView];
    [self addDeleteButtonUnderCard:[mCards lastObject]];
}

- (void) addCard:(ReviewCardType)type data:(NSString*)data {
    totReviewCardView* card = [totReviewCardView loadCard:type data:data];
    card.parent = self;
    [mCards addObject:card];
    [card release];
    [self addSubview:[mCards lastObject]];
    [self refreshView];
    [self addDeleteButtonUnderCard:[mCards lastObject]];
}


- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    totReviewCardView* cv = (totReviewCardView*)context;
    [cv.associated_delete_button removeFromSuperview];
    //[cv.associated_delete_button release];
    [self deleteCard:cv];
}

- (void) handleDeleteButton: (id)button {
    printf("Click delete button\n");
    UIButton* btn = (UIButton*)button;
    int y = btn.frame.origin.y;
    for (int i = 0; i < [mCards count]; ++i) {
        totReviewCardView* cv = [mCards objectAtIndex:i];
        if (cv.associated_delete_button == btn) {
            // Found the right card by comparing its position with the delete button.
            [UIView beginAnimations:@"delete_card" context:cv];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:1.0];
            [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
                cv.frame = CGRectMake(320, cv.frame.origin.y, cv.frame.size.width, cv.frame.size.height);
            [UIView commitAnimations];
        }
    }
}

- (void) addDeleteButtonUnderCard: (totReviewCardView*)card {
    int x = card.frame.size.width / 4;
    int y = card.frame.origin.y;
    UIButton* delete_button = [[UIButton alloc] initWithFrame:CGRectMake(x, y, 40, 40)];
    delete_button.backgroundColor = [UIColor redColor];
    [delete_button addTarget:self
                      action:@selector(handleDeleteButton:)
            forControlEvents:UIControlEventTouchUpInside];
    [self insertSubview:delete_button belowSubview:card];
    card.associated_delete_button = delete_button;
    [delete_button release];
}

- (void) refreshView {
    int x = 0;
    int y = GAP_BETWEEN_CARDS;  // start from the top.
    for (int i = 0; i < [mCards count]; ++i) {
        totReviewCardView* cv = [mCards objectAtIndex:i];
        x = (320 - cv.frame.size.width) / 2;
        cv.frame = CGRectMake(x, y, cv.frame.size.width, cv.frame.size.height);
        cv.associated_delete_button.frame =
            CGRectMake(cv.associated_delete_button.frame.origin.x,
                       y,
                       cv.associated_delete_button.frame.size.width,
                       cv.associated_delete_button.frame.size.height);
        y = y + cv.frame.size.height + GAP_BETWEEN_CARDS;
        if (y >= self.contentSize.height) {
            self.contentSize = CGSizeMake(320, y);
        }
    }
}

- (void) moveToTop:(totReviewCardView *)card {
    float card_y = card.frame.origin.y;
    float view_y = self.contentOffset.y;
    [self setContentOffset:CGPointMake(0, card_y) animated:YES];
}

- (void) moveCard:(totReviewCardView *)card To:(int)index {
    for (int i = 0; i < [mCards count]; ++i) {
        totReviewCardView* cv = [mCards objectAtIndex:i];
        if (cv == card) {
            [mCards removeObjectAtIndex:i];
            [mCards insertObject:cv atIndex:index];
            break;
        }
    }
    [self refreshView];
}

- (void) deleteCard:(totReviewCardView *)card {
    for (int i = 0; i < [mCards count]; ++i) {
        totReviewCardView* cv = [mCards objectAtIndex:i];
        if (cv == card) {  // Find the to be deleted card.
            [cv removeFromSuperview];
            [mCards removeObjectAtIndex:i];
            break;
        }
    }
    [self refreshView];
}

- (void)dealloc {
    [super dealloc];
    [mCards release];
}

@end