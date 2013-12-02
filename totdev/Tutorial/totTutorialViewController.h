//
//  tutorialViewController.h
//  totdev
//
//  Created by Hao Wang on 3/28/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import <UIKit/UIKit.h>

@class totHomeRootController;

@interface totTutorialViewController : UIViewController <UIScrollViewDelegate> {
    UIScrollView* tutorialScrollView;
    UIPageControl* pageControl;
    
    int image_cnt;
    BOOL scrollCanceled;
    CGRect _frame;
    
}

@property (nonatomic, retain) totHomeRootController* homeController;
@property (nonatomic, assign) int nextview; // switch to the next view, default to home

- (id)initWithFrame:(CGRect)frame;

@end
