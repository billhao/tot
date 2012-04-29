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
    
    int scrollWidth, scrollHeight, scrollYOrigin, numOfRows;
    UIColor *bcgColor;
    
    NSMutableArray *contentArray; 
    NSMutableArray *marginArray;
    
    BOOL pageControlEnabledTop;  
    BOOL pageControlEnabledBottom;  
    
    BOOL rememberPosition;  
    NSString *positionIdentifier;  
    
    id <totSliderViewDelegate> delegate;
}  

@property (nonatomic, retain) id <totSliderViewDelegate> delegate;
@property (nonatomic, assign) int numOfRows;

/// returns width of the scollview  
//- (int)getScrollViewWidth;  

/// set Position by yOrigin (xOrigin is always 0
/// and size is fixed
//- (void)setPosition:(int)yOrigin;

/// set scroll view lay out: buttons per row
// buttons per column = 2
//- (void)setLayout:(int)btnPerRow;

///set margin
-(void)setMarginArray:(NSArray *)margins;

/// set an array with images you want to display in your new scroll view  
- (void)setContentArray:(NSArray *)images;

/// set background color for your UIScrollView  
- (void)setBackGroundColor:(UIColor *)color;  

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