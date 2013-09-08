//
//  totTimelineController.h
//  totdev
//
//  Created by Lixing Huang on 6/29/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "totHomeRootController.h"
#import "totTimeline.h"

@interface totTimelineController : UIViewController

@property(nonatomic, retain) totHomeRootController* homeController;
@property(nonatomic, retain) totTimeline* timeline_;

- (void) loadEventsFrom:(int)start limit:(int)limit;

@end
