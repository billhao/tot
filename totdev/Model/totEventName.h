//
//  totEventName.h
//  totdev
//
//  Created by Lixing Huang on 5/5/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#ifndef totdev_totEventName_h
#define totdev_totEventName_h

// for preferences not associated with a baby
static int       PREFERENCE_NO_BABY     = 0;

// preference keys
static NSString *PREFERENCE_LOGGED_IN   = @"logged_in"; // who is currently logged in
static NSString *PREFERENCE_LAST_LOGGED_IN   = @"last_logged_in"; // the last logged in user
static NSString *PREFERENCE_ACTIVE_BABY_ID = @"active_baby_id";

// baby information
static NSString *INFO_NAME              = @"info/name";
static NSString *INFO_BIRTHDAY          = @"info/birthday";
static NSString *INFO_SEX               = @"info/sex";

// basic
static NSString *EVENT_BASIC_HEIGHT     = @"basic/height";
static NSString *EVENT_BASIC_WEIGHT     = @"basic/weight";
static NSString *EVENT_BASIC_HEAD       = @"basic/head";
static NSString *EVENT_BASIC_SLEEP      = @"basic/sleep";
static NSString *EVENT_BASIC_LANGUAGE   = @"basic/language";
static NSString *EVENT_BASIC_DIAPER     = @"basic/diaper";

// feeding
static NSString *EVENT_FEEDING_MILK     = @"feeding/milk";
static NSString *EVENT_FEEDING_WATER    = @"feeding/water";
static NSString *EVENT_FEEDING_RICE     = @"feeding/rice";
static NSString *EVENT_FEEDING_FRUIT    = @"feeding/fruit";
static NSString *EVENT_FEEDING_VEGETABLE= @"feeding/vegetable";
static NSString *EVENT_FEEDING_CHEESE   = @"feeding/cheese";
static NSString *EVENT_FEEDING_BREAD    = @"feeding/bread";
static NSString *EVENT_FEEDING_EGG      = @"feeding/egg";


// activity - emotion
static NSString *EVENT_EMOTION_HAPPY    = @"emotion/emotion_happy";
static NSString *EVENT_EMOTION_SAD      = @"emotion/emotion_sad";
static NSString *EVENT_EMOTION_SURPRISE = @"emotion/emotion_surprise";
static NSString *EVENT_EMOTION_ANGRY    = @"emotion/emotion_angry";
static NSString *EVENT_EMOTION_DISGUST  = @"emotion/emotion_disgust";
static NSString *EVENT_EMOTION_FEAR     = @"emotion/emotion_fear";

static NSString *EVENT_MOTOR_STAND      = @"motor_skill/motor_skill_stand";
static NSString *EVENT_MOTOR_WALK       = @"motor_skill/motor_skill_walk";
static NSString *EVENT_MOTOR_RUN        = @"motor_skill/motor_skill_run";
static NSString *EVENT_MOTOR_DANCE      = @"motor_skill/motor_skill_dance";
static NSString *EVENT_MOTOR_JUMP       = @"motor_skill/motor_skill_jump";
static NSString *EVENT_MOTOR_CRUISE     = @"motor_skill/motor_skill_cruise";
static NSString *EVENT_MOTOR_CRAWL      = @"motor_skill/motor_skill_crawl";
static NSString *EVENT_MOTOR_SIT        = @"motor_skill/motor_skill_sit";
static NSString *EVENT_MOTOR_ROLLOVER   = @"motor_skill/motor_skill_roll_over";
static NSString *EVENT_MOTOR_KICKLEG    = @"motor_skill/motor_skill_kick_leg";
static NSString *EVENT_MOTOR_LIFTNECK   = @"motor_skill/motor_skill_lift_neck";

#endif
