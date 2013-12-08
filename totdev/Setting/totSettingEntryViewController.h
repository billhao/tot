//
//  totSettingEntryViewController.h
//  totdev
//
//  Created by Hao on 6/2/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "totModel.h"

@class totHomeRootController;
@class totResetPasswordView;

@interface totSettingEntryViewController : UIViewController <UIAlertViewDelegate, MFMailComposeViewControllerDelegate> {
    totResetPasswordView* resetPasswordView;
}

@property (nonatomic, assign) totHomeRootController* homeController;

@end
