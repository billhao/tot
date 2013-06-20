//
//  totBookletView.h
//  totdev
//
//  Created by Lixing Huang on 6/11/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "totCameraViewController.h"

@class totPageElement;
@class totPage;
@class totBook;

// ---------------------------------totBookBasicView---------------------------------------

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

// ---------------------------------totPageElementViewInternal---------------------------------------

// Represents the view of basic page element.
@interface totPageElementViewInternal : totBookBasicView {
    // Data
    totPageElement* mData;
    // Subviews
    UIImageView *mImage;
}

@property (nonatomic, retain) totPageElement* mData;

- (id)initWithElement:(totPageElement*)data;
- (void)display;
- (void)resizeTo:(CGRect)size;
// whether the element contains media files or not.
- (BOOL)isEmpty;

@end

// ---------------------------------totPageElementView---------------------------------------

// Wrapper of the basic page element. (To make the rotation work..)
// And deal with other touch events.
@interface totPageElementView : UIView <UIGestureRecognizerDelegate, CameraViewDelegate> {
    totPageElementViewInternal* mView;
    CGPoint mTouchLastTime;
}

@property (nonatomic, readonly) totPageElementViewInternal* mView;

- (id)initWithElementData:(totPageElement*)data;
- (void)setPageElementData:(totPageElement*)data;

@end

// ---------------------------------totPageView---------------------------------------

// Page View
@interface totPageView : UIView {
    // Data
    totPage* mPage;
    
    // Subviews
    NSMutableArray* mElementsView;
    UIImageView* mBackground;
}

@property (nonatomic, readonly) totPage* mPage;

// Loads the template data.
// data should be [totPage toDictionary];
- (id)initWithFrame:(CGRect)frame andPageTemplateData:(NSDictionary*)data;
- (id)initWithFrame:(CGRect)frame pagedata:(totPage*)pagedata;

    // Loads an existed book.
- (void)loadFromData:(NSString*)jsonData;

- (CGPoint)fullPageSize;

@end

// ---------------------------------totBookView---------------------------------------

// Book View
@interface totBookView : UIView {
    // Data
    totBook* mBook;
    
    // Subviews
    totPageView* mPrev;
    totPageView* mCurr;
    totPageView* mNext;
}

- (void)addNewPage:(NSString*)pageName;

@end



