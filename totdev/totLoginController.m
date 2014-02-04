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
#import "totUtility.h"

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
    [mForgotPwd addTarget:self action:@selector(ForgotPwdButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    mEmail = [[UITextField alloc] initWithFrame:CGRectMake(60, 71, 180, 37)];
    mPwd = [[UITextField alloc] initWithFrame:CGRectMake(60, 131, 180, 37)];
    
    [mEmail setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [mEmail setBorderStyle:UITextBorderStyleNone];
    [mEmail setPlaceholder:NSLocalizedString(@"Email", @"")];
    [mEmail setTextColor:[UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1.0f]];
    [self.view addSubview:mEmail];
    mEmail.autocorrectionType = UITextAutocorrectionTypeNo;
    mEmail.keyboardType = UIKeyboardTypeEmailAddress;
    mEmail.returnKeyType = UIReturnKeyDone;
    mEmail.enablesReturnKeyAutomatically = TRUE;
    
    [mPwd setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [mPwd setBorderStyle:UITextBorderStyleNone];
    [mPwd setPlaceholder:NSLocalizedString(@"Password", @"")];
    [mPwd setTextColor:[UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1.0f]];
    mPwd.autocorrectionType = UITextAutocorrectionTypeNo;
    mPwd.returnKeyType = UIReturnKeyDone;
    mPwd.enablesReturnKeyAutomatically = TRUE;
    mPwd.secureTextEntry = TRUE;
    [self.view addSubview:mPwd];
    
    [mEmail setDelegate:self];
    [mPwd setDelegate:self];
    
    NSString* email_string = @"Email";
    if (![email_string isEqualToString:NSLocalizedString(@"Email", @"")]) {
        UIButton* login_button = [UIButton buttonWithType:UIButtonTypeCustom];
        login_button.layer.cornerRadius = 5;
        [login_button setFrame:mLogin.frame];
        [login_button setTitle:NSLocalizedString(@"Login", @"") forState:UIControlStateNormal];
        [login_button setTitleColor:[UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0]
                           forState:UIControlStateNormal];
        [login_button setBackgroundColor:[UIColor colorWithRed:51/255.0f green:209/255.0 blue:33/255.0 alpha:1.0f]];
        [login_button addTarget:self
                         action:@selector(LoginButtonClicked:)
               forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:login_button];
        
        UIButton* register_button = [UIButton buttonWithType:UIButtonTypeCustom];
        register_button.layer.cornerRadius = 5;
        [register_button setFrame:mNewuser.frame];
        [register_button setTitle:NSLocalizedString(@"Register", @"") forState:UIControlStateNormal];
        [register_button setTitleColor:[UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0]
                              forState:UIControlStateNormal];
        [register_button setBackgroundColor:[UIColor colorWithRed:245/255.0f green:73/255.0 blue:82/255.0 alpha:1.0f]];
        [register_button addTarget:self
                            action:@selector(NewUserButtonClicked:)
                  forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:register_button];
        
        [mLogin setHidden:YES];
        [mNewuser setHidden:YES];
        [mForgotPwd setHidden:YES];
    }
    
    mPrivacy.hidden = TRUE;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [mEmail release];
    [mPwd release];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"[Login]new user mode=%d", newuser);
    
    UIImage* bgImg;
    if( newuser ) {
        //mLogin.hidden = TRUE;
        //mNewuser.frame = CGRectMake(47, mNewuser.frame.origin.y, mNewuser.frame.size.width, mNewuser.frame.size.height);
        
        //set background
        bgImg = [UIImage imageNamed:@"bg_registration"];
//        UIColor* bg = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg_registration"]];
//        self.view.backgroundColor = bg;
//        [bg release];
    }
    else {
        mNewuser.hidden = FALSE;
        
        //set background
        bgImg = [UIImage imageNamed:@"bg_login"];
//        UIColor* bg = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg_login"]];
//        self.view.backgroundColor = bg;
//        [bg release];
    }
    self.view.backgroundColor = [UIColor blackColor];
    UIImageView* bgImgView = [[UIImageView alloc] initWithImage:bgImg];
    [self.view addSubview:bgImgView];
    [self.view sendSubviewToBack:bgImgView];
    [bgImgView release];

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
    // check if email and pwd matches db
    NSString* email = mEmail.text;
    NSString* pwd = mPwd.text;
    
    // check validity of email and pwd
    if( ![self checkEmail] ) return;
    if( ![totLoginController checkPwd:pwd] ) return;

    // check if email exists
    NSString* account_pref = [NSString stringWithFormat:PREFERENCE_ACCOUNT, email];
    NSString* pwd_db = [model getPreferenceNoBaby:account_pref];
    
    NSString* msg = nil;
    if( [totUser verifyPassword:pwd email:email message:&msg] ) {
        // TODO add this user's info to local db if she has never used on this phone before, such as after a phone change
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
        
        [user release];
        
        /*
         if( global.baby != nil )
            [global.baby printBabyInfo];
        */
        
        // if yes and pwd matches, go to home view
        [self backgroundTap:nil]; // dismiss keyboard
        // add account if this account does not exist on this device
        [totUser addAccount:email password:pwd];
        [self setLoggedIn:email];
        [self showHomeView];
    }
    else {
        // if yes and pwd doesn't match, prompt for pwd
        if( msg )
            [self showAlert:msg];
        else
            [self showAlert:@"Email address or password does not match"];
    }
}

- (void)NewUserButtonClicked: (UIButton *)button {
    NSString* email = mEmail.text;
    NSString* pwd = mPwd.text;
    
    // check validity of email and pwd
    if( ![self checkEmail] ) return;
    if( ![totLoginController checkPwd:pwd] ) return;

    // check if email exists
    NSString* account_pref = [NSString stringWithFormat:PREFERENCE_ACCOUNT, email];
    NSString* pwd_db = [model getPreferenceNoBaby:account_pref];
    
    NSString* msg = nil;
    if( pwd_db == nil ) {
        // if no, add email and pwd to db, go to home view
        totUser* user =[totUser newUser:email password:pwd message:&msg];
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
            if( msg )
                [self showAlert:msg];
            else
                [self showAlert:@"Fail to add user"];
            return;
        }
        [user release];
    }
    else {
        BOOL re = [totUser verifyPassword:pwd email:email message:&msg];
        if( re ) {
            totUser* user = [[totUser alloc] initWithID:email];
            global.user = user;
            if( global.baby != nil ) {
                // add new baby's id to this user
                [user addBabyToUser:global.baby];
                [user setDefaultBaby:global.baby];
            }
            [user release];
            // if yes and pwd matches, go to home view
            [self backgroundTap:nil]; // dismiss keyboard
            [self setLoggedIn:email];
            [self showHomeView];
        }
        else {
            if( msg )
                [self showAlert:msg];
            else
                [self showAlert:@"Email address already exists but password does not match"];
        }
    }
}

- (void)ForgotPwdButtonClicked: (UIButton *)button {
    if( ![self checkEmail] ) return;

    NSString* email = mEmail.text;
    NSString* msg = nil;
    BOOL re = [totUser forgotPassword:email message:&msg];
    if( msg )
        [self showAlert:msg];
    else
        [self showAlert:@"Cannot reset password"];
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
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    BOOL showTutorial = FALSE;
    totEvent* e = [global.model getItem:PREFERENCE_NO_BABY name:EVENT_TUTORIAL_SHOW];
    if ( e == nil ) {
        // show tutorial if this is the first time
        [appDelegate showTutorial];
        return;
    }
    
    // go to home view
    [appDelegate showHomeView:TRUE];
}

- (void)PrivacyButtonClicked: (UIButton *)button {
}

// check email against a regex
- (BOOL)checkEmail {
    NSString* email = mEmail.text;
    email = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // check
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    if ([emailTest evaluateWithObject:email] == NO) {
        [self showAlert:@"Invalid email address"];
        return FALSE;
    }
    
    return TRUE;
}

// password needs to be 4 chars or more
+ (BOOL)checkPwd:(NSString*)pwd {
    NSString* pwd1 = [pwd stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if( pwd.length != pwd1.length ) {
        [totUtility showAlert:@"Password cannot start or end with space"];
        return FALSE;
    }
    else if( pwd.length < 4 ) {
        // prompt for a valid pwd
        [totUtility showAlert:@"Password must be at least 4 characters"];
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
