//
//  totHomeViewController.h
//  totdev
//
//  Created by Lixing Huang on 4/11/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Utility/totCameraViewController.h"
#import "totBookListViewController.h"

@class totImageView;
@class totMediaLibrary;

enum {
    kBasicLanguage=0,
    kBasicSleep=1,
    kBasicHeight=2,
    kBasicFood=3,
    kBasicDiaper=4,
    kBasicHealth=5,
    kBasicWeight=6,
    kBasicHead=7
};

typedef enum {
    Animation_None,
    Animation_Left_To_Right,
    Animation_Right_To_Left,
    Animation_Fade_And_Scale
} ANIMATIONTYPE;

@interface totHomeEntryViewController : UIViewController <CameraViewDelegate, UIScrollViewDelegate> {
    totImageView* mPhotoViewA;
    totImageView* mPhotoViewB;
    UIView* activityView;
    
    UIButton* cameraBtn;
    UIButton* menuBtn;
    UIButton* scrapbookBtn;
    
    totMediaLibrary* mediaLib;
    
    MediaInfo* currentPhoto;
    
    // Message passed to the next view.
    NSMutableDictionary* mMessage;
    
    totBookListViewController* scrapbookListController;
    
    // activity related stuff
    NSArray* allActivities;             // all available activities
    NSMutableArray* activityButtons;    // hold all the actual buttons
    
    UIView* selectedActivities_bgView;
    UIImageView* selectedActivities_lineView;
    
    BOOL activity_animation_on; // activity animation is on
    
    // for debug
    UILabel* photoPositionLabel;
    
    // auto play
    BOOL autoPlay;
    
    // icon size change when switch between selected and not selected
    CGSize activityIconSizeChange;
}

@property (nonatomic, assign) totHomeRootController *homeRootController;

@property (nonatomic, readonly) int MAX_SELECTED_ACTIVITIES;

@end
