/*
 * Represents a user and all operations
 */


#import <Foundation/Foundation.h>
#import "totModel.h"
#import "totBaby.h"
#import "totMediaLibrary.h"


@interface totUser : NSObject {
    NSString* email;
}

@property(nonatomic,retain) NSString* email;

// initializer
-(id) initWithID:(NSString*)_email;    // init to an existing user

+(void) setModel:(totModel*)model;

// add a new user
+(totUser*) newUser:(NSString*)email password:(NSString*)pwd;

+(BOOL)verifyPassword:(NSString*)pwd email:(NSString*)email;

// return total # user accounts in db
+(int) getTotalAccountCount;

// get the user that is logged in last time, this function is used at startup
+(totUser*) getLoggedInUser;

// get the default baby for this user
-(totBaby*) getDefaultBaby;

// add baby id to this user
-(BOOL) addBabyToUser:(totBaby*)baby;

// set the default baby for this user
-(void) setDefaultBaby:(totBaby*)baby;

// set last viewed photo for this user
-(void) setLastViewedPhoto:(MediaInfo*)mediaInfo;
// get last viewed photo for this user
-(MediaInfo*) getLastViewedPhoto;

@end
