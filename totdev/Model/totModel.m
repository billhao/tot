//
//  totModel.m
//  see test_Model.m for usage examples
//
//  Created by Hao on 4/21/12.

#import "totModel.h"
#import "totEvent.h"
#import "totEventName.h"

@implementation totModel

@synthesize fileMgr;
@synthesize dbfile;

- (id) init {
    self = [super init];
    if (self != nil) {
        @try {
            // db file name 
            dbfile = @"totdb.sqlite";
            
            // locate db file and open db
            NSLog(@"[db] init");
            db = nil;
            // get filename for db
            NSString *dbPath = [self.GetDocumentDirectory stringByAppendingPathComponent:dbfile];
            // does it exist?
            BOOL success = [fileMgr fileExistsAtPath:dbPath];
            if(!success) {
                // copy it if not exist
                [self CopyDbToDocumentsFolder];
            }
            success = [fileMgr fileExistsAtPath:dbPath];
            if(!success) {
                NSLog(@"[db] Cannot locate database file '%@'.", dbPath);
                return false;
            }
            if(!(sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK)) {
                NSLog(@"[db] An error has occured open db.");
                db = nil;
            }
        }
        @catch (NSException *exception) {
            NSLog(@"[db] An exception occured: %@", [exception reason]);
        }
    }
    return self;
}

- (void) dealloc {
    // release my objects
    if (db != nil) {
        sqlite3_close(db);
        db = nil;
    }
    [super dealloc];
}

-(void)CopyDbToDocumentsFolder{
    NSError *err=nil;
    
    fileMgr = [NSFileManager defaultManager];
    
    NSString *dbpath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbfile];
    
    NSString *copydbpath = [self.GetDocumentDirectory stringByAppendingPathComponent:dbfile];
    
    [fileMgr removeItemAtPath:copydbpath error:&err];
    
    //NSLog(@"DB path = %@", copydbpath);
    
    if(![fileMgr copyItemAtPath:dbpath toPath:copydbpath error:&err]) {
        NSLog(@"Unable to copy database.");
    }
}
    
-(NSString *)GetDocumentDirectory{
    fileMgr = [NSFileManager defaultManager];
    NSString *homeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    return homeDir;
}

- (Boolean) addEvent:(int)baby_id event:(NSString*)event datetime:(NSDate*)datetime value:(NSString*)value {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *formattedDateString = [dateFormatter stringFromDate:datetime];
    [dateFormatter release];
    return [self addEvent:baby_id event:event datetimeString:formattedDateString value:value];
}

