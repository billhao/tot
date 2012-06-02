//
//  totReviewRootController.h
//  totdev
//
//  Created by Lixing Huang on 4/11/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class totReviewTableViewController;

@interface totReviewRootController : UIViewController {
    totReviewTableViewController *tableViewController;
}

@property (nonatomic, retain) totReviewTableViewController *tableViewController;

@end
