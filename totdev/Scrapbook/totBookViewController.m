//
//  totBookViewController.m
//  totdev
//
//  Created by Lixing Huang on 6/11/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import "totBookViewController.h"
#import "totBookletView.h"
#import "totBooklet.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "totBookListViewController.h"
#import "totUtility.h"

@interface totBookViewController ()

@end

@implementation totBookViewController

@synthesize fullPageFrame, disablePageSwipe;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
- (id)init:(totBookListViewController*)vc
{
    //self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self = [super init];
    if (self) {
        // Custom initialization
        mPageViews = [[NSMutableArray alloc] init];
        currentPageIndex = -1;

        bookview = nil;
        
        mBook = nil;
        mTemplateBook = nil;
        
        bookListVC = vc;
        
        fullPageFrame = CGRectMake(0, 0, 480, 320);
        disablePageSwipe = FALSE;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:240 green:240 blue:240 alpha:1.0];
    self.view.clipsToBounds = TRUE;
    
    [self.view addSubview:bookview];
    
    // bind gesture events
    // left swipe
    UISwipeGestureRecognizer* leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGestureEvent:)];
    leftSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftSwipeRecognizer];
    [leftSwipeRecognizer release];
    
    // right swipe
    UISwipeGestureRecognizer* rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGestureEvent:)];
    rightSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipeRecognizer];
    [rightSwipeRecognizer release];

    NSLog(@"bookvc viewdidload %@", [totUtility getFrameString:self.view.frame]);
}

- (void)viewWillAppear:(BOOL)animated {
    // hide status bar
    [[UIApplication sharedApplication] setStatusBarHidden:TRUE withAnimation:UIStatusBarAnimationNone];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    CGRect f = appDelegate.window.frame;
    appDelegate.loginNavigationController.view.frame = f;
    self.view.frame = f;
    [appDelegate.loginNavigationController.view setNeedsLayout];
    
    [self createOptionMenu];
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"bookvc viewdidappear %@", [totUtility getFrameString:self.view.frame]);
}

- (void)viewWillDisappear:(BOOL)animated {
    // show status bar
    [[UIApplication sharedApplication] setStatusBarHidden:FALSE withAnimation:UIStatusBarAnimationNone];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    CGRect f = appDelegate.window.frame;
    appDelegate.loginNavigationController.view.frame = f;
    self.view.frame = f;
    [appDelegate.loginNavigationController.view setNeedsLayout];
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [super dealloc];
    if( bookview != nil) [bookview release];
    if(mTemplateBook != nil) [mTemplateBook release];
    if(mBook != nil) [mBook release];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    NSLog(@"bookvc preferredInterfaceOrientationForPresentation");
    if( [mBook orientationLandscape] )
        return UIInterfaceOrientationLandscapeRight;
    else
        return UIInterfaceOrientationPortrait;
}

- (NSUInteger)supportedInterfaceOrientations {
    if( [mBook orientationLandscape] )
        return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
    else
        return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return TRUE;
}

- (void)viewWillLayoutSubviews {
    NSLog(@"bookvc viewWillLayoutSubviews %@", [totUtility getFrameString:self.view.bounds]);
    bookview.frame = self.view.bounds;
}

#pragma mark - Book operations
// load book data and show it
- (void)openBook:(NSString*)bookid bookname:(NSString*)bookname isTemplate:(BOOL)isTemplate {
    // load book and template data first
    if( isTemplate ) {
        // load template
        [self loadTemplateFile:bookname]; // template has to be loaded anyway

        // set up a new book
        mBook = [[totBook alloc] init];
        mBook.bookname = mTemplateBook.templateName;
        mBook.templateName = bookname;
        mBook.orientationLandscape = mTemplateBook.orientationLandscape;

        // add all pages from template to book
        // TODO in future this block should move to the copy function of totBook
        // like totPage.copy (a deep copy)
        for( int i=0; i<mTemplateBook.pageCount; i++ ) {
            totPage* pageData;
            pageData = [[mTemplateBook getPageWithIndex:i] copy:mBook];
            [self addPage:pageData atIndex:i];
            [pageData release];
        }
    }
    else {
        // load book
        mBook = [totBook loadFromDB:bookid bookname:bookname];
        
        // load template
        [self loadTemplateFile:mBook.templateName]; // template has to be loaded anyway
    }
    
    // rotate the coordinates for window if landscape
    CGRect f = [totUtility getWindowRect];
    if( mBook.orientationLandscape ) {
        int k = f.origin.x;
        f.origin.x = f.origin.y;
        f.origin.y = k;
        k = f.size.width;
        f.size.width = f.size.height;
        f.size.height = k;
    }
    fullPageFrame = f;
    
    // set up option button. its position depends on orientation
    [self setupOptionButton];
    
    // set up the views
    bookview = [[totBookView alloc] initWithFrame:fullPageFrame];
    bookview.bookvc = self;
    
    [self.view insertSubview:bookview atIndex:0];
    
    [self gotoPage:0];
}

