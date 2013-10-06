//
//  totBookEntryViewController.m
//  totdev
//
//  Created by Hao Wang on 8/11/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import "totBookListViewController.h"
#import "AppDelegate.h"
#import "totEventName.h"
#import "totUtility.h"
#import "totBooklet.h"
#import <QuartzCore/QuartzCore.h>

@interface totBookListViewController ()

@end

@implementation totBookListViewController

@synthesize homeController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        mCurrentBook = nil;
        booksAndTemplates = nil;
        deleteBtn = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // create navigation bar
    float navbar_height = 42;
    
    // create book list scroll view
    [self createScrollView:navbar_height];
    
    // load all books and templates
    [self loadBooksAndTemplates:TRUE];

    // this is created the last because it needs to be on top of the scroll view
    [self createNavigationBar];
    
    // right swipe
    UISwipeGestureRecognizer* rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGestureEvent:)];
    rightSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [scrollView addGestureRecognizer:rightSwipeRecognizer];
    [rightSwipeRecognizer release];
}

- (void)dealloc {
    [super dealloc];
    
    if( mCurrentBook != nil )
        [mCurrentBook release];
    if( booksAndTemplates != nil )
        [booksAndTemplates release];
    if( deleteBtn != nil )
        [deleteBtn release];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return FALSE;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// open a book
- (void)openBook:(int)bookID {
    // open the book
    if( mCurrentBook == nil ) {
        mCurrentBook = [[totBookViewController alloc] init:self];
    }
    NSMutableDictionary* book = booksAndTemplates[bookID];
    [mCurrentBook openBook:[book objectForKey:@"id"] bookname:[book objectForKey:@"name"] isTemplate:[[book objectForKey:@"type"] isEqualToString:@"template"]];
    
    // show the book
    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:mCurrentBook animated:TRUE completion:nil];
}

- (void)closeBook:(BOOL)modified {
    if( modified ) {
        // refresh
        [self loadBooksAndTemplates:TRUE];
    }
    [self dismissViewControllerAnimated:TRUE completion:^{
        [mCurrentBook release];
        mCurrentBook = nil;
    }];
}

- (void)deleteBook:(int)bookID thumbnail:(UIView*)v {
    NSMutableDictionary* book = booksAndTemplates[bookID];
    BOOL isTemplate = [[book objectForKey:@"type"] isEqualToString:@"template"];
    if( isTemplate ) return; // do not allow delete template

    if( deleteBtn == nil )
        [self createDeleteButton];
    deleteBtn.tag = bookID; // set the book id
    deleteBtn.alpha = 0;
    // TODO delete button size
    deleteBtn.frame = CGRectMake(v.frame.size.width-45, 0, 45, 45);
    [v addSubview:deleteBtn];
    [UIView animateWithDuration:0.3 animations:^{
        deleteBtn.alpha = 1.0;
    }];
}

#pragma mark - Event handler

// Respond to a swipe gesture
- (IBAction)swipeGestureEvent:(UISwipeGestureRecognizer *)swipeRecognizer {
    if( swipeRecognizer.direction == UISwipeGestureRecognizerDirectionRight ) {
        for (UIView* v in bookBtnList) {
            CGPoint pt = [swipeRecognizer locationInView:v];
            if( [v pointInside:pt withEvent:nil] ) {
                [self deleteBook:v.tag thumbnail:v ];
                break;
            }
        }
    }
}


- (void)bookSelected:(id)sender {
    UIButton* btn = (UIButton*)sender;
    int bookID = btn.superview.tag;
    [self openBook:bookID];
}


- (void)deleteBookBtnSelected:(id)sender {
    // hide the delete button
    
    int bookID = deleteBtn.tag;
    NSMutableDictionary* book = booksAndTemplates[bookID];
    NSString* bookid   = [book objectForKey:@"id"];
    NSString* bookname = [book objectForKey:@"name"];
    NSLog(@"delete book %d %@ %@", bookID, bookid, bookname);

    // delete the book from db
    [totBook deleteBook:bookid bookname:bookname];
    [booksAndTemplates removeObjectAtIndex:bookID];
    
    // remove the book thumbnail from view
    UIView* bookView = bookBtnList[bookID];
    [UIView animateWithDuration:0.2 animations:^{
        deleteBtn.alpha = 0;
        bookView.alpha = 0;
    } completion:^(BOOL finished) {
        [deleteBtn removeFromSuperview];

        [self loadBooksAndTemplates:FALSE];
    }];
    
}

