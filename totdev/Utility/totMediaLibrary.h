//
//  totMediaLibrary.h
//  totdev
//
//  Created by Hao Wang on 8/3/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MediaInfo : NSObject

@property long mediaID;
@property long eventID;
@property(retain) NSDate* dateTimeTaken;
@property(retain) NSString* filename;

- (id)initWithJSON:(NSString*)jsonData;

@end


@interface totMediaLibrary : NSObject {
    int pid;
}

@property(nonatomic, retain) MediaInfo* currentMediaInfo;

- (MediaInfo*)getNewestPhoto;
- (void)next;
- (void)previous;

// save a photo or video event to db as an activity
+ (MediaInfo*)addPhoto:(NSString*)filepath dateTimeTaken:(NSDate*)dateTimeTaken;
+ (MediaInfo*)addPhoto:(MediaInfo*)mediaInfo;

+ (NSString*)getMediaDirectory;
+ (NSString*)getMediaPath:(NSString*)filename;
+ (void)checkMediaDirectory;

@end
