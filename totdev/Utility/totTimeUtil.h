//
//  totTimeUtil.h
//  totdev
//
//  Created by Lixing Huang on 8/12/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
    int year, month, day, hour, minute, second;
} Walltime;

@interface totTimeUtil : NSObject

+ (void) now: (Walltime*)wall_time;

@end
