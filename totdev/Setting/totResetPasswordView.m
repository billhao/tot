//
//  totResetPasswordView.m
//  totdev
//
//  Created by Lixing Huang on 11/16/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import "totResetPasswordView.h"
#import "AppDelegate.h"

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

}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        int statusBarHeight = 0;
        if( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") )
            statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;

        // Background.
        [self setBackgroundColor:[UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1.0f]];

        // Creats the navigation bar.
        int navbarHeight = 36;
        UIView* navbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, navbarHeight+statusBarHeight)];
        navbar.backgroundColor = [UIColor colorWithRed:116.0/255 green:184.0/255 blue:229.0/255 alpha:1.0];

        // Creates home button.
        UIImage* homeImg = [UIImage imageNamed:@"timeline_home"];
        UIImage* homeImgPressed = [UIImage imageNamed:@"timeline_home_pressed"];
        UIButton* homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];

        homeBtn.frame = CGRectMake(277.5-12, (navbarHeight-homeImg.size.height-24)/2+statusBarHeight,
                                   homeImg.size.width+24, homeImg.size.height+24); // make the button 24px wider and longer
        [homeBtn setImage:homeImg forState:UIControlStateNormal];
        [homeBtn setImage:homeImgPressed forState:UIControlStateHighlighted];
        [homeBtn addTarget:self action:@selector(homeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [navbar addSubview:homeBtn];

        [self addSubview:navbar];
        [navbar release];

        // Title for settings.
        UILabel* title = [[UILabel alloc] init];
        title.font = [UIFont fontWithName:@"Helvetica" size:24];
        title.text = @"Reset Password";
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

        UILabel* oldPassword = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 300, 30)];
        oldPassword.text = @"Old Password";
        [oldPassword setFont:[UIFont fontWithName:@"Raleway-SemiBold_2" size:18]];
        [oldPassword setTextColor:[UIColor colorWithRed:0.4f green:0.4f blue:0.4f alpha:1.0f]];
        [self addSubview:oldPassword];
        [oldPassword release];

        oldPasswordTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 100, 300, 40)];
        oldPasswordTextField.borderStyle = UITextBorderStyleRoundedRect;
        oldPasswordTextField.backgroundColor = [UIColor whiteColor];
        oldPasswordTextField.delegate = self;

        UILabel* newPassword = [[UILabel alloc] initWithFrame:CGRectMake(10, 160, 300, 30)];
        newPassword.text = @"New Password";
        [newPassword setFont:[UIFont fontWithName:@"Raleway-SemiBold_2" size:18]];
        [newPassword setTextColor:[UIColor colorWithRed:0.4f green:0.4f blue:0.4f alpha:1.0f]];
        [self addSubview:newPassword];
        [newPassword release];

        newPasswordTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 190, 300, 40)];
        newPasswordTextField.borderStyle = UITextBorderStyleRoundedRect;
        newPasswordTextField.backgroundColor = [UIColor whiteColor];
        newPasswordTextField.delegate = self;

        [self addSubview:oldPasswordTextField];
        [self addSubview:newPasswordTextField];

        UIButton* resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        resetBtn.layer.cornerRadius = 5;
        resetBtn.layer.masksToBounds = YES;
        [resetBtn setFrame:CGRectMake(10, 280, 300, 43)];
        [resetBtn setBackgroundColor:[UIColor colorWithRed:245/255.0f green:73/255.0 blue:82/255.0 alpha:1.0f]];
        [resetBtn setTitle:@"Reset" forState:UIControlStateNormal];
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




