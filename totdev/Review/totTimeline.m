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
    }
    return self;
}

- (void) addCard:(totReviewCardView*)card {
    // Need change the position of the card so that it appears at the bottom of the timeline.
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
