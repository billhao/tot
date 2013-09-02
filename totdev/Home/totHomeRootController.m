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
#import "totHomeActivityBrowseController.h"
#import "totHomeActivityLabelController.h"
#import "totHomeAlbumBrowseController.h"
#import "totTimelineController.h"
#import "AppDelegate.h"

@implementation totHomeRootController

@synthesize homeEntryViewController;
//@synthesize homeFeedingViewController;
//@synthesize homeHeightViewController;
//@synthesize homeActivityLabelController;
//@synthesize homeActivityBrowseController;
//@synthesize homeAlbumBrowseController;
@synthesize timelineController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"%@", @"home init");
        self.tabBarItem.title = @"Home";
        [[self tabBarItem] setFinishedSelectedImage:[UIImage imageNamed:@"home_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"home"]];
        [[self tabBarItem] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], UITextAttributeTextColor, nil] forState:UIControlStateSelected];
        //[[self tabBarItem] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], UITextAttributeTextColor, nil]  forState:UIControlStateNormal];
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
    NSLog(@"%@", @"home root didload");
    
    totHomeEntryViewController *aHomeView = [[totHomeEntryViewController alloc] init];
    aHomeView.view.frame = self.view.frame;
    self.homeEntryViewController = aHomeView;
    self.homeEntryViewController.homeRootController = self;
    [aHomeView release];
    
    // Create timeline. This view will be displayed when the user flip the finger up.
    totTimelineController* tc = [[totTimelineController alloc] initWithNibName:@"Timeline" bundle:nil];
    self.timelineController = tc;
    [tc release];
    
    self.homeEntryViewController.view.frame = CGRectMake(0, 0, 320, 460);
    self.timelineController.view.frame = CGRectMake(0, 0, 320, 460);
    
    // =======================================
    
    mCurrentViewIndex = kHomeViewEntryView;
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"root vc view did appear");
    //[self presentViewController:homeEntryViewController animated:FALSE completion:nil];
    //[self presentViewController:timelineController animated:FALSE completion:nil];
    [self switchTo:kHomeViewEntryView withContextInfo:nil];
}

- (UIViewController*)getViewByIndex:(int)viewIndex {
    switch (viewIndex) {
        case kHomeViewEntryView:
            return homeEntryViewController;
        case kTimeline:
            return timelineController;
        case kScrapbook:
            return nil;
//        case kHomeViewFeedView:
//            return homeFeedingViewController;
//        case kHomeViewHeightView:
//            return homeHeightViewController;
//        case kHomeActivityLabelController:
//            return homeActivityLabelController;
//        case kHomeActivityBrowseController:
//            return homeActivityBrowseController;
//        case kHomeAlbumBrowseController:
//            return homeAlbumBrowseController;
        default:
            printf("Invalid view index\n");
            return nil;
    }
}

- (float)getViewXPositionByIndex:(int)viewIndex {
    switch (viewIndex) {
        case kHomeViewEntryView:
            return homeEntryViewController.view.frame.origin.x;
        
//        case kHomeViewFeedView:
//            return homeFeedingViewController.view.frame.origin.x;
//        case kHomeViewHeightView:
//            return homeHeightViewController.view.frame.origin.x;
//        case kHomeActivityLabelController:
//            return homeActivityLabelController.view.frame.origin.x;
//        case kHomeActivityBrowseController:
//            return homeActivityBrowseController.view.frame.origin.x;
//        case kHomeAlbumBrowseController:
//            return homeAlbumBrowseController.view.frame.origin.x;
        default:
            printf("Invalid view index\n");
            return -1;
    }
}

- (void) switchTo:(int)viewIndex withContextInfo:(NSMutableDictionary*)info {
    float currentX = 0, nextX = 0;
    UIViewController *currentView, *nextView;
    
//    currentX = [self getViewXPositionByIndex:mCurrentViewIndex];
    currentView = [self getViewByIndex:mCurrentViewIndex];
//    nextX = [self getViewXPositionByIndex:viewIndex];
    nextView = [self getViewByIndex:viewIndex];
    
//    switch (viewIndex) {
//        case kHomeViewEntryView:
//            break;
//        case kHomeViewFeedView:
//            break;
//        case kHomeViewHeightView:
//        {
//            // tell the height view which measurement is on the top
//            int i = (int)info;
//            [(totHomeHeightViewController*)nextView setInitialPicker:i];
//            break;
//        }
//        case kHomeActivityLabelController:
//            [homeActivityLabelController receiveMessage:info];
//            break;
//        case kHomeActivityBrowseController:
//            [homeActivityBrowseController receiveMessage:info];
//            break;
//        case kHomeAlbumBrowseController:
//            [homeAlbumBrowseController receiveMessage:info];
//            break;
//        default:
//            break;
//    }

    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    if( viewIndex == kHomeViewEntryView ) {
        [delegate.loginNavigationController pushViewController:nextView animated:FALSE];
    }
    else if( viewIndex == kTimeline ) {
        nextView.view.frame = CGRectMake(0, 480, 320, 460);
        [UIView animateWithDuration:0.75
                         animations:^{
                             //[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                             [delegate.loginNavigationController pushViewController:nextView animated:FALSE];
                             if( currentX < nextX ) {
                                 currentView.view.frame = CGRectMake(-320, 0, 320, 460);
                             } else {
                                 currentView.view.frame = CGRectMake(320, 0, 320, 460);
                             }
                             nextView.view.frame = CGRectMake(0, 0, 320, 460);
                             //[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:delegate.loginNavigationController.view cache:NO];
                         }];
    }
    
//        [self presentViewController:nextView animated:TRUE completion:^{
//            mCurrentViewIndex = viewIndex;
//        }];
//    }];
    
//    [UIView beginAnimations:@"swipe" context:nil];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:0.5f];
//    
//    [currentView viewWillDisappear:NO];
//    
//    if( currentX < nextX ) {
//        currentView.view.frame = CGRectMake(-320, 0, 320, 460);
//    } else {
//        currentView.view.frame = CGRectMake(320, 0, 320, 460);
//    }
//    nextView.view.frame = CGRectMake(0, 0, 320, 460);
//    mCurrentViewIndex = viewIndex;
//    
//    [nextView viewWillAppear:NO];
//    
//    [UIView commitAnimations];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [homeEntryViewController release];
    [timelineController release];
//    [homeFeedingViewController release];
//    [homeHeightViewController release];
//    [homeActivityLabelController release];
//    [homeActivityBrowseController release];
//    [homeAlbumBrowseController release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
