//
//  totHomeRootController.m
//  totdev
//
//  Created by Lixing Huang on 4/11/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totHomeRootController.h"
#import "totHomeEntryViewController.h"
#import "totSettingRootController.h"
#import "totTimelineController.h"
#import "AppDelegate.h"
#import "Global.h"
#import "totUtility.h"
#import "totTutorialViewController.h"

@implementation totHomeRootController

@synthesize homeEntryViewController, scrapbookListController, settingController, tutorialController, timelineController;

- (id)init
{
    self = [super init];
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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

    // customize the tab bar item
    NSLog(@"%@", @"home root didload");

    mCurrentViewIndex = -1;
}

- (void)viewDidAppear:(BOOL)animated {
//    NSLog(@"root vc view did appear");
//    [self switchTo:kHomeViewEntryView withContextInfo:nil];
    //[self switchTo:kTimeline withContextInfo:nil];
    //[self switchTo:kScrapbook withContextInfo:nil];
}

- (UIViewController*)getViewByIndex:(int)viewIndex {
    switch (viewIndex) {
        case kHomeViewEntryView:
            return [self getHomeVC];
        case kTimeline:
            return [self getTimelineVC];
        case kScrapbook:
            return [self getScrapbookVC];
        case kSetting:
            return [self getSettingVC];
        case KTutorial:
            return [self getTutorialVC];
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

    int statusBarOffset = 20;
    if( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") )
        statusBarOffset = 0;
    
    CGSize screenSize = [totUtility getScreenSize];
    
    switch (viewIndex) {
        case kHomeViewEntryView:
        {
            CGRect f = currentView.view.frame;
            nextView.view.frame = f;//CGRectMake(0, -statusBarOffset, 320, 480);
            [currentView.view.superview insertSubview:nextView.view belowSubview:currentView.view];
            //[nc.view insertSubview:nextView.view atIndex:0];
            [UIView animateWithDuration:.5 animations:^{
                if( mCurrentViewIndex == kTimeline ) {
                    currentView.view.frame = CGRectMake(0, screenSize.height, 320, screenSize.height-statusBarOffset);
                }
                else if( mCurrentViewIndex == kScrapbook ) {
                    currentView.view.frame = CGRectMake(320, 0, 320, screenSize.height-statusBarOffset);
                }
                else if( mCurrentViewIndex == kSetting ) {
                    currentView.view.frame = CGRectMake(320, 0, 320, screenSize.height-statusBarOffset);
                }
            } completion:^(BOOL finished) {
                nextView.view.frame = CGRectMake(0, statusBarOffset, 320, screenSize.height-statusBarOffset);
                if([nc.viewControllers containsObject:nextView]) {
                    [nc popToViewController:nextView animated:FALSE];
                }
                else {
                    [nc pushViewController:nextView animated:FALSE];
                }
                if( mCurrentViewIndex == KTutorial )
                    [self releaseTutorial];
                mCurrentViewIndex = viewIndex;
            }];
            break;
        }
        case kTimeline:
        {
            if( mCurrentViewIndex != kSetting ) {
                nextView.view.frame = CGRectMake(0, screenSize.height, 320, screenSize.height-statusBarOffset);
            }
            else {
                [currentView.view.superview insertSubview:nextView.view belowSubview:currentView.view];
            }
            [UIView animateWithDuration:0.75
                             animations:^{
                                 if( mCurrentViewIndex == kSetting ) {
                                     currentView.view.frame = CGRectMake(320, 0, 320, screenSize.height-statusBarOffset);
                                 }
                                 else {
                                     nextView.view.frame = CGRectMake(0, statusBarOffset, 320, screenSize.height-statusBarOffset);
                                     [nc.view addSubview:nextView.view];
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
        case kScrapbook:
        {
            nextView.view.frame = CGRectMake(320, statusBarOffset, 320, screenSize.height-statusBarOffset);
            [UIView animateWithDuration:0.5
                             animations:^{
//                                 if( currentX < nextX ) {
//                                     currentView.view.frame = CGRectMake(-320, 20, 320, 460);
//                                 } else {
//                                     currentView.view.frame = CGRectMake(320, 20, 320, 460);
//                                 }
                                 nextView.view.frame = CGRectMake(0, statusBarOffset, 320, screenSize.height-statusBarOffset);
                                 [nc.view addSubview:nextView.view];
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
        case kSetting:
        {
            if( mCurrentViewIndex != KTutorial ) {
                nextView.view.frame = CGRectMake(320, statusBarOffset, 320, screenSize.height-statusBarOffset);
            }
            [UIView animateWithDuration:0.5
                             animations:^{
                                 if( mCurrentViewIndex != KTutorial ) {
                                     nextView.view.frame = CGRectMake(0, statusBarOffset, 320, screenSize.height-statusBarOffset);
                                     [delegate.loginNavigationController.view addSubview:nextView.view];
                                 }
                             } completion:^(BOOL finished){
                                 if([nc.viewControllers containsObject:nextView]) {
                                     [nc popToViewController:nextView animated:FALSE];
                                 }
                                 else {
                                     [nc pushViewController:nextView animated:FALSE];
                                 }
                                 if( mCurrentViewIndex == KTutorial )
                                     [self releaseTutorial];
                                 mCurrentViewIndex = viewIndex;
                             }];
            break;
        }
        case KTutorial:
        {
            // tutorial will switch back to this view when done
            if( mCurrentViewIndex == kSetting )
                tutorialController.nextview = kSetting;
            else
                tutorialController.nextview = kHomeViewEntryView;
            //statusBarOffset = 0; // always 0 for ios 6 & 7 because tutorial is full screen
            nextView.view.alpha = 0.5;
            CGSize screenSize = [totUtility getScreenSize];
            nextView.view.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
            //CGRectMake(0, statusBarOffset + (screenSize.height-480+statusBarOffset)/2, 320, 480-statusBarOffset);
            [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve
                             animations:^{
                                 nextView.view.alpha = 1;
                                 [delegate.loginNavigationController.view addSubview:nextView.view];
                             } completion:^(BOOL finished){
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
    }
}

- (void)popup {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    UINavigationController* nc = delegate.loginNavigationController;
    UIViewController* vc = [nc popViewControllerAnimated:NO];
    if( vc == tutorialController ) {
        [tutorialController release];
        tutorialController = nil;
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

- (totHomeEntryViewController*)getHomeVC {
    if( !homeEntryViewController ) {
        homeEntryViewController = [[totHomeEntryViewController alloc] init];
        homeEntryViewController.homeRootController = self;
    }
    return homeEntryViewController;
}

- (totTimelineController*)getTimelineVC {
    if( timelineController == nil ) {
    // Create timeline. This view will be displayed when the user flip the finger up.
        timelineController = [[totTimelineController alloc] init];
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

- (totTutorialViewController*)getTutorialVC {
//    CGRect frame = self.view.bounds;
//    if( !SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ) {
//        float statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
//        frame.size.height -= statusBarHeight;
//    }
    if( tutorialController == nil ) {
        int statusBarOffset = 20;
        if( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") )
            statusBarOffset = 0;
        CGSize screenSize = [totUtility getScreenSize];
        CGRect rect = CGRectMake(0, statusBarOffset + (screenSize.height-480+statusBarOffset)/2, 320, 480-statusBarOffset);
        tutorialController = [[totTutorialViewController alloc] initWithFrame:rect];
        tutorialController.homeController = self;
    }
    return tutorialController;
}

- (void)releaseTutorial {
    [tutorialController release];
    tutorialController = nil;
}

// release all views when log out
- (void)releaseAllViews {
    [homeEntryViewController release];
    homeEntryViewController = nil;
    [timelineController release];
    timelineController = nil;
    [settingController release];
    settingController = nil;
    [tutorialController release];
    tutorialController = nil;
}

@end
