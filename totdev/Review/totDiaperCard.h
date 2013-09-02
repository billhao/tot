//
//  totDiaperCard.h
//  totdev
//
//  Created by Lixing Huang on 8/11/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "totReviewCardView.h"

@class totImageView;

@interface totDiaperEditCard : totReviewEditCardView {
    totImageView* wet;
    totImageView* solid;
    totImageView* wet_solid;
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

