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

@interface totBookViewController ()

@end

@implementation totBookViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
- (id)init
{
    //self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self = [super init];
    if (self) {
        // Custom initialization
        bookview = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.view addSubview:bookview];
    
    [self createOptionMenu];
    
    // add scrapbook option menu button
    optionMenuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    optionMenuBtn.frame = CGRectMake(320-50, 480-50, 50, 50);
    [optionMenuBtn setImage:[UIImage imageNamed:@"scrapbook_option_button"] forState:UIControlStateNormal];
    [optionMenuBtn setImage:[UIImage imageNamed:@"scrapbook_option_button_pressed"] forState:UIControlStateHighlighted];
    //optionBtn.backgroundColor = [UIColor blueColor];
    [optionMenuBtn addTarget:self action:@selector(optionMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:optionMenuBtn];
    [optionMenuBtn release];
    

    
    // Setup a pageElement
    /*
    totPageElement* element = [[totPageElement alloc] init];
    [totPageElement initPageElement:element x:50 y:50 w:50 h:50 r:0.9 n:@"Test" t:IMAGE];
    [element addResource:[totPageElement image] withPath:@"bg_registration.png"];
    
    totPageElementView* elementView = [[totPageElementView alloc] initWithElementData:element];
    [self.view addSubview:elementView];
    [elementView release];
    
    [element release];
     */
    
    // Setup a page
    /*
    NSString* path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"tpl"];
    totBook* book = [[totBook alloc] init];
    [book loadFromTemplateFile:path];
    book.bookname = @"test_scrapbook";
    
    totPage* pagedata = [book getPageWithIndex:0];
    totPageView* page = [[totPageView alloc] initWithFrame:CGRectMake(0, 0, 320, 411) pagedata:pagedata];
    [self.view addSubview:page];
    [page release];
    
    [book release];
     */
    
}

- (void)viewWillAppear:(BOOL)animated {
    // hide status bar
    [[UIApplication sharedApplication] setStatusBarHidden:TRUE withAnimation:UIStatusBarAnimationFade];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    CGRect f = appDelegate.window.frame;
    appDelegate.loginNavigationController.view.frame = f;
    self.view.frame = f;
    [appDelegate.loginNavigationController.view setNeedsLayout];
}

- (void)viewWillDisappear:(BOOL)animated {
    // show status bar
    [[UIApplication sharedApplication] setStatusBarHidden:FALSE withAnimation:UIStatusBarAnimationFade];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    CGRect f = appDelegate.window.frame;
    appDelegate.loginNavigationController.view.frame = f;
    self.view.frame = f;
    [appDelegate.loginNavigationController.view setNeedsLayout];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [super dealloc];
    if( bookview != nil) [bookview release];
}

- (void)optionButtonPressed:(id)sender {
    NSLog(@"option clicked");
    optionView.hidden = TRUE;
    optionMenuBtn.hidden = FALSE;
}

- (void)optionMenuButtonPressed:(id)sender {
    optionView.hidden = FALSE;
    optionMenuBtn.hidden = TRUE;
}

- (void)createOptionMenu {
    optionView = [[UIView alloc] init];
    optionView.frame = CGRectMake(160, 240, 320-160-10, 480-240-10);
    optionView.backgroundColor = [UIColor grayColor];
    optionView.alpha = 0.8;
    
    NSMutableArray* buttons = [[NSMutableArray alloc] initWithObjects:
                               @"Add new page",
                               @"Remove this page",
                               @"Close",
                               nil];

    int margin_x = 10;
    int margin_x_left = 10;
    int margin_x_right = 10;
    int margin_y = 10;
    int margin_y_top = 10;
    int margin_y_bottom = 10;
    int icon_height = 50;
    int icon_width = 140;

    int i = 0;
    for (NSString* button in buttons) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(margin_x_left, margin_y_top+i*(icon_height+margin_y), icon_width, icon_height);
        btn.titleLabel.text = button;
        btn.tag = i;
        btn.backgroundColor = [UIColor redColor];
        //[btn setImage:[UIImage imageNamed:button] forState:UIControlStateNormal];
        //[btn setImage:[UIImage imageNamed:button] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(optionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        i++;
        [optionView addSubview:btn];
    }
    [buttons release];
    
    optionView.hidden = TRUE;
    [self.view addSubview:optionView];
}

- (void)open:(NSString*)bookname isTemplate:(BOOL)isTemplate {
    // Setup a book
    bookview = [[totBookView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    bookview.bookvc = self;
    if( isTemplate ) {
        [bookview loadTemplateFile:bookname];
        [bookview addNewPage:@"FirstYearTemplateCover"];
    }
    else {
        [bookview loadBook:bookname];
    }
}

@end


