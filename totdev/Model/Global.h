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

@class totCameraViewController;

@interface Global : NSObject

@property(nonatomic, retain) totModel* model;
@property(nonatomic, retain) totBaby* baby;
@property(nonatomic, retain) totUser* user;

@property (nonatomic, retain) totCameraViewController *cameraView;

@end

extern Global* global;

