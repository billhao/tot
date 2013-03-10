//
//  totSliderView.h
//  totdev
//
//  Created by Yifei Chen on 4/26/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <Foundation/Foundation.h>  
#import <UIKit/UIKit.h>  

#define PAGE_CTRL_TOP    1
#define PAGE_CTRL_BOTTOM 2
#define NO_PAGE_CTRL     3

@class totSliderView;


@protocol totSliderViewDelegate <NSObject>
@optional
- (void)sliderView:(totSliderView*)sv buttonPressed:(id)sender;
@end


@interface totSliderView :UIView <UIScrollViewDelegate> {
    UIScrollView  * scrollView;
    UIPageControl * pageControl;

    int scrollWidth, scrollHeight;
    int btnPerRow, btnPerCol;

    NSMutableArray * contentArray;  // each element is UIImage
    NSMutableArray * marginArray;   // each element is boolean var
    NSMutableArray * labelArray;    // each element is UILabel
    NSMutableArray * titleArray;    // each element is UILabel

    int pageControlPosition;
    id <totSliderViewDelegate> delegate;

    BOOL rememberPosition;
    NSString *positionIdentifier;
}

@property (nonatomic, retain) id <totSliderViewDelegate> delegate;

- (void)setPageCtrlPosition: (int)position;
- (void)setBtnPerRow: (int)buttonPerRow;
- (void)setBtnPerCol: (int)buttonPerCol;

- (void)retainMarginArray: (NSArray*)margins;
- (void)retainContentArray: (NSArray*)images;
- (void)retainLabelArray: (NSArray*)labels;
- (void)retainTitleArray: (NSArray*)titles;

- (void)get;

- (void)changeButton:(int)btnIndex withNewLabel:(NSString*)l;
- (void)clearButtonLabel:(int)btnIndex;
- (void)clearAllButtonLabels;

- (void)cleanScrollView;


@end  