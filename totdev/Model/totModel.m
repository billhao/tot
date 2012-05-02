//
//  totModel.m
//  totdev
//
//  Created by Hao on 4/21/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totModel.h"
#import "totEvent.h"

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
    
    if(![fileMgr copyItemAtPath:dbpath toPath:copydbpath error:&err]) {
        NSLog(@"Unable to copy database.");
    }
}
    
-(NSString *)GetDocumentDirectory{
    fileMgr = [NSFileManager defaultManager];
    NSString *homeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    return homeDir;
}
                                
- (Boolean) addEvent:(int)baby_id event:(NSString*)event datetime:(NSString*)datetime value:(NSString*)value {
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

- (NSMutableArray *) getEvent :(int)baby_id event:(NSString*)event {
    NSMutableArray *events = [[[NSMutableArray alloc] init] autorelease];
    sqlite3_stmt *stmt = nil;
    @try {
        if (db == nil) {
            NSLog(@"Can't open db");
            return events;
        }

        NSString* searchname = [NSString stringWithFormat:@"%%%@%%", event];
        //NSLog(@"%@", searchname);
        const char *sql = "SELECT event.event_id, event.time, event.name, event.value FROM event WHERE name LIKE ? ORDER BY event.time DESC";
        if(sqlite3_prepare_v2(db, sql, -1, &stmt, NULL) != SQLITE_OK) {
            NSLog(@"[db] Problem with prepare statement");
            return events;
        }
        int ret = sqlite3_bind_text(stmt, 1, [searchname UTF8String], -1, SQLITE_TRANSIENT);
        NSLog(@"[db] getEvent bind_text %d", ret);

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
            NSLog(@"%@", time);
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

- (void) resetDB {
    // simply copy the db
    [self CopyDbToDocumentsFolder];
}

@end
