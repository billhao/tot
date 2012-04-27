//
//  totEvent.h
//  totdev
//
//  Created by Hao on 4/22/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface totEvent : NSObject {
    int      event_id;
    int      baby_id;
    NSDate   *datetime;
    NSString *name;
    NSString *value;
}

@property (nonatomic) int      event_id;
@property (nonatomic) int      baby_id;
@property (nonatomic, retain) NSDate   *datetime;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *value;

// return datetime of the event in string
-(NSString*) getTimeText;

// set datetime from a string
-(NSDate*) setTimeFromText:(NSString*)dt;

// return the event as a string
-(NSString*) toString;

@end
