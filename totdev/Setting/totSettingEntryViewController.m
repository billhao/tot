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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor blueColor];
    
    // add bg
    /*
    UIImage* img = [UIImage imageNamed:@"settings_bg"];
    UIImageView* bgview = [[UIImageView alloc] initWithImage:img];
    bgview.frame = CGRectMake(0, 0, img.size.width, img.size.height);
    [self.view addSubview:bgview];
    [self.view sendSubviewToBack:bgview];
    [bgview release];

    // set buttons appearances
    UIFont* font = [UIFont fontWithName:@"Roboto-Regular" size:16.0];
    UIColor* fontcolor = [UIColor colorWithRed:217.0/255 green:27.0/255 blue:92.0/255 alpha:1];//[UIColor colorWithRed:147.0/255 green:149.0/255 blue:152.0/255 alpha:1];

    [mClearDBButton.titleLabel setFont:font];
    [mClearDBButton setTitleColor:fontcolor forState:UIControlStateNormal];
    [mClearDBButton setTitleColor:fontcolor forState:UIControlStateHighlighted];
    [mClearDBButton setTitle:@"clear database" forState:UIControlStateNormal];
    [mClearDBButton setTitle:@"clear database" forState:UIControlStateHighlighted];

    [mSignOutButton.titleLabel setFont:font];
    [mSignOutButton setTitleColor:fontcolor forState:UIControlStateNormal];
    [mSignOutButton setTitleColor:fontcolor forState:UIControlStateHighlighted];
    [mSignOutButton setTitle:@"sign out" forState:UIControlStateNormal];
    [mSignOutButton setTitle:@"sign out" forState:UIControlStateHighlighted];

    [mTutorialButton.titleLabel setFont:font];
    [mTutorialButton setTitleColor:fontcolor forState:UIControlStateNormal];
    [mTutorialButton setTitleColor:fontcolor forState:UIControlStateHighlighted];
    [mTutorialButton setTitle:@"show tutorial" forState:UIControlStateNormal];
    [mTutorialButton setTitle:@"show tutorial" forState:UIControlStateHighlighted];

    [mClearDBButton addTarget:self action:@selector(ClearDBButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mSignOutButton addTarget:self action:@selector(SignOutButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mTutorialButton addTarget:self action:@selector(TutorialButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
     */
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)ClearDBButtonClicked: (UIButton *)button {
    [global.model clearDB];
    NSLog(@"%@", @"[settings] clearing database");
}

- (void)SignOutButtonClicked: (UIButton *)button {
    [global.model deletePreferenceNoBaby:PREFERENCE_LOGGED_IN];

    // show log in
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    // clear current baby and user information
    global.baby = nil;
    global.user = nil;

    // show login view
    [appDelegate showFirstView];
    //[self presentViewController:appDelegate.loginController animated:TRUE completion:nil];
}

- (void)TutorialButtonClicked: (UIButton *)button {
    AppDelegate* app = [self getAppDelegate];
    [app showTutorial];
}

-(AppDelegate*) getAppDelegate {
    return [[UIApplication sharedApplication] delegate];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
