//
//  totLoginController.m
//  totdev
//
//  Created by Hao on 5/26/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totLoginController.h"
#import "AppDelegate.h"
#import "totEventName.h"

@implementation totLoginController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        model = [appDelegate getDataModel];
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

    // set up events
    [mLogin addTarget:self action:@selector(LoginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mNewuser addTarget:self action:@selector(NewUserButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mPrivacy addTarget:self action:@selector(PrivacyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mEmail setDelegate:self];
    [mPwd setDelegate:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    // set email and clear password
    NSString* lastlogin = [model getPreferenceNoBaby:PREFERENCE_LAST_LOGGED_IN];
    if( lastlogin==nil )
        mEmail.text = @"";
    else {
        mEmail.text = lastlogin;
    }
    mPwd.text = @"";
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)LoginButtonClicked: (UIButton *)button {
    // check validity of email and pwd
    if( ![self checkEmail] ) return;
    if( ![self checkPwd] ) return;

    // check if email and pwd matches db
    NSString* email = mEmail.text;
    NSString* pwd = mPwd.text;
    
    // check if email exists
    NSString* account_pref = [NSString stringWithFormat:@"Account/%@", email];
    NSString* pwd_db = [model getPreferenceNoBaby:account_pref];
    
    if( (pwd_db!=nil) && ([pwd compare:pwd_db]==NSOrderedSame) ) {
        // if yes and pwd matches, go to home view
        [self setLoggedIn:email];
        [self showHomeView];
    }
    else {
        // if yes and pwd doesn't match, prompt for pwd
        [self showAlert:@"User does not exist or password doesn't match"];
    }
}

- (void)NewUserButtonClicked: (UIButton *)button {
    // check validity of email and pwd
    if( ![self checkEmail] ) return;
    if( ![self checkPwd] ) return;

    NSString* email = mEmail.text;
    NSString* pwd = mPwd.text;

    // check if email exists
    NSString* account_pref = [NSString stringWithFormat:@"Account/%@", email];
    NSString* pwd_db = [model getPreferenceNoBaby:account_pref];
    
    if( pwd_db == nil ) {
        // if no, add email and pwd to db, go to home view
        BOOL re = [model addPreferenceNoBaby:account_pref value:pwd];
        if( re ) {
            [self setLoggedIn:email];
            [self showHomeView];
        }
        else {
            // prompt fail to add user
            [self showAlert:@"Fail to add user"];
            return;
        }
    }
    else if( [pwd compare:pwd_db]==NSOrderedSame ) {
        // if yes and pwd matches, go to home view
        [self setLoggedIn:email];
        [self showHomeView];
    }
    else {
        // if yes and pwd doesn't match, prompt for pwd
        [self showAlert:@"User already exists"];
    }
}

- (void)showAlert:(NSString*)text {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" 
                                                    message:text 
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

// set the logged in flag in db
- (void)setLoggedIn:(NSString*)email {
    [model updatePreferenceNoBaby:PREFERENCE_LOGGED_IN value:email];
    [model updatePreferenceNoBaby:PREFERENCE_LAST_LOGGED_IN value:email];
}

- (void)showHomeView {
    // go to home view
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate showHomeView];
}

- (void)PrivacyButtonClicked: (UIButton *)button {
}

- (BOOL)checkEmail {
    NSString* email = mEmail.text;
    if( email.length == 0 ) {
        // prompt for a valid email
        return FALSE;
    }
    
    return TRUE;
}

- (BOOL)checkPwd {
    NSString* pwd = mPwd.text;
    if( pwd.length == 0 ) {
        // prompt for a valid pwd
        return FALSE;
    }
    
    return TRUE;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return TRUE;
}

@end
