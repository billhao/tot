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
    "eye_contact",
    "vision_attention", 
    "motor_skill",
    "emotion",    
    "chew",    
    "gesture",
    "mirror_test",
    "imitation"
};

const static const char *ACTIVITY_MEMBERS [] = { // the name should correspond to the image file name
    "", // eye contact
    "", // vision attention
    "motor_skill_stand,motor_skill_walk,motor_skill_run,motor_skill_dance,motor_skill_jump,motor_skill_cruise,motor_skill_crawl,motor_skill_sit,motor_skill_roll_over,motor_skill_kick_leg,motor_skill_lift_neck",  // motorskill
    "emotion_happy,emotion_sad,emotion_surprise,emotion_angry,emotion_disgust,emotion_fear", // emotion
    "", // chew
    "gesture_point,gesture_clap,gesture_wave,gesture_suck_thumb,gesture_suck_toe", // gesture
    "", // mirror test
    ""  // imitation
};

#endif
