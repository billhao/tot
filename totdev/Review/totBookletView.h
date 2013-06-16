//
//  totBookletView.h
//  totdev
//
//  Created by Lixing Huang on 6/11/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import <UIKit/UIKit.h>

@class totPageElement;

// Takes care of the animation.
@interface totBookBasicView : UIView {
}

- (void) rotate: (float)r;
- (void) scale: (float)s;
- (void) rotateTo: (float)r;
- (void) scaleToX: (float)sx andToY:(float)sy;
- (void) scaleTo: (float)s;
- (void) moveTo: (CGPoint)p;

@end

// Represents the view of basic page element.
@interface totPageElementViewInternal : totBookBasicView {
    totPageElement* mData;
    UIImageView *mImage;
}

@property (nonatomic, retain) totPageElement* mData;

- (id)initWithElement:(totPageElement*)data;
- (void)display;
- (void)resizeTo:(CGRect)size;

@end

// Wrapper of the basic page element. (To make the rotation work..)
@interface totPageElementView : UIView <UIGestureRecognizerDelegate> {
    totPageElementViewInternal* mView;
    CGPoint mTouchLastTime;
}

@property (nonatomic, readonly) totPageElementViewInternal* mView;

- (id)initWithElementData:(totPageElement*)data;
- (void)setPageElementData:(totPageElement*)data;
@end


// Page View
@interface totPageView : UIView {

}

@end

// Book View
@interface totBookView : UIView {

}

@end