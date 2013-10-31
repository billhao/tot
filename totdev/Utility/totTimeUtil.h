//
//  totTimeUtil.h
//  totdev
//
//  Created by Lixing Huang on 8/12/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import <Foundation/Foundation.h>

//
// ----------------- tot Time Utility ---------------------
//
typedef struct {
    int year, month, day, hour, minute, second;
} Walltime;

@interface totTimeUtil : NSObject

+ (void) now: (Walltime*)wall_time;
+ (NSString*) getTimeDescriptionFromNow : (NSDate*)event_time;

+(NSString*) getTimeString:(NSDate*)datetime;
+(NSString*) getDateString:(NSDate*)datetime;

@end



//
// ------------------ tot Timer ---------------------------
//
@class totTimer;
@protocol totTimerDelegate <NSObject>

@optional
- (void) timerCallback: (totTimer*)timer;

@end

@interface totTimer : NSObject {
    NSTimer* timer_;
    id<totTimerDelegate> delegate;
}

@property (nonatomic, assign) id<totTimerDelegate> delegate;

- (void) startWithInternalInSeconds: (int)interval;
- (void) stop;
- (void) timerHandler:(NSTimer*)timer;

@end
