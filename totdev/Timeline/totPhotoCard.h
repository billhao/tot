//
//  totLanguageCard.h
//  totdev
//
//  Created by Lixing Huang on 8/11/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "totReviewCardView.h"
#import "totMediaLibrary.h"
#import "totImageView.h"

@interface totPhotoShowCard : totReviewShowCardView {
    totImageView* mPhotoView;
    UIView* activityView;
    
    float margin_x;
    float margin_y;
}

@property (nonatomic, retain) MediaInfo* mediaInfo;

@end

