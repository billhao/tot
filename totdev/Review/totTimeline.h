//
//  totTimeline.h
//  totdev
//
//  Created by Lixing Huang on 6/29/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import "totReviewCardView.h"
#import <UIKit/UIKit.h>

@interface totTimeline : UIScrollView {
    NSMutableArray* mCards;
    
    int gapBetweenCards;
}

- (void) setBackground;

- (void) addEmptyCard:(ReviewCardType)type;
- (void) addCard:(ReviewCardType)type data:(NSString*)data;

@end
