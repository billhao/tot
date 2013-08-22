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

@class totPage;
@class totBook;

// ---------------------------------totPageElement---------------------------------------

// Types of page element.
typedef enum {
    TEXT  = 0,
    IMAGE = 1,
    VIDEO = 2,
} PageElementMediaType;

// Represents each element on the page. The element could be txt, image, or video.
@interface totPageElement : NSObject

// the top-left point
@property (nonatomic, assign) float x;
@property (nonatomic, assign) float y;

// the size of the element
@property (nonatomic, assign) float w;
@property (nonatomic, assign) float h;

// rotate the element at the center
@property (nonatomic, assign) float radians;

// the media type
@property (nonatomic, assign) PageElementMediaType type;

// identifier of the element
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSMutableDictionary* resources;  // the paths to the resource files (each element may contain more than one resource)

@property (nonatomic, retain) totPage* page; // parent page

// fucntions
- (id)init:(totPage*)page;
- (id)copy:(totPage*)page; // a deep copy this object

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

// ---------------------------------totPage---------------------------------------

// Represents the page of scrapbook.
typedef enum {
    COVER = 1,
    PAGE = 2,
} PageType;

@interface totPage : NSObject

@property (nonatomic, assign) PageType type;
@property (nonatomic, retain) NSString* templateFilename;
@property (nonatomic, retain) NSString* name; // identifier of the page.
@property (nonatomic, retain) NSMutableArray* pageElements;  // Each element is a totPageElement.
@property (nonatomic, retain) totBook* book; // parent book

// functions
- (id)init:(totBook*)book;
- (id)copy:(totBook*)book; // a deep copy this object

// element is a NSDictionary containing all necessary information for the element.
// keys: x, y, w, h, radius, type, name, etc.
- (void) addPageElement:(id)element;

- (NSDictionary*) toDictionary;
- (void) loadFromDictionary: (NSDictionary*)dict;

- (totPageElement*) getPageElement:(NSString*)name;
- (totPageElement*) getPageElementAtIndex:(int)index;
- (int)elementCount;

@end

// ---------------------------------totBook---------------------------------------

// Represents the scrapbook.
@interface totBook : NSObject {
    NSMutableArray* pages;  // Each element is a totPage.
    
    
    int lastRandomPage; // use this to avoid generate repeated random page 
}

@property (nonatomic, retain) NSString* bookid; // a unique id. book name may not be unique
@property (nonatomic, retain) NSString* bookname; // may not be unique
@property (nonatomic, retain) NSString* templateName;

- (void) loadFromTemplateFile:(NSString*)filename;  // result in an empty book.
- (void) loadFromJSONString: (NSString*)json;  // json represents the book.
- (void) loadBook:(NSString*)bookid bookname:(NSString*)bookname;  // result in an editted book.

- (NSDictionary*) toDictionary;
- (void) loadFromDictionary: (NSDictionary*)dict;

// caller needs to release the page.
- (void)insertPage:(totPage *)page pageIndex:(int)pageIndex;
- (void)deletePage:(int)pageIndex;

+ (totBook*) loadFromDB:(NSString*)bookid bookname:(NSString*)bookname;
- (void) saveToDB; // save the book as a json string in db

- (totPage*) getPage:(NSString*)name;
- (totPage*) getPageWithIndex:(int)pageIndex;
- (totPage*) getRandomPage;

- (int) pageCount;

@end