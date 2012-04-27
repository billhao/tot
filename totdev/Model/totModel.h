//
//  totModel.h
//  totdev
//
//  Created by Hao on 4/21/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface totModel : NSObject {
    NSString *dbfile;
    NSFileManager *fileMgr;
    sqlite3 *db;
}

@property (nonatomic,retain) NSFileManager *fileMgr;
@property (nonatomic,retain) NSString *dbfile;

// constructor and destructor
- (id) init;
- (void) dealloc;

// reset the db to factory mode
- (void) resetDB;

- (void) CopyDbToDocumentsFolder;
- (NSString *) GetDocumentDirectory;

- (Boolean) addEvent:(int)baby_id event:(NSString*)event datetime:(NSString*)datetime value:(NSString*)value;
- (NSMutableArray *) getEvent:(int)baby_id event:(NSString*)event;

@end
