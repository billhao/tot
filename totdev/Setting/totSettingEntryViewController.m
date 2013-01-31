//
//  totSettingEntryViewController.m
//  totdev
//
//  Created by Hao on 6/2/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totSettingEntryViewController.h"
#import "AppDelegate.h"
#import "totEventName.h"

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
    [mClearDBButton addTarget:self action:@selector(ClearDBButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mSignOutButton addTarget:self action:@selector(SignOutButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
