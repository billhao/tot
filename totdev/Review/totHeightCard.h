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
    STHorizontalPicker* picker_height;
    
    UIButton* confirm;
    UIButton* cancel;
}

+ (int) height;
+ (int) width;

@end



@interface totHeightShowCard : totReviewShowCardView {

}

+ (int) height;
+ (int) width;

@end

