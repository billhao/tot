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
        NSLog(@"%@", @"activity initWithNibName");
        // customize the tab bar item
        self.tabBarItem.title = @"Activity";
        [[self tabBarItem] setFinishedSelectedImage:[UIImage imageNamed:@"activity_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"activity"]];
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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"%@", @"activity didload");

    self.view.frame = CGRectMake(0, 20, 320, 460);

    totActivityEntryViewController *anEntryView = [[totActivityEntryViewController alloc] initWithNibName:@"ActivityEntryView"
                                                                                                   bundle:nil];
    self.activityEntryViewController = anEntryView;
    self.activityEntryViewController.activityRootController = self;
    [anEntryView release];
    
    totActivityViewController *activityView = [[totActivityViewController alloc] initWithNibName:@"ActivityView" bundle:nil];
    self.activityViewController = activityView;
    self.activityViewController.activityRootController = self;
    [activityView release];
    
    totActivityInfoViewController *activityInfoView = [[totActivityInfoViewController alloc] initWithNibName:@"ActivityInfoView"
                                                                                                      bundle:nil];
    self.activityInfoViewController = activityInfoView;
    self.activityInfoViewController.activityRootController = self;
    [activityInfoView release];
    
    totActivityAlbumViewController *activityAlbumView = [[totActivityAlbumViewController alloc] initWithNibName:@"ActivityAlbumView"
                                                                                                         bundle:nil];
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

- (UIViewController*)getViewByIndex:(int)viewIndex {
    switch (viewIndex) {
        case kActivityEntryView:
            return activityEntryViewController;
        case kActivityView:
            return activityViewController;
        case kActivityAlbumView:
            return activityAlbumViewController;
        case kActivityInfoView:
            return activityInfoViewController;
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
    UIViewController *currentView, *nextView;
    
    currentX = [self getViewXPositionByIndex:mCurrentViewIndex];
    currentView = [self getViewByIndex:mCurrentViewIndex];
    nextX = [self getViewXPositionByIndex:viewIndex];
    nextView = [self getViewByIndex:viewIndex];
    
    // info contains the data structure which needs to be passed into next view
    if (viewIndex == kActivityView) {
        [activityViewController receiveMessage:info];
    } else if (viewIndex == kActivityAlbumView) {
        [activityAlbumViewController receiveMessage:info];
    } else if (viewIndex == kActivityInfoView) {
        [activityInfoViewController receiveMessage:info];
    }
    
    [UIView beginAnimations:@"swipe" context:nil];
	[UIView setAnimationDuration:1.0f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    if (mCurrentViewIndex == kActivityEntryView) {
        [activityEntryViewController viewWillDisappear:YES];
    } else if (mCurrentViewIndex == kActivityView) {
        [activityViewController viewWillDisappear:YES];
    } else if (mCurrentViewIndex == kActivityAlbumView) {
        [activityAlbumViewController viewWillDisappear:YES];
    } else if (mCurrentViewIndex == kActivityInfoView) {
        [activityInfoViewController viewWillDisappear:YES];
    }
    
    if (viewIndex == kActivityEntryView) {
        [activityEntryViewController viewWillAppear:YES];
    } else if (viewIndex == kActivityView) {
        [activityViewController viewWillAppear:YES];
    } else if (viewIndex == kActivityAlbumView) {
        [activityAlbumViewController viewWillAppear:YES];
    } else if (viewIndex == kActivityInfoView) {
        [activityInfoViewController viewWillAppear:YES];
    }
    
    if( currentX < nextX ) {
        currentView.view.frame = CGRectMake(-SCREEN_W, 0, SCREEN_W, SCREEN_H);
    } else {
        currentView.view.frame = CGRectMake(SCREEN_W, 0, SCREEN_W, SCREEN_H);
    }
    nextView.view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    mCurrentViewIndex = viewIndex;
    
    if (mCurrentViewIndex == kActivityEntryView) {
        [activityEntryViewController viewDidDisappear:YES];
    } else if (mCurrentViewIndex == kActivityView) {
        [activityViewController viewDidDisappear:YES];
    } else if (mCurrentViewIndex == kActivityAlbumView) {
        [activityAlbumViewController viewDidDisappear:YES];
    } else if (mCurrentViewIndex == kActivityInfoView) {
        [activityInfoViewController viewDidDisappear:YES];
    }
    
    if (viewIndex == kActivityEntryView) {
        [activityEntryViewController viewDidAppear:YES];
    } else if (viewIndex == kActivityView) {
        [activityViewController viewDidAppear:YES];
    } else if (viewIndex == kActivityAlbumView) {
        [activityAlbumViewController viewDidAppear:YES];
    } else if (viewIndex == kActivityInfoView) {
        [activityInfoViewController viewDidAppear:YES];
    }
    
    [UIView commitAnimations];
}

- (void)switchTo:(int)viewIndex {
    float currentX = 0, nextX = 0;
    UIViewController *currentView, *nextView;
    
    currentX = [self getViewXPositionByIndex:mCurrentViewIndex];
    currentView = [self getViewByIndex:mCurrentViewIndex];
    nextX = [self getViewXPositionByIndex:viewIndex];
    nextView = [self getViewByIndex:viewIndex];
    
    [UIView beginAnimations:@"swipe" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5f];
    
    if( currentX < nextX ) {
        currentView.view.frame = CGRectMake(-SCREEN_W, 0, SCREEN_W, SCREEN_H);
    } else {
        currentView.view.frame = CGRectMake(SCREEN_W, 0, SCREEN_W, SCREEN_H);
    }
    nextView.view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
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
