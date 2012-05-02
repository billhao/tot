//
//  totActivityEntryViewController.h
//  totdev
//
//  Created by Lixing Huang on 4/15/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "totCameraViewController.h"
#import "totActivityRootController.h"
#import "../Model/totModel.h"
#import "../Model/totEvent.h"

enum {
    kActivityEyeContact = 0,
    kActivityVisionAttention = 1,
    kActivityMotorSkill = 2,
    kActivityEmotion = 3,
    kActivityChew = 4,
    kActivityGesture = 5,
    kActivityMirrorTest = 6,
    kActivityImitation = 7
};

@interface totActivityEntryViewController : UIViewController {    
    NSMutableArray *mActivityNames;
    NSMutableDictionary *mActivityMembers;

    totActivityRootController *activityRootController;
    
    totModel *mTotModel;
}

@property (nonatomic, assign) totActivityRootController *activityRootController;

- (void)prepareMessage:(NSMutableDictionary*)message for:(int)activity;

@end
