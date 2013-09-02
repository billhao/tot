//
//  totLanguageCard.h
//  totdev
//
//  Created by Lixing Huang on 8/11/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "totReviewCardView.h"

@interface totLanguageEditCard : totReviewEditCardView {
    UITextView* new_words_input;
}

+ (int) height;
+ (int) width;

@end


@interface totLanguageShowCard : totReviewShowCardView {}

+ (int) height;
+ (int) width;

@end

