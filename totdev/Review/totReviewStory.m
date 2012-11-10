//
//  totReviewStory.m
//  totdev
//
//  Created by Lixing Huang on 6/2/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totReviewStory.h"

#define TABLE_CELL_DEFAULT_HEIGHT 100

@implementation totReviewStory

@synthesize mEventType;
@synthesize mWhen;
@synthesize mContent;
@synthesize mComment;
@synthesize mRawContent;
@synthesize mBabyId;
@synthesize mEventId;

- (id) init {
    self = [super init];
    if (self) {}
    return self;
}

- (BOOL) isVisibleStory {
    NSArray * categories = [NSArray arrayWithObjects:@"basic", @"feeding", @"eye_contact",
                            @"vision_attention", @"chew", @"mirror_test", @"imitation",
                            @"motor_skill", @"emotion", @"gesture",
                            nil];
    BOOL visible = NO;
    NSArray * tokens = [mEventType componentsSeparatedByString:@"/"];
    printf("%s ", [mEventType UTF8String]);
    for (int i = 0; i < [tokens count]; ++i) {
        printf("%s ", [[tokens objectAtIndex:i] UTF8String]);
    }
    
    NSString * category = [tokens objectAtIndex:0];
    if ([categories containsObject:category]) {
        //if ([category isEqualToString:@"basic"]) {
        //    NSString * subcategory = [tokens objectAtIndex:1];
        //    if ([subcategory isEqualToString:@"sleep"]) {
        //        if ([mRawContent isEqualToString:@"start"]) {
        //            printf("invisible\n");
        //            return visible;
        //        }
        //    }
        //}
        visible = YES;
        printf("visible\n");
    } else {
        printf("invisible\n");
    }
    return visible;
}

- (int) storyViewHeight {
    int cellHeight = TABLE_CELL_DEFAULT_HEIGHT;
    return cellHeight;
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
