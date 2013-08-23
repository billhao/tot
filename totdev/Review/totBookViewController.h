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
@class totBook;
@class totPageView;

@interface totBookViewController : UIViewController {
    // views
    totBookView* bookview;
    UIButton* optionMenuBtn;
    UIView* optionView;
    
    NSMutableArray* mPageViews;
    int currentPageIndex;
    
    // data
    totBook* mTemplateBook;  // only stores template.
    totBook* mBook;  // book containing the real data.

    totBookListViewController* bookListVC;
    
    CGRect fullPageFrame; // this could be (0,0,320,480) for portrait or (0,0,480,320) for landscape. adjust when needed.
}

- (id)init:(totBookListViewController*)vc;

- (void)openBook:(NSString*)bookid bookname:(NSString*)bookname isTemplate:(BOOL)isTemplate;
- (void)hideOptionMenu:(BOOL)hidden;
- (void)hideOptionMenuAndButton:(BOOL)hide;
- (IBAction)swipeGestureEvent:(UISwipeGestureRecognizer *)swipeRecognizer;

+ (void)savePageImageToFile:(NSString*)bookid page:(totPageView*)page;
+ (UIImage*)loadPageImageFromFile:(NSString*)bookid;

@end
