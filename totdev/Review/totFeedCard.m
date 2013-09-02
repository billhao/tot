//
//  totFeedCard.m
//  totdev
//
//  Created by Lixing Huang on 8/11/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import "totFeedCard.h"
#import "totReviewCardView.h"
#import "totTimeUtil.h"

@implementation totFeedEditCard

+ (int) height { return 200; }
+ (int) width { return 308; }

- (id)init {
    self = [super init];
    if (self) {
        [self setBackground];
        [self setIcon:@"food_gray.png" withCalendarDays:1000];
        [self setTitle:@"Breakfast"];
        [self setTimestamp];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end


@implementation totFeedShowCard

+ (int) height { return 200; }
+ (int) width { return 308; }

- (id)init {
    self = [super init];
    if (self) {
        [self setBackground];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end

