//
//  totBookletView.h
//  totdev
//
//  Created by Lixing Huang on 6/11/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import <UIKit/UIKit.h>

@class totPageElement;
@class totPage;
@class totBook;

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

// Wrapper of the basic page element. (To make the rotation work..)
// And deal with other touch events.
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
// Loads an existed book.
- (void)loadFromData:(NSString*)jsonData;

- (CGPoint)fullPageSize;

@end

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