- (Boolean) addEvent:(int)baby_id event:(NSString*)event datetimeString:(NSString*)datetime value:(NSString*)value {
    if (db == nil) {
        NSLog(@"Can't open db");
        return false;
    }

    sqlite3_stmt *stmt = nil;
    @try {
        const char *sql = "Insert into event (baby_id, time, name, value) VALUES (?,?,?,?)";

        int ret;
        ret = sqlite3_prepare_v2(db, sql, -1, &stmt, NULL);
        if( ret == SQLITE_OK ) {
            sqlite3_bind_int (stmt, 1, baby_id); // baby_id
            sqlite3_bind_text(stmt, 2, [datetime UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(stmt, 3, [event UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(stmt, 4, [value UTF8String], -1, SQLITE_TRANSIENT);
            ret = sqlite3_step(stmt);
            if( ret != SQLITE_DONE ) {
                NSLog(@"[db] addEvent step return %d", ret);
                return false;
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"[db] An exception occured: %@", [exception reason]);
        return false;
    }
    @finally {
        if( stmt != nil ) sqlite3_finalize(stmt);
        return true;
    }
}

// add a system-wide preference, such as accounts
- (BOOL) addPreferenceNoBaby:(NSString*)pref_name value:(NSString*)value {
    return [self addPreference:PREFERENCE_NO_BABY preference:pref_name value:value];
}

// add a preference specific to a baby or an account
- (BOOL) addPreference:(int)baby_id preference:(NSString*)pref_name value:(NSString*)value {
    NSString* pref = [NSString stringWithFormat:@"Pref/%@", pref_name];
    return [self addEvent:baby_id event:pref datetime:[NSDate date] value:value];
}

// pref_name is something like "Account/billhao@gmail.com"
- (NSString*) getPreferenceNoBaby:(NSString*)pref_name {
    return [self getPreference:PREFERENCE_NO_BABY preference:pref_name];
}

- (int) getPreferenceNoBabyCount:(NSString*)pref_name {
    NSString* pref = [NSString stringWithFormat:@"Pref/%@", pref_name];
    return [self getEventCount:PREFERENCE_NO_BABY event:pref];
}

- (NSString*) getPreference:(int)baby_id preference:(NSString*)pref_name {
    NSString* pref = [NSString stringWithFormat:@"Pref/%@", pref_name];
    NSMutableArray* array = [self getEvent:baby_id event:pref limit:1];
    if( array.count == 1 ) {
        totEvent* e = [array objectAtIndex:0];
        return e.value;
    }
    else
        return nil;
}

// add a system-wide preference, such as accounts
- (BOOL) updatePreferenceNoBaby:(NSString*)pref_name value:(NSString*)value {
    return [self updatePreference:PREFERENCE_NO_BABY preference:pref_name value:value];
}

// add a preference specific to a baby or an account
- (BOOL) updatePreference:(int)baby_id preference:(NSString*)pref_name value:(NSString*)value {
    // remove key if it exists
    NSString* pref = [NSString stringWithFormat:@"Pref/%@", pref_name];
    int cnt = [self getEventCount:baby_id event:pref];
    if( cnt < 0 )
        return FALSE;
    else if( cnt > 0 ) {
        // remove keys
        BOOL re = [self deleteEvents:baby_id event:pref];
        if( !re ) return FALSE;
    }
    
    // add preference
    return [self addPreference:baby_id preference:pref_name value:value];
}

// delete a preference
- (void) deletePreferenceNoBaby:(NSString*)pref_name {
    NSString* pref = [NSString stringWithFormat:@"Pref/%@", pref_name];
    [self deleteEvents:PREFERENCE_NO_BABY event:pref];
}

// get events with name
- (NSMutableArray *) getEvent :(int)baby_id event:(NSString*)event {
    return [self getEvent:baby_id event:event limit:0 offset:0 startDate:nil endDate:nil]; // call the same function with no limit
}

// get limited # of events with name
- (NSMutableArray *) getEvent:(int)baby_id event:(NSString*)event limit:(int)limit {
    return [self getEvent:baby_id event:event limit:limit offset:0 startDate:nil endDate:nil];
}

// get limited # of events at offset with name
- (NSMutableArray *) getEvent:(int)baby_id event:(NSString*)event limit:(int)limit offset:(int)offset {
    return [self getEvent:baby_id event:event limit:limit offset:offset startDate:nil endDate:nil];
}

// get all events in a time period
- (NSMutableArray *) getEvent:(int)baby_id startDate:(NSDate*)start endDate:(NSDate*)end {
    return [self getEvent:baby_id event:nil limit:0 offset:0 startDate:start endDate:end]; // call with a nil event
}

// get all events in a time period and contain the string in name
- (NSMutableArray *) getEvent:(int)baby_id event:(NSString*)event startDate:(NSDate*)start endDate:(NSDate*)end {
    return [self getEvent:baby_id event:event limit:0 offset:0 startDate:start endDate:end];
}

- (NSMutableArray *) getEvent:(int)baby_id event:(NSString*)event limit:(int)limit offset:(int)offset startDate:(NSDate*)start endDate:(NSDate*)end {
    NSMutableArray *events = [[[NSMutableArray alloc] init] autorelease];
    sqlite3_stmt *stmt = nil;
    @try {
        if (db == nil) {
            NSLog(@"Can't open db");
            return events;
        }
        
        NSString* searchname = nil;
        if( event!=nil ) searchname = [NSString stringWithFormat:@"%%%@%%", event];
        //NSLog(@"%@", searchname);
        NSString* sql_main = @"SELECT event.event_id, event.time, event.name, event.value FROM event %@ ORDER BY datetime(event.time) DESC %@";
        NSString* sql_condition;
        if( event!=nil ) {
            if( start!=nil && end!=nil ) {
                sql_condition = @"WHERE name LIKE ? AND datetime(time) >= ? AND datetime(time) < ?";
            }
            else if( start!=nil ) {
                sql_condition = @"WHERE name LIKE ? AND datetime(time) >= ?";
            }
            else if( end!=nil ) {
                sql_condition = @"WHERE name LIKE ? AND datetime(time) < ?";
            }
            else {
                sql_condition = @"WHERE name LIKE ?";
            }
        }
        else {
            if( start!=nil && end!=nil ) {
                sql_condition = @"WHERE datetime(time) >= ? AND datetime(time) < ?";
            }
            else if( start!=nil ) {
                sql_condition = @"WHERE datetime(time) >= ?";
            }
            else if( end!=nil ) {
                sql_condition = @"WHERE datetime(time) < ?";
            }
            else {
                sql_condition = @"";
            }
        }
        NSString* sql_limit = @"";
        if( limit > 0 ) {
            if( offset > 0 )
                sql_limit = @"LIMIT ?,?";
            else
                sql_limit = @"LIMIT ?";
        }
        
        NSString* sql = [NSString stringWithFormat:sql_main, sql_condition, sql_limit];
        //NSLog(@"[db] SQL=%@", sql);
        
        const char *sqlz = [sql cStringUsingEncoding:NSASCIIStringEncoding];
        if(sqlite3_prepare_v2(db, sqlz, -1, &stmt, NULL) != SQLITE_OK) {
            NSLog(@"[db] Problem with prepare statement");
            return events;
        }
        int param_cnt = 0;
        if( event != nil ) {
            param_cnt++;
            int ret = sqlite3_bind_text(stmt, param_cnt, [searchname UTF8String], -1, SQLITE_TRANSIENT);
            if( ret!=SQLITE_OK ) NSLog(@"[db] getEvent bind_text %d", ret);
        }
        if( start != nil ) {
            param_cnt++;
            int ret = sqlite3_bind_text(stmt, param_cnt, [[totEvent formatTime:start] UTF8String], -1, SQLITE_TRANSIENT);
            if( ret!=SQLITE_OK ) NSLog(@"[db] getEvent bind_text %d", ret);
        }
        if( end != nil ) {
            param_cnt++;
            int ret = sqlite3_bind_text(stmt, param_cnt, [[totEvent formatTime:end] UTF8String], -1, SQLITE_TRANSIENT);
            if( ret!=SQLITE_OK ) NSLog(@"[db] getEvent bind_text %d", ret);
        }
        if( limit > 0 ) {
            if( offset > 0 ) {
                param_cnt++;
                int ret = sqlite3_bind_int(stmt, param_cnt, offset);
                if( ret!=SQLITE_OK ) NSLog(@"[db] getEvent bind_int %d", ret);
            }
            param_cnt++;
            int ret = sqlite3_bind_int(stmt, param_cnt, limit);
            if( ret!=SQLITE_OK ) NSLog(@"[db] getEvent bind_int %d", ret);
        }
        
        while (sqlite3_step(stmt)==SQLITE_ROW) {
            int i = sqlite3_column_int(stmt, 0);
            NSString *time  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 1)];
            NSString *name  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 2)];
            NSString *value = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, 3)];
            //NSLog(@"[db] record, %d, %@", i, value);
            
            totEvent *e = [[totEvent alloc] init];
            e.event_id = i;
            e.baby_id = baby_id;
            e.name = name;
            e.value = value;
            //NSLog(@"%@", time);
            [e setTimeFromText:time];
            [events addObject:e];
            [e release];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"[db] An exception occured: %@", [exception reason]);
    }
    @finally {
        if( stmt != nil ) sqlite3_finalize(stmt);
        return events;
    }
}

