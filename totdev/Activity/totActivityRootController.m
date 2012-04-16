//
//  totActivityRootController.m
//  totdev
//
//  Created by Lixing Huang on 4/11/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totActivityRootController.h"
#import "totActivityEntryViewController.h"
#import "totActivityViewController.h"
#import "totActivityInfoViewController.h"
#import "totActivityAlbumViewController.h"

@implementation totActivityRootController

@synthesize activityEntryViewController;
@synthesize activityViewController;
@synthesize activityInfoViewController;
@synthesize activityAlbumViewController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    totActivityEntryViewController *anEntryView = [[totActivityEntryViewController alloc] initWithNibName:@"ActivityEntryView" bundle:nil];
    self.activityEntryViewController = anEntryView;
    [anEntryView release];
    
    totActivityViewController *activityView = [[totActivityViewController alloc] initWithNibName:@"ActivityView" bundle:nil];
    self.activityViewController = activityView;
    [activityView release];
    
    totActivityInfoViewController *activityInfoView = [[totActivityInfoViewController alloc] initWithNibName:@"ActivityInfoView" bundle:nil];
    self.activityInfoViewController = activityInfoView;
    [activityInfoView release];
    
    totActivityAlbumViewController *activityAlbumView = [[totActivityAlbumViewController alloc] initWithNibName:@"ActivityAlbumView" bundle:nil];
    self.activityAlbumViewController = activityAlbumView;
    [activityAlbumView release];
    
    [self.view addSubview:activityEntryViewController.view];
//    [self.view addSubview:activityViewController.view];
//    [self.view addSubview:activityInfoViewController.view];
//    [self.view addSubview:activityAlbumViewController.view];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [activityEntryViewController release];
    [activityViewController release];
    [activityInfoViewController release];
    [activityAlbumViewController release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
