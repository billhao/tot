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
    NSDate* now = [NSDate date];
    NSDateFormatter* date_formatter = [[NSDateFormatter alloc] init];
    [date_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSArray* tokens = [[date_formatter stringFromDate:now] componentsSeparatedByString:@" "];
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

@end
