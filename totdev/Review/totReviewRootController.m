//
//  totReviewRootController.m
//  totdev
//
//  Created by Lixing Huang on 4/11/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "AppDelegate.h"
#import "totReviewRootController.h"
#import "totReviewTableViewController.h"
#import "totReviewStory.h"
#import "totReviewFilterView.h"
#import "../Model/totEvent.h"

#define LIMIT 10

@implementation totReviewRootController

@synthesize tableViewController;
@synthesize mModel;
@synthesize mOffset;
@synthesize mCurrentBabyId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // customize the tab bar item
        self.tabBarItem.title = @"Review";
        [[self tabBarItem] setFinishedSelectedImage:[UIImage imageNamed:@"review_selected"]
                        withFinishedUnselectedImage:[UIImage imageNamed:@"review"]];
        [[self tabBarItem] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor],
                                                   UITextAttributeTextColor, nil] forState:UIControlStateSelected];
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        mModel = [appDelegate getDataModel];
        mCurrentBabyId = appDelegate.baby.babyID; //TODO should always use baby instead of babyID
        mOffset = 0;
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

- (void)loadEvents:(BOOL)refresh ofType:(NSString*)type {
    NSArray * events = nil;
    if (type == nil)
        events = [mModel getEvent:mCurrentBabyId limit:LIMIT offset:mOffset];
    else
        events = [mModel getEvent:mCurrentBabyId event:type limit:LIMIT offset:mOffset];
    
    // If no more events available
    if ([events count] == 0) return;
    
    mOffset += [events count];
    
    NSMutableArray *dat = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [events count]; ++i) {
        // parse the results from db
        totReviewStory *story = [[totReviewStory alloc] init];
        
        totEvent * anEvent = (totEvent*)[events objectAtIndex:i];
        story.mEventType = anEvent.name;
        story.mRawContent = anEvent.value;
        story.mWhen = anEvent.datetime;
        story.mBabyId = anEvent.baby_id;
        story.mEventId = anEvent.event_id;
        [dat addObject:story];
        [story release];
    }
    if (refresh)
        [tableViewController setData:dat];
    else
        [tableViewController appendData:dat];
    
    [dat release];
}

- (void)viewWillAppear:(BOOL)animated {
    if(tableViewController) {
        mOffset = 0;
        [self loadEvents:YES ofType:nil];
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    totReviewTableViewController *aTableView = 
        [[totReviewTableViewController alloc] initWithNibName:@"ReviewTableView" bundle:nil];
    self.tableViewController = aTableView;
    [self.tableViewController setRootController:self];
    [self.view addSubview:tableViewController.view];
    [aTableView release];
    
    totReviewFilterView *filterView = [[totReviewFilterView alloc] initWithFrame:CGRectMake(0, -200, 320, 240)];
    [self.view addSubview:filterView];
    [filterView release];
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
