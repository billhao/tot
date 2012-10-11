//
//  totReviewStory.m
//  totdev
//
//  Created by Lixing Huang on 6/2/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totReviewStory.h"

@implementation totReviewStory

@synthesize mEventType;
@synthesize mWhen;
@synthesize mContent;
@synthesize mComment;
@synthesize mRawContent;
@synthesize mBabyId;

- (id) init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void) dealloc {
    [mEventType release];
    [mWhen release];
    [mContent release];
    [mComment release];
    [mRawContent release];
    [super dealloc];
}

@end
