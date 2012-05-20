//
//  totHomeDiaperViewController.h
//  totdev
//
//  Created by Lixing Huang on 5/19/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "totHomeRootController.h"
#import "totTimerController.h"
#import "../Utility/totNavigationBar.h"

@interface totHomeDiaperViewController : UIViewController <totNavigationBarDelegate, totTimerControllerDelegate> {
    totHomeRootController *mHomeRootController;
    totNavigationBar *mNavigationBar;
    totTimerController *mClock;

    UILabel *wetDiaper, *solidDiaper, *wetSolidDiaper;
    UILabel *currentTimeLabel;
}

@property (nonatomic, assign) totHomeRootController *mHomeRootController;

@end
