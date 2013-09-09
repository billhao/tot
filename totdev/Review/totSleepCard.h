//
//  totSleepCard.h
//  totdev
//
//  Created by Lixing Huang on 8/11/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import "totReviewCardView.h"
#import <UIKit/UIKit.h>

@interface totSleepEditCard : totReviewEditCardView {
    UIButton* start_button;
    UIButton* stop_button;
}

@end



@interface totSleepShowCard : totReviewShowCardView {
    totEvent* sleepStartEvent;
}

+ (NSString*)formatValue:(NSDate*)d1 d2:(NSDate*)d2;

@end


