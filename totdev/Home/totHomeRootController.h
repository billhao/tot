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

enum {
    kHomeViewEntryView  = 0,
    kTimeline           = 1,
    kScrapbook          = 2,
};

@interface totHomeRootController : UIViewController {
    totHomeEntryViewController* homeEntryViewController;
//    totHomeFeedingViewController* homeFeedingViewController;
//    totHomeHeightViewController* homeHeightViewController;
//    totHomeActivityLabelController* homeActivityLabelController;
//    totHomeActivityBrowseController* homeActivityBrowseController;
//    totHomeAlbumBrowseController* homeAlbumBrowseController;
    
    int mCurrentViewIndex;
}

@property (nonatomic, retain) totHomeEntryViewController* homeEntryViewController;
@property (nonatomic, retain) totTimelineController* timelineController;

//@property (nonatomic, retain) totHomeFeedingViewController* homeFeedingViewController;
//@property (nonatomic, retain) totHomeHeightViewController* homeHeightViewController;
//@property (nonatomic, retain) totHomeActivityLabelController* homeActivityLabelController;
//@property (nonatomic, retain) totHomeActivityBrowseController* homeActivityBrowseController;
//@property (nonatomic, retain) totHomeAlbumBrowseController* homeAlbumBrowseController;


- (void) switchTo:(int)viewIndex withContextInfo:(NSMutableDictionary*)info;

@end
