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
const static int SCREEN_H = 411;

enum {
    kActivityEntryView = 0,
    kActivityView = 1,
    kActivityInfoView = 2,
    kActivityAlbumView = 3
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

@end
