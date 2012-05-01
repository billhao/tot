//
//  totActivityConst.h
//  totdev
//
//  Created by Lixing Huang on 4/30/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#ifndef totdev_totActivityConst_h
#define totdev_totActivityConst_h

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
    "3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24", // emotion
    "task1,task2", // chew
    "task1,task2"  // motorskill
};

#endif
