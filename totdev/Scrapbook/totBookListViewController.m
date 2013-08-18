//
//  totBookEntryViewController.m
//  totdev
//
//  Created by Hao Wang on 8/11/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import "totBookListViewController.h"
#import "AppDelegate.h"

@interface totBookListViewController ()

@end

@implementation totBookListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        mCurrentBook = nil;
        booksAndTemplates = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // load all books and templates
    [self loadBooksAndTemplates];
    
    // create navigation bar
    //navController = [[UINavigationController alloc] initWithRootViewController:self.parentViewController];
    
    // create book list scroll view
    [self createScrollView];
}

- (void)dealloc {
    [super dealloc];
    
    if( mCurrentBook != nil )
        [mCurrentBook release];
    if( booksAndTemplates != nil )
        [booksAndTemplates release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadBooksAndTemplates {
    if( booksAndTemplates == nil )
        booksAndTemplates = [[NSMutableArray alloc] init];

    // load books from DB
    for (int i=1; i<3; i++) {
        NSMutableDictionary* book = [[NSMutableDictionary alloc] init];
        [book setObject:[NSString stringWithFormat:@"book%d", i] forKey:@"name"];
        [book setObject:@"book" forKey:@"type"];
        [booksAndTemplates addObject:book];
        [book release];
    }
//    NSMutableArray* books = [[[NSMutableArray alloc]initWithObjects:@"book1", @"book2", @"book1", @"book2", @"book1", @"book2", @"book1", @"book2", @"book1", @"book2", nil] autorelease];
//    [booksAndTemplates addObjectsFromArray:books];
//    [books release];
    
    // load book templates from resources
    NSString* templatePath = [[NSBundle mainBundle] resourcePath];
    NSArray* files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:templatePath error:nil];
    for (NSString* filename in files) {
        if( [[filename pathExtension] isEqualToString:@"tpl"] ) {
            NSMutableDictionary* book = [[NSMutableDictionary alloc] init];
            [book setObject:[[filename lastPathComponent] stringByDeletingPathExtension] forKey:@"name"];
            [book setObject:@"template" forKey:@"type"];
            [booksAndTemplates addObject:book];
            [book release];
        }
    }

    NSLog(@"%@", booksAndTemplates);
}

// create a scroll view of books and templates
- (void)createScrollView {
    int margin_x = 20;
    int margin_x_left = 20;
    int margin_x_right = 20;
    int margin_y = 20;
    int margin_y_top = 10;
    int margin_y_bottom = 10;
    int icon_height = 195;
    int icon_width = 130;
    int label_height = 20;
    int columns = 2;
    int rows = ceil(booksAndTemplates.count/columns);
    int scrollview_height = 420; // 480 - 20 - 40navi
    
    // create the view
    bookListView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, 320, scrollview_height)];
    //UIImageView* bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activity_background"]];
    UIView* bg = [[UIView alloc] init];
    bg.frame = CGRectMake(0, 0, 320, scrollview_height);
    bg.backgroundColor = [UIColor grayColor];
    bg.alpha = 1;
    [bookListView addSubview:bg];
    [bg release];
    
    // create the scroll view
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, scrollview_height)];
    [bookListView addSubview:scrollView];
    
    scrollView.pagingEnabled = FALSE;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    
    for (int r=0; r<rows; r++) {
        for( int c=0; c<columns; c++) {
            int i = r * columns + c; // book #
            NSMutableDictionary* book = booksAndTemplates[i];
            // get the icon file names, just replace space with underscore
            NSString* bookIcon = [book objectForKey:@"name"];
            NSString* bookIconPressed = [NSString stringWithFormat:@"activity_%@_pressed", bookIcon];
            //bookIcon = @"book1";
            //bookIconPressed = @"camera_button";
            
            UIButton* bookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            bookBtn.frame = CGRectMake(margin_x_left+c*(icon_width+margin_x), margin_y_top+r*(icon_height+label_height+margin_y), icon_width, icon_height);
            [bookBtn setImage:[UIImage imageNamed:bookIcon] forState:UIControlStateNormal];
            [bookBtn setImage:[UIImage imageNamed:bookIconPressed] forState:UIControlStateHighlighted];
            bookBtn.tag = i;
            [bookBtn addTarget:self action:@selector(bookSelected:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel* bookLabel = [[UILabel alloc] init];
            bookLabel.frame = CGRectMake(margin_x_left+c*(icon_width+margin_x), margin_y_top+r*(icon_height+label_height+margin_y)+icon_height, icon_width, label_height);
            bookLabel.backgroundColor = [UIColor clearColor];
            bookLabel.alpha = 0.8;
            bookLabel.text = [book objectForKey:@"name"];
            
            [scrollView addSubview:bookBtn];
            [scrollView addSubview:bookLabel];
        }
    }
    scrollView.contentSize = CGSizeMake(320, margin_y_top+margin_y_bottom+rows*(icon_height+label_height+margin_y));
    [scrollView release];
    
    [self.view addSubview:bookListView];
}

// open a book
- (void)openBook:(int)bookID {
    if( mCurrentBook == nil ) {
        mCurrentBook = [[totBookViewController alloc] init:self];
    }
    NSMutableDictionary* book = booksAndTemplates[bookID];
    [mCurrentBook open:[book objectForKey:@"name"] isTemplate:[[book objectForKey:@"type"] isEqualToString:@"template"]];
}

- (void)closeBook {
    [mCurrentBook release];
    mCurrentBook = nil;
}

- (void)bookSelected:(id)sender {
    UIButton* btn = (UIButton*)sender;
    int bookID = btn.tag;
    [self openBook:bookID];
}


@end
