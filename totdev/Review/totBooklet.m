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
#import "totModel.h"

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
@synthesize name, resources;

- (id) init:(totPage*)page {
    if (self = [super init]) {
        x = y = w = h = 0;
        type = TEXT;
        radians = 0;
        resources = [[NSMutableDictionary alloc] init];
        self.page = page;
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

// make a deep of this element because when make copy an element from a template to a real book
// every embeded object need to be a new one. otherwise it will point to the same objects
- (id)copy:(totPage*)page
{
    totPageElement* e = [[totPageElement alloc] init:self.page];
    e.x = self.x;
    e.y = self.y;
    e.w = self.w;
    e.h = self.h;
    e.radians = self.radians;
    e.name = [NSString stringWithString:self.name];
    e.type = self.type;
    e.page = page;
    
    for (NSString* key in resources.keyEnumerator) {
        [e.resources setObject:[resources objectForKey:key] forKey:key];
    }
    
    return e;
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
            [resources setObject:[NSString stringWithString:[res objectForKey:key]]
                          forKey:[NSString stringWithString:key]];
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

@synthesize type, templateFilename, name, pageElements;

- (id) init:(totBook*)book {
    if (self = [super init]) {
        pageElements = [[NSMutableArray alloc] init];
        self.book = book;
    }
    return self;
}

- (void) dealloc {
    [super dealloc];
    [name release];
    [templateFilename release];
    [pageElements release];
}

// a deep copy this object. see totPageElement's comment on this
- (id)copy:(totBook*)book {
    totPage* p = [[totPage alloc] init:book];
    p.type = self.type;
    p.templateFilename = [NSString stringWithString:self.templateFilename];
    p.name = [NSString stringWithString:self.name];
    p.book = book;
    
    for (totPageElement* e in pageElements) {
        [p.pageElements addObject:[e copy:p]];
    }
    return p;
}

- (int)elementCount {
    return [pageElements count];
}

- (totPageElement*) getPageElement:(NSString*)n {
    for (totPageElement* element in pageElements) {
        if ([element.name caseInsensitiveCompare:n]) {
            return element;
        }
    }
    return nil;
}

- (totPageElement*) getPageElementAtIndex:(int)index {
    if (index < 0 || index >= [pageElements count])
        return nil;
    return [pageElements objectAtIndex:index];
}

// Used to load data from template description file.
- (void) addPageElement:(id)element {
    totPageElement* new_element = [[totPageElement alloc] init:self];
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
            totPageElement* e = [[totPageElement alloc] init:self];
            [e loadFromDictionary:[ee objectAtIndex:i]];
            [pageElements addObject:e];
            [e release];
        }
    }
}

@end


////////////////////////////////////////////////////////////////
// totBook
////////////////////////////////////////////////////////////////
@implementation totBook

@synthesize bookid, bookname, templateName;

- (id) init {
    if (self = [super init]) {
        pages = [[NSMutableArray alloc] init];
        self.bookid = [NSString stringWithFormat:@"%d", [totModel getSecondsSince1970]];
    }
    return self;
}

// Parse template description file
- (BOOL) isComment:(NSString*)line {
    if ([line length] < 2) return NO;
    NSString* s = [line substringToIndex:2];
    return ([s isEqualToString:@"//"] ? YES : NO);
}
- (void) parsePageObject:(id)page_json_object toPage:(totPage*)new_page {
    if (!page_json_object || !new_page) return;
    for (id object_key in page_json_object) {
        if ([object_key isEqualToString:@"template_path"]) {
            new_page.templateFilename = [page_json_object objectForKey:object_key];
        } else if ([object_key isEqualToString:@"meta"]) {
            NSString* meta = [page_json_object objectForKey:object_key];
            if ([meta caseInsensitiveCompare:@"cover"] == NSOrderedSame) {
                new_page.type = COVER;
            } else if ([meta caseInsensitiveCompare:@"page"] == NSOrderedSame) {
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
                totPage* new_page = [[totPage alloc] init:self];
                [self parsePageObject:page_json_object toPage:new_page];
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
    if( lines == nil ) {
        NSLog(@"Template file not found: %@", filename);
        return;
    }
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
            totPage* p = [[totPage alloc] init:self];
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

// save the book as a json string in db
- (void) saveToDB {
    NSDictionary* dict = [self toDictionary];
    NSString* dbid = [NSString stringWithFormat:SCRAPBOOK_REPLACABLE, self.bookid, self.bookname];
    NSLog(@"save book %@ to db", dbid);
    [global.model setItem:global.baby.babyID name:dbid value:dict];
}

+ (totBook*) loadFromDB:(NSString*)bookid bookname:(NSString*)bookname {
    NSString* dbid = [NSString stringWithFormat:SCRAPBOOK_REPLACABLE, bookid, bookname];
    NSLog(@"load book %@ to db", dbid);
    totEvent* e = [global.model getItem:global.baby.babyID name:dbid];
    if( e == nil )
        return nil;
    
    totBook* book = [[totBook alloc]init];
    book.bookid = bookid;
    [book loadFromJSONString:e.value];
    return book;
}

- (void)insertPage:(totPage *)page pageIndex:(int)pageIndex {
    [pages insertObject:page atIndex:pageIndex];
}

- (void)deletePage:(int)pageIndex {
    [pages removeObjectAtIndex:pageIndex];
}

- (totPage*)getPage:(NSString*)name {
    for (totPage* page in pages) {
        if ([page.name caseInsensitiveCompare:name] == NSOrderedSame) {
            return page;
        }
    }
    return nil;
}

- (totPage*)getRandomPage {
    int cnt = 10;
    int n;
    while( cnt > 0 ) {
        cnt--;
        n = arc4random_uniform(pages.count);
        if( n != lastRandomPage )
            break;
    }
    lastRandomPage = n;
    return pages[n];
}

- (totPage*)getPageWithIndex:(int)pageIndex {
    if (pageIndex < 0 || pageIndex >= [pages count]) {
        return nil;
    }
    return [pages objectAtIndex:pageIndex];
}

- (int)pageCount {
    return [pages count];
}

- (void)loadBook:(NSString*)bookid bookname:(NSString*)bookname {
    
}

- (void)dealloc {
    [super dealloc];
    [bookname release];
    [templateName release];
    [pages release];
}

@end
