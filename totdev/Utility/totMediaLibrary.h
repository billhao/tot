//
//  totMediaLibrary.h
//  totdev
//
//  Created by Hao Wang on 8/3/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import <Foundation/Foundation.h>

@class totEvent;

@interface MediaInfo : NSObject

@property long mediaID;
@property long eventID;
@property(nonatomic, retain) NSDate* dateTimeTaken;
@property(nonatomic, retain) NSString* filename;
@property(nonatomic, retain) NSURL* assetURL;
@property(nonatomic, retain) NSMutableArray* activities;

- (id)initWithEvent:(totEvent*)event;
- (void)save;
- (BOOL)isDefault; // if the current media is default photo for home page

// get default photo for home page
+ (MediaInfo*)getDefault;

@end


@interface totMediaLibrary : NSObject {
    int pid;
}

@property(nonatomic, retain) MediaInfo* currentMediaInfo;

- (MediaInfo*)getNewestPhoto;
- (BOOL)next;
- (BOOL)previous;

// save a photo or video event to db as an activity
+ (MediaInfo*)addPhoto:(NSString*)filepath dateTimeTaken:(NSDate*)dateTimeTaken;
+ (MediaInfo*)addPhoto:(MediaInfo*)mediaInfo;

+ (MediaInfo*)getMediaFromEvent:(totEvent*)event;
+ (NSString*)getMediaDirectory;
+ (NSString*)getMediaPath:(NSString*)filename;
+ (void)checkMediaDirectory;

@end
