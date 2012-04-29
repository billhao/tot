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

@interface totSliderView :NSObject <UIScrollViewDelegate> {  
    UIView *main;
    
    UIScrollView *scrollView;  
    UIPageControl *pageControl; 
    
    CGRect rectBase;
    CGRect rectScrollView;  
    CGRect rectPageControl;  
    
    int scrollWidth;  
    int scrollHeight;
    int scrollYOrigin;

    int numOfRows;
    
    NSArray *contentArray; 
    NSArray *marginArray;
    
    UIColor *bcgColor;  
    
    BOOL pageControlEnabledTop;  
    BOOL pageControlEnabledBottom;  
    
    BOOL rememberPosition;  
    NSString *positionIdentifier;  
    
    id <totSliderViewDelegate> delegate;
}  

@property (nonatomic, retain) UIScrollView *scrollView;  
@property (nonatomic, retain) id <totSliderViewDelegate> delegate;

/// returns width of the scollview  
- (int)getScrollViewWidth;  

/// set Position by yOrigin (xOrigin is always 0
/// and size is fixed
- (void)setPosition:(int)yOrigin;

/// set scroll view lay out: buttons per row
// buttons per column = 2
- (void)setLayout:(int)btnPerRow;

///set margin
-(void)setMarginArray:(NSArray *)margins;

/// set background color for your UIScrollView  
- (void)setBackGroundColor:(UIColor *)color;  

/// set an array with images you want to display in your new scroll view  
- (void)setContentArray:(NSArray *)images;  

/// display page control for the scroll view on the top of the view (inset)  
- (void)enablePageControlOnTop;  

/// display page control for the scroll view on the bottom of the view (inset)  
- (void)enablePageControlOnBottom;  

/// enable position history  
- (void)enablePositionMemory:(NSString *)identifier;  

/// enable position history with custom memory identifier  
- (void)enablePositionMemoryWithIdentifier:(NSString *)identifier;  

/// returns your UIScrollView with predefined page  
- (UIScrollView *)getWithPosition:(int)page;  

/// returns your UIScrollView with enabled position history  
- (UIScrollView *)getWithPositionMemory:(NSString *)identifier;  

/// returns your UIScrollView with enabled position history with custom memory identifier  
- (UIScrollView *)getWithPositionMemoryIdentifier:(NSString *)identifier;  

/// returns your UIScrollView  
- (UIScrollView *)get;  


- (void)buttonPressed:(id)sender;


@end  