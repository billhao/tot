//
//  totHeightCard.h
//  totdev
//
//  Created by Lixing Huang on 8/11/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "totReviewCardView.h"
#import "STHorizontalPicker.h"

@interface totHeightEditCard : totReviewEditCardView <STHorizontalPickerDelegate> {
    STHorizontalPicker* picker;
    UILabel* selectedValueLabel;
    UIButton* confirm_button;
    UIButton* cancel_button;
    UIImageView* bgview;
}

@property(nonatomic, assign, readonly) ReviewCardType type; // height, weight or HC
@property(nonatomic, readonly, getter=getWidth)  int width;
@property(nonatomic, readonly, getter=getHeight) int height;

+ (int) width;
+ (int) height;

- (id)init:(ReviewCardType)cardType;

@end



@interface totHeightShowCard : totReviewShowCardView {

}

@property(nonatomic, assign, readonly) ReviewCardType type; // height, weight or HC

+ (int) height;
+ (int) width;

- (id) init:(ReviewCardType)cardType;

@end

