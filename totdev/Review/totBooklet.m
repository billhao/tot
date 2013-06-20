//
//  totBookletController.m
//  totdev
//
//  Created by Lixing Huang on 5/22/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import "totBooklet.h"
#import "totHomeFeedingViewController.h"
#import "Global.h"
#import "totEventName.h"

////////////////////////////////////////////////////////////////
// totPageElement
////////////////////////////////////////////////////////////////
@implementation totPageElement

@synthesize x;
@synthesize y;
@synthesize w;
@synthesize h;
@synthesize radians;
@synthesize type;
@synthesize name;

- (id) init {
    if (self = [super init]) {
        x = y = w = h = 0;
        type = TEXT;
        radians = 0;
        resources = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (NSString*) image { return @"image"; }
+ (NSString*) video { return @"video"; }
+ (NSString*) audio { return @"audio"; }

+ (void)initPageElement:(totPageElement*)e
                      x:(float)x
                      y:(float)y
                      w:(float)w
                      h:(float)h
                      r:(float)r
                      n:(NSString*)name
                      t:(PageElementMediaType)t {
    e.x = x;
    e.y = y;
    e.w = w;
    e.h = h;
    e.radians = r;
    e.name = name;
    e.type = t;
}

- (void) addResource:(NSString *)key withPath:(NSString *)path {
    if (resources) {
        [resources setObject:path forKey:key];
    }
}

- (NSString*) getResource:(NSString *)key {
    if (resources)
        return [resources objectForKey:key];
    else
        return nil;
}

- (BOOL) isEmpty {
    return ([resources count] == 0);
}

- (NSDictionary*) toDictionary {
    NSMutableDictionary* output = [[[NSMutableDictionary alloc] init] autorelease];
    [output setObject:[NSNumber numberWithFloat:x] forKey:@"x"];
    [output setObject:[NSNumber numberWithFloat:y] forKey:@"y"];
    [output setObject:[NSNumber numberWithFloat:w] forKey:@"w"];
    [output setObject:[NSNumber numberWithFloat:h] forKey:@"h"];
    [output setObject:[NSNumber numberWithFloat:radians] forKey:@"radius"];
    [output setObject:[NSNumber numberWithInt:type] forKey:@"type"];
    if (name && [name length] > 0) {
        [output setObject:name forKey:@"name"];
    }
    if (resources && [resources count] > 0) {
        [output setObject:resources forKey:@"resources"];
    }
    return output;
}

- (float) getFloatValue: (NSString*)key fromObject:(NSDictionary*)dict {
    NSNumber* n = [dict objectForKey:key];
    if (n)
        return [n floatValue];
    else
        return 0.0f;
}

- (int) getIntValue: (NSString*)key fromObject:(NSDictionary*)dict {
    NSNumber* n = [dict objectForKey:key];
    if (n)
        return [n intValue];
    else
        return 0;
}

- (void) loadFromDictionary:(NSDictionary *)dict {
    self.x = [self getFloatValue:@"x" fromObject:dict];
    self.y = [self getFloatValue:@"y" fromObject:dict];
    self.w = [self getFloatValue:@"w" fromObject:dict];
    self.h = [self getFloatValue:@"h" fromObject:dict];
    self.radians = [self getFloatValue:@"radius" fromObject:dict];
    self.type = [self getIntValue:@"type" fromObject:dict];

    self.name = [dict objectForKey:@"name"];
    NSDictionary* res = [dict objectForKey:@"resources"];
    [resources removeAllObjects];
    if (res) {
        for (id key in res) {
            [resources setObject:[res objectForKey:key] forKey:key];
        }
    }
}

- (void) dealloc {
    [super dealloc];
    [resources release];
    [name release];
}

@end


////////////////////////////////////////////////////////////////
// totPage
////////////////////////////////////////////////////////////////
@implementation totPage

@synthesize type;
@synthesize templateFilename;
@synthesize name;

- (id) init {
    if (self = [super init]) {
        pageElements = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) dealloc {
    [super dealloc];
    [name release];
    [templateFilename release];
    [pageElements release];
}

- (int)elementCount {
    return [pageElements count];
}

- (totPageElement*) getPageElement:(NSString*)name {
    return nil;
}

- (totPageElement*) getPageElementAtIndex:(int)index {
    if (index < 0 || index >= [pageElements count])
        return nil;
    return [pageElements objectAtIndex:index];
}

// Used to load data from template description file.
- (void) addPageElement:(id)element {
    totPageElement* new_element = [[totPageElement alloc] init];
    new_element.book = self.book;
    NSDictionary* element_object = (NSDictionary*)element;
    for (id element_attr in element_object) {
        if ([element_attr isEqualToString:@"x"]) {
            NSString* x_str = [element_object objectForKey:element_attr];
            new_element.x = [x_str floatValue];
        } else if ([element_attr isEqualToString:@"y"]) {
            NSString* y_str = [element_object objectForKey:element_attr];
            new_element.y = [y_str floatValue];
        } else if ([element_attr isEqualToString:@"radius"]) {
            NSString* radius_str = [element_object objectForKey:element_attr];
            new_element.radians = [radius_str floatValue];
        } else if ([element_attr isEqualToString:@"w"]) {
            NSString* w_str = [element_object objectForKey:element_attr];
            new_element.w = [w_str floatValue];
        } else if ([element_attr isEqualToString:@"h"]) {
            NSString* h_str = [element_object objectForKey:element_attr];
            new_element.h = [h_str floatValue];
        } else if ([element_attr isEqualToString:@"type"]) {
            NSString* type_str = [element_object objectForKey:element_attr];
            if ([type_str isEqualToString:@"text"]) {
                new_element.type = TEXT;
            } else if ([type_str isEqualToString:@"image"]) {
                new_element.type = IMAGE;
            } else if ([type_str isEqualToString:@"video"]) {
                new_element.type = VIDEO;
            }
        } else if ([element_attr isEqualToString:@"name"]) {
            new_element.name = [element_object objectForKey:element_attr];
        }
    }
    [pageElements addObject:new_element];
    [new_element release];
}

- (NSDictionary*) toDictionary {
    NSMutableDictionary* output = [[[NSMutableDictionary alloc] init] autorelease];
    [output setObject:[NSNumber numberWithInt:type] forKey:@"type"];
    if (templateFilename && [templateFilename length] > 0) {
        [output setObject:templateFilename forKey:@"template"];
    }
    if (name && [name length] > 0) {
        [output setObject:name forKey:@"name"];
    }
    if (pageElements && [pageElements count] > 0) {
        NSMutableArray* elements = [[NSMutableArray alloc] init];
        for (int i = 0; i < [pageElements count]; ++i) {
            [elements addObject:[[pageElements objectAtIndex:i] toDictionary]];
        }
        [output setObject:elements forKey:@"elements"];
        [elements release];
    }
    return output;
}

- (void) loadFromDictionary:(NSDictionary *)dict {
    NSNumber* tt = [dict objectForKey:@"type"];
    if (tt) {
        self.type = [tt intValue];
    }
    
    self.templateFilename = [dict objectForKey:@"template"];
    self.name = [dict objectForKey:@"name"];

    NSArray* ee = [dict objectForKey:@"elements"];
    [pageElements removeAllObjects];
    if (ee && [ee count] > 0) {
        for (int i = 0; i < [ee count]; ++i) {
            totPageElement* e = [[totPageElement alloc] init];
            e.book = self.book;
            [e loadFromDictionary:[ee objectAtIndex:i]];
            [pageElements addObject:e];
            [e release];
        }
    }
}

//- (NSDictionary*) saveToDictionary {
//    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
//    [dict setObject:[NSNumber numberWithInt:self.type] forKey:@"type"];
//    
//    [dict setObject:self.templateFilename forKey:@"template"];
//    [dict setObject:self.name forKey:@"name"];
//    
//    NSMutableArray* pp = [[NSMutableArray alloc]init];
//    [dict setObject:pp forKey:@"elements"];
//    
//    if (pageElements) {
//        for (int i = 0; i < [pageElements count]; ++i) {
//            totPageElement* e = [pageElements objectAtIndex:i];
//            NSDictionary* element_dict = [e saveToDictionary];
//            [pp addObject:element_dict];
//        }
//    }
//    
//    [pp release];
//    return dict;
//}
@end


////////////////////////////////////////////////////////////////
// totBook
////////////////////////////////////////////////////////////////
@implementation totBook

@synthesize bookname;
@synthesize templateName;

- (id) init {
    if (self = [super init]) {
        pages = [[NSMutableArray alloc] init];
    }
    return self;
}

// Parse template description file
- (BOOL) isComment:(NSString*)line {
    if ([line length] < 2) {
        return NO;
    }
    NSString* s = [line substringToIndex:2];
    if ([s isEqualToString:@"//"]) {
        return YES;
    } else {
        return NO;
    }
}

- (void) parseTemplateJSONObject:(NSDictionary*)object {
    for (id key in object) {
        if ([key isEqualToString:@"template_name"]) {
            self.templateName = [object objectForKey:key];
        } else if ([key isEqualToString:@"pages"]) {
            // NSArray contains page objects.
            NSArray* page_json_objects = [object objectForKey:key];
            for (id page_json_object in page_json_objects) {  // Iterates through pages.
                // For each page, creates a new totPage.
                totPage* new_page = [[totPage alloc] init];
                new_page.book = self;
                for (id object_key in page_json_object) {
                    if ([object_key isEqualToString:@"template_path"]) {
                        new_page.templateFilename = [page_json_object objectForKey:object_key];
                    } else if ([object_key isEqualToString:@"meta"]) {
                        NSString* meta = [page_json_object objectForKey:object_key];
                        if ([meta isEqualToString:@"cover"]) {
                            new_page.type = COVER;
                        } else if ([meta isEqualToString:@"page"]) {
                            new_page.type = PAGE;
                        }
                    } else if ([object_key isEqualToString:@"name"]) {
                        new_page.name = [page_json_object objectForKey:object_key];
                    } else if ([object_key isEqualToString:@"elements"]) {
                        NSArray* element_json_objects = [page_json_object objectForKey:object_key];
                        for (id element_json_element in element_json_objects) {
                            [new_page addPageElement:element_json_element];
                        }
                    } else {
                        printf("Invalid key: %s\n", [object_key UTF8String]);
                    }
                }
                [pages addObject:new_page];
                [new_page release];
            }
        } else {
            printf("Invalid key: %s\n", [key UTF8String]);
        }
    }
}
// Parse template description file ends

- (void)loadFromTemplateFile:(NSString *)filename {
    NSString* content = [NSString stringWithContentsOfFile:filename
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    NSMutableString* jsonString = [[NSMutableString alloc] init];
    
    // Get rid of comments and empty lines.
    NSArray* lines = [content componentsSeparatedByString:@"\n"];
    for (int i = 0; i < [lines count]; ++i) {
        NSString* line = (NSString*)[lines objectAtIndex:i];
        line = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([line length] > 0) {
            if ([self isComment:line]) {
                continue;
            }
            [jsonString appendString:line];
        }
    }
    
    // Parse the json string.
    NSError* error = [[NSError alloc] init];
    NSDictionary* object = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                                           options:NSJSONReadingMutableContainers
                                                             error:&error];
    if (!object) {
        NSLog(@"%@", [[error userInfo] objectForKey:@"NSDebugDescription"]);
        exit(-1);
    }
    [self parseTemplateJSONObject:object];
    [error release];
    [jsonString release];
}

- (NSDictionary*)toDictionary {
    NSMutableDictionary* output = [[[NSMutableDictionary alloc] init] autorelease];
    if (bookname && [bookname length] > 0) {
        [output setObject:bookname forKey:@"bookname"];
    }
    if (templateName && [templateName length] > 0) {
        [output setObject:templateName forKey:@"template"];
    }
    if (pages && [pages count] > 0) {
        NSMutableArray* pp = [[NSMutableArray alloc] init];
        for (int i = 0; i < [pages count]; ++i) {
            [pp addObject:[[pages objectAtIndex:i] toDictionary]];
        }
        [output setObject:pp forKey:@"pages"];
        [pp release];
    }
    return output;
}

- (void)loadFromDictionary:(NSDictionary *)dict {
    self.bookname = [dict objectForKey:@"bookname"];
    self.templateName = [dict objectForKey:@"template"];

    NSArray* pp = [dict objectForKey:@"pages"];
    [pages removeAllObjects];
    if (pp && [pp count] > 0) {
        for (int i = 0; i < [pp count]; ++i) {
            totPage* p = [[totPage alloc] init];
            p.book = self;
            [p loadFromDictionary:[pp objectAtIndex:i]];
            [pages addObject:p];
            [p release];
        }
    }
}

- (void)loadFromJSONString:(NSString *)json {
    NSError* error = [[NSError alloc] init];
    NSDictionary* object = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]
                                                           options:NSJSONReadingMutableContainers
                                                             error:&error];
    if (!object) {
        NSLog(@"%@", [[error userInfo] objectForKey:@"NSDebugDescription"]);
        exit(-1);
    }
    [self loadFromDictionary:object];
    [error release];
}

//- (NSDictionary*) saveToDictionary {
//    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
//    [dict setObject:self.bookname forKey:@"bookname"];
//    [dict setObject:self.templateName  forKey:@"template"];
//    
//    NSMutableArray* pp = [[NSMutableArray alloc]init];
//    [dict setObject:pp forKey:@"pages"];
//    
//    if (pages) {
//        for (int i = 0; i < [pages count]; ++i) {
//            totPage* p = [pages objectAtIndex:i];
//            NSDictionary* page_dict = [p saveToDictionary];
//            [pp addObject:page_dict];
//        }
//    }
//    [pp release];
//    return dict;
//}

// save the book as a json string in db
- (void) saveToDB {
    NSDictionary* dict = [self toDictionary];
    NSString* bookid = [NSString stringWithFormat:SCRAPBOOK_REPLACABLE, self.bookname];
    [global.model setItem:global.baby.babyID name:bookid value:dict];
}

+ (totBook*) loadFromDB:(NSString*)bookname {
    NSString* bookid = [NSString stringWithFormat:SCRAPBOOK_REPLACABLE, bookname];
    totEvent* e = [global.model getItem:global.baby.babyID name:bookid];
    if( e == nil )
        return nil;
    
    totBook* book = [[totBook alloc]init];
    [book loadFromJSONString:e.value];
    return book;
}

- (void)loadBook:(NSString *)bookname {}

- (NSDictionary*)getPage:(NSString*)name {
    return nil;
}

//- (NSDictionary*)getPageWithIndex:(int)pageIndex {
//    if (pageIndex < 0 || pageIndex >= [pages count]) {
//        return nil;
//    }
//    return [[pages objectAtIndex:pageIndex] toDictionary];
//}

- (totPage*)getPageWithIndex:(int)pageIndex {
    if (pageIndex < 0 || pageIndex >= [pages count]) {
        return nil;
    }
    return [pages objectAtIndex:pageIndex];
}


- (int)pageCount {
    return [pages count];
}

- (void)dealloc {
    [super dealloc];
    [bookname release];
    [templateName release];
    [pages release];
}

@end
