//
//  Baby.m
//  totdev
//
//  Created by Hao Wang on 11/9/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totBaby.h"
#import "totModel.h"
#import "totEvent.h"
#import "totEventName.h"
#import "Global.h"

@implementation totBaby

@synthesize babyID = _babyID, name = _name, sex = _sex, birthday = _birthday, avatar;

// initializer
//
// init to an existing baby
-(id) initWithID:(int)BabyID {
    if( self = [super init] ) {
        _babyID = BabyID;
        
        // also get other basic info
        // name
        self.name = [global.model getPreference:_babyID preference:BABY_NAME];
        
        // sex
        NSString* sex = [global.model getPreference:_babyID preference:BABY_SEX];
        self.sex = NA;
        if( [sex isEqualToString:@"MALE"] )
            self.sex = MALE;
        else if( [sex isEqualToString:@"FEMALE"] )
            self.sex = FEMALE;
        
        // birthday
        NSString* bday = [global.model getPreference:_babyID preference:BABY_BIRTHDAY];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        self.birthday = [dateFormatter dateFromString:bday];
        [dateFormatter release];
    }
    return self;
}

+(void) setModel:(totModel*)model {
    global.model = model;
}

// add a new baby
+(totBaby*) newBaby:(NSString*)name sex:(enum SEX)sex birthday:(NSDate*)bday {
    // format sex
    NSString* str_sex = @"";
    if( sex == MALE )
        str_sex = @"MALE";
    else if( sex == FEMALE )
        str_sex = @"FEMALE";
    
    // format bday
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* str_bday = [dateFormatter stringFromDate:bday];

    int baby_id = [global.model getNextBabyID];
    NSLog(@"next id = %d", baby_id);
    [global.model addPreference:baby_id preference:BABY_NAME value:name];
    [global.model addPreference:baby_id preference:BABY_SEX value:str_sex];
    [global.model addPreference:baby_id preference:BABY_BIRTHDAY value:str_bday];
    
    return [[totBaby alloc] initWithID:baby_id];
}

// get number of words produced by a baby to date
- (int) getNumberofWordsToDate {
    return 1;
}

// print baby info to console
-(void) printBabyInfo {
    NSString* str_sex = @"N/A";
    if( _sex == MALE )
        str_sex = @"MALE";
    else if( _sex == FEMALE )
        str_sex = @"FEMALE";
    
    // format bday
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* str_bday = [dateFormatter stringFromDate:_birthday];
    [dateFormatter release];
    
    NSString* output =
        [NSString stringWithFormat:@"Baby Info\nID = %d\nName = %@\nSex = %@\nBday = %@", _babyID, _name, str_sex, str_bday];
    NSLog(@"%@", output);
}

// return a pretty formatted age for summary card in timeline
-(NSString*)formatAge {
    NSDate* today = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:self.birthday toDate:today options:0];

    NSString* str;
    NSString* year;
    NSString* month;
    NSString* day;
    
    if( components.day == 0 )
        day = @"";
    else if( components.day == 1 )
        day = @"1 day";
    else
        day = [NSString stringWithFormat:@"%d days", components.day];

    if( components.month == 0 )
        month = @"";
    else if( components.month == 1 )
        month = @"1 month";
    else
        month = [NSString stringWithFormat:@"%d months", components.month];

    if( components.year == 0 )
        year = @"";
    else if( components.year == 1 )
        year = @"1 year";
    else
        year = [NSString stringWithFormat:@"%d years", components.year];
    
    if( components.year == 0 && components.month == 0 && components.day == 0 ) {
        // first day
        str = [NSString stringWithFormat:@"first day!"];
    }
    else if( components.day == 0 && components.month == 0 ) {
        // today is birthday
        if( components.year == 1 )
            str = [NSString stringWithFormat:@"one year! happy birthday!"];
        else
            str = [NSString stringWithFormat:@"%d years! happy birthday!", components.year];
    }
    else {
        str = [NSString stringWithFormat:@"%@ %@ %@", year, month, day];
    }
    [calendar release];
    return str;
}

// get avatar from db or return the default one if nil
- (UIImage*)avatar {
    UIImage* img = nil;
    NSString* filename = [global.model getPreference:global.baby.babyID preference:PREFERENCE_BABY_AVATAR];
    if( filename ) {
        NSString* filepath = [totMediaLibrary getMediaPath:filename];
        img = [UIImage imageWithContentsOfFile:filepath];
    }
    else {
        img = [UIImage imageNamed:@"summary_head_default"];
    }
    
    if( img )
        return [[img retain] autorelease];
    else
        return nil;
}

@end








