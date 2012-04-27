//
//  test_Model.m
//  totdev
//
//  Created by Hao on 4/26/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "test_Model.h"
#import "totModel.h"
#import "totEvent.h"

@implementation test_Model

-(void) test_Model {
    totModel *model = [[totModel alloc] init];
    [model resetDB];
    [model addEvent:0 event:@"emotion/sadness" datetime:@"2011-10-1 6:05:0" value:@"file path" ];
    
    NSString* event = [[NSString alloc] initWithString:@"emotion"];
    NSMutableArray *events = [model getEvent:0 event:event];
    for (totEvent* e in events) {
        NSLog(@"Return from db: %@", [e toString]);        
    }
    [event release];
    [events release];
    [model release];
}

@end