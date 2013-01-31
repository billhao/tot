//
//  totReviewTableViewController.h
//  totdev
//
//  Created by Lixing Huang on 5/28/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "totReviewRootController.h"

@interface totReviewTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *mReviewTable;
    
    UIView *mLoadingCell; //mLoadingCell is a UIView containing the loading icon
    NSMutableArray *mData; //mData contains a list of cell views
    NSString *mCurrentType;
    
    totReviewRootController * mRootController;
}

@property (nonatomic, retain) IBOutlet UITableView *mReviewTable;

- (void)setTypeName:(NSString*)t;
- (void)setData:(NSArray*)dat;
- (void)appendData:(NSArray*)dat;
- (void)emptyData;
- (void)setRootController:(totReviewRootController*)parent;

@end
