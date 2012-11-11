//
//  User.m
//  totdev
//
//  Created by Hao Wang on 11/9/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totUser.h"

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
        email = _email;
    }
    return self;
}

// add a new user
+(totUser*) newUser:(NSString*)email password:(NSString*)pwd {
    NSString* account_pref = [NSString stringWithFormat:@"Account/%@", email];
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

@end
