//
//  totBookletView.h
//  totdev
//
//  Created by Lixing Huang on 6/11/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "totCameraViewController.h"
#import "totBookViewController.h"

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
@interface totPageElementViewInternal : totBookBasicView<UITextViewDelegate> {
    // Data
    totPageElement* mData;
    // Subviews
    UIImageView *mImage;
    UITextView* mTextView;

    totPageView* mParentView;
}

@property (nonatomic, retain) totPageElement* mData;
@property (nonatomic, assign) totPageView* mParentView;
@property (nonatomic, assign) UITextView* mTextView;
@property (nonatomic, assign) UIImageView* mImage;

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
@interface totPageElementView : UIView <UIGestureRecognizerDelegate, CameraViewDelegate, UIActionSheetDelegate> {
    totPageElementViewInternal* mView;
    CGPoint mTouchLastTime;
    
    int myIndexInSuperview; // this is used to remember the index of this view in its superview. when animate this view to full screen, we need this index when bring it back to original
}

@property(nonatomic, retain) totBookViewController* bookvc;
@property (nonatomic, readonly) totPageElementViewInternal* mView;

- (id)initWithElementData:(totPageElement*)data bookvc:(totBookViewController*)bookvc;
- (void)setPageElementData:(totPageElement*)data;
- (void)setPageView:(totPageView*)pageView;

@end

// ---------------------------------totPageView---------------------------------------

// Page View
@interface totPageView : UIView <UITextFieldDelegate> {
    // Data
    totPage* mPage;
    
    // Subviews
    NSMutableArray* mElementsView;
    UIImageView* mBackground;
    UIView* mPopupTextInputView;
    UITextField* mTextInput;
    
    // If input text view pops up
    totPageElementViewInternal* mCurrentActivePageElement;
}

@property (nonatomic, retain) totBookViewController* bookvc;
@property (nonatomic, retain) totPage* mPage;
@property (nonatomic, assign) totPageElementViewInternal* mCurrentActivePageElement;

// Loads the template data.
// data should be [totPage toDictionary];
//- (id)initWithFrame:(CGRect)frame andPageTemplateData:(NSDictionary*)data bookvc:(totBookViewController*)bookvc;
- (id)initWithFrame:(CGRect)frame pagedata:(totPage*)pagedata bookvc:(totBookViewController*)bookvc;

// save the view to an image
- (UIImage*)renderToImage;

// Pop up the input text view.
- (void)showInputTextView;

@end

// ---------------------------------totBookView---------------------------------------

@class totBookView;

@protocol BookViewDelegate <NSObject>
@optional
- (void) tapAtBook:(totBookView*)bookview;
- (void) longPressAtBook:(totBookView*)bookview;
@end

// Book View
@interface totBookView : UIView <UIGestureRecognizerDelegate> {
    id <BookViewDelegate> delegate;
    
    // Subviews
    /*  // Gives up for now..
    totPageView* mPrev;
    totPageView* mCurr;
    totPageView* mNext;
     */

}
@property(nonatomic, retain) totBookViewController* bookvc;


- (void)swipeViews:(totPageView*)view1 view2:(totPageView*)view2 leftToRight:(BOOL)leftToRight;

@end



