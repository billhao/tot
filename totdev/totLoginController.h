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
    IBOutlet UITextField* mEmail;
    IBOutlet UITextField* mPwd;
    IBOutlet UIButton*    mLogin;
    IBOutlet UIButton*    mNewuser;
    IBOutlet UIButton*    mPrivacy;

    totModel* model;
}

- (BOOL)checkEmail;
- (BOOL)checkPwd;

- (void)setLoggedIn:(NSString*)email;
- (void)showHomeView;

- (void)showAlert:(NSString*)text; // show a message box

@end
