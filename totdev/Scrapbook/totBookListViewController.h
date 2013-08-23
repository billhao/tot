//
//  totBookEntryViewController.h
//  totdev
//
//  Created by Hao Wang on 8/11/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "totBookViewController.h"

@interface totBookListViewController : UIViewController <UIScrollViewDelegate> {
    UINavigationController *navController;
    UIView* bookListView; // a scroll view of books and templates
    UIScrollView* scrollView;
    UIButton* deleteBtn;
    NSMutableArray* bookBtnList;
    
    totBookViewController* mCurrentBook;
    
    NSMutableArray* booksAndTemplates;
}

@property(strong, nonatomic) UIViewController* parentController;

- (void)closeBook:(BOOL)modified;

@end
