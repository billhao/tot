//
//  totReviewFilterView.h
//  totdev
//
//  Created by Lixing Huang on 1/17/13.
//  Copyright (c) 2013 USC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class totReviewFilterOpenerView;
@class totReviewRootController;

@interface totReviewFilterView : UIView {
    totReviewFilterOpenerView *opener;
    totReviewRootController *parentController;
}

@property (nonatomic, retain) totReviewFilterOpenerView *opener;
@property (nonatomic, assign) totReviewRootController *parentController;

- (void) buttonPressed : (id)sender;

@end
