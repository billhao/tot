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
#import "totSettingRootController.h"
#import "totTimelineController.h"
#import "AppDelegate.h"
#import "Global.h"

@implementation totHomeRootController

@synthesize homeEntryViewController, scrapbookListController, settingController;
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
//        self.tabBarItem.title = @"Home";
//        [[self tabBarItem] setFinishedSelectedImage:[UIImage imageNamed:@"home_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"home"]];
//        [[self tabBarItem] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], UITextAttributeTextColor, nil] forState:UIControlStateSelected];
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
    
    homeEntryViewController = [[totHomeEntryViewController alloc] init];
    homeEntryViewController.view.frame = self.view.frame;
    homeEntryViewController.homeRootController = self;
    homeEntryViewController.view.frame = CGRectMake(0, 0, 320, 460);

    mCurrentViewIndex = kHomeViewEntryView;
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"root vc view did appear");
    [self switchTo:kHomeViewEntryView withContextInfo:nil];
    //[self switchTo:kTimeline withContextInfo:nil];
    //[self switchTo:kScrapbook withContextInfo:nil];
}

- (UIViewController*)getViewByIndex:(int)viewIndex {
    switch (viewIndex) {
        case kHomeViewEntryView:
            return homeEntryViewController;
        case kTimeline:
            return [self getTimelineVC];
        case kScrapbook:
            return [self getScrapbookVC];
        case kSetting:
            return [self getSettingVC];
        default:
            printf("Invalid view index\n");
            return nil;
    }
}

- (float)getViewXPositionByIndex:(int)viewIndex {
    switch (viewIndex) {
        case kHomeViewEntryView:
            return homeEntryViewController.view.frame.origin.x;
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

    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    UINavigationController* nc = delegate.loginNavigationController;

    switch (viewIndex) {
        case kHomeViewEntryView:
        {
            nextView.view.frame = CGRectMake(0, 0, 320, 460);
            [currentView.view.superview insertSubview:nextView.view atIndex:0];
            [UIView animateWithDuration:.5 animations:^{
                if( mCurrentViewIndex == kTimeline ) {
                    currentView.view.frame = CGRectMake(0, 480, 320, 460);
                }
                else if( mCurrentViewIndex == kScrapbook ) {
                    currentView.view.frame = CGRectMake(320, 0, 320, 460);
                }
                else if( mCurrentViewIndex == kSetting ) {
                    currentView.view.frame = CGRectMake(320, 0, 320, 460);
                }
            } completion:^(BOOL finished) {
                if([nc.viewControllers containsObject:nextView]) {
                    [nc popToViewController:nextView animated:FALSE];
                }
                else {
                    [nc pushViewController:nextView animated:FALSE];
                }
                mCurrentViewIndex = viewIndex;
            }];
            break;
        }
        case kTimeline:
        {
            nextView.view.frame = CGRectMake(0, 480, 320, 460);
            [UIView animateWithDuration:0.75
                             animations:^{
//                                 if( currentX < nextX ) {
//                                     currentView.view.frame = CGRectMake(-320, 0, 320, 460);
//                                 } else {
//                                     currentView.view.frame = CGRectMake(320, 0, 320, 460);
//                                 }
                                 nextView.view.frame = CGRectMake(0, 20, 320, 460);
                                 [delegate.loginNavigationController.view addSubview:nextView.view];
                             } completion:^(BOOL finished) {
                                 [delegate.loginNavigationController pushViewController:nextView animated:FALSE];
                                 mCurrentViewIndex = viewIndex;
                             }];
            break;
        }
        case kScrapbook:
        {
            nextView.view.frame = CGRectMake(320, 20, 320, 460);
            [UIView animateWithDuration:0.5
                             animations:^{
//                                 if( currentX < nextX ) {
//                                     currentView.view.frame = CGRectMake(-320, 20, 320, 460);
//                                 } else {
//                                     currentView.view.frame = CGRectMake(320, 20, 320, 460);
//                                 }
                                 nextView.view.frame = CGRectMake(0, 20, 320, 460);
                                 [delegate.loginNavigationController.view addSubview:nextView.view];
                             } completion:^(BOOL finished) {
                                 [delegate.loginNavigationController pushViewController:nextView animated:FALSE];
                                 mCurrentViewIndex = viewIndex;
                             }];
            break;
        }
        case kSetting:
        {
            nextView.view.frame = CGRectMake(320, 20, 320, 460);
            [UIView animateWithDuration:0.5
                             animations:^{
                                 nextView.view.frame = CGRectMake(0, 20, 320, 460);
                                 [delegate.loginNavigationController.view addSubview:nextView.view];
                             } completion:^(BOOL finished){
                                 [delegate.loginNavigationController pushViewController:nextView animated:FALSE];
                                 mCurrentViewIndex = viewIndex;
                             }];
            break;
        }
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    if(homeEntryViewController) [homeEntryViewController release];
    if(timelineController) [timelineController release];
    if(scrapbookListController) [scrapbookListController release];
    if(settingController) [settingController release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return FALSE;
}


- (totTimelineController*)getTimelineVC {
    if( timelineController == nil ) {
    // Create timeline. This view will be displayed when the user flip the finger up.
        timelineController = [[totTimelineController alloc] initWithNibName:@"Timeline" bundle:nil];
        timelineController.homeController = self;
    }
    return timelineController;
}

- (totBookListViewController*)getScrapbookVC {
    // create scrapbook
    if( scrapbookListController == nil ) {
        scrapbookListController = [[totBookListViewController alloc] init];
        scrapbookListController.homeController = self;
    }
    return scrapbookListController;
}

- (totSettingRootController*)getSettingVC {
    if (settingController == nil) {
        settingController = [[totSettingRootController alloc] init];
        settingController.homeController = self;
    }
    return settingController;
}

@end
