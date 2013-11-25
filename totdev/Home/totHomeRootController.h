//
//  totHomeRootController.h
//  totdev
//
//  Created by Lixing Huang on 4/11/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <UIKit/UIKit.h>


@class totHomeEntryViewController;
@class totTimelineController;
@class totBookListViewController;
@class totSettingRootController;
@class totTutorialViewController;

enum {
    kHomeViewEntryView  = 0,
    kTimeline           = 1,
    kScrapbook          = 2,
    kSetting            = 3,
    KTutorial           = 4
};

@interface totHomeRootController : UIViewController {
    int mCurrentViewIndex;
}

@property (nonatomic, retain) totHomeEntryViewController* homeEntryViewController;
@property (nonatomic, retain) totTimelineController* timelineController;
@property (nonatomic, retain) totBookListViewController* scrapbookListController;
@property (nonatomic, retain) totSettingRootController* settingController;
@property (nonatomic, retain) totTutorialViewController* tutorialController;


- (void) switchTo:(int)viewIndex withContextInfo:(NSMutableDictionary*)info;

// release all views when log out
- (void)releaseAllViews;

@end
