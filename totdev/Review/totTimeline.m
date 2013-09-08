//
//  totTimeline.m
//  totdev
//
//  Created by Lixing Huang on 6/29/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import "totTimeline.h"
#import "totReviewStory.h"
#import "Global.h"
#import "totTimelineController.h"

#define INIT_HEIGHT 1000

@implementation totTimeline

@synthesize controller;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentSize = CGSizeMake(320, INIT_HEIGHT);
        mCards = [[NSMutableArray alloc] init];
        [self setBackground];
        [self setDelegate:self];
    }
    return self;
}

// Change the background of the timeline
- (void) setBackground {
    [self setBackgroundColor:[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0f]];
}

- (void) addEmptyCard:(ReviewCardType)type {
    totReviewCardView* card = [totReviewCardView createEmptyCard:type timeline:self];
    card.parent = self;
    if ([mCards count] > 0) {
        [mCards insertObject:card atIndex:1];  // new card is always under the summary card.
    } else {
        [mCards addObject:card];
    }
    [self addSubview:card];
    [self refreshView];
    [self addDeleteButtonUnderCard:card];
    [card release];
}

- (void) addCard:(ReviewCardType)type data:(NSString*)data {
    totReviewCardView* card = [totReviewCardView loadCard:type data:data timeline:self];
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
    [self setContentOffset:CGPointMake(0, card_y-4) animated:YES];
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

- (void) loadCardsNumber:(int)limit startFrom:(int)start {
    NSArray * events = nil;
    
    events = [global.model getEvent:global.baby.babyID limit:limit offset:start];
    
    // If no more events available
    if ([events count] == 0) {
        return;
    }
    
    for (int i = 0; i < [events count]; ++i) {
        // parse the results from db
        totReviewStory *story = [[totReviewStory alloc] init];
        
        totEvent * anEvent = (totEvent*)[events objectAtIndex:i];
        story.mEventType = anEvent.name;
        story.mRawContent = anEvent.value;
        story.mWhen = anEvent.datetime;
        story.mBabyId = anEvent.baby_id;
        story.mEventId = anEvent.event_id;
        
        // add new card.
        // change it to different type.
        totReviewCardView* card = [totReviewCardView loadCard:story.mEventType story:story timeline:self];
        if (card) {
            card.parent = self;
            [card.mShowView viewWillAppear:YES];
            [mCards addObject:card];
            [card release];
            [self addSubview:[mCards lastObject]];
            [self addDeleteButtonUnderCard:[mCards lastObject]];
        }
        
        [story release];
    }
    
    [self refreshView];
}

#pragma UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // TODO(lxhuang) add loading button and wait for a second.
    if (scrollView.contentOffset.y + 389 > scrollView.contentSize.height) {
        int cards_num = [mCards count];
        if (cards_num > 1) {
            totReviewCardView* card = [mCards objectAtIndex:1];
            cards_num--;  // don't consider the summary card
            for (int i = 1; i < [mCards count]; ++i) {
                if (((totReviewCardView*)[mCards objectAtIndex:i]).mMode == EDIT) {
                    cards_num--;
                } else {
                    break;
                }
            }
            [self.controller loadEventsFrom:cards_num limit:10];
        }
    }
}

- (void)dealloc {
    [super dealloc];
    [mCards release];
}

@end
