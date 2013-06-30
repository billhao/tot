//
//  totReviewCardView.h
//  totdev
//
//  Created by Lixing Huang on 6/29/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import <UIKit/UIKit.h>

@class totReviewCardView;

// ---------------- Card in editting mode --------------------
@interface totReviewEditCardView : UIView {
    totReviewCardView* parentView;
}

@property (nonatomic, assign) totReviewCardView* parentView;

@end

// ---------------- Card in displaying mode ------------------
@interface totReviewShowCardView : UIView {
    totReviewCardView* parentView;
}

@property (nonatomic, assign) totReviewCardView* parentView;

@end

// ---------------- Review card ------------------------------
typedef enum {
    EDIT = 0,
    SHOW = 1,
} ReviewCardMode;

typedef enum {
    TEST     = -1,
    HEIGHT   = 0,
    WEIGHT   = 1,
    HEAD     = 2,
    FEEDING  = 3,
    DIAPER   = 4,
    SLEEP    = 5,
    LANGUAGE = 6,
} ReviewCardType;

@interface totReviewCardView : UIView {
    totReviewEditCardView* mEditView;
    totReviewShowCardView* mShowView;
    ReviewCardMode mMode;
}

@property (nonatomic, retain) totReviewEditCardView* mEditView;
@property (nonatomic, retain) totReviewShowCardView* mShowView;

- (void) flip;

+ (totReviewCardView*) createEmptyCard:(ReviewCardType)type;
+ (totReviewCardView*) loadCard:(ReviewCardType)type data:(NSString*)data;

@end
