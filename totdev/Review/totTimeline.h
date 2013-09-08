//
//  totTimeline.h
//  totdev
//
//  Created by Lixing Huang on 6/29/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import "totReviewCardView.h"
#import <UIKit/UIKit.h>

#define GAP_BETWEEN_CARDS 5

@class totTimelineController;

@interface totTimeline : UIScrollView <UIScrollViewDelegate> {
    NSMutableArray* mCards;
    totTimelineController* controller;
}

@property (assign, atomic) totTimelineController* controller;

- (void) setBackground;

- (void) addEmptyCard:(ReviewCardType)type;
- (void) addCard:(ReviewCardType)type data:(NSString*)data;

// Deletes the review card.
- (void) deleteCard:(totReviewCardView*)card;

- (void) refreshView;

// Moves the card to the top of the screen.
- (void) moveToTop:(totReviewCardView*)card;

// Changes the position of the card.
- (void) moveCard:(totReviewCardView*)card To:(int)index;

// Load cards from db.
- (void) loadCardsNumber:(int)limit startFrom:(int)start;

@end