- (void)homeButtonPressed:(id)sender {
    // go back to home page
    [homeController switchTo:kHomeViewEntryView withContextInfo:nil];
}


# pragma mark - Helper functions

- (void)loadBooksAndTemplatesData {
    if( booksAndTemplates == nil )
        booksAndTemplates = [[NSMutableArray alloc] init];
    else
        [booksAndTemplates removeAllObjects];
    
    // load books from DB
    NSMutableArray* events = [global.model getEvent:global.baby.babyID event:SCRAPBOOK];
    for ( totEvent* e in events ) {
        NSMutableDictionary* book = [[NSMutableDictionary alloc] init];
        NSArray* names = [e.name componentsSeparatedByString:@"/"];
        if( names.count != 3 ) continue;
        [book setObject:names[1] forKey:@"id"];
        [book setObject:names[2] forKey:@"name"];
        [book setObject:@"book" forKey:@"type"];
        [booksAndTemplates addObject:book];
        [book release];
    }
    
    //    NSMutableArray* books = [[[NSMutableArray alloc]initWithObjects:@"book1", @"book2", @"book1", @"book2", @"book1", @"book2", @"book1", @"book2", @"book1", @"book2", nil] autorelease];
    //    [booksAndTemplates addObjectsFromArray:books];
    //    [books release];
    
    // load book templates from resources
    // TODO this iterates basically all resource files (several hundreds). need to be improved
    NSString* templatePath = [[NSBundle mainBundle] resourcePath];
    NSArray* files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:templatePath error:nil];
    for (NSString* filename in files) {
        if( [[filename pathExtension] isEqualToString:@"tpl"] ) {
            NSMutableDictionary* book = [[NSMutableDictionary alloc] init];
            [book setObject:@"" forKey:@"id"];
            [book setObject:[[filename lastPathComponent] stringByDeletingPathExtension] forKey:@"name"];
            [book setObject:@"template" forKey:@"type"];
            [booksAndTemplates addObject:book];
            [book release];
        }
    }
    
    NSLog(@"%@", booksAndTemplates);
}

- (void)loadBooksAndTemplates:(int)bLoadData {
    if( bLoadData ) {
        // load data first
        [self loadBooksAndTemplatesData];
    }
        
    // remove any view already there
    [[scrollView subviews]
     makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    int margin_x = 20;
    float margin_x_left = 5.5; // the thumbnail size is 618
    float margin_x_right = 5.5;
    int margin_y = 6;
    int margin_y_top = 8;
    int margin_y_bottom = 8;
    float icon_height = 200;
    float icon_width = 309;
    int label_height = 24;
    int columns = 1;
    int rows = ceil((double)booksAndTemplates.count/columns);
    UIFont* font1 = [UIFont fontWithName:@"Raleway-Medium" size:18];
    UIColor* color1 = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1.0];

    bookBtnList = [[NSMutableArray alloc] initWithCapacity:booksAndTemplates.count];
    for (int r=0; r<rows; r++) {
        for( int c=0; c<columns; c++) {
            int i = r * columns + c; // book #
            if( i >= booksAndTemplates.count ) break;
            
            NSMutableDictionary* book = booksAndTemplates[i];
            BOOL isTemplate = [[book objectForKey:@"type"] isEqualToString:@"template"];
            NSString* bookid = [book objectForKey:@"id"];
            
            // TOOD debug
            //if( !isTemplate ) continue;

            // get the icon file names, just replace space with underscore
            NSString* bookIcon = [book objectForKey:@"name"];
            NSString* bookIconPressed = bookIcon;// [NSString stringWithFormat:@"activity_%@_pressed", bookIcon];
            
            UIView* bookView = [[UIView alloc] init];
            bookView.frame = CGRectMake(margin_x_left+c*(icon_width+margin_x), margin_y_top+r*(icon_height+margin_y), icon_width, icon_height);
            UIButton* bookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            bookBtn.frame = bookView.bounds;
            [bookBtn addTarget:self action:@selector(bookSelected:) forControlEvents:UIControlEventTouchUpInside];
            [bookView addSubview:bookBtn];
            //[totUtility enableBorder:bookBtn];
            if( isTemplate ) {
                [bookBtn setImage:[UIImage imageNamed:bookIcon] forState:UIControlStateNormal];
                [bookBtn setImage:[UIImage imageNamed:bookIconPressed] forState:UIControlStateHighlighted];
            }
            else {
                // background
                UIImageView* bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sb_book_bg"]];
                [bookView addSubview:bg];
                
                // book thumbnail
                UIImage* coverImg = [totBookViewController loadPageImageFromFile:bookid];
                UIImageView* coverImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 7, 278, 153)];
                coverImgView.image = coverImg;
                [bookView addSubview:coverImgView];
                coverImgView.layer.borderWidth = 0.5;
                coverImgView.layer.borderColor = [UIColor grayColor].CGColor;
                [bookView addSubview:coverImgView];

                bookBtn.backgroundColor = [UIColor clearColor];
            }
            bookView.tag = i;
            [bookBtnList addObject:bookView];
            
            UILabel* bookLabel = [[UILabel alloc] init];
            bookLabel.frame = CGRectMake(margin_x_left+c*(icon_width+margin_x)+15, margin_y_top+r*(icon_height+label_height+margin_y)+170, icon_width-30, label_height);
            bookLabel.backgroundColor = [UIColor clearColor];
            bookLabel.alpha = 0.8;
            bookLabel.text = [book objectForKey:@"name"];
            bookLabel.tag = i;
            bookLabel.font = font1;
            bookLabel.textColor = color1;
            [bookLabel sizeToFit];
            
            // TODO in the release, thumbnails for templates should be the same as books
            if( isTemplate )
                bookLabel.hidden = TRUE;
            
            [scrollView addSubview:bookView];
            [scrollView addSubview:bookLabel];
            [bookLabel release];
            [bookView release];
        }
    }
    scrollView.contentSize = CGSizeMake(320, margin_y_top+margin_y_bottom+rows*(icon_height+margin_y));
    float h = scrollView.contentSize.height;
    // scroll to top
