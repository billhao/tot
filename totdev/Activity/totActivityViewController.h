//
//  totActivityViewController.h
//  totdev
//
//  Created by Lixing Huang on 4/15/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "totActivityRootController.h"
#import "../Utility/totSliderView.h"

@interface totActivityViewController : UIViewController <totSliderViewDelegate> {
    totActivityRootController *activityRootController;
    
}

@property (nonatomic, assign) totActivityRootController *activityRootController;




@end
