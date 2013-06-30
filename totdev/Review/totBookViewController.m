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

@interface totBookViewController ()

@end

@implementation totBookViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
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
    
    // Setup a book
    /*
    totBookView* bookview = [[totBookView alloc] initWithFrame:CGRectMake(0, 0, 320, 411)];
    [bookview loadTemplateFile:@"test"];
    [bookview addNewPage:@"FirstYearTemplateCover"];
    [self.view addSubview:bookview];
    [bookview release];
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [super dealloc];
}

@end


