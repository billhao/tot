//
//  totBookViewController.h
//  totdev
//
//  Created by Lixing Huang on 6/11/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import <UIKit/UIKit.h>

@class totPageElementView;
@class totBookView;
@class totBookListViewController;

@interface totBookViewController : UIViewController {
    totBookView* bookview;
    UIButton* optionMenuBtn;
    UIView* optionView;
    
    totBookListViewController* bookListVC;
}

- (id)init:(totBookListViewController*)vc;

- (void)open:(NSString*)bookname isTemplate:(BOOL)isTemplate;
- (void)hideOptionMenuAndButton:(BOOL)hide;
- (IBAction)swipeGestureEvent:(UISwipeGestureRecognizer *)swipeRecognizer;

@end
