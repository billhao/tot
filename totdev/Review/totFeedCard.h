//
//  totFeedCard.h
//  totdev
//
//  Created by Lixing Huang on 8/11/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "totReviewCardView.h"
#import "totQuantityController.h"

@interface totFeedEditCard : totReviewEditCardView<UITextFieldDelegate, totQuantityControllerDelegate> {
    UIButton* addBtn;
    totQuantityController* mQuantity;
    UITextField* currentEditingQuantityTextField;
    
    NSMutableArray* foodBoxes;
    NSMutableArray* quanBoxes;
    NSMutableArray* unitBoxes;
    NSMutableArray* inputViews;
    
    float w1;
    float w2;
//    float w3;
    float margin_x;
    
    float x, y, w, h;
}

@end


@interface totFeedShowCard : totReviewShowCardView {

}

+ (NSString*)formatValue:(NSString*)value;

@end