//    scrollView.contentOffset = CGPointMake(0, 0);
    
    // TODO vertical scroll bar not shown after edit book & reload book list
}

// create a scroll view of books and templates
- (void)createScrollView:(float)y_offset {
    float xx = self.view.bounds.size.height;
    int scrollview_height = self.view.bounds.size.height - y_offset; // 480 - 20 - 40navi
    
    // create the view
    bookListView = [[UIView alloc] initWithFrame:CGRectMake(0, y_offset, 320, scrollview_height)];
//    UIView* bg = [[UIView alloc] init];
//    bg.frame = CGRectMake(0, 0, 320, scrollview_height);
//    bg.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0f];
//    [bookListView addSubview:bg];
//    [bg release];
    
    // create the scroll view
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, scrollview_height)];
    UIImage* scrollViewBg = [UIImage imageNamed:@"scrapbook_bg"];
    scrollView.backgroundColor = [UIColor colorWithPatternImage:scrollViewBg];
    [bookListView addSubview:scrollView];
    
    scrollView.pagingEnabled = FALSE;
    scrollView.showsVerticalScrollIndicator = TRUE;
    scrollView.showsHorizontalScrollIndicator = FALSE;
    scrollView.delegate = self;
    
    [self.view addSubview:bookListView];
}

- (void)createDeleteButton {
    deleteBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [deleteBtn setImage:[UIImage imageNamed:@"delete_button"] forState:UIControlStateNormal];
    //[deleteBtn setImage:[UIImage imageNamed:@"delete_button_pressed"] forState:UIControlStateHighlighted];
    [deleteBtn addTarget:self action:@selector(deleteBookBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
}

// return the height of the nav bar
- (void)createNavigationBar {
    // create navigation bar
    UIImage* navbar_img = [UIImage imageNamed:@"scrapbook_navbar"];
    UIView* navbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, navbar_img.size.height)];
    //navbar.backgroundColor = [UIColor colorWithRed:116.0/255 green:184.0/255 blue:229.0/255 alpha:1.0];
    navbar.backgroundColor = [UIColor colorWithPatternImage:navbar_img];
    
    // create home button
    UIImage* homeImg = [UIImage imageNamed:@"timeline_home"];
    UIImage* homeImgPressed = [UIImage imageNamed:@"timeline_home_pressed"];
    UIButton* homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    homeBtn.frame = CGRectMake(277.5-12, 12-12, homeImg.size.width+24, homeImg.size.height+24); // make the button 24px wider and longer
    [homeBtn setImage:homeImg forState:UIControlStateNormal];
    [homeBtn setImage:homeImgPressed forState:UIControlStateHighlighted];
    [homeBtn addTarget:self action:@selector(homeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [navbar addSubview:homeBtn];
    
    [self.view addSubview:navbar];
    [navbar release];
}


@end
