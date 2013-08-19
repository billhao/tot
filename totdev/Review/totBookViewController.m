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

@interface totBookViewController ()

@end

@implementation totBookViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
- (id)init:(totBookListViewController*)vc
{
    //self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self = [super init];
    if (self) {
        // Custom initialization
        bookview = nil;
        bookListVC = vc;
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

#pragma mark - Event handler

// Respond to a swipe gesture
- (IBAction)swipeGestureEvent:(UISwipeGestureRecognizer *)swipeRecognizer {
    // Get the location of the gesture
    CGPoint location = [swipeRecognizer locationInView:self.view];
    NSLog(@"Swipe %d", swipeRecognizer.direction);
    if( swipeRecognizer.direction == UISwipeGestureRecognizerDirectionLeft ) {
        // go to next page
        [bookview nextPage];
    }
    else if( swipeRecognizer.direction == UISwipeGestureRecognizerDirectionRight ) {
        // go to prev page
        [bookview previousPage];
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
            [self addNewPage];
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
}

- (void)optionMenuButtonPressed:(id)sender {
    optionView.hidden = FALSE;
    optionMenuBtn.hidden = TRUE;
}

- (void)hideOptionMenuAndButton:(BOOL)hide {
    if( hide ) {
        optionMenuBtn.alpha = 0;
//        optionView.hidden = TRUE;
//        optionMenuBtn.hidden = TRUE;
    }
    else {
        optionMenuBtn.alpha = 1;
//        optionMenuBtn.hidden = FALSE;
    }
}

#pragma mark - Helper functions

- (void)createOptionMenu {
    optionView = [[UIView alloc] init];
    optionView.frame = CGRectMake(160, 240, 320-160-10, 480-240-10);
    optionView.backgroundColor = [UIColor grayColor];
    optionView.alpha = 0.8;
    
    NSMutableArray* buttons = [[NSMutableArray alloc] initWithObjects:
                               @"Add new page",
                               @"Delete this page",
                               @"Edit book name",
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

- (void)addNewPage {
    [bookview addNewPage:nil]; // add a random page
}

- (void)deleteCurrentPage {
    [bookview deleteCurrentPage];
}

- (void)closeBook {
    // prompt to save if it is a template and has been modified
    
    // remove book view from parent
    [self.view removeFromSuperview];
    [bookListVC closeBook]; // release the bookvc
}

- (void)editBookName {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Edit book name" message:@"What is the new book name?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert textFieldAtIndex:0].text = bookview.mBook.bookname;
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"Entered: %@",[[alertView textFieldAtIndex:0] text]);
    if( buttonIndex == 1 ) {
        bookview.mBook.bookname = [alertView textFieldAtIndex:0].text;
    }
}

// load book data and show it
- (void)open:(NSString*)bookid bookname:(NSString*)bookname isTemplate:(BOOL)isTemplate {
    // Setup a book
    bookview = [[totBookView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    bookview.bookvc = self;
    if( isTemplate ) {
        [bookview loadTemplateFile:bookname];
        //[bookview addNewPage:@"FirstYearTemplateCover"];
    }
    else {
        [bookview loadBook:bookid bookname:bookname];
    }
    
    [bookview display];
    [bookListVC.view addSubview:self.view];
}

@end


