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
#import "RNEncryptor.h"
#import "totServerCommController.h"

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
        self.email = _email;
    }
    return self;
}

-(void) dealloc {
    if (self.email) {
        [self.email release];
    }
    [super dealloc];
}

+(BOOL) addAccount:(NSString*)email password:(NSString*)pwd {
    NSString* pwdhash = [self getPasswordHash:pwd salt:nil];
    NSString* account_pref = [NSString stringWithFormat:PREFERENCE_ACCOUNT, email];
    return [_model addPreferenceNoBaby:account_pref value:pwdhash];
}

// add a new user
+(totUser*) newUser:(NSString*)email password:(NSString*)pwd message:(NSString**)message {
    // clean the email
    email = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // register with server
    totServerCommController* server = [[totServerCommController alloc] init];
    int retCode = [server sendRegInfo:@"" withEmail:email withPasscode:pwd returnMessage:message];
    if( retCode == SERVER_RESPONSE_CODE_SUCCESS ) {
        BOOL re = [self addAccount:email password:pwd];
        if( re ) {
            [server release];
            return [[totUser alloc] initWithID:email];
        } else {
            *message = [[[NSString alloc] initWithString:@"Cannot add user to database"] autorelease];
            // TODO should we delete this user from server? otherwise it wouldn't be possible to create the user next time
            [server release];
            return nil;
        }
    } else {
        [server release];
        return nil;
    }
}

+(BOOL)verifyPassword:(NSString*)pwd email:(NSString*)email message:(NSString**)message {
//    NSString* pwdhash_db = @"";
    
//    NSString* account_pref = [NSString stringWithFormat:PREFERENCE_ACCOUNT, email];
//    pwdhash_db = [global.model getPreferenceNoBaby:account_pref];

//    NSData* salt = [self HexString2Data:[pwdhash_db substringToIndex:2*kRNCryptorAES256Settings.keySettings.saltSize]];
//    NSString* pwdhash = [self getPasswordHash:pwd salt:salt];
    
    totServerCommController* server = [[totServerCommController alloc] init];
    int ret = [server sendLoginInfo:email withPasscode:pwd returnMessage:message];
    [server release];
    if( ret == SERVER_RESPONSE_CODE_SUCCESS ) {
        return TRUE;
    } else {
        return FALSE;
    }
}

// request the server to reset password
+(BOOL)forgotPassword:(NSString*)email message:(NSString**)message {
    totServerCommController* server = [[totServerCommController alloc] init];
    int retCode = [server sendForgetPasscodeforUser:email returnMessage:message];
    [server release];
    if( retCode == SERVER_RESPONSE_CODE_SUCCESS ) {
        return TRUE;
    } else
        return FALSE;
}

// change to a new ped
+(BOOL)changePassword:(NSString*)newPasswd oldPassword:(NSString*)oldPassword message:(NSString**)message {
    totServerCommController* server = [[totServerCommController alloc] init];
    int retCode = [server sendResetPasscodeForUser:global.user.email from:oldPassword to:newPasswd returnMessage:message ];
    [server release];
    if( retCode == SERVER_RESPONSE_CODE_SUCCESS ) {
        return TRUE;
    } else {
        return FALSE;
    }
}

// concatenate salt and hash of pwd to the final string, which will be stored
+(NSString*)getPasswordHash:(NSString*)pwd salt:(NSData*)salt {
    // hash the password
    if( salt == nil ) {
        salt = [RNEncryptor randomDataOfLength:kRNCryptorAES256Settings.keySettings.saltSize];
    }
    NSData* data = [RNEncryptor keyForPassword:pwd salt:salt settings:kRNCryptorAES256Settings.keySettings];
    NSString* hash = [self toHexString:data];
    NSString* saltStr = [self toHexString:salt];
    NSString* finalStr = [NSString stringWithFormat:@"%@%@", saltStr, hash];
    return finalStr;
}

+ (NSString*) toHexString:(NSData*)data {
    const unsigned char* bytes = (const unsigned char*)[data bytes];
	NSMutableString* str = [[[NSMutableString alloc] initWithCapacity:data.length*2] autorelease];
	for (unsigned int i = 0; i < data.length; i++) {
		[str appendFormat:@"%02x", bytes[i]];
	}
	return str;
}

+ (NSData*) HexString2Data:(NSString*)str {
	NSMutableData* data = [[NSMutableData alloc] initWithCapacity:str.length/2];
	unsigned char wholeByte;
    char bytes[3] = {'\0','\0','\0'};
    for (unsigned int i = 0; i < str.length/2; i++) {
		bytes[0] = [str characterAtIndex:i*2];
		bytes[1] = [str characterAtIndex:i*2+1];
        wholeByte = strtol(bytes, NULL, 16);
        [data appendBytes:&wholeByte length:1];
	}
	return data;
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
    
    MediaInfo* mediaInfo = [[[MediaInfo alloc] initWithEvent:e] autorelease];
    mediaInfo.eventID = e.event_id;
    return mediaInfo;
}

@end
