//
//  totHomeRootController.h
//  totdev
//
//  Created by Lixing Huang on 4/11/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class totHomeEntryViewController;

@interface totHomeRootController : UIViewController {
    totHomeEntryViewController *homeEntryViewController;
}

@property (nonatomic, retain) totHomeEntryViewController *homeEntryViewController;

@end
