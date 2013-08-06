//
//  User.m
//  totdev
//
//  Created by Hao Wang on 11/9/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totUser.h"
#import "totEventName.h"
#import "Global.h"

@implementation totUser

@synthesize email;

static totModel* _model;

+(void) setModel:(totModel*)model {
    _model = model;
}

// initializer
// init to an existing user
-(id) initWithID:(NSString*)_email {
    if( self = [super init] ) {
        email = [_email retain]; // release at the end?
    }
    return self;
}

// add a new user
+(totUser*) newUser:(NSString*)email password:(NSString*)pwd {
    NSString* account_pref = [NSString stringWithFormat:PREFERENCE_ACCOUNT, email];
    BOOL re = [_model addPreferenceNoBaby:account_pref value:pwd];
    if( re )
        return [[totUser alloc] initWithID:email];
    else
        return nil;
}

// return total # user accounts in db
+(int) getTotalAccountCount {
    return [_model getAccountCount];
}

// get the user that is logged in last time, this function is used at startup
+(totUser*) getLoggedInUser {
    NSString* email = [_model getPreferenceNoBaby:PREFERENCE_LOGGED_IN];
    if( email == nil ) return nil;
    
    return [[[totUser alloc] initWithID:email] autorelease];
}

// add baby id to this user
-(BOOL) addBabyToUser:(totBaby*)baby {
    NSString* user_baby = [NSString stringWithFormat:PREFERENCE_USER_BABY, email];
    NSString* baby_id = [NSString stringWithFormat:@"%d", baby.babyID];
    if( ![_model addPreferenceNoBaby:user_baby value:baby_id] )
        return FALSE;

    NSString* baby_user = [NSString stringWithFormat:PREFERENCE_BABY_USER, baby_id];
    if( ![_model addPreferenceNoBaby:baby_user value:email] )
        return FALSE;
    
    return TRUE;
}

// set the default baby for this user
-(void) setDefaultBaby:(totBaby*)baby {
    NSString* pref = [NSString stringWithFormat:PREFERENCE_DEFAULT_BABY, email];
    NSString* baby_id = [NSString stringWithFormat:@"%d", baby.babyID];
    [_model updatePreferenceNoBaby:pref value:baby_id];
}

// get the default baby for this user
-(totBaby*) getDefaultBaby {
    NSString* pref = [NSString stringWithFormat:PREFERENCE_DEFAULT_BABY, email];
    NSString* babyid = [_model getPreferenceNoBaby:pref];
    return [[[totBaby alloc] initWithID:[babyid intValue]] autorelease];
}

// set last viewed photo for this user
-(void) setLastViewedPhoto:(MediaInfo*)mediaInfo {
    NSString* pref = [NSString stringWithFormat:PREFERENCE_LAST_PHOTO_VIEWED, email];
    [_model updatePreferenceNoBaby:pref value:mediaInfo.filename];
}

// get last viewed photo for this user
-(MediaInfo*) getLastViewedPhoto {
    NSString* pref = [NSString stringWithFormat:PREFERENCE_LAST_PHOTO_VIEWED, email];
    NSString* filename = [_model getPreferenceNoBaby:pref];
    if( filename == nil ) return nil;
    
    NSString* activityName = [NSString stringWithFormat:ACTIVITY_PHOTO_REPLACABLE, filename];
    totEvent* e = [_model getItem:global.baby.babyID name:activityName];
    if( e == nil ) return nil;
    
    MediaInfo* mediaInfo = [[[MediaInfo alloc] initWithJSON:e.value] autorelease];
    mediaInfo.eventID = e.event_id;
    return mediaInfo;
}

@end
