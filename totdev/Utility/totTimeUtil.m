//
//  totTimeUtil.m
//  totdev
//
//  Created by Lixing Huang on 8/12/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import "totTimeUtil.h"

@implementation totTimeUtil

+ (void) now: (Walltime*)wall_time {
    return [self getDateTimeString:[NSDate date] wall_time:wall_time];
}

+ (void)getDateTimeString:(NSDate*)date wall_time:(Walltime*)wall_time {
    NSDateFormatter* date_formatter = [[NSDateFormatter alloc] init];
    [date_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSArray* tokens = [[date_formatter stringFromDate:date] componentsSeparatedByString:@" "];
    NSArray* part1 = [[tokens objectAtIndex:0] componentsSeparatedByString:@"-"];
    NSArray* part2 = [[tokens objectAtIndex:1] componentsSeparatedByString:@":"];
    
    assert([part1 count] == 3);
    assert([part2 count] == 3);
    
    NSNumberFormatter* number_formatter = [[NSNumberFormatter alloc] init];
    [number_formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    wall_time->year = [[number_formatter numberFromString:[part1 objectAtIndex:0]] intValue];
    wall_time->month = [[number_formatter numberFromString:[part1 objectAtIndex:1]] intValue];
    wall_time->day = [[number_formatter numberFromString:[part1 objectAtIndex:2]] intValue];
    wall_time->hour = [[number_formatter numberFromString:[part2 objectAtIndex:0]] intValue];
    wall_time->minute = [[number_formatter numberFromString:[part2 objectAtIndex:1]] intValue];
    wall_time->second = [[number_formatter numberFromString:[part2 objectAtIndex:2]] intValue];
}

+ (NSString*) getTimeDescriptionFromNow : (NSDate*)event_time {
    NSString * time_desc = nil;
    NSDate * curr_time = [NSDate date];

    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
    [date_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    NSNumberFormatter * number_formatter = [[NSNumberFormatter alloc] init];
    [number_formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    // current time
    NSArray* tokens = [[date_formatter stringFromDate:curr_time] componentsSeparatedByString:@" "];
    NSArray* comps1 = [[tokens objectAtIndex:0] componentsSeparatedByString:@"-"];
    NSArray* comps2 = [[tokens objectAtIndex:1] componentsSeparatedByString:@":"];
    
    int current_year  = [[number_formatter numberFromString:[comps1 objectAtIndex:0]] intValue];
    int current_month = [[number_formatter numberFromString:[comps1 objectAtIndex:1]] intValue];
    int current_day   = [[number_formatter numberFromString:[comps1 objectAtIndex:2]] intValue];
    int current_hour  = [[number_formatter numberFromString:[comps2 objectAtIndex:0]] intValue];
    int current_minute= [[number_formatter numberFromString:[comps2 objectAtIndex:1]] intValue];
    int current_second= [[number_formatter numberFromString:[comps2 objectAtIndex:2]] intValue];
    
    // event time
    tokens = [[date_formatter stringFromDate:event_time] componentsSeparatedByString:@" "];
    comps1 = [[tokens objectAtIndex:0] componentsSeparatedByString:@"-"];
    comps2 = [[tokens objectAtIndex:1] componentsSeparatedByString:@":"];
    
    int event_year  = [[number_formatter numberFromString:[comps1 objectAtIndex:0]] intValue];
    int event_month = [[number_formatter numberFromString:[comps1 objectAtIndex:1]] intValue];
    int event_day   = [[number_formatter numberFromString:[comps1 objectAtIndex:2]] intValue];
    int event_hour  = [[number_formatter numberFromString:[comps2 objectAtIndex:0]] intValue];
    int event_minute= [[number_formatter numberFromString:[comps2 objectAtIndex:1]] intValue];
    int event_second= [[number_formatter numberFromString:[comps2 objectAtIndex:2]] intValue];
    
    // construct the time description
    if (current_year == event_year && current_month == event_month && current_day == event_day) {
        if (current_hour == event_hour && current_minute == event_minute) {
            int second_diff = current_second - event_second;
            if (second_diff == 1)
                time_desc = [NSString stringWithFormat:NSLocalizedString(@"1 second ago", @"")];
            else
                time_desc = [NSString stringWithFormat:@"%d %@", second_diff, NSLocalizedString(@"seconds ago", @"")];
        } else if (current_hour == event_hour) {
            int minute_diff = current_minute - event_minute;
            if (minute_diff == 1)
                time_desc = [NSString stringWithFormat:NSLocalizedString(@"1 minute ago", @"")];
            else
                time_desc = [NSString stringWithFormat:@"%d %@", minute_diff, NSLocalizedString(@"minutes ago", @"")];
        } else {
            int hour_diff = current_hour - event_hour;
            if (hour_diff == 1)
                time_desc = [NSString stringWithFormat:NSLocalizedString(@"1 hour ago", @"")];
            else
                time_desc = [NSString stringWithFormat:@"%d %@", hour_diff, NSLocalizedString(@"hours ago", @"")];
        }
    } else if (current_year == event_year && current_month == event_month) {
        int day_diff = current_day - event_day;
        if (day_diff == 1)
            time_desc = [NSString stringWithFormat:NSLocalizedString(@"about 1 day ago", @"")];
        else
            time_desc = [NSString stringWithFormat:@"%d %@", day_diff, NSLocalizedString(@"days ago", @"")];
    } else {
        time_desc = [NSString stringWithString:[date_formatter stringFromDate:event_time]];
    }
    
    [number_formatter release];
    [date_formatter release];
    
    return time_desc;
}

+(NSString*) getTimeString:(NSDate*)datetime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSString *formattedDateString = [dateFormatter stringFromDate:datetime];
    formattedDateString = [formattedDateString lowercaseString];
    [dateFormatter release];
    
    return formattedDateString;
}

+(NSString*) getDateString:(NSDate*)datetime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    
    NSString *formattedDateString = [dateFormatter stringFromDate:datetime];
    [dateFormatter release];
    
    return formattedDateString;
}

@end



@implementation totTimer

@synthesize delegate;

- (void) startWithInternalInSeconds: (int)interval {
    if (!timer_) {
        timer_ = [NSTimer scheduledTimerWithTimeInterval:interval
                                                  target:self
                                                selector:@selector(timerHandler:)
                                                userInfo:nil
                                                 repeats:YES];
    }
}

- (void) stop {
    if (timer_) {
        [timer_ invalidate];
        timer_ = nil;
    }
}

- (void) timerHandler:(NSTimer*)timer {
    if (delegate && [delegate respondsToSelector:@selector(timerCallback:)]) {
        [delegate timerCallback:self];
    }
}

@end
