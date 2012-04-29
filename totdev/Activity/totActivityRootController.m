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
    self.activityEntryViewController.activityRootController = self;
    [anEntryView release];
    
    totActivityViewController *activityView = [[totActivityViewController alloc] initWithNibName:@"ActivityView" bundle:nil];
    self.activityViewController = activityView;
    self.activityViewController.activityRootController = self;
    [activityView release];
    
    totActivityInfoViewController *activityInfoView = [[totActivityInfoViewController alloc] initWithNibName:@"ActivityInfoView" bundle:nil];
    self.activityInfoViewController = activityInfoView;
    self.activityInfoViewController.activityRootController = self;
    [activityInfoView release];
    
    totActivityAlbumViewController *activityAlbumView = [[totActivityAlbumViewController alloc] initWithNibName:@"ActivityAlbumView" bundle:nil];
    self.activityAlbumViewController = activityAlbumView;
    self.activityAlbumViewController.activityRootController = self;
    [activityAlbumView release];
    
    [self.view addSubview:activityEntryViewController.view];
    [self.view addSubview:activityInfoViewController.view];
    [self.view addSubview:activityAlbumViewController.view];
    [self.view addSubview:activityViewController.view];

    activityEntryViewController.view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    activityInfoViewController.view.frame = CGRectMake(SCREEN_W, 0, SCREEN_W, SCREEN_H);
    activityAlbumViewController.view.frame = CGRectMake(SCREEN_W, 0, SCREEN_W, SCREEN_H);
    activityViewController.view.frame = CGRectMake(SCREEN_W, 0, SCREEN_W, SCREEN_H);
    
    mCurrentViewIndex = kActivityEntryView;
}

- (UIView*)getViewByIndex:(int)viewIndex {
    switch (viewIndex) {
        case kActivityEntryView:
            return activityEntryViewController.view;
        case kActivityView:
            return activityViewController.view;
        case kActivityAlbumView:
            return activityAlbumViewController.view;
        case kActivityInfoView:
            return activityInfoViewController.view;
        default:
            printf("Invalid view index\n");
            return nil;
    }
}

- (float)getViewXPositionByIndex:(int)viewIndex {
    switch (viewIndex) {
        case kActivityEntryView:
            return activityEntryViewController.view.frame.origin.x;
        case kActivityView:
            return activityViewController.view.frame.origin.x;
        case kActivityAlbumView:
            return activityAlbumViewController.view.frame.origin.x;
        case kActivityInfoView:
            return activityInfoViewController.view.frame.origin.x;
        default:
            printf("Invalid view index\n");
            return -1;
    }
}

- (void)switchTo:(int)viewIndex withContextInfo:(NSMutableDictionary *)info {
    float currentX = 0, nextX = 0;
    UIView *currentView, *nextView;
    
    currentX = [self getViewXPositionByIndex:mCurrentViewIndex];
    currentView = [self getViewByIndex:mCurrentViewIndex];
    nextX = [self getViewXPositionByIndex:viewIndex];
    nextView = [self getViewByIndex:viewIndex];
    
    // info contains the data structure which needs to be passed into next view
    switch (viewIndex) {
        case kActivityEntryView:
            break;
        case kActivityView:
            [activityViewController receiveMessage:info];
            break;
        case kActivityAlbumView:
            break;
        case kActivityInfoView:
            [activityInfoViewController receiveMessage:info];
            break;
        default:
            break;
    }
    
    [UIView beginAnimations:@"swipe" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5f];
    
    if( currentX < nextX ) {
        currentView.frame = CGRectMake(-SCREEN_W, 0, SCREEN_W, SCREEN_H);
    } else {
        currentView.frame = CGRectMake(SCREEN_W, 0, SCREEN_W, SCREEN_H);
    }
    nextView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    mCurrentViewIndex = viewIndex;
    
    [UIView commitAnimations];
}

- (void)switchTo:(int)viewIndex {
    float currentX = 0, nextX = 0;
    UIView *currentView, *nextView;
    
    currentX = [self getViewXPositionByIndex:mCurrentViewIndex];
    currentView = [self getViewByIndex:mCurrentViewIndex];
    nextX = [self getViewXPositionByIndex:viewIndex];
    nextView = [self getViewByIndex:viewIndex];
    
    [UIView beginAnimations:@"swipe" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5f];
    
    if( currentX < nextX ) {
        currentView.frame = CGRectMake(-SCREEN_W, 0, SCREEN_W, SCREEN_H);
    } else {
        currentView.frame = CGRectMake(SCREEN_W, 0, SCREEN_W, SCREEN_H);
    }
    nextView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    mCurrentViewIndex = viewIndex;
    
    [UIView commitAnimations];
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
