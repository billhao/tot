//
//  totLoginController.h
//  totdev
//
//  Created by Hao on 5/26/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "totModel.h"

@interface totLoginController : UIViewController <UITextFieldDelegate> {
    IBOutlet UITextField *mEmail, *mPwd, *mCurrentControl;
    IBOutlet UIButton*    mLogin;
    IBOutlet UIButton*    mNewuser;
    IBOutlet UIButton*    mPrivacy;

    totModel* model;
    int mBaby_id; // baby id for new user
}

// create new user or login
@property (nonatomic) BOOL newuser; // whether shown as create new user page or login page, this is set before current view is shown

- (IBAction) backgroundTap:(id) sender;

- (BOOL)checkEmail;
- (BOOL)checkPwd;

- (void)setLoggedIn:(NSString*)email;
- (void)showHomeView;

- (void)showAlert:(NSString*)text; // show a message box

- (void)setBabyIDforNewUser:(int)newbaby_id;

@end
