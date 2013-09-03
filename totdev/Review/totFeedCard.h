//
//  totFeedCard.h
//  totdev
//
//  Created by Lixing Huang on 8/11/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "totReviewCardView.h"

@interface totFeedEditCard : totReviewEditCardView<UITextFieldDelegate> {
    UIButton* addBtn;
    
    NSMutableArray* foodBoxes;
    NSMutableArray* quanBoxes;
    NSMutableArray* unitBoxes;
    NSMutableArray* inputViews;
    
    float x;
    float y;
    float w1;
    float w2;
    float w3;
    float h;
    float margin_x;
    float margin_y;
}

+ (int) height;
+ (int) width;

@end


@interface totFeedShowCard : totReviewShowCardView {

}

+ (int) height;
+ (int) width;

@end

