//
//  totUITabBarController.m
//  totdev
//
//  Created by Lixing Huang on 4/11/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totUITabBarController.h"
#import "Utility/totCameraViewController.h"
#import "Utility/totAlbumViewController.h"
#import "Utility/totPhotoView.h"
#import "Utility/totUtility.h"

@implementation totUITabBarController

@synthesize cameraView;
@synthesize albumView;
@synthesize photoView;

- (id)init {
    self = [super init];
    NSLog(@"%@", @"totUITabBarController init");
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"%@", @"totUITabBarController initWithNibName");
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
    
    NSLog(@"totUITabBarController viewDidLoad");
    
    
    // set tab bar property
    // [self.tabBar1 setBackgroundImage:nil];
    // set bg color
    // [self.tabBar1 setBackgroundColor:[[UIColor alloc] initWithRed:0.98 green:0.973 blue:0.969 alpha:1]];
    // [self.tabBar1 setBackgroundColor:[[UIColor alloc] initWithRed:1.0 green:0.0 blue:0.0 alpha:1]];
    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"tab_background"]];
    // [self.tabBar setSelectionIndicatorImage:nil];
    // [self.tabBar setTintColor:[UIColor clearColor]];
    
    // set up tabs
    homeController = [[totHomeRootController alloc] init];
    activityController = [[totActivityRootController alloc] init];
    reviewController = [[totReviewRootController alloc] init];
    settingController = [[totSettingRootController alloc] init];
    
    // I also delete a tab controller in MainWindow.xib, which should link to totActivityRootController
    // NSArray* tabs = [NSArray arrayWithObjects:homeController, activityController, reviewController, settingController, nil];
    NSArray* tabs = [NSArray arrayWithObjects:homeController, reviewController, settingController, nil];
    
    [self setViewControllers:tabs];

    totCameraViewController *aCameraView = [[totCameraViewController alloc] initWithNibName:@"CameraView" bundle:nil];
    self.cameraView = aCameraView;
    self.cameraView.view.frame = CGRectMake(0, 0, 0, 0);
    [aCameraView release];
    
    albumViewController *anAlbumView = [[albumViewController alloc] init];
    self.albumView = anAlbumView;
    [anAlbumView release];
    
    totPhotoView *aPhotoView = [[totPhotoView alloc] initWithNibName:@"PhotoView" bundle:nil];
    self.photoView = aPhotoView;
    self.photoView.view.frame = CGRectMake(0, 0, 0, 0);
    [aPhotoView release];
    
    [self.view addSubview:cameraView.view];
    [self.view addSubview:albumView.view];
    [self.view addSubview:photoView.view];
}

- (void)viewWillAppear:(BOOL)animated {
    CGRect frame = self.view.bounds;
    frame.origin.y = 20;
    frame.size.height = 460;
    homeController.view.frame = frame;
    activityController.view.frame = frame;
    reviewController.view.frame = frame;
    settingController.view.frame = frame;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [cameraView release];
    [albumView release];
    
    [homeController release];
    [activityController release];
    [reviewController release];
    [settingController release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
