//
//  totDiaperCard.h
//  totdev
//
//  Created by Lixing Huang on 8/11/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "totReviewCardView.h"
#import "totImageView.h"

@class totImageView;

@interface totDiaperEditCard : totReviewEditCardView<totImageViewDelegate> {

    enum Selection {
        SELECTION_WET = 1,
        SELECTION_SOILED = 2,
        SELECTION_WETSOILED = 3,
    };

    totImageView* wet;
    totImageView* soiled;
    totImageView* wet_soiled;
    UIImageView * mSelectedIcon;
    
    UIButton* confirm_button;
    UIButton* cancel_button;

    int mDiaperType;
    
    // position of first selection item
    float x;
    float y;
    float w;
    float h;
    float margin_y;
}

+ (int) height;
+ (int) width;

@end


@interface totDiaperShowCard : totReviewShowCardView {
    UILabel* age_in_days_label;
    UILabel* diaper_status_label; // could be wet, solid and web&solid.
    UILabel* timestamp_label;
    //UILabel* description;
}

+ (int) height;
+ (int) width;

@end

