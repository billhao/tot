//
//  totSettingRootController.m
//  totdev
//
//  Created by Lixing Huang on 4/11/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totSettingRootController.h"
#import "totSettingEntryViewController.h"

@implementation totSettingRootController

@synthesize mEntryView;
@synthesize homeController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // customize the tab bar item
        //self.tabBarItem.title = @"Settings";
        //[[self tabBarItem] setFinishedSelectedImage:[UIImage imageNamed:@"setting_selected"]
        //                withFinishedUnselectedImage:[UIImage imageNamed:@"setting"]];
        //[[self tabBarItem] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], UITextAttributeTextColor, nil] forState:UIControlStateSelected];
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
{}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // add the entry view
    totSettingEntryViewController* settingController =
        [[totSettingEntryViewController alloc] init];
    settingController.view.frame = self.view.bounds;
    self.mEntryView = settingController;
    self.mEntryView.homeController = self.homeController;
    [self.view addSubview:settingController.view];
    [settingController release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self.mEntryView release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
