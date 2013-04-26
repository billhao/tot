//
//  totHomeAlbumBrowseController.h
//  totdev
//
//  Created by Lixing Huang on 4/25/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import <UIKit/UIKit.h>

@class totHomeRootController;

@interface totHomeAlbumBrowseController : UIViewController {
    totHomeRootController* homeRootController;
}

@property (nonatomic, assign) totHomeRootController* homeRootController;

- (void)receiveMessage: (NSMutableDictionary*)message;

@end
