//
//  totResetPasswordView.m
//  totdev
//
//  Created by Lixing Huang on 11/16/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import "totResetPasswordView.h"
#import "AppDelegate.h"
#import "totServerCommController.h"
#import "totUtility.h"

@implementation totResetPasswordView

- (void)homeButtonPressed: (id)sender {
    [UIView beginAnimations:@"hide_reset_password" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    {
        self.frame = CGRectMake(320, 0, 320, 480);
    }
    [UIView commitAnimations];
}

// Reset the password.
- (void)reset: (id)sender {
    [oldPasswordTextField resignFirstResponder];
    [newPasswordTextField resignFirstResponder];

    NSString* oldpwd = oldPasswordTextField.text;
    NSString* newpwd = newPasswordTextField.text;

    NSString* msg = nil;
    if( ![totUser verifyPassword:oldpwd email:global.user.email message:&msg] ) {
        [totUtility showAlert:msg];
        return;
    }
    
    if( ![totLoginController checkPwd:newpwd] ) return;
    
    msg = nil;
    [totUser changePassword:newpwd oldPassword:oldpwd message:&msg];
    [totUtility showAlert:msg];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        float statusBarHeight = 0;
        if( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") )
            statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;

        // Background.
        [self setBackgroundColor:[UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1.0f]];

        // Creats the navigation bar.
        int navbarHeight = 36;
        UIView* navbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, navbarHeight+statusBarHeight)];
        navbar.backgroundColor = [UIColor colorWithRed:116.0/255 green:184.0/255 blue:229.0/255 alpha:1.0];

        // Creates home button.
        UIImage* homeImg = [UIImage imageNamed:@"setting_back"];
        UIButton* homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        float width = homeImg.size.width+24;
        float height = homeImg.size.height+24;
        homeBtn.frame = CGRectMake(9, (navbarHeight-height)/2+statusBarHeight, width, height); // make the button 24px wider and longer
        [homeBtn setImage:homeImg forState:UIControlStateNormal];
        [homeBtn setImage:homeImg forState:UIControlStateHighlighted];
        [homeBtn addTarget:self action:@selector(homeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [navbar addSubview:homeBtn];

        [self addSubview:navbar];
        [navbar release];

        // Title for settings.
        UILabel* title = [[UILabel alloc] init];
        title.font = [UIFont fontWithName:@"Helvetica" size:24];
        title.text = NSLocalizedString(@"Change Password", @"");
        title.backgroundColor = [UIColor clearColor];
        title.textColor = [UIColor whiteColor];
        [title sizeToFit];
        CGRect frame = self.frame;
        CGRect f = title.frame;
        f.origin.x = (frame.size.width-f.size.width)/2;
        f.origin.y = (navbarHeight-f.size.height)/2 + statusBarHeight;
        title.frame = f;
        [navbar addSubview:title];
        [title release];

        float gap = 63;
        float y = gap + statusBarHeight;
        
        oldPasswordTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, y, 300, 40)];
        oldPasswordTextField.borderStyle = UITextBorderStyleRoundedRect;
        oldPasswordTextField.backgroundColor = [UIColor whiteColor];
        oldPasswordTextField.placeholder = NSLocalizedString(@"old password", @"");
        oldPasswordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        oldPasswordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        oldPasswordTextField.returnKeyType = UIReturnKeyDone;
        oldPasswordTextField.secureTextEntry = TRUE;
        newPasswordTextField.delegate = self;
        oldPasswordTextField.delegate = self;

        y += gap;
        newPasswordTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, y, 300, 40)];
        newPasswordTextField.borderStyle = UITextBorderStyleRoundedRect;
        newPasswordTextField.backgroundColor = [UIColor whiteColor];
        newPasswordTextField.placeholder = NSLocalizedString(@"new password", @"");
        newPasswordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        newPasswordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        newPasswordTextField.returnKeyType = UIReturnKeyDone;
        newPasswordTextField.secureTextEntry = TRUE;
        newPasswordTextField.delegate = self;

        [self addSubview:oldPasswordTextField];
        [self addSubview:newPasswordTextField];

        y += gap;
        UIButton* resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        resetBtn.layer.cornerRadius = 5;
        resetBtn.layer.masksToBounds = YES;
        [resetBtn setFrame:CGRectMake(10, y, 300, 43)];
        [resetBtn setBackgroundColor:[UIColor colorWithRed:245/255.0f green:73/255.0 blue:82/255.0 alpha:1.0f]];
        [resetBtn setTitle:NSLocalizedString(@"Go", @"") forState:UIControlStateNormal];
        [resetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [resetBtn.titleLabel setFont:[UIFont fontWithName:@"Raleway-SemiBold_2" size:18.0f]];
        [resetBtn addTarget:self action:@selector(reset:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:resetBtn];
    }
    return self;
}

- (void) dealloc {
    [super dealloc];
    [oldPasswordTextField release];
    [newPasswordTextField release];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end




