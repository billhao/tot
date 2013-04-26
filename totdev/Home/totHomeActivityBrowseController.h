//
//  totHomeActivityBrowseController.h
//  totdev
//
//  Created by Lixing Huang on 4/25/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import <UIKit/UIKit.h>

@class totHomeRootController;

@interface totHomeActivityBrowseController : UIViewController {
    totHomeRootController* homeRootController;
}

@property (nonatomic, assign) totHomeRootController* homeRootController;

// receive para meters passed by other module for initialization or customization
// This module need display the labels for the current image.
// So expect there is a key named "labels" in the message.
// When writing code for this module, just suppose there is a NSArray* existed as a value.
// The reason to use NSArray is that we suppose each photo or video can have more than one labels.
- (void)receiveMessage: (NSMutableDictionary*)message;

@end
