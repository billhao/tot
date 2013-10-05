//
//  totTimeline.h
//  totdev
//
//  Created by Lixing Huang on 6/29/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import "totReviewCardView.h"
#import <UIKit/UIKit.h>
#import "totTimerController.h"
#import "totTimelineController.h"
#import "totTimerController.h"

#define GAP_BETWEEN_CARDS 5

@interface totTimeline : UIScrollView <UIScrollViewDelegate, totTimerDelegate> {
    NSMutableArray* mCards;
    
    totTimer* timer;
    
    totEvent* lastLoadedEvent; // keep the last loaded event because some events may not be parsed/loaded as a card. need to skip those events
}

@property (assign, atomic) totTimelineController* controller;
@property (assign, atomic) BOOL sleeping; // if the baby is sleeping
@property (nonatomic, retain) totReviewCardView* summaryCard;

- (void) setBackground;

// Adds edit card of the specified type.
- (totReviewCardView*) addEmptyCard:(ReviewCardType)type;

// Deletes the review card.
- (void) deleteCard:(totReviewCardView*)card;

// Re-adjust the size of each card.
- (void) refreshView;

// Moves the card to the top of the screen.
- (void) moveToTop:(totReviewCardView*)card;

// Changes the position of the card.
- (void) moveCard:(totReviewCardView*)card To:(int)index;

// Load cards from db and append to timeline
- (void) loadCardsNumber:(int)limit;

// load cards that are newer than the first event in timeline and insert to the front of the line
- (void) refreshNewCards;

// Update the value of the specified type in summary card.
- (void) updateSummaryCard:(ReviewCardType)type withValue:(NSString*)value;

- (int)getSummaryCardIndex;
- (int)getEditCardIndex;
- (totReviewCardView*)getSleepCard;

@end
