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

@interface totTimeline : UIScrollView {
    NSMutableArray* mCards;
}

- (void) setBackground;

- (void) addEmptyCard:(ReviewCardType)type;
- (void) addCard:(ReviewCardType)type data:(NSString*)data;

- (void) deleteCard:(totReviewCardView*)card;

- (void) refreshView;

@end
