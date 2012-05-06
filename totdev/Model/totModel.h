// the model sets db connection, adds a record to db, or get a list of objects from db
// see test_Model.m for an exmaple
// Created by Hao on 4/21/12.

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

// add an event
- (Boolean) addEvent:(int)baby_id event:(NSString*)event datetimeString:(NSString*)datetime value:(NSString*)value;
- (Boolean) addEvent:(int)baby_id event:(NSString*)event datetime:(NSDate*)datetime value:(NSString*)value;

// get a list of events that contain the string in name
- (NSMutableArray *) getEvent:(int)baby_id event:(NSString*)event;

// utility functions below

// copy empty tables with structure to document folder
- (void) CopyDbToDocumentsFolder;
- (NSString *) GetDocumentDirectory;

// reset the db to factory mode, clear all the records
- (void) resetDB;


@end
