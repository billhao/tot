//
//  totActivityEntryViewController.h
//  totdev
//
//  Created by Lixing Huang on 4/15/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "totCameraViewController.h"

enum {
    kActivityVisionAttention = 0,
    kActivityEyeContact = 1,
    kActivityMirrorTest = 2,
    kActivityImitation = 3,
    kActivityGesture = 4,
    kActivityEmotion = 5,
    kActivityChew = 6,
    kActivityMotorSkill = 7
};

@interface totActivityEntryViewController : UIViewController <CameraViewDelegate> {    
    NSMutableArray *mActivityNames;
}

- (void) launchCamera;

@end
