//
//  totResetPasswordView.h
//  totdev
//
//  Created by Lixing Huang on 11/16/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface totResetPasswordView : UIView <UITextFieldDelegate> {
    UITextField* oldPasswordTextField;
    UITextField* newPasswordTextField;
}

@end