- (int) getEventCount:(int)baby_id event:(NSString*)event {
    int cnt = -1;
    sqlite3_stmt *stmt = nil;
    @try {
        if (db == nil) {
            NSLog(@"Can't open db");
            return cnt;
        }
        
        NSString* searchname = [NSString stringWithFormat:@"%%%@%%", event];
        const char *sql = "SELECT count(*) FROM event WHERE name LIKE ?";
        if(sqlite3_prepare_v2(db, sql, -1, &stmt, NULL) != SQLITE_OK) {
            NSLog(@"[db] Problem with prepare statement");
            return cnt;
        }
        int ret = sqlite3_bind_text(stmt, 1, [searchname UTF8String], -1, SQLITE_TRANSIENT);
        if( ret!=SQLITE_OK ) NSLog(@"[db] getEvent bind_text %d", ret);
        
        if (sqlite3_step(stmt)==SQLITE_ROW) {
            cnt = sqlite3_column_int(stmt, 0);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"[db] An exception occured: %@", [exception reason]);
    }
    @finally {
        if( stmt != nil ) sqlite3_finalize(stmt);
        return cnt;
    }
}

- (BOOL) deleteEvents:(int)baby_id event:(NSString*)event {
    BOOL re = FALSE;
    sqlite3_stmt *stmt = nil;
    @try {
        if (db == nil) {
            NSLog(@"Can't open db");
            return re;
        }
        
        NSString* searchname = [NSString stringWithFormat:@"%%%@%%", event];
        const char *sql = "DELETE FROM event WHERE name LIKE ?";
        if(sqlite3_prepare_v2(db, sql, -1, &stmt, NULL) != SQLITE_OK) {
            NSLog(@"[db] Problem with prepare statement");
            return re;
        }
        int ret = sqlite3_bind_text(stmt, 1, [searchname UTF8String], -1, SQLITE_TRANSIENT);
        if( ret!=SQLITE_OK ) NSLog(@"[db] getEvent bind_text %d", ret);
        
        if (sqlite3_step(stmt)!=SQLITE_OK) {
            return FALSE;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"[db] An exception occured: %@", [exception reason]);
    }
    @finally {
        if( stmt != nil ) sqlite3_finalize(stmt);
        return TRUE;
    }
}

