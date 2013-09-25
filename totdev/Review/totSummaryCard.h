//
//  totSummaryCard.h
//  totdev
//
//  Created by Lixing Huang on 8/11/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "totReviewCardView.h"
#import "totCameraViewController.h"
#import "totImageView.h"

@interface totSummaryCard : totReviewShowCardView <CameraViewDelegate> {
    UIImageView* icon_baby;
    NSMutableArray* physicalLabels;
    NSMutableArray* physicalButtons;
    
    UILabel* label_babyName;
    UILabel* label_babyAge;
    UIImageView* sexImgView;
    
    UIView* headView;
    totImageView* headImg;
}

- (void) updateLabel:(ReviewCardType)type withValue:(NSString*)value;

@end
