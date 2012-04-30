//
//  totActivityRootController.h
//  totdev
//
//  Created by Lixing Huang on 4/11/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class totActivityEntryViewController;
@class totActivityViewController;
@class totActivityInfoViewController;
@class totActivityAlbumViewController;

const static int SCREEN_W = 320;
const static int SCREEN_H = 460;

const static const char *ACTIVITY_NAMES [] = {
    "vision_attention", 
    "eye_contact",
    "mirror_test",
    "imitation",
    "gesture",
    "emotion",
    "chew",
    "motor_skill"
};

const static const char *ACTIVITY_MEMBERS [] = { // the name should correspond to the image file name
    "task1,task2", // vision attention
    "task1,task2", // eye contact
    "task1,task2", // mirror test
    "task1,task2", // imitation
    "task1,task2", // gesture
    "3,4,5,6,7,8,9,10,11,12", // emotion
    "task1,task2", // chew
    "task1,task2"  // motorskill
};

enum {
    kActivityEntryView = 0,
    kActivityView = 1,
    kActivityInfoView = 2,
    kActivityAlbumView = 3
};

enum {
    kViewName = 0,
};

@interface totActivityRootController : UIViewController {
    totActivityEntryViewController *activityEntryViewController;
    totActivityViewController *activityViewController;
    totActivityInfoViewController *activityInfoViewController;
    totActivityAlbumViewController *activityAlbumViewController;
    
    NSDictionary *mViewStack;
    int mCurrentViewIndex;
}

@property (nonatomic, retain) totActivityEntryViewController *activityEntryViewController;
@property (nonatomic, retain) totActivityViewController *activityViewController;
@property (nonatomic, retain) totActivityInfoViewController *activityInfoViewController;
@property (nonatomic, retain) totActivityAlbumViewController *activityAlbumViewController;

- (void) switchTo:(int)viewIndex;
- (void) switchTo:(int)viewIndex withContextInfo:(NSMutableDictionary*)info;

@end
