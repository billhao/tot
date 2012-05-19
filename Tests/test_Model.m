//
//  test_Model.m
//  totdev
//
//  Created by Hao on 4/26/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "AppDelegate.h"
#import "test_Model.h"
#import "totModel.h"
#import "totEvent.h"

@implementation test_Model

-(void) test_Model {
    // init a model, which sets db connection
    totModel *model = [[totModel alloc] init];
    
    // reset the db and remove all records in db for testing purpose
    [model resetDB];
    
    // add an event
    [model addEvent:0 event:@"emotion/sadness" datetimeString:@"2011-10-1 6:05:0" value:@"file path" ];
    
    // get a list of events containing "emotion"
    NSString* event = [[NSString alloc] initWithString:@"emotion"];
    // return from getEvent is an array of totEvent object
    // a totEvent represents a single event
    NSMutableArray *events = [model getEvent:0 event:event];
    for (totEvent* e in events) {
        NSLog(@"Return from db: %@", [e toString]);        
    }
    [event release];
    [model release];
}

-(BOOL) test {
    totEvent* e = [[totEvent alloc] init];
    [e setTimeFromText:@"2011-10-2 5:0:0"];
    NSLog(@"%@", [e getTimeText]);
    NSLog(@"%@", [e toString]);
    

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    totModel* model = [appDelegate getDataModel];
    // return from getEvent is an array of totEvent object
    // a totEvent represents a single event
    NSMutableArray *events = [model getEvent:0 event:@"emotion" limit:1];
    for (totEvent* e in events) {
        NSLog(@"Return from db: %@", [e toString]);        
    }

    return FALSE;
}
@end