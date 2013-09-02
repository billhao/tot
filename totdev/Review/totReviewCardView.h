//
//  totReviewCardView.h
//  totdev
//
//  Created by Lixing Huang on 6/29/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Global.h"
#import "totEventName.h"

// Each card will have an icon, they should share the same position info.
#define CARD_ICON_X 5
#define CARD_ICON_Y 5
#define CARD_ICON_W 40
#define CARD_ICON_H 40

#define TIME1_X 50
#define TIME2_X 150
#define TIME1_W 80
#define TIME2_W 100
#define TIME_H 40
#define TIME_Y 5

@class totReviewCardView;

// ---------------- Card in editting mode --------------------
@interface totReviewEditCardView : UIViewController {
    totReviewCardView* parentView;
}

@property (nonatomic, assign) totReviewCardView* parentView;

- (void) setBackground;

@end

// ---------------- Card in displaying mode ------------------
@interface totReviewShowCardView : UIViewController {
    totReviewCardView* parentView;
    UILabel* title;
    UILabel* description;
}

@property (nonatomic, assign) totReviewCardView* parentView;

- (void) setBackground;

@end

// ---------------- Review card ------------------------------
@class totTimeline;

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
    SUMMARY  = 7,
} ReviewCardType;

@interface totReviewCardView : UIView <UIGestureRecognizerDelegate> {
    totReviewEditCardView* mEditView;
    totReviewShowCardView* mShowView;
    ReviewCardMode mMode;
    totTimeline* parent;  // the parent view, don't take ownership.
    UIButton* associated_delete_button;  // the delete button associated with this card, don't take ownership.
    
    // pan gesture related
    float touch_x;
    float touch_y;
    float origin_x;  // used to recover the position.
}

@property (nonatomic, retain) totReviewEditCardView* mEditView;
@property (nonatomic, retain) totReviewShowCardView* mShowView;
@property (nonatomic, assign) totTimeline* parent;
@property (nonatomic, assign) UIButton* associated_delete_button;

- (void) flip;

+ (totReviewCardView*) createEmptyCard:(ReviewCardType)type;
+ (totReviewCardView*) loadCard:(ReviewCardType)type data:(NSString*)data;

@end
