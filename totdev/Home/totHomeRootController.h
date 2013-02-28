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

enum {
    kHomeViewEntryView  = 0,
    kHomeViewFeedView   = 1,
    kHomeViewHeightView = 2,
};

@interface totHomeRootController : UIViewController {
    totHomeEntryViewController *homeEntryViewController;
    totHomeFeedingViewController *homeFeedingViewController;
    totHomeHeightViewController *homeHeightViewController;
    
    int mCurrentViewIndex;
}

@property (nonatomic, retain) totHomeEntryViewController *homeEntryViewController;
@property (nonatomic, retain) totHomeFeedingViewController *homeFeedingViewController;
@property (nonatomic, retain) totHomeHeightViewController *homeHeightViewController;

- (void) switchTo:(int)viewIndex withContextInfo:(NSMutableDictionary*)info;

@end
