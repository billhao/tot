//
//  totSettingEntryViewController.m
//  totdev
//
//  Created by Hao on 6/2/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totSettingEntryViewController.h"
#import "../AppDelegate.h"
#import "totEventName.h"
#import "totTutorialViewController.h"
#import "totUtility.h"
#import "totHomeRootController.h"

@implementation totSettingEntryViewController

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

- (void)homeButtonPressed:(id)sender {
    if (self.homeController) {
        [self.homeController switchTo:kHomeViewEntryView withContextInfo:nil];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Creats the navigation bar.
    UIView* navbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 42)];
    navbar.backgroundColor = [UIColor colorWithRed:116.0/255 green:184.0/255 blue:229.0/255 alpha:1.0];
    
    // Creates home button
    UIImage* homeImg = [UIImage imageNamed:@"timeline_home"];
    UIImage* homeImgPressed = [UIImage imageNamed:@"timeline_home_pressed"];
    UIButton* homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [homeBtn setFrame:CGRectMake(265, 0, homeImg.size.width+24, homeImg.size.height+24)];  // make the button 24px wider and longer
    [homeBtn setImage:homeImg forState:UIControlStateNormal];
    [homeBtn setImage:homeImgPressed forState:UIControlStateHighlighted];
    [homeBtn addTarget:self action:@selector(homeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [navbar addSubview:homeBtn];
    
    [self.view addSubview:navbar];
    [navbar release];
    
    // Creates logout button.
    UIButton* logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [logoutBtn setFrame:CGRectMake(60, 300, 200, 50)];
    [logoutBtn setBackgroundColor:[UIColor colorWithRed:245/255.0f green:73/255.0 blue:82/255.0 alpha:1.0f]];
    [logoutBtn setTitle:@"Log out" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logoutBtn.titleLabel setFont:[UIFont fontWithName:@"Raleway-SemiBold_2" size:18.0f]];
    [logoutBtn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutBtn];
    
    // Creates the clear button.
    UIButton* clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearButton setFrame:CGRectMake(60, 200, 200, 50)];
    [clearButton setBackgroundColor:[UIColor colorWithRed:245/255.0f green:73/255.0 blue:82/255.0 alpha:1.0f]];
    [clearButton setTitle:@"Clear data" forState:UIControlStateNormal];
    [clearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [clearButton.titleLabel setFont:[UIFont fontWithName:@"Raleway-SemiBold_2" size:18.0f]];
    [clearButton addTarget:self action:@selector(clearData:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearButton];
    
    // Creates the tutorial button.
    UIButton* tutorialButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tutorialButton setFrame:CGRectMake(60, 100, 200, 50)];
    [tutorialButton setBackgroundColor:[UIColor colorWithRed:29/255.0f green:209/255.0 blue:41/255.0 alpha:1.0f]];
    [tutorialButton setTitle:@"Tutorial" forState:UIControlStateNormal];
    [tutorialButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tutorialButton.titleLabel setFont:[UIFont fontWithName:@"Raleway-SemiBold_2" size:18.0f]];
    [tutorialButton addTarget:self action:@selector(startTutorial:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tutorialButton];
}

- (void)logout: (id)sender {}

- (void)clearData: (id)sender {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"Are you sure you want to delete all data?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Delete", nil];
    [alert show];
}

- (void)startTutorial: (id)sender {}

#pragma UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"Cancel");
    } else if (buttonIndex == 1) {
        NSLog(@"Delete");
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(AppDelegate*) getAppDelegate {
    return [[UIApplication sharedApplication] delegate];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
