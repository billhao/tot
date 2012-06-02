//
//  totReviewTableViewController.h
//  totdev
//
//  Created by Lixing Huang on 5/28/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface totReviewTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *mReviewTable;
    NSMutableArray *mData;
}

@property (nonatomic, retain) IBOutlet UITableView *mReviewTable;

- (void)setData:(NSArray*)dat;

@end