- (void)closeBook {
    // prompt to save if it is a template and has been modified
    
    // save a thumbnail of the first page
    if( mPageViews.count > 0 ) {
        [totBookViewController savePageImageToFile:mBook.bookid page:mPageViews[0]];
    }
    
    [bookListVC closeBook:TRUE]; // release the bookvc
}

// change the book name
- (void)editBookName {
    // show the input window
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Edit book name" message:@"What is the new book name?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert textFieldAtIndex:0].text = mBook.bookname;
    [alert show];
    [alert release];
}

#pragma mark - Page operations

- (void)nextPage {
    if( currentPageIndex >= (int)mBook.pageCount-1 ) {
        // indicate this is already the last page
        return;
    }
    totPageView* curr = [self getPageView:currentPageIndex];
    totPageView* next = [self getPageView:currentPageIndex+1];
    [bookview swipeViews:curr view2:next leftToRight:FALSE];
    currentPageIndex++;
}

- (void)previousPage {
    if( currentPageIndex <= 0 ) {
        // indicate this is already the first page
        return;
    }
    totPageView* curr = [self getPageView:currentPageIndex];
    totPageView* prev = [self getPageView:currentPageIndex-1];
    [bookview swipeViews:prev view2:curr leftToRight:TRUE];
    currentPageIndex--;
}

// New page means an empty page, so that there is no data associated with the page yet.
// add a random page if pageName is nil
- (void)addNewPage:(NSString*)pageName {
    if (!mTemplateBook) {
        printf("You MUST call loadTemplateFile first\n");
        return;
    }
    totPage* pageData = nil;
    if( pageName )
        pageData = [[mTemplateBook getPage:pageName] copy:mBook];
    else
        pageData = [[mTemplateBook getRandomPage] copy:mBook];
    if (!pageData) return;  // Invalid page name.

    // add it to mBook (since we are adding a real page.)
    int newPageIndex = currentPageIndex + 1;

    // add a view.
    [self addPage:pageData atIndex:newPageIndex];
    
    [self nextPage];
}

- (void)addPage:(totPage*)pageData atIndex:(int)pageIndex{
    // add it to mBook (since we are adding a real page.)
    [mBook insertPage:pageData pageIndex:pageIndex];
}

// return a view at an index. create it if it is nil.
- (totPageView*)getPageView:(int)pageIndex {
    if( pageIndex < 0 ) return nil;
    
    // check pageviews has enough capacity
    // mPageViews.count is unsigned int. pageIndex (could be -1) will be converted to unsigned int so -1 may be > mPageViews.count
    while( (pageIndex >= (int)mPageViews.count) && (pageIndex < (int)mBook.pageCount) ) {
        // add nil page
        NSLog(@"Add a nil page");
        [mPageViews addObject:[NSNull null]];
    }

    // get or create the pageview
    totPageView* page = mPageViews[pageIndex];
    if( [page isKindOfClass:NSNull.class] ) {
        // create the page view
        totPage* pageData = [mBook getPageWithIndex:pageIndex];
        // add a view.
        // TODO orientation
        page = [[totPageView alloc] initWithFrame:fullPageFrame pagedata:pageData bookvc:self];
        [mPageViews setObject:page atIndexedSubscript:pageIndex];
        [bookview addSubview:page];
        [page release];
    }
    return [mPageViews objectAtIndex:pageIndex];
}

