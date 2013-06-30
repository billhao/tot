//
//  totReviewRootController.h
//  totdev
//
//  Created by Lixing Huang on 4/11/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Model/totModel.h"

@class totReviewTableViewController;
@class totBookViewController;
@class totTimelineController;

@interface totReviewRootController : UIViewController {
    totReviewTableViewController* tableViewController;
    totBookViewController* mBookController;
    totTimelineController* mTimelineController;
    totModel* mModel;
    int mCurrentBabyId;
    int mOffset;
}

@property (nonatomic, retain) totReviewTableViewController* tableViewController;
@property (nonatomic, retain) totBookViewController* mBookController;
@property (nonatomic, retain) totTimelineController* mTimelineController;
@property (nonatomic, assign) totModel * mModel;
@property (nonatomic, assign) int mOffset;
@property (nonatomic, assign) int mCurrentBabyId;

- (void) loadEvents:(BOOL)refresh ofType:(NSString*) type;

@end
