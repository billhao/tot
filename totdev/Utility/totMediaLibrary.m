//
//  totMediaLibrary.m
//  totdev
//
//  Created by Hao Wang on 8/3/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import "totMediaLibrary.h"
#import "Global.h"
#import "totEventName.h"
#import "totHomeFeedingViewController.h"

@implementation MediaInfo
- (id)initWithJSON:(NSString*)jsonData {
    self = [super init];
    if (self) {
        NSMutableDictionary* obj = (NSMutableDictionary*)[totHomeFeedingViewController JSONToObject:jsonData];
        self.filename = [obj objectForKey:@"filename"];
        self.dateTimeTaken = [totEvent dateFromString:[obj objectForKey:@"datetime_taken"]];
    }
    return self;
}
@end


@implementation totMediaLibrary

- (id)init {
    self = [super init];
    if (self) {
        pid = 1;
    }
    return self;
}

- (MediaInfo*)getNewestPhoto {
    return nil;
}

- (void)next {
    NSDate* dt;
    if (self.currentMediaInfo == nil)
        dt = [NSDate date];
    else
        dt = self.currentMediaInfo.dateTimeTaken;
    self.currentMediaInfo = [self getNextMedia:FALSE datetime:dt];
}

- (void)previous {
    NSDate* dt;
    if (self.currentMediaInfo == nil)
        dt = [NSDate date];
    else
        dt = self.currentMediaInfo.dateTimeTaken;
    self.currentMediaInfo = [self getNextMedia:TRUE datetime:dt];
}


+ (MediaInfo*)addPhoto:(NSString*)filepath dateTimeTaken:(NSDate*)dateTimeTaken {
    return nil;
}

+ (MediaInfo*)addPhoto:(MediaInfo*)mediaInfo {
    // add a record to db
    NSMutableDictionary* imageData = [[NSMutableDictionary alloc] init];
    [imageData setValue:mediaInfo.filename forKey:@"filename"];
    [imageData setValue:[totEvent formatTime:mediaInfo.dateTimeTaken] forKey:@"datetime_taken"];
    NSString* activityName = [NSString stringWithFormat:ACTIVITY_PHOTO_REPLACABLE, mediaInfo.filename];
    [global.model setItem:global.baby.babyID name:activityName value:imageData];
    return mediaInfo;
}


// get next (newer) image if previous is false. get previous (older) image if true.
- (MediaInfo*)getNextMedia:(BOOL)previous datetime:(NSDate*)datetime {
    NSArray* events;
    if( previous ) {
        events = [global.model getEvent:global.baby.babyID event:ACTIVITY_PHOTO limit:1 offset:-1 startDate:nil endDate:datetime orderByDesc:TRUE];
    }
    else {
        events = [global.model getEvent:global.baby.babyID event:ACTIVITY_PHOTO limit:1 offset:-1 startDate:datetime endDate:nil orderByDesc:FALSE];
    }
    if( events.count > 0 ) {
        // release???
        totEvent* event = [events objectAtIndex:0];
        MediaInfo* mediaInfo = [[[MediaInfo alloc] initWithJSON:event.value] autorelease];
        mediaInfo.eventID = event.event_id;
        return mediaInfo;
    }
    return nil;
}

#pragma mark - Utility functions for media directory
+ (NSString*)getMediaDirectory {
    NSString* doc = [totModel GetDocumentDirectory];
    return [doc stringByAppendingPathComponent:@"Media"];
}

+ (NSString*)getMediaPath:(NSString*)filename {
    return [[totMediaLibrary getMediaDirectory] stringByAppendingPathComponent:filename];
}

+ (void)checkMediaDirectory {
    NSString *mediaDir = [totMediaLibrary getMediaDirectory];
    if (![[NSFileManager defaultManager] fileExistsAtPath:mediaDir]) {
        NSError* error = nil;
        if( ![[NSFileManager defaultManager] createDirectoryAtPath:mediaDir withIntermediateDirectories:NO attributes:nil error:&error] ) {
            NSLog(@"Cannot create media directory: %d %@", error.code, error.description);
        }
    }
}


@end
