/*
 * Represents a user and all operations
 */


#import <Foundation/Foundation.h>
#import "totModel.h"

@interface totUser : NSObject {
    NSString* email;
}

@property(nonatomic,retain) NSString* email;

// initializer
-(id) initWithID:(NSString*)_email;    // init to an existing user

+(void) setModel:(totModel*)model;

// add a new user
+(totUser*) newUser:(NSString*)email password:(NSString*)pwd;

// return total # user accounts in db
+(int) getTotalAccountCount;

@end
