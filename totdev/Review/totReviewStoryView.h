//
//  totReviewStoryView.h
//  totdev
//
//  Created by Lixing Huang on 6/2/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

// this is the display logic of totReviewStory

#import <UIKit/UIKit.h>
#import "totReviewStory.h"

@protocol totReviewStoryViewDelegate <NSObject>

@optional
- (void) storyView:(id)storyView pressInsideView:(UIView*)view;

@end


@interface totReviewStoryView : UIView {
    int height, width;
}

- (void) setReviewStory:(totReviewStory*)story;

@property (nonatomic, assign) int height;
@property (nonatomic, assign) int width;

@end
