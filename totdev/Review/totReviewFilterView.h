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

@interface totReviewFilterView : UIView {
    float mPrevTouchY;
    float mCurrTouchY;
    float mBeginTouchY;
    int mStatus;
}

@end
