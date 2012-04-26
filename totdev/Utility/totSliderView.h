//
//  totSliderView.h
//  totdev
//
//  Created by Yifei Chen on 4/26/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <Foundation/Foundation.h>  
#import <UIKit/UIKit.h>  

@interface totSliderView :NSObject <UIScrollViewDelegate> {  
    
    UIScrollView *scrollView;  
    UIPageControl *pageControl;  
    
    CGRect rectBase;
    CGRect rectScrollView;  
    CGRect rectPageControl;  
    
    int scrollWidth;  
    int scrollHeight;
    int scrollYOrigin;

    int buttonsPerRow;
    
    NSArray *contentArray;  
    
    UIColor *bcgColor;  
    
    BOOL pageControlEnabledTop;  
    BOOL pageControlEnabledBottom;  
    
    BOOL rememberPosition;  
    NSString *positionIdentifier;  
    
    
}  

@property (nonatomic, retain) UIScrollView *scrollView;  

/// returns width of the scollview  
- (int)getScrollViewWidth;  

/// set width and height for your final UIScrollView  
- (void)setWidth:(int)width andHeight:(int)height;  

/// set Position by yOrigin (xOrigin is always 0
/// and size is fixed
- (void)setPosition:(int)yOrigin;

/// set scroll view lay out: buttons per row
// buttons per column = 2
- (void)setLayout:(int)btnPerRow;

/// set the exactly same size as it is your parent view  
- (void)setSizeFromParentView:(UIScrollView *)scView;  

/// set background color for your UIScrollView  
- (void)setBackGroudColor:(UIColor *)color;  

/// set an array with images you want to display in your new scroll view  
- (void)setContentArray:(NSArray *)images;  

/// display page control for the scroll view on the top of the view (inset)  
- (void)enablePageControlOnTop;  

/// display page control for the scroll view on the bottom of the view (inset)  
- (void)enablePageControlOnBottom;  

/// enable position history  
- (void)enablePositionMemory;  

/// enable position history with custom memory identifier  
- (void)enablePositionMemoryWithIdentifier:(NSString *)identifier;  

/// returns your UIScrollView with predefined page  
- (UIScrollView *)getWithPosition:(int)page;  

/// returns your UIScrollView with enabled position history  
- (UIScrollView *)getWithPositionMemory;  

/// returns your UIScrollView with enabled position history with custom memory identifier  
- (UIScrollView *)getWithPositionMemoryIdentifier:(NSString *)identifier;  

/// returns your UIScrollView  
- (UIScrollView *)get;  


- (void)buttonPressed:(id)sender;


@end  