//
//  totSettingRootController.h
//  totdev
//
//  Created by Lixing Huang on 4/11/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "totHomeRootController.h"

@class totSettingEntryViewController;

@interface totSettingRootController : UIViewController {
    totSettingEntryViewController* mEntryView;
}

@property (nonatomic, retain) totSettingEntryViewController* mEntryView;
@property (nonatomic, assign) totHomeRootController* homeController;

@end
