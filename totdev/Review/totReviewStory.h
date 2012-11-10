//
//  totReviewStory.h
//  totdev
//
//  Created by Lixing Huang on 6/2/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface totReviewStory : NSObject {
    int mBabyId;
    int mEventId;
    NSString * mEventType;
    NSDate   * mWhen;
    NSMutableDictionary * mContent;
    NSString * mComment;
    NSString * mRawContent;
}

- (id) init;
- (int) storyViewHeight;
- (BOOL) isVisibleStory;

@property (nonatomic, retain) NSString * mEventType;
@property (nonatomic, retain) NSDate * mWhen;
@property (nonatomic, retain) NSMutableDictionary * mContent;
@property (nonatomic, retain) NSString * mComment;
@property (nonatomic, retain) NSString * mRawContent;
@property (nonatomic, assign) int mBabyId;
@property (nonatomic, assign) int mEventId;

@end
