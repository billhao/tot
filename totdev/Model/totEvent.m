//
//  totEvent.m
//  totdev
//
//  Created by Hao on 4/22/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totEvent.h"
#import <time.h>
#import <xlocale.h>

@implementation totEvent

@synthesize event_id, baby_id, name, value, datetime;

-(NSString*) getTimeText {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //[dateFormatter setDateStyle:NSDateFormatterShortStyle];
    //[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
    NSString *formattedDateString = [dateFormatter stringFromDate:datetime];
    //NSLog(@"formattedDateString: %@", formattedDateString);
    
    [dateFormatter release];
    
    return formattedDateString;
}

+(NSString*) formatTime:(NSDate*)datetime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *formattedDateString = [dateFormatter stringFromDate:datetime];
    [dateFormatter release];
    
    return formattedDateString;
}

+(NSDate*) dateFromString:(NSString*)datetime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [dateFormatter dateFromString:datetime];
    [dateFormatter release];
    
    return date;
}

-(NSDate*) setTimeFromText:(NSString*)dt {
    struct tm  t;
    const char *formatString = "%Y-%m-%d %H:%M:%S";
    strptime_l([dt UTF8String], formatString, &t, NULL);
    datetime = [NSDate dateWithTimeIntervalSince1970: mktime(&t)];
    return datetime;
}

-(NSString*) toString {
    return [NSString stringWithFormat:@"%d\t%d\t%@\t%@\t%@", event_id, baby_id, [self getTimeText], name, value];
}

-(void)dealloc {
    //[datetime release];
    [name release];
    [value release];
}

@end
