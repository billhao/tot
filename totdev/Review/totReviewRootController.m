//
//  totReviewRootController.m
//  totdev
//
//  Created by Lixing Huang on 4/11/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totReviewRootController.h"
#import "totReviewTableViewController.h"

@implementation totReviewRootController

@synthesize tableViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // customize the tab bar item
        self.tabBarItem.title = @"Review";
        [[self tabBarItem] setFinishedSelectedImage:[UIImage imageNamed:@"review_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"review"]];
        [[self tabBarItem] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], UITextAttributeTextColor, nil] forState:UIControlStateSelected];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void)viewWillAppear:(BOOL)animated {
    if(tableViewController) {
        NSMutableArray *dat = [[NSMutableArray alloc] init];
        [dat addObject:@"entity1"];
        [dat addObject:@"entity2"];
        [dat addObject:@"entity3"];
        [dat addObject:@"entity4"];
        [dat addObject:@"entity5"];
        [dat addObject:@"entity1"];
        [dat addObject:@"entity2"];
        [dat addObject:@"entity3"];
        [dat addObject:@"entity4"];
        [dat addObject:@"entity5"];
        [tableViewController setData:dat];
        [dat release];
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    totReviewTableViewController *aTableView = 
        [[totReviewTableViewController alloc] initWithNibName:@"ReviewTableView" bundle:nil];
    self.tableViewController = aTableView;
    [self.view addSubview:tableViewController.view];
    [aTableView release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [tableViewController release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
