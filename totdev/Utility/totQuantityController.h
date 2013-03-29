//
//  totQuantityController.h
//  totdev
//
//  Created by Chengjie on 03/14/2013.
//  Copyright (c) 2013 USC. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    kQUButtonOK = 0,  // borrowed from kButtonOk + QU
    kQUButtonCancel = 1
};

enum {
    kPickerQuantity = 0,
    kPickerUnit = 1,
};


@protocol totQuantityControllerDelegate <NSObject>

@optional
-(void)saveQuantity:(NSString*)q; //including quantity and unit
-(void)cancelQuantity;

@end

@interface totQuantityController: UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
    
    NSMutableArray *mUnit; //oz, count, lb, g
    NSMutableArray *mQuantity;
    
    int mComponentWidth, mComponentHeight;
    int mWidth, mHeight;
    int mCurrentQuantityIdx, mCurrentUnitIdx;
    id<totQuantityControllerDelegate> delegate;
    
    // keep the superview and hidden textview on the superview so we can use its InputView and InputAccessoryView
    UIView* mSuperView;
    UITextView* mHiddenText;
}

@property (nonatomic, readonly) int mCurrentQuantityIdx;
@property (nonatomic, readonly) int mCurrentUnitIdx;
@property (nonatomic, assign) int mWidth;
@property (nonatomic, assign) int mHeight;
@property (nonatomic, retain) id<totQuantityControllerDelegate> delegate;
@property (nonatomic, retain) UIPickerView *mQuantityPicker;

// must init with a super view
- (id)init:(UIView*)superView;

// set the current value
- (void)setQuantityPicked:(int)q andUnitPicked:(int)u;

// return "May" from 5
+ (NSString*)getUnitString:(int)u;

// for the ok and cancel button
- (UIView*)createInputAccessoryView;

// show and dismiss this picker
- (void)show;
- (void)dismiss;

@end
