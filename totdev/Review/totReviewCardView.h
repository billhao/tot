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
#import "totTimeUtil.h"
#import "totUtility.h"

@class totTimeline;
@class totReviewCardView;
@class totReviewStory;

// ---------------- Card in editting mode --------------------
@interface totReviewEditCardView : UIViewController <totTimerDelegate> {
    totReviewCardView* parentView;
    
    UIButton* hour_button;  // hour/minute
    UIButton* year_button;  // year/month/day
    
    UIButton* confirm_button;  // want to deprecate these two buttons.
    UIButton* cancel_button;

    UIButton* icon_unconfirmed_button;    // use icon as the button to confirm.
    UIButton* icon_confirmed_button;  // confirmed!
    
    totTimer* timer_;
    float contentYOffset; // y offset of real content in a card
    float margin_y; // margin on y axis from y offset
    
    UIImageView* line;
}

@property (nonatomic, assign) totReviewCardView* parentView;
@property (nonatomic, retain) totTimeline* timeline;

- (void) setBackground;
- (void) setIcon:(NSString*)icon_name;
- (void) setIcon:(NSString*)icon_name confirmedIcon:(NSString*)confirmed_icon_name;
- (void) setCalendar:(int)days;
- (void) setTimestamp;  // use the current time.
- (void) setTitle:(NSString *)desc;

- (bool) clickOnConfirmIconButtonDelegate;
- (NSString*) getTimestampInString;

- (int) height;
- (int) width;

@end

// ---------------- Card in displaying mode ------------------
@interface totReviewShowCardView : UIViewController {
    totReviewCardView* parentView;
    
    UILabel* card_title;
    UILabel* description;
    UILabel* timestamp;
    UIImageView* calendar_icon_;
    UILabel* calendar_text_;
    
    totReviewStory* story_;
    totEvent* e;
    
    UIImageView* line;
}

@property (nonatomic, assign) totReviewCardView* parentView;
@property (nonatomic, retain) totTimeline* timeline;
@property (nonatomic, readonly) UILabel* card_title;
@property (nonatomic, readonly) UILabel* description;
@property (nonatomic, retain) totReviewStory* story_;
@property (nonatomic, retain) totEvent* e;


- (void) setBackground;
- (void) setIcon:(NSString*)icon_name;
- (void) setTimestamp:(NSString*)time;
- (void) setCalendar:(int)days;

- (int) height;
- (int) width;

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
    DIAPER   = 3,
    LANGUAGE = 4,
    SLEEP    = 5,
    FEEDING  = 6,
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
    float origin_x;  // used to recover the position of the view when we finish the animation.
}

@property (nonatomic, retain) totReviewEditCardView* mEditView;
@property (nonatomic, retain) totReviewShowCardView* mShowView;
@property (nonatomic, assign) totTimeline* parent;
@property (nonatomic, assign) UIButton* associated_delete_button;
@property (nonatomic, readonly) ReviewCardMode mMode;

- (void) flip;

// caller needs to take ownership.
+ (totReviewCardView*) createEmptyCard:(ReviewCardType)type timeline:(totTimeline*)timeline;
// caller needs to take ownership.
+ (totReviewCardView*) loadCard:(NSString*)type story:(totReviewStory*)story timeline:(totTimeline*)timeline;

@end
