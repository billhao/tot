//
//  totHomeActivityLabelController.h
//  totdev
//
//  Created by Lixing Huang on 4/25/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "totSliderView.h"

@class totHomeRootController;

@interface totHomeActivityLabelController : UIViewController<totSliderViewDelegate> {
    totHomeRootController* homeRootController;
    
    UIImageView* backgroundImage;
    NSMutableDictionary* mMessage;
    
    NSMutableArray* mActivities;
    NSMutableDictionary* mActivityChildren;
    
    totSliderView* mActivitySlider;
    NSMutableArray* mActivityChildrenSliders;
    totSliderView* currentChildSlider;
    totSliderView* mExistingActivitySlider;

}

@property (nonatomic, assign) totHomeRootController* homeRootController;

// receive parameters passed by other module for initialization or customization
// In this module, we need display the photo or the thumbnail of the video just captured.
// So expect there is a key named "image" in the message.
// When writing code for this module, just suppose there is a UIImage* existed as a value.
- (void)receiveMessage: (NSMutableDictionary*)message;


- (void)sliderView:(totSliderView*)sv buttonPressed:(id)sender;

@end
