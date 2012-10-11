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

@interface totReviewRootController : UIViewController {
    totReviewTableViewController *tableViewController;
    totModel *mModel;
    int mCurrentBabyId;
    int mOffset;
}

@property (nonatomic, retain) totReviewTableViewController *tableViewController;
@property (nonatomic, assign) totModel * mModel;
@property (nonatomic, assign) int mOffset;
@property (nonatomic, assign) int mCurrentBabyId;

- (void) loadEvents;

@end
