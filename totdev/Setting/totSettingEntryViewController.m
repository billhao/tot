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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {}
    return self;
}

- (void)didReceiveMemoryWarning {
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

- (void)addButton:(NSString*)name position:(int)y select:(SEL)action {
    // Creates the background.
    UIView* background = [[UIView alloc] initWithFrame:CGRectMake(10, y, 300, 43)];
    [background.layer setCornerRadius:5];
    [background.layer setMasksToBounds:YES];
    [background setBackgroundColor:[UIColor whiteColor]];
    
    // Creates the tutorial button.
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 300, 43)];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setTitle:name forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0.4f green:0.4f blue:0.4f alpha:1.0f] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:@"Raleway-SemiBold_2" size:18.0f]];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [background addSubview:button];
    
    [self.view addSubview:background];
    [background release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1.0f]];

    float statusBarHeight = 0;
    if( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") )
        statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;

    // Creats the navigation bar.
    int navbarHeight = 36;
    UIView* navbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, navbarHeight+statusBarHeight)];
    navbar.backgroundColor = [UIColor colorWithRed:116.0/255
                                             green:184.0/255
                                              blue:229.0/255
                                             alpha:1.0];

    // Creates home button
    UIImage* homeImg = [UIImage imageNamed:@"setting_back"];
    UIButton* homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    homeBtn.frame = CGRectMake(9,
                               (navbarHeight-homeImg.size.height-24)/2+statusBarHeight,
                               homeImg.size.width+24,
                               homeImg.size.height+24);  // make the button 24px wider and longer
    [homeBtn setImage:homeImg forState:UIControlStateNormal];
    [homeBtn setImage:homeImg forState:UIControlStateHighlighted];
    [homeBtn addTarget:self action:@selector(homeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [navbar addSubview:homeBtn];
    
    [self.view addSubview:navbar];
    [navbar release];

    // title for settings
    UILabel* title = [[UILabel alloc] init];
    [title setFont:[UIFont fontWithName:@"Helvetica" size:24]];
    [title setText:@"Settings"];
    [title setBackgroundColor:[UIColor clearColor]];
    [title setTextColor:[UIColor whiteColor]];
    [title sizeToFit];
    CGRect frame = self.view.frame;
    CGRect f = title.frame;
    f.origin.x = (frame.size.width-f.size.width)/2;
    f.origin.y = (navbarHeight-f.size.height)/2 + statusBarHeight;
    [title setFrame:f];
    [navbar addSubview:title];
    [title release];

    float gap = 63;

    // Creates the tutorial button.
    float y = gap + statusBarHeight; [self addButton:@"Tutorial" position:y select:@selector(startTutorial:)];
    // Creates the reset password button.
    y += gap; [self addButton:@"Change password" position:y select:@selector(resetPassword:)];
    // Creates the rating button
    y += gap; [self addButton:@"Review on app store" position:y select:@selector(rate:)];
    // Creates the contact button
    y += gap; [self addButton:@"Contact us" position:y select:@selector(contact:)];

    // Creates logout button.
    y += gap;
    UIButton* logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutBtn.layer.cornerRadius = 5;
    logoutBtn.layer.masksToBounds = YES;
    [logoutBtn setFrame:CGRectMake(10, y, 300, 43)];
    [logoutBtn setBackgroundColor:[UIColor colorWithRed:245/255.0f green:73/255.0 blue:82/255.0 alpha:1.0f]];
    [logoutBtn setTitle:@"Log out" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logoutBtn.titleLabel setFont:[UIFont fontWithName:@"Raleway-SemiBold_2" size:18.0f]];
    [logoutBtn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutBtn];
}

#pragma MFMailComposeViewControllerDelegate
- (void) mailComposeController:(MFMailComposeViewController *)controller
           didFinishWithResult:(MFMailComposeResult)result
                         error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Message"
                                                            message:@"Received your message. We'll contact you ASAP if necessary."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil] autorelease];
            [alert show];
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)contact: (id)sender {
    // Email Subject
    NSString *emailTitle = @"Contact tot team";
    // Email Content
    NSString *messageBody = @"";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"totdevteam@gmail.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    [mc release];
}

- (void)rate: (id)sender {
    static NSString *const iOSAppStoreURLFormat =
        @"itms-apps://itunes.apple.com/app/id632407645";
    static NSString *const iOS7AppStoreURLFormat =
        @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=632407645";
    NSString* urlFormat = [[UIDevice currentDevice].systemVersion floatValue] >= 7.0f ? iOS7AppStoreURLFormat: iOSAppStoreURLFormat;
    NSURL* reviewURL = [NSURL URLWithString:urlFormat];
    
    // Go to iTunes store.
    [[UIApplication sharedApplication] openURL:reviewURL];
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
