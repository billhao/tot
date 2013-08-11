//
//  totHomeRootController.h
//  totdev
//
//  Created by Lixing Huang on 4/11/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <UIKit/UIKit.h>


@class totHomeEntryViewController;
@class totHomeFeedingViewController;
@class totHomeHeightViewController;
@class totHomeActivityLabelController;
@class totHomeActivityBrowseController;
@class totHomeAlbumBrowseController;
@class totTimelineController;

enum {
    kHomeViewEntryView  = 0,
    kHomeViewFeedView   = 1,
    kHomeViewHeightView = 2,
    kHomeActivityLabelController = 3,
    kHomeActivityBrowseController = 4,
    kHomeAlbumBrowseController = 5,
};

@interface totHomeRootController : UIViewController {
    totHomeEntryViewController* homeEntryViewController;
    totHomeFeedingViewController* homeFeedingViewController;
    totHomeHeightViewController* homeHeightViewController;
    totHomeActivityLabelController* homeActivityLabelController;
    totHomeActivityBrowseController* homeActivityBrowseController;
    totHomeAlbumBrowseController* homeAlbumBrowseController;
    
    totTimelineController* timelineController;
    
    int mCurrentViewIndex;
}

@property (nonatomic, retain) totHomeEntryViewController* homeEntryViewController;
@property (nonatomic, retain) totHomeFeedingViewController* homeFeedingViewController;
@property (nonatomic, retain) totHomeHeightViewController* homeHeightViewController;
@property (nonatomic, retain) totHomeActivityLabelController* homeActivityLabelController;
@property (nonatomic, retain) totHomeActivityBrowseController* homeActivityBrowseController;
@property (nonatomic, retain) totHomeAlbumBrowseController* homeAlbumBrowseController;

@property (nonatomic, retain) totTimelineController* timelineController;

- (void) switchTo:(int)viewIndex withContextInfo:(NSMutableDictionary*)info;

@end
