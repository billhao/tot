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
// get a list of events in a time period
- (NSMutableArray *) getEvent:(int)baby_id startDate:(NSDate*)start endDate:(NSDate*)end;
// get a list of events in a time period and contain the string in name
- (NSMutableArray *) getEvent:(int)baby_id event:(NSString*)event startDate:(NSDate*)start endDate:(NSDate*)end;
// return only limited events
- (NSMutableArray *) getEvent:(int)baby_id event:(NSString*)event limit:(int)limit;
// return only limited events at offset (offset starts at 1)
- (NSMutableArray *) getEvent:(int)baby_id limit:(int)limit offset:(int)offset;
// return only limited events at offset (offset starts at 1)
- (NSMutableArray *) getEvent:(int)baby_id event:(NSString*)event limit:(int)limit offset:(int)offset;
// get events with all sorts of parameters (offset starts at 1)
- (NSMutableArray *) getEvent:(int)baby_id event:(NSString*)event limit:(int)limit offset:(int)offset startDate:(NSDate*)start endDate:(NSDate*)end;
// this is copied from getEvent, the difference is that this function return exact matches, not LIKE
- (NSMutableArray *) getItem:(int)baby_id name:(NSString*)name limit:(int)limit offset:(int)offset startDate:(NSDate*)start endDate:(NSDate*)end;

// get N events in a category (event) before current_event_id (N=limit)
- (NSMutableArray *) getPreviousEvent:(int)baby_id event:(NSString*)event limit:(int)limit current_event_date:(NSDate*)current_event_date;

- (int) getEventCount:(int)baby_id event:(NSString*)event;
- (BOOL) deleteEvents:(int)baby_id event:(NSString*)event;

// add a system-wide preference, such as accounts
- (BOOL) addPreferenceNoBaby:(NSString*)pref_name value:(NSString*)value;
// add a preference specific to a baby or an account
- (BOOL) addPreference:(int)baby_id preference:(NSString*)pref_name value:(NSString*)value;

// get a system-wide preference, such as accounts
- (NSString*) getPreferenceNoBaby:(NSString*)pref_name;
// get a preference specific to a baby or an account
- (NSString*) getPreference:(int)baby_id preference:(NSString*)pref_name;
- (int) getPreferenceNoBabyCount:(NSString*)pref_name;

// add a system-wide preference, such as accounts
- (BOOL) updatePreferenceNoBaby:(NSString*)pref_name value:(NSString*)value;
// add a preference specific to a baby or an account
- (BOOL) updatePreference:(int)baby_id preference:(NSString*)pref_name value:(NSString*)value;

// delete a preference
- (void) deletePreferenceNoBaby:(NSString*)pref_name;

// get next baby id for creating a new baby profile
- (int) getNextBabyID;

// get # accounts
- (int) getAccountCount;

// get total # records in db
- (int) getDBCount;

// utility functions below

// copy empty tables with structure to document folder
- (void) CopyDbToDocumentsFolder;
- (NSString *) GetDocumentDirectory;

// clear all records in the database
- (BOOL) clearDB;
// reset the database for factory mode, which may contains some records for development/testing
- (void) resetDB;

// print events to log
+ (void) printEvents:(NSMutableArray*)events;


@end
