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

@interface totHomeRootController : UIViewController {
    totHomeEntryViewController *homeEntryViewController;
    totHomeFeedingViewController *homeFeedingViewController;
}

@property (nonatomic, retain) totHomeEntryViewController *homeEntryViewController;
@property (nonatomic, retain) totHomeFeedingViewController *homeFeedingViewController;

@end
