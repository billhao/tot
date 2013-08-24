//
//  totSummaryCard.h
//  totdev
//
//  Created by Lixing Huang on 8/11/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "totReviewCardView.h"

@interface totSummaryCard : totReviewShowCardView {
    UIImageView* icon_baby;
    UIImageView* icon_height;
    UIImageView* icon_weight;
    UIImageView* icon_hc;
    UIImageView* icon_feed;
    UIImageView* icon_sleep;
    UIImageView* icon_diaper;
    UIImageView* icon_language;
    
    UILabel* label_babyName;
    UILabel* label_life_in_days;
    UILabel* label_height;
    UILabel* label_weight;
    UILabel* label_hc;
    UILabel* label_feed;
    UILabel* label_diaper;
    UILabel* label_sleep;
    UILabel* label_language;
}

+ (int) height;
+ (int) width;

@end
