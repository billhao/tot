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

@interface totHomeEntryViewController : UIViewController <CameraViewDelegate, UIScrollViewDelegate> {
    totImageView* mPhotoView;
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

    UIView* selectedActivities_bgView;
    UIImageView* selectedActivities_lineView;
    
    BOOL activity_animation_on; // activity animation is on
    
    // for debug
    UILabel* photoPositionLabel;
}

@property (nonatomic, assign) totHomeRootController *homeRootController;

@property (nonatomic, readonly) int MAX_SELECTED_ACTIVITIES;

@end
