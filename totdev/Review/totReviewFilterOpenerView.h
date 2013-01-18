//
//  totReviewFilterView.h
//  totdev
//
//  Created by Lixing Huang on 1/10/13.
//  Copyright (c) 2013 USC. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FOLD       0
#define EXPANDED   1

@class totReviewFilterView;

@interface totReviewFilterOpenerView : UIView {
    totReviewFilterView *filter;
    float mPrevTouchY;
    float mCurrTouchY;
    float mBeginTouchY;
    int mStatus;
}

- (void) fold;
- (void) expand;

@property (atomic, retain) totReviewFilterView* filter;

@end
