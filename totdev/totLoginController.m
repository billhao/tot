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

@synthesize newuser;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        model = global.model;
        newuser = FALSE;
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"[Login]new user mode=%d", newuser);
    
    if( newuser ) {
        mLogin.hidden = TRUE;
        mNewuser.frame = CGRectMake(47, mNewuser.frame.origin.y, mNewuser.frame.size.width, mNewuser.frame.size.height);
        //set background
        self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg_registration"]];
    }
    else {
        mNewuser.hidden = FALSE;
        
        //set background
        self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg_login"]];
    }

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
    NSString* account_pref = [NSString stringWithFormat:PREFERENCE_ACCOUNT, email];
    NSString* pwd_db = [model getPreferenceNoBaby:account_pref];
    
    if( (pwd_db!=nil) && ([pwd compare:pwd_db]==NSOrderedSame) ) {
        totUser* user = [[totUser alloc] initWithID:email];
        global.user = user;
        if( global.baby != nil ) {
            // add new baby's id to this user
            [user addBabyToUser:global.baby];
            [user setDefaultBaby:global.baby];
        }
        else {
            // check if baby is set. it may be nil after register. get the default baby for user if baby is not set.
            global.baby = [global.user getDefaultBaby];
        }
        if( global.baby != nil )
            [global.baby printBabyInfo];
        
        // if yes and pwd matches, go to home view
        [self backgroundTap:nil]; // dismiss keyboard
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
    NSString* account_pref = [NSString stringWithFormat:PREFERENCE_ACCOUNT, email];
    NSString* pwd_db = [model getPreferenceNoBaby:account_pref];
    
    if( pwd_db == nil ) {
        // if no, add email and pwd to db, go to home view
        totUser* user =[totUser newUser:email password:pwd];
        if( user != nil ) {
            global.user = user;
            if( global.baby != nil ) {
                // add new baby's id to this user
                [user addBabyToUser:global.baby];
                [user setDefaultBaby:global.baby];
            }
            [self backgroundTap:nil]; // dismiss keyboard
            [self setLoggedIn:email];
            [self showHomeView];
        }
        else {
            // prompt fail to add user
            [self showAlert:@"Fail to add user"];
            return;
        }
        [user release];
    }
    else if( [pwd compare:pwd_db]==NSOrderedSame ) {
        totUser* user = [[totUser alloc] initWithID:email];
        global.user = user;
        if( global.baby != nil ) {
            // add new baby's id to this user
            [user addBabyToUser:global.baby];
            [user setDefaultBaby:global.baby];
        }
        // if yes and pwd matches, go to home view
        [self backgroundTap:nil]; // dismiss keyboard
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

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    mCurrentControl = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    mCurrentControl = nil;
}

// dismiss the keyboard when tapping on background
- (IBAction) backgroundTap:(id) sender{
    if( mCurrentControl == mEmail ) {
        [mEmail resignFirstResponder];
    }
    else if( mCurrentControl == mPwd ) {
        [mPwd resignFirstResponder];
    }
}

-(AppDelegate*) getAppDelegate {
    return [[UIApplication sharedApplication] delegate];
}

@end
