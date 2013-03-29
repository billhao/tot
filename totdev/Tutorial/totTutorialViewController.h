//
//  tutorialViewController.h
//  totdev
//
//  Created by Hao Wang on 3/28/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface totTutorialViewController : UIViewController <UIScrollViewDelegate> {
    UIScrollView* tutorialScrollView;
    
    int image_cnt;
    BOOL scrollCanceled;
}

@end
