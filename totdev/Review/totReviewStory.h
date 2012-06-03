//
//  totReviewStory.h
//  totdev
//
//  Created by Lixing Huang on 6/2/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface totReviewStory : NSObject {
    NSString *who;
    NSString *type;
    NSDate *when;
    NSMutableDictionary *content;
    NSString *comment;
    int height;
}

- (id) init;

@property (nonatomic, retain) NSString *who;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSDate *when;
@property (nonatomic, retain) NSMutableDictionary *content;
@property (nonatomic, retain) NSString *comment;
@property (nonatomic, assign) int height;

@end
