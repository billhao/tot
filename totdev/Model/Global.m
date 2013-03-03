//
//  Global.m
//  totdev
//
//  Created by Hao Wang on 1/3/13.
//  Copyright (c) 2013 USC. All rights reserved.
//

#import "Global.h"

@implementation Global

@synthesize model, baby, user;

Global* global = nil;

// override
- (id)init {
    NSLog(@"global init");
    if( self = [super init] ) {
        // create model
        self.model = [[[totModel alloc] init] autorelease];

        // add reference to db
        [totUser setModel:model];
        [totBaby setModel:model];

        // create baby and user
        self.baby = nil;
        self.user = nil;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"dealloc");
    self.baby = nil;
    self.user = nil;
    [super dealloc];
}

@end
