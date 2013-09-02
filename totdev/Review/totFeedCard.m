//
//  totFeedCard.m
//  totdev
//
//  Created by Lixing Huang on 8/11/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import "totFeedCard.h"

@implementation totFeedEditCard

+ (int) height { return 200; }
+ (int) width { return 310; }

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

- (void)setIcons {
    
}

@end


@implementation totFeedShowCard

+ (int) height { return 200; }
+ (int) width { return 310; }

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