// clear all records in the database
- (BOOL) clearDB {
    BOOL re = FALSE;
    sqlite3_stmt *stmt = nil;
    @try {
        if (db == nil) {
            NSLog(@"Can't open db");
            return re;
        }
        
        const char *sql = "DELETE FROM event";
        if(sqlite3_prepare_v2(db, sql, -1, &stmt, NULL) != SQLITE_OK) {
            NSLog(@"[db] Problem with prepare statement");
            return re;
        }
        
        if (sqlite3_step(stmt)!=SQLITE_OK) {
            return FALSE;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"[db] An exception occured: %@", [exception reason]);
    }
    @finally {
        if( stmt != nil ) sqlite3_finalize(stmt);
        return TRUE;
    }
}

// reset the database for factory mode, which may contains some records for development/testing
- (void) resetDB {
    // simply copy the db
    [self CopyDbToDocumentsFolder];
}

+ (void) printEvents:(NSMutableArray*)events {
    if( events == nil ) {
        NSLog(@"[printEvents] events is nil");
        return;
    }
    if( [events count] == 0 ) {
        NSLog(@"[printEvents] No events to print");
        return;
    }
    NSLog(@"[printEvents] %d events", [events count]);
    NSLog(@"--------");
    for (totEvent* e in events) {
        NSLog(@"%@", [e toString]);
    }
    NSLog(@"--------\n");
}

// get next baby id for creating a new baby profile
// TODO return first id if error occurs, this behavior probably should be changed
- (int) getNextBabyID {
    int nextid = PREFERENCE_NO_BABY + 1;
    sqlite3_stmt *stmt = nil;
    @try {
        if (db == nil) {
            NSLog(@"Can't open db");
            return nextid;
        }
        
        const char *sql = "SELECT MAX(baby_id) FROM event";
        if(sqlite3_prepare_v2(db, sql, -1, &stmt, NULL) != SQLITE_OK) {
            NSLog(@"[db] Problem with prepare statement");
            return nextid;
        }
        if (sqlite3_step(stmt)==SQLITE_ROW) {
            nextid = sqlite3_column_int(stmt, 0)+1;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"[db] An exception occured: %@", [exception reason]);
    }
    @finally {
        if( stmt != nil ) sqlite3_finalize(stmt);
        return nextid;
    }
}

// get # accounts
- (int) getAccountCount {
    int cnt = 0;
    cnt = [self getEventCount:PREFERENCE_NO_BABY event:@"Account/"];
    return [self getPreferenceNoBabyCount:@"Account"];
}

@end
