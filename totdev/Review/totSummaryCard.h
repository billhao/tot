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
    NSMutableArray* physicalLabels;
    
    UILabel* label_babyName;
    UILabel* label_babyAge;
}

+ (int) height;
+ (int) width;

@end
