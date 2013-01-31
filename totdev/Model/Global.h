//
//  Global.h
//  totdev
//
//  Created by Hao Wang on 1/3/13.
//  Copyright (c) 2013 USC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "totBaby.h"
#import "totUser.h"
#import "totModel.h"

@interface Global : NSObject

@property(nonatomic, retain) totModel* model;
@property(nonatomic, retain) totBaby* baby;
@property(nonatomic, retain) totUser* user;

@end

extern Global* global;

