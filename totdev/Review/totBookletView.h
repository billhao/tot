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
- (void) rotateTo: (float)r;
- (void) scale: (float)s;
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
- (void)removeImage;
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

@property (nonatomic, retain) totPage* mPage;

// Loads the template data.
// data should be [totPage toDictionary];
- (id)initWithFrame:(CGRect)frame andPageTemplateData:(NSDictionary*)data;
- (id)initWithFrame:(CGRect)frame pagedata:(totPage*)pagedata;

@end

// ---------------------------------totBookView---------------------------------------

@class totBookView;

@protocol BookViewDelegate <NSObject>
@optional
- (void) tapAtBook:(totBookView*)bookview;
- (void) longPressAtBook:(totBookView*)bookview;
@end

// Book View
@interface totBookView : UIView {
    // Data
    totBook* mTemplateBook;  // only stores template.
    totBook* mBook;  // book containing the real data.
    
    id <BookViewDelegate> delegate;
    
    NSMutableArray* mPageViews;
    // Subviews
    /*  // Gives up for now..
    totPageView* mPrev;
    totPageView* mCurr;
    totPageView* mNext;
     */
}

@property (nonatomic, assign) totBook* mBook;

- (void)loadTemplateFile:(NSString*)filename;

// New page means an empty page, so that there is no data associated with the page yet.
- (void)addNewPage:(NSString*)pageName;

- (void)saveBook:(NSString*)bookname;
- (void)loadBook:(NSString*)bookname;

@end