- (void)gotoPage:(int)pageIndex {
    totPageView* page = [self getPageView:pageIndex];
    currentPageIndex = pageIndex;
    return;
    int newPageIndex = pageIndex;
    if ([mPageViews count] > 1) {
        totPageView* curr = page;
        curr.frame = CGRectMake(320, 0, self.view.frame.size.width, self.view.frame.size.height);
        totPageView* prev = [mPageViews objectAtIndex:newPageIndex-1];
        
        // swipe the previous page, and display the current page.
        [UIView beginAnimations:@"swipe" context:nil];
        [UIView setAnimationDuration:0.5f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        prev.frame = CGRectMake(-320, 0, self.view.frame.size.width, self.view.frame.size.height);
        curr.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    [page release];
}

- (void)deleteCurrentPage {
    // swipe the previous page, and display the current page.
    totPageView* curr = [mPageViews objectAtIndex:currentPageIndex];
    curr.clipsToBounds = TRUE;
    [UIView animateWithDuration:0.5f animations: ^{
        curr.frame = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 0, 0);
    } completion:^(BOOL finished) {
        // remove both page view and data
        int lastPageIndex = currentPageIndex;
        [mPageViews removeObjectAtIndex:lastPageIndex];
        [mBook deletePage:lastPageIndex];
        
        // swipe to the next page
        if( (int)mPageViews.count > currentPageIndex ) {
            // there is a page after it, go to that one
            totPageView* curr = [mPageViews objectAtIndex:currentPageIndex];
            [bookview swipeViews:nil view2:curr leftToRight:FALSE];
        }
        else if( mPageViews.count > 0 ) {
            // this is the last page, go to the page before it
            currentPageIndex--;
            totPageView* curr = [mPageViews objectAtIndex:currentPageIndex];
            [bookview swipeViews:curr view2:nil leftToRight:TRUE];
        }
        else {
            // this is the only page
            // add a new page, and swipe to the new page
            // next = newpage;
            currentPageIndex = -1;
            [self addNewPage:nil];
        }
    }];
}

#pragma mark - Event handler

// Respond to a swipe gesture
- (IBAction)swipeGestureEvent:(UISwipeGestureRecognizer *)swipeRecognizer {
    if( disablePageSwipe ) return;
    
    [self hideOptionMenu:TRUE];
    // Get the location of the gesture
    CGPoint location = [swipeRecognizer locationInView:self.view];
    NSLog(@"Swipe %d", swipeRecognizer.direction);
    if( swipeRecognizer.direction == UISwipeGestureRecognizerDirectionLeft ) {
        // go to next page
        [self nextPage];
    }
    else if( swipeRecognizer.direction == UISwipeGestureRecognizerDirectionRight ) {
        // go to prev page
        [self previousPage];
    }
}

- (void)optionButtonPressed:(id)sender {
    NSLog(@"option clicked");
    
    // hide option view
    optionView.hidden = TRUE;
    optionMenuBtn.hidden = FALSE;
    
    UIButton* btn = (UIButton*)sender;
    switch (btn.tag) {
        case 0:
            [self addNewPage:nil];
            break;
        case 1:
            [self deleteCurrentPage];
            break;
        case 2:
            [self editBookName];
            break;
        case 3:
            [self closeBook];
            break;
        default:
            break;
    }
    
    [mBook saveToDB];
}

- (void)optionMenuButtonPressed:(id)sender {
    optionView.hidden = FALSE;
    optionMenuBtn.hidden = TRUE;
}

- (void)hideOptionMenu:(BOOL)hidden {
    if( optionView.hidden != hidden) {
        optionView.hidden = hidden;
        optionMenuBtn.hidden = !hidden;
    }
}

- (void)hideOptionMenuAndButton:(BOOL)hide {
    if( hide ) {
        optionMenuBtn.alpha = 0;
        //        optionView.hidden = TRUE;
        //        optionMenuBtn.hidden = TRUE;
    }
    else {
        optionMenuBtn.hidden = FALSE;
        optionMenuBtn.alpha = 1;
        //        optionMenuBtn.hidden = FALSE;
    }
}

// edit book name
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"Entered: %@",[[alertView textFieldAtIndex:0] text]);
    if( buttonIndex == 1 ) {
        // delete the book
        [mBook deleteBook];

        mBook.bookname = [alertView textFieldAtIndex:0].text;
        
        // save to db with the new name
        [mBook saveToDB];
    }
}



#pragma mark - Helper functions

