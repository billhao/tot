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
        
        // initialize constants
        gapBetweenCards = 5;
    }
    return self;
}

// Change the background of the timeline
- (void) setBackground {
    [self setBackgroundColor:[UIColor colorWithRed:0.7f green:0.7f blue:0.7f alpha:1.0f]];
}

- (void) addCard:(totReviewCardView*)card {
    int h = 0;
    
    for (int i = 1; i < [mCards count]; ++i) {
        totReviewCardView* cv = [mCards objectAtIndex:i - 1];
        h = h + cv.frame.size.height + gapBetweenCards;
    }
    
    // change the position of the card so that it appears at the bottom.
    card.frame = CGRectMake(0, (h == 0 ? gapBetweenCards : h), card.frame.size.width, card.frame.size.height);
    
    [self addSubview:card];
}

- (void) addEmptyCard:(ReviewCardType)type {
    totReviewCardView* card = [totReviewCardView createEmptyCard:type];
    [mCards addObject:card];
    [card release];
    [self addCard:[mCards lastObject]];
}

- (void) addCard:(ReviewCardType)type data:(NSString*)data {
    totReviewCardView* card = [totReviewCardView loadCard:type data:data];
    [mCards addObject:card];
    [card release];
    [self addCard:[mCards lastObject]];
}

- (void)dealloc {
    [super dealloc];
    [mCards release];
}

@end
