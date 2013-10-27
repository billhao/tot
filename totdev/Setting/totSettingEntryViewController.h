//
//  totSettingEntryViewController.h
//  totdev
//
//  Created by Hao on 6/2/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "totModel.h"

@class totHomeRootController;

@interface totSettingEntryViewController : UIViewController <UIAlertViewDelegate> {}

@property (nonatomic, assign) totHomeRootController* homeController;

@end
