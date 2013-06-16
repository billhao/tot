//
//  totBookletController.h
//  totdev
//
//  This is the basis of the page of our scrapbook.
//
//  Created by Lixing Huang on 5/22/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import <UIKit/UIKit.h>

// Types of page element.
typedef enum {
    TEXT  = 0,
    IMAGE = 1,
    VIDEO = 2,
} PageElementMediaType;

// Represents each element on the page. The element could be txt, image, or video.
@interface totPageElement : NSObject {
    float x, y;  // the top-left point.
    float w, h;  // the size of the element
    float radians;  // rotate the element at the center
    NSMutableDictionary* resources;  // the paths to the resource files (each element may contain more than one resource)
    PageElementMediaType type;  // the media type
    NSMutableString* name;  // identifier of the element
}

@property (nonatomic, assign) float x;
@property (nonatomic, assign) float y;
@property (nonatomic, assign) float w;
@property (nonatomic, assign) float h;
@property (nonatomic, assign) float radians;
@property (nonatomic, assign) PageElementMediaType type;
@property (nonatomic, retain) NSString* name;

- (id) init;
- (void) addResource:(NSString*)key withPath:(NSString*)path;
- (NSString*) getResource:(NSString*)key;
- (BOOL) isEmpty;  // whether contains any resources or not.
- (NSDictionary*) toDictionary;
- (void) loadFromDictionary: (NSDictionary*)dict;
// Return the keys. We can use these keys to getResource later.
+ (NSString*) image;
+ (NSString*) video;
+ (NSString*) audio;
// NOTE: (x, y) is the top-left corner of the element.
+ (void)initPageElement:(totPageElement*)e
                      x:(float)x
                      y:(float)y
                      w:(float)w
                      h:(float)h
                      r:(float)r
                      n:(NSString*)name
                      t:(PageElementMediaType)t;
@end


// Represents the page of scrapbook.
typedef enum {
    COVER = 1,
    PAGE = 2,
} PageType;
@interface totPage : NSObject {
    PageType type;
    NSString* templateFilename;
    NSString* name;  // identifier of the page.
    NSMutableArray* pageElements;  // Each element is a totPageElement.
}

@property (nonatomic, assign) PageType type;
@property (nonatomic, retain) NSString* templateFilename;
@property (nonatomic, retain) NSString* name;

- (id) init;
// element is a NSDictionary containing all necessary information for the element.
// keys: x, y, w, h, radius, type, name, etc.
- (void) addPageElement:(id)element;
- (NSDictionary*) toDictionary;
- (void) loadFromDictionary: (NSDictionary*)dict;

// TODO(lxhuang)
- (totPageElement*) getPageElement:(NSString*)name;
- (totPageElement*) getPageElementAtIndex:(int)index;
- (int)elementCount;

@end


// Represents the scrapbook.
@interface totBook : NSObject {
    NSString* bookname;  // Must be unique.
    NSString* templateName;
    NSMutableArray* pages;  // Each element is a totPage.
}

@property (nonatomic, retain) NSString* bookname;
@property (nonatomic, retain) NSString* templateName;

- (void) loadFromTemplateFile:(NSString*)filename;  // result in an empty book.
- (void) loadFromDictionary: (NSDictionary*)dict;
- (void) loadFromJSONString: (NSString*)json;  // json represents the book.
- (void) loadBook:(NSString*)bookname;  // result in an editted book.
- (NSDictionary*) toDictionary;

- (NSDictionary*) getPage:(NSString*)name;
- (NSDictionary*) getPageWithIndex:(int)pageIndex;
- (int)pageCount;

@end
