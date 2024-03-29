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
#import "totUtility.h"

@implementation MediaInfo

@synthesize assetURL, activities;

- (id)init {
    self = [super init];
    if (self) {
        self.activities = [[[NSMutableArray alloc] init] autorelease];
    }
    return self;
}

- (id)initWithEvent:(totEvent*)event {
    self = [super init];
    if (self) {
        NSString* jsonData = event.value;
        NSMutableDictionary* obj = (NSMutableDictionary*)[totUtility JSONToObject:jsonData];
        self.filename = [obj objectForKey:@"filename"];
        NSString* assetURLStr = [obj objectForKey:@"assetURL"];
        if( assetURLStr )
            assetURL = [[[NSURL alloc] initWithString:assetURLStr] autorelease];
        self.dateTimeTaken = event.datetime; // [totEvent dateFromString:[obj objectForKey:@"datetime_taken"]];
        self.activities = [obj objectForKey:@"activities"];
        if( !activities )
            activities = [[NSMutableArray alloc] init];
        self.activities = activities;
    }
    return self;
}

-(void)dealloc {
    [assetURL release];
    assetURL = nil;
    
    [activities release];
    activities = nil;
    
    [super dealloc];
}

// save this media info to db
- (void)save {
    // add a record to db
    NSMutableDictionary* imageData = [[NSMutableDictionary alloc] init];
    [imageData setValue:self.filename forKey:@"filename"];
    [imageData setValue:[self.assetURL absoluteString] forKey:@"assetURL"];
    [imageData setValue:[totEvent formatTime:self.dateTimeTaken] forKey:@"datetime_taken"];
    [imageData setValue:self.activities forKey:@"activities"];

    NSString* activityName = [NSString stringWithFormat:ACTIVITY_PHOTO_REPLACABLE, self.filename];
    [global.model setItem:global.baby.babyID name:activityName value:imageData];
    
    [imageData release];
}

// datetime is nil for default media
+ (MediaInfo*)getDefault {
    MediaInfo* m = [[MediaInfo alloc] init];
    m.assetURL = nil;
    m.filename = @"home_bg";
    m.dateTimeTaken = nil;
    m.activities = [[NSMutableArray alloc] init];
    return m;
}

// datetime is nil for default media
- (BOOL)isDefault {
    return self.dateTimeTaken == nil;
}

@end


@implementation totMediaLibrary

- (id)init {
    self = [super init];
    if (self) {
        pid = 1;
        // get the last photo or the default photo
        MediaInfo* m = [global.user getLastViewedPhoto];
        if( m == nil )
            self.currentMediaInfo = [MediaInfo getDefault];
        else
            self.currentMediaInfo = m;
    }
    return self;
}

- (MediaInfo*)getNewestPhoto {
    return nil;
}

- (BOOL)next {
    NSDate* dt;
    if (self.currentMediaInfo == nil)
        dt = [NSDate date];
    else
        dt = self.currentMediaInfo.dateTimeTaken;
    MediaInfo* info = [self getNextMedia:FALSE datetime:dt];
    if( info ) {
        self.currentMediaInfo = info;
        return TRUE;
    }
    else {
        // go back to first photo if enabled
        dt = [NSDate dateWithTimeIntervalSince1970:0];
        MediaInfo* info = [self getNextMedia:FALSE datetime:dt];
        if( info ) {
            self.currentMediaInfo = info;
            return TRUE;
        }
        else
            return FALSE;
    }
}

- (BOOL)previous {
    NSDate* dt;
    if (self.currentMediaInfo == nil)
        dt = [NSDate date];
    else
        dt = self.currentMediaInfo.dateTimeTaken;
    MediaInfo* info = [self getNextMedia:TRUE datetime:dt];
    if( info ) {
        self.currentMediaInfo = info;
        return TRUE;
    }
    else {
        // go back to last photo if enabled
        dt = [NSDate date];
        MediaInfo* info = [self getNextMedia:TRUE datetime:dt];
        if( info ) {
            self.currentMediaInfo = info;
            return TRUE;
        }
        return FALSE;
    }
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
    [imageData release];
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
        // TODO release???
        totEvent* event = [events objectAtIndex:0];
        MediaInfo* mediaInfo = [[[MediaInfo alloc] initWithEvent:event] autorelease];
        mediaInfo.eventID = event.event_id;
//        mediaInfo.eventName = [NSString stringWithString:event.name];
        return mediaInfo;
    }
    return nil;
}

+ (MediaInfo*)getMediaFromEvent:(totEvent*)event {
        // TODO release???
    MediaInfo* mediaInfo = [[[MediaInfo alloc] initWithEvent:event] autorelease];
    mediaInfo.eventID = event.event_id;
    return mediaInfo;
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
