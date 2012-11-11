/*
 * Represents a baby and all operations
 */


#import <Foundation/Foundation.h>
#import "totModel.h"

@interface totBaby : NSObject {
    totModel* _model;
    int babyID;         // baby id
    
    enum SEX {
        NA,          // N/A
        MALE,
        FEMALE
    };    
}

@property(nonatomic, assign) int babyID;         // baby id

// initializer
-(id) initWithID:(int)babyID;    // init to an existing baby

+(void) setModel:(totModel*)model;

// add a new baby
+(totBaby*) newBaby:(NSString*)name sex:(enum SEX)sex birthday:(NSDate*)bday;

// language operations
//
// get number of words produced by a baby to date
-(int) getNumberofWordsToDate;

@end
