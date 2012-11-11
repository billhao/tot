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

@implementation totBaby

@synthesize babyID;

// initializer
//
// init to an existing baby
-(id) initWithID:(int)BabyID {
    if( self = [super init] ) {
        babyID = BabyID;
    }
    return self;
}

static totModel* _model;

+(void) setModel:(totModel*)model {
    _model = model;
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
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* str_bday = [dateFormatter stringFromDate:bday];
    [dateFormatter release];

    int baby_id = [_model getNextBabyID];
    NSLog(@"next id = %d", baby_id);
    [_model addPreference:baby_id preference:INFO_NAME value:name];
    [_model addPreference:baby_id preference:INFO_SEX value:str_sex];
    [_model addPreference:baby_id preference:INFO_BIRTHDAY value:str_bday];
    
    return [[totBaby alloc] initWithID:baby_id];
}

// get number of words produced by a baby to date
- (int) getNumberofWordsToDate {
    return 1;
}

@end