- (void)setupOptionButton {
    // add scrapbook option menu button
    if( !optionMenuBtn ) {
        optionMenuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        optionMenuBtn.alpha = 0.7;
        [optionMenuBtn setImage:[UIImage imageNamed:@"scrapbook_option_button"] forState:UIControlStateNormal];
        //optionBtn.backgroundColor = [UIColor blueColor];
        [optionMenuBtn addTarget:self action:@selector(optionMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:optionMenuBtn];
    }
    CGRect f = CGRectMake(fullPageFrame.size.width-66, fullPageFrame.size.height-66, 56, 56);
    //f = CGRectMake(420, 255, 56, 56);
    optionMenuBtn.frame = f;
}

- (void)createOptionMenu {
    if( optionView ) return;
    
    NSMutableArray* buttons = [[NSMutableArray alloc] initWithObjects:
                               @"add page",
                               @"delete page",
                               @"book name",
                               @"close book",
                               nil];

    int margin_x_left = 0;
    int margin_x_right = 0;
    int margin_y = 0;
    int margin_y_top = 0;
    int margin_y_bottom = 0;
    int icon_height = 38;
    int icon_width = 132;
    
    // create option view
    optionView = [[UIView alloc] init];
    // TODO orientation
    optionView.backgroundColor = [UIColor whiteColor];
    optionView.alpha = 0.9;
    optionView.layer.cornerRadius = 6;

    int w = margin_x_left+margin_x_right+icon_width;
    int h = buttons.count*(icon_height+margin_y)-margin_y+margin_y_top+margin_y_bottom;
    CGSize size = self.view.bounds.size;
    optionView.frame = CGRectMake(size.width-10-w, size.height-10-h, w, h);
    optionView.hidden = TRUE;
    
    // create the buttons
    for( int i=0; i<buttons.count; i++ ) {
        NSString* button = buttons[i];
        int y = margin_y_top+i*(icon_height+margin_y);

        // draw the separation line
        if( i != 0 ) {
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, y, w, .5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [optionView addSubview:line];
        [line release];
        }

        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(margin_x_left, y, icon_width, icon_height);
        [btn setTitle:button forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:0 green:122/255.0 blue:1 alpha:1] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:@"Raleway" size:16];
        //btn.titleLabel.textColor = [UIColor colorWithRed:0 green:122/255.0 blue:1 alpha:1];
        btn.tag = i;
        btn.backgroundColor = [UIColor clearColor];
//        NSString* button_pressed = [NSString stringWithFormat:@"%@_pressed", button];
//        [btn setImage:[UIImage imageNamed:button] forState:UIControlStateNormal];
//        [btn setImage:[UIImage imageNamed:button_pressed] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(optionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

        [optionView addSubview:btn];
    }
    [buttons release];
    
    [self.view addSubview:optionView];
}

- (void)loadTemplateFile:(NSString*)filename {
    NSString* path = [[NSBundle mainBundle] pathForResource:filename ofType:@"tpl"];
    if( path == nil ) {
        NSLog(@"Template file not found: %@", filename);
        return;
    }

    mTemplateBook = [[totBook alloc] init];
    [mTemplateBook loadFromTemplateFile:path]; // this is an empty book so there is no book name yet.
}

+ (void)savePageImageToFile:(NSString*)bookid page:(totPageView*)page {
    UIImage* img = [page renderToImage];
    
    // crop the screenshot by ratio of book preview size
    float crop_w = img.size.width;
    float crop_h = img.size.height;
    float ratio = 153/278.0; // height/width of the book preview area size
    if( crop_h > crop_w ) {
        // portrait, take the top section
        crop_h = ratio * crop_w;
        img = [totUtility crop:img rect:CGRectMake(0, 0, crop_w, crop_h)];
    }
    else {
        // landscape, take the middle section
        crop_h = ratio * crop_w;
        img = [totUtility crop:img rect:CGRectMake(0, (img.size.height-crop_h)/2, crop_w, crop_h)];
    }
    
    NSData* imgData = UIImagePNGRepresentation(img);
    NSString* imagePath = [[totModel GetDocumentDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"scrapbookCover/%@.png", bookid]];

    NSString* dir = [[totModel GetDocumentDirectory] stringByAppendingPathComponent:@"scrapbookCover"];

    // check for dir
    if (![[NSFileManager defaultManager] fileExistsAtPath:dir]) {
        NSError* error = nil;
        if( ![[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:NO attributes:nil error:&error] ) {
            NSLog(@"Cannot create scrapbook cover directory: %d %@", error.code, error.description);
        }
    }
    
    [imgData writeToFile:imagePath atomically:FALSE];
}

+ (UIImage*)loadPageImageFromFile:(NSString*)bookid {
    NSString* imagePath = [[totModel GetDocumentDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"scrapbookCover/%@.png", bookid]];
    return [UIImage imageWithContentsOfFile:imagePath];
}

@end


