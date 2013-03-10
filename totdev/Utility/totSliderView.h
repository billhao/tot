//
//  totSliderView.h
//  totdev
//
//  Created by Chengjie Zhang / Lixing Huang on 4/26/12.
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

    BOOL rememberPosition;
    int scrollWidth, scrollHeight;
    int btnPerRow, btnPerCol;
    float btnWidthHeightRatio;

    NSMutableArray * contentArray;  // each element is UIButton
    NSMutableArray * marginArray;   // each element is boolean var
    NSMutableArray * labelArray;    // each element is UILabel
    NSMutableArray * titleArray;    // each element is UILabel

    NSString * identifier;
    int pageControlPosition;
    id <totSliderViewDelegate> delegate;
}

@property (nonatomic, retain) id <totSliderViewDelegate> delegate;

- (void)setUniqueIdentifier: (NSString*)identifier;
- (void)setPageCtrlPosition: (int)position;
- (void)setBtnPerRow: (int)buttonPerRow;
- (void)setBtnPerCol: (int)buttonPerCol;
- (void)setBtnWidthHeightRatio: (float)r;

- (void)retainMarginArray: (NSArray*)margins;
- (void)retainContentArray: (NSArray*)images;
- (void)retainLabelArray: (NSArray*)labels;
- (void)retainTitleArray: (NSArray*)titles;

- (void)get;
- (void)getWithPositionMemoryIdentifier;

- (void)changeButton:(int)btnIndex withNewImage:(NSString*)filename;
- (void)changeButton:(int)btnIndex withNewLabel:(NSString*)l;
- (void)clearButtonLabel:(int)btnIndex;
- (void)clearAllButtonLabels;
- (void)cleanScrollView;

@end  