//
//  totReviewStory.m
//  totdev
//
//  Created by Lixing Huang on 6/2/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totReviewStory.h"

@implementation totReviewStory

@synthesize who;
@synthesize type;
@synthesize when;
@synthesize content;
@synthesize comment;
@synthesize height;

- (id) init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void) dealloc {
    [who release];
    [when release];
    [type release];
    [content release];
    [comment release];
    [super dealloc];
}

@end
