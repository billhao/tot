//
//  totSettingEntryViewController.m
//  totdev
//
//  Created by Hao on 6/2/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "../AppDelegate.h"
#import "totSettingEntryViewController.h"
#import "totEventName.h"
#import "totTutorialViewController.h"
#import "totUtility.h"
#import "totHomeRootController.h"
#import "totResetPasswordView.h"

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
        [self.homeController switchTo:kTimeline withContextInfo:nil];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1.0f]];
    
    int statusBarHeight = 0;
    if( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") )
        statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;

    // Creats the navigation bar.
    int navbarHeight = 36;
    UIView* navbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, navbarHeight+statusBarHeight)];
    navbar.backgroundColor = [UIColor colorWithRed:116.0/255 green:184.0/255 blue:229.0/255 alpha:1.0];
    
    // Creates home button
    UIImage* homeImg = [UIImage imageNamed:@"timeline_home"];
    UIImage* homeImgPressed = [UIImage imageNamed:@"timeline_home_pressed"];
    UIButton* homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    homeBtn.frame = CGRectMake(9, (navbarHeight-homeImg.size.height-24)/2+statusBarHeight, homeImg.size.width+24, homeImg.size.height+24); // make the button 24px wider and longer
    [homeBtn setImage:homeImg forState:UIControlStateNormal];
    [homeBtn setImage:homeImgPressed forState:UIControlStateHighlighted];
    [homeBtn addTarget:self action:@selector(homeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [navbar addSubview:homeBtn];
    
    [self.view addSubview:navbar];
    [navbar release];

    // title for settings
    UILabel* title = [[UILabel alloc] init];
    title.font = [UIFont fontWithName:@"Helvetica" size:24];
    title.text = @"Settings";
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor whiteColor];
    [title sizeToFit];
    CGRect frame = self.view.frame;
    CGRect f = title.frame;
    f.origin.x = (frame.size.width-f.size.width)/2;
    f.origin.y = (navbarHeight-f.size.height)/2 + statusBarHeight;
    title.frame = f;
    [navbar addSubview:title];
//    [totUtility enableBorder:title];
    [title release];

    float gap = 63;
    float y = gap + statusBarHeight;
    
    
    // Creates the background.
    UIView* background = [[UIView alloc] initWithFrame:CGRectMake(10, y, 300, 43)];
    background.layer.cornerRadius = 5;
    background.layer.masksToBounds = YES;
    [background setBackgroundColor:[UIColor whiteColor]];
    
    //UIView* separator = [[UIView alloc] initWithFrame:CGRectMake(0, 43, 300, 1)];
    //[separator setBackgroundColor:[UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f]];
    //[background addSubview:separator];
    //[separator release];
    
    // Creates the tutorial button.
    UIButton* tutorialButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tutorialButton setFrame:CGRectMake(0, 0, 300, 43)];
    [tutorialButton setBackgroundColor:[UIColor clearColor]];
    [tutorialButton setTitle:@"Tutorial" forState:UIControlStateNormal];
    [tutorialButton setTitleColor:[UIColor colorWithRed:0.4f green:0.4f blue:0.4f alpha:1.0f] forState:UIControlStateNormal];
    [tutorialButton.titleLabel setFont:[UIFont fontWithName:@"Raleway-SemiBold_2" size:18.0f]];
    [tutorialButton addTarget:self action:@selector(startTutorial:) forControlEvents:UIControlEventTouchUpInside];
    [background addSubview:tutorialButton];
    
    [self.view addSubview:background];
    [background release];
    
    /*
    y += gap;
    UIView* background1 = [[UIView alloc] initWithFrame:CGRectMake(10, y, 300, 43)];
    background1.layer.cornerRadius = 5;
    background1.layer.masksToBounds = YES;
    [background1 setBackgroundColor:[UIColor whiteColor]];
    
    // Creates the clear button.
    UIButton* clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearButton setFrame:CGRectMake(0, 0, 300, 43)];
    [clearButton setBackgroundColor:[UIColor clearColor]];
    [clearButton setTitle:@"Clear data" forState:UIControlStateNormal];
    [clearButton setTitleColor:[UIColor colorWithRed:0.4f green:0.4f blue:0.4f alpha:1.0f] forState:UIControlStateNormal];
    [clearButton.titleLabel setFont:[UIFont fontWithName:@"Raleway-SemiBold_2" size:18.0f]];
    [clearButton addTarget:self action:@selector(clearData:) forControlEvents:UIControlEventTouchUpInside];
    [background1 addSubview:clearButton];
    
    [self.view addSubview:background1];
    [background1 release];
    */
    
    // Creates the reset password button.
    y += gap;
    UIView* background2 = [[UIView alloc] initWithFrame:CGRectMake(10, y, 300, 43)];
    background2.layer.cornerRadius = 5;
    background2.layer.masksToBounds = YES;
    [background2 setBackgroundColor:[UIColor whiteColor]];
    
    UIButton* passwordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [passwordBtn setFrame:CGRectMake(0, 0, 300, 43)];
    [passwordBtn setBackgroundColor:[UIColor clearColor]];
    [passwordBtn setTitle:@"Change password" forState:UIControlStateNormal];
    [passwordBtn setTitleColor:[UIColor colorWithRed:0.4f green:0.4f blue:0.4f alpha:1.0f] forState:UIControlStateNormal];
    [passwordBtn.titleLabel setFont:[UIFont fontWithName:@"RaleWay-SemiBold_2" size:18.0f]];
    [passwordBtn addTarget:self action:@selector(resetPassword:) forControlEvents:UIControlEventTouchUpInside];
    [background2 addSubview:passwordBtn];
    
    [self.view addSubview:background2];
    [background2 release];
    
    // Creates logout button.
    UIButton* logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutBtn.layer.cornerRadius = 5;
    logoutBtn.layer.masksToBounds = YES;
    y += gap;
    [logoutBtn setFrame:CGRectMake(10, y, 300, 43)];
    [logoutBtn setBackgroundColor:[UIColor colorWithRed:245/255.0f green:73/255.0 blue:82/255.0 alpha:1.0f]];
    [logoutBtn setTitle:@"Log out" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logoutBtn.titleLabel setFont:[UIFont fontWithName:@"Raleway-SemiBold_2" size:18.0f]];
    [logoutBtn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutBtn];
}

- (void)resetPassword: (id)sender {
    // create reset password view.
    resetPasswordView = [[totResetPasswordView alloc] initWithFrame:CGRectMake(320, 0, 320, 480)];
    [self.view addSubview:resetPasswordView];

    [UIView beginAnimations:@"show_reset_password" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    {
        resetPasswordView.frame = CGRectMake(0, 0, 320, 480);
    }
    [UIView commitAnimations];
    
    [resetPasswordView release];
}

- (void)logout: (id)sender {
    // remove loggedin in db
    [global.model deletePreferenceNoBaby:PREFERENCE_LOGGED_IN];
    
    // show login screen
    global.baby = nil;
    global.user = nil;
    [[totUtility getAppDelegate] showFirstView];
    
    // unload all the views: home, timeline, scrapbook
    [[totUtility getAppDelegate].homeController releaseAllViews];
}

- (void)clearData: (id)sender {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"Are you sure you want to delete all data?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Delete", nil];
    [alert show];
}

- (void)startTutorial: (id)sender {
    [self.homeController switchTo:KTutorial withContextInfo:nil];
}

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
    [resetPasswordView release];
}

-(AppDelegate*) getAppDelegate {
    return [[UIApplication sharedApplication] delegate];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
