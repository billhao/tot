//
//  totBookletTest.m
//  totdev
//
//  Created by Lixing Huang on 6/4/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import "totBookletTest.h"
#import "totBooklet.h"

@implementation totBookletTest

- (void) basicTest {
    NSError* error;
    totBook* book = [[totBook alloc] init];
    NSString* path = [[NSBundle mainBundle] pathForResource:@"test"
                                                     ofType:@"tpl"];
    [book loadFromTemplateFile:path];
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:[book toDictionary]
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *debug = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", debug);
    [book loadFromJSONString:debug];
    [debug release];
    [book release];
}

@end
