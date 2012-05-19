//
//  totHomeDiaperViewController.h
//  totdev
//
//  Created by Lixing Huang on 5/19/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "totHomeRootController.h"

@interface totHomeDiaperViewController : UIViewController {
    totHomeRootController *mHomeRootController;
}

@property (nonatomic, assign) totHomeRootController *mHomeRootController;

@end
