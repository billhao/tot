//
//  totHomeRootController.m
//  totdev
//
//  Created by Lixing Huang on 4/11/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totHomeRootController.h"
#import "totHomeEntryViewController.h"
#import "totHomeHeightViewController.h"
#import "totHomeFeedingViewController.h"
#import "totHomeDiaperViewController.h"

@implementation totHomeRootController

@synthesize homeEntryViewController;
@synthesize homeFeedingViewController;
@synthesize homeHeightViewController;
@synthesize homeDiaperViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"%@", @"home init");
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

    // customize the tab bar item
    NSLog(@"%@", @"home didload");
    [[self tabBarItem] setFinishedSelectedImage:[UIImage imageNamed:@"home_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"home"]];
    [[self tabBarItem] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], UITextAttributeTextColor, nil] forState:UIControlStateSelected];
    //[[self tabBarItem] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], UITextAttributeTextColor, nil]  forState:UIControlStateNormal];
    
    totHomeEntryViewController *aHomeView = [[totHomeEntryViewController alloc] initWithNibName:@"HomeView" bundle:nil];
    self.homeEntryViewController = aHomeView;
    self.homeEntryViewController.homeRootController = self;
    [aHomeView release];
    
    totHomeFeedingViewController *aFeedView = 
        [[totHomeFeedingViewController alloc] initWithNibName:@"homeFeedingView" bundle:nil];
    self.homeFeedingViewController = aFeedView;
    self.homeFeedingViewController.homeRootController = self;
    [aFeedView release];
    
    totHomeHeightViewController *aHeightView = 
        [[totHomeHeightViewController alloc] initWithNibName:@"totHomeHeightViewController" bundle:nil];
    self.homeHeightViewController = aHeightView;
    self.homeHeightViewController.homeRootController = self;
    [aHeightView release];
    
    totHomeDiaperViewController *aDiaperView = 
        [[totHomeDiaperViewController alloc] initWithNibName:@"homeDiaperView" bundle:nil];
    self.homeDiaperViewController = aDiaperView;
    self.homeDiaperViewController.mHomeRootController = self;
    [aDiaperView release];
    
    [self.view addSubview:homeEntryViewController.view];
    [self.view addSubview:homeFeedingViewController.view];
    [self.view addSubview:homeHeightViewController.view];
    [self.view addSubview:homeDiaperViewController.view];
    
    self.homeEntryViewController.view.frame = CGRectMake(0, 0, 320, 460);
    self.homeFeedingViewController.view.frame = CGRectMake(320, 0, 320, 460);
    self.homeHeightViewController.view.frame = CGRectMake(320, 0, 320, 460);
    self.homeDiaperViewController.view.frame = CGRectMake(320, 0, 320, 460);
    
    mCurrentViewIndex = kHomeViewEntryView;
}


- (UIViewController*)getViewByIndex:(int)viewIndex {
    switch (viewIndex) {
        case kHomeViewEntryView:
            return homeEntryViewController;
        case kHomeViewFeedView:
            return homeFeedingViewController;
        case kHomeViewHeightView:
            return homeHeightViewController;
        case kHomeViewDiaperView:
            return homeDiaperViewController;
        default:
            printf("Invalid view index\n");
            return nil;
    }
}

- (float)getViewXPositionByIndex:(int)viewIndex {
    switch (viewIndex) {
        case kHomeViewEntryView:
            return homeEntryViewController.view.frame.origin.x;
        case kHomeViewFeedView:
            return homeFeedingViewController.view.frame.origin.x;
        case kHomeViewHeightView:
            return homeHeightViewController.view.frame.origin.x;
        case kHomeViewDiaperView:
            return homeDiaperViewController.view.frame.origin.x;
        default:
            printf("Invalid view index\n");
            return -1;
    }
}

- (void) switchTo:(int)viewIndex withContextInfo:(NSMutableDictionary*)info {
    float currentX = 0, nextX = 0;
    UIViewController *currentView, *nextView;
    
    currentX = [self getViewXPositionByIndex:mCurrentViewIndex];
    currentView = [self getViewByIndex:mCurrentViewIndex];
    nextX = [self getViewXPositionByIndex:viewIndex];
    nextView = [self getViewByIndex:viewIndex];
    
    switch (viewIndex) {
        case kHomeViewEntryView:
            break;
        case kHomeViewFeedView:
            break;
        case kHomeViewHeightView:
            break;
        case kHomeViewDiaperView:
            break;
        default:
            break;
    }
    
    [UIView beginAnimations:@"swipe" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5f];
    
    [currentView viewWillDisappear:NO];
    
    if( currentX < nextX ) {
        currentView.view.frame = CGRectMake(-320, 0, 320, 460);
    } else {
        currentView.view.frame = CGRectMake(320, 0, 320, 460);
    }
    nextView.view.frame = CGRectMake(0, 0, 320, 460);
    mCurrentViewIndex = viewIndex;
    
    [nextView viewWillAppear:NO];
    
    [UIView commitAnimations];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [homeEntryViewController release];
    [homeFeedingViewController release];
    [homeHeightViewController release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
