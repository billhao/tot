//
//  totSliderView.h
//  totdev
//
//  Created by Yifei Chen on 4/26/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <Foundation/Foundation.h>  
#import <UIKit/UIKit.h>  

@protocol totSliderViewDelegate <NSObject>

@optional
- (void)buttonPressed: (id)sender;

@end

@interface totSliderView :UIView <UIScrollViewDelegate> {
    UIScrollView *scrollView;  
    UIPageControl *pageControl;
    
    int scrollWidth, scrollHeight, scrollYOrigin;
    UIColor *bcgColor;
    
    //layout setting
    int btnPerRow; //default is 3 (a.k.a numOfCol)
    int btnPerCol; //default is 2 (a.k.a numOfRow)
    // int btnWidth; //auto-computed based on btuPerRow and the width
    int btnHeight; // if left blank, by default height = width
    int vMarginBetweenBtn; // if left blank, by default is 0
    int hMarginBetweenBtn; // if left blank, by default is 0
    
    int tagOffset; // default 0: for food category, 1000: for recently used, 2000: for chooseFood, 3000: for foodChosen
    
    NSMutableArray *contentArray; 
    NSMutableArray *marginArray;
    NSMutableArray *isIconArray;
    NSMutableArray *labelArray;
    NSMutableArray *buttonArray;
    
    BOOL pageControlEnabledTop;  
    BOOL pageControlEnabledBottom;  
    
    BOOL rememberPosition;  
    NSString *positionIdentifier;  
    
    id <totSliderViewDelegate> delegate;
}  

@property (nonatomic, retain) id <totSliderViewDelegate> delegate;

/// returns the entirewidth of the scollview
- (int)getScrollViewWidth;

/// set Position by yOrigin (xOrigin is always 0
/// and size is fixed
//- (void)setPosition:(int)yOrigin;

/// set scroll view lay out: buttons per row
// buttons per row = 3 by default; buttons per col = 2 by default
- (void)setBtnPerRow:(int)buttonPerRow;
- (void)setBtnPerCol:(int)buttonPerCol;
// buttons height
- (void)setBtnHeight:(int)buttonHeight;
- (void)setvMarginBetweenBtn:(int)vMargin;
- (void)sethMarginBetweenBtn:(int)hMargin;

///set margin
-(void)setMarginArray:(NSArray *)margins;

/// set an array with images you want to display in your new scroll view  
- (void)setContentArray:(NSArray *)images;

/// set an array indicating whether this icon has user photos or not
- (void)setIsIconArray:(NSArray*)isIcon;

/// set background color for your UIScrollView
- (void)setBackGroundColor:(UIColor *)color;  

/// set a value of a button
- (void)setButton:(int)idx andWithValue:(float)value;

/// set a value of a tagOffset: 0 1000 2000 3000
- (void)setTagOffset:(int)tagOffset;


/// clear all labels on all buttons
- (void)clearButtonLabels;

/// clear all background clear on buttons
- (void)clearButtonBGColor;

/// display page control for the scroll view on the top of the view (inset)  
- (void)enablePageControlOnTop;  

/// display page control for the scroll view on the bottom of the view (inset)  
- (void)enablePageControlOnBottom;  

/// enable position history  
//- (void)enablePositionMemory:(NSString *)identifier;  

/// enable position history with custom memory identifier  
//- (void)enablePositionMemoryWithIdentifier:(NSString *)identifier;  

/// returns your UIScrollView with predefined page  
//- (UIScrollView *)getWithPosition:(int)page;  

/// returns your UIScrollView with enabled position history  
//- (UIScrollView *)getWithPositionMemory:(NSString *)identifier;  

/// returns your UIScrollView with enabled position history with custom memory identifier  
- (void)getWithPositionMemoryIdentifier:(NSString *)identifier;  

/// returns your UIScrollView  
- (void)get;

/// clean all subviews from scroll view
- (void)cleanScrollView;

- (void)buttonPressed:(id)sender;


@end  