//
//  totSleepCard.h
//  totdev
//
//  Created by Lixing Huang on 8/11/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import "totReviewCardView.h"
#import <UIKit/UIKit.h>
#import "totTimeUtil.h"

@interface totSleepEditCard : totReviewEditCardView<totTimerDelegate> {
    UIButton* start_button;
    UIButton* stop_button;

    NSDate* startSleepTime; // save the timestamp when start sleep
}

@end



@interface totSleepShowCard : totReviewShowCardView {
}

@property(nonatomic, retain) totEvent* sleepStartEvent;

+ (NSString*)formatValue:(NSDate*)d1 d2:(NSDate*)d2;

@end


