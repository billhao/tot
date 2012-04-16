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

@interface totActivityRootController : UIViewController {
    totActivityEntryViewController *activityEntryViewController;
    totActivityViewController *activityViewController;
    totActivityInfoViewController *activityInfoViewController;
    totActivityAlbumViewController *activityAlbumViewController;
}

@property (nonatomic, retain) totActivityEntryViewController *activityEntryViewController;
@property (nonatomic, retain) totActivityViewController *activityViewController;
@property (nonatomic, retain) totActivityInfoViewController *activityInfoViewController;
@property (nonatomic, retain) totActivityAlbumViewController *activityAlbumViewController;

@end
