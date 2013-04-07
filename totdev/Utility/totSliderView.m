//
//  totSliderView.m
//  totdev
//
//  Created by Chengjie Zhang / Lixing Huang on 4/26/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "totSliderView.h"
#import "totImageView.h"
#import "../Utility/totUtility.h"

#define DEFAULT_BTNPERROW   3
#define DEFAULT_BTNPERCOL   2

@implementation totSliderView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    if( self = [super initWithFrame:frame] ) {
        self.userInteractionEnabled = YES;
        
        scrollWidth   = frame.size.width;
        scrollHeight  = frame.size.height;
        
        btnPerRow = DEFAULT_BTNPERROW;
        btnPerCol = DEFAULT_BTNPERCOL;
        btnWidthHeightRatio = 1.0f;
        rememberPosition = NO;
        
        scrollView  = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, scrollWidth, scrollHeight)];
        pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        
        [self addSubview:scrollView];
        [self addSubview:pageControl];
    }
    return self;
}

- (int)getScrollPageNumber {
    int num = [contentArray count];
    int numPerPage = btnPerRow * btnPerCol;
    int pagenum = num / numPerPage + ((num%numPerPage)==0 ? 0 : 1);
    return pagenum;
}

- (int)getScrollViewWidth {
    int pagenum = [self getScrollPageNumber];
    return (pagenum * scrollWidth);
}

- (void)cleanScrollView {
    for(UIView *subview in [scrollView subviews]) {
        [subview removeFromSuperview];  // removeFromSuperview will call release on subview itself...
    }
}

- (void)buttonPressed:(id)sender {
    if( [delegate respondsToSelector:@selector(sliderView:buttonPressed:)] ) {
        [delegate sliderView:self buttonPressed:sender];
    }
}

- (void)setBtnWidthHeightRatio:(float)r { btnWidthHeightRatio = r; }

- (void)setPageCtrlPosition:(int)position { pageControlPosition = position; }

- (void)setBtnPerRow:(int)buttonPerRow { btnPerRow = buttonPerRow; }

- (void)setBtnPerCol:(int)buttonPerCol { btnPerCol = buttonPerCol; }

- (void)setUniqueIdentifier:(NSString *)name {
    if (name == nil) {
        rememberPosition = NO;
    } else {
        identifier = [NSString stringWithString:name];
        rememberPosition = YES;
    }
}

// copy data
- (void)retainContentArray: (NSArray*)images {
    if (contentArray) {
        [contentArray release];
    }
    if (!images) {
        printf("totSliderView.m retainContentArray images cannot be empty\n");
        exit(1);
    }
    contentArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [images count]; i++) {
        if ([images objectAtIndex:i] == nil) {
            printf("totSliderView.m retainContentArray image has nil element...\n");
            exit(1);
        }

        UIButton * imageButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        imageButton.layer.cornerRadius = 6.0;
        imageButton.layer.masksToBounds = YES;
        [imageButton setImage:[images objectAtIndex:i] forState:UIControlStateNormal];
        [imageButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [contentArray addObject:imageButton];
        [imageButton release];
    }
}

- (void)retainMarginArray: (NSArray*)margins {
    if (marginArray) {
        [marginArray release];
    }
    if (!margins) {
        printf("totSliderView.m setMarginArray margins cannot be empty\n");
        exit(1);
    }
    marginArray = [[NSMutableArray alloc] initWithArray:margins];
}

- (void)retainLabelArray: (NSArray*)labels {
    if (labelArray) {
        [labelArray release];
    }
    if (!labels || [labels count] == 0) {
        printf("totSliderView.m setLabelArray labels cannot be empty\n");
        exit(1);
    }
    labelArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [labels count]; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [label setText:[labels objectAtIndex:i]];
        [label setFont:[UIFont fontWithName:@"Roboto-Regular" size:16.0]];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:210.0/255 green:0.0 blue:63.0/255 alpha:1.0];
        //label.textColor = [UIColor colorWithRed:218.0/255.0 green:31.0/255.0 blue:95.0/255.0 alpha:1.0f];
        //label.textColor = [UIColor blackColor];
        [labelArray addObject:label];
        [label release];
    }
}

- (void)retainTitleArray: (NSArray *)titles {
    if (titleArray) {
        [titleArray release];
    }
    if (!titles || [titles count] == 0) {
        printf("totSliderView.m setTitleArray titles cannot be empty\n");
        exit(1);
    }
    titleArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [titles count]; i++) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [titleLabel setText:[titles objectAtIndex:i]];
        [titleLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:12.0]];
        [titleArray addObject:titleLabel];
        [titleLabel release];
    }
}

// visualize data
- (void)getWithPosition: (int)page {
    const int RATIO_BTN_SIZE_AND_GAP = 3;
    
    if (!contentArray) {
        printf("Must set content array before using totSliderView\n");
        exit(1);
    }
    
    int btnPerPage = btnPerRow * btnPerCol;
    int totalPageNumbers = [self getScrollPageNumber];
    
    [self cleanScrollView];
    
    scrollView.contentSize = CGSizeMake([self getScrollViewWidth], scrollHeight);
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.alwaysBounceHorizontal = YES;
    scrollView.contentOffset = CGPointMake(page * scrollWidth, 0);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;

    // horizontal layout
    int num_of_gap = ((btnPerRow * RATIO_BTN_SIZE_AND_GAP) + (btnPerRow + 1));
    int h_gap = scrollWidth / num_of_gap;
    int btn_width = h_gap * RATIO_BTN_SIZE_AND_GAP;
    int btn_height = (int)((float)btn_width * btnWidthHeightRatio);
    
    // vertical layout
    int v_gap = (scrollHeight - btnPerCol * btn_height) / (btnPerCol + 1);
    
    // add buttons
    for (int i = 0; i < totalPageNumbers; i++) {
        UIView *subview = [[UIView alloc] initWithFrame:CGRectMake(i*scrollWidth, 0, scrollWidth, scrollHeight)];
        for (int col = 0; col < btnPerRow; col++){
            for (int row = 0; row < btnPerCol; row ++) {
                int xx = (col + 1) * h_gap + col * btn_width;
                int yy = (row + 1) * v_gap + row * btn_height;
                int btn_index = i * btnPerPage + row * btnPerRow + col;

                if (contentArray && btn_index < [contentArray count]) {
                    UIButton * btn = [contentArray objectAtIndex:btn_index];
                    [btn setFrame:CGRectMake(xx, yy, btn_width, btn_height)];
                    [btn setTag:btn_index + 1];
                    [subview addSubview:btn];
                }
                if (marginArray && btn_index < [marginArray count]) {
                    if ([[marginArray objectAtIndex:btn_index] boolValue]) {
                        UIImageView * margin = [[UIImageView alloc] initWithFrame:CGRectMake(xx, yy, btn_width + 2, btn_height + 2)];
                        margin.image = [UIImage imageNamed:@"margin.png"];
                        [subview addSubview:margin];
                        [margin release];
                    }
                }
                if (titleArray && btn_index < [titleArray count]) {
                    UILabel * title = [titleArray objectAtIndex:btn_index];
                    [title setFrame:CGRectMake(xx, yy + btn_height, btn_width, v_gap)];
                    [subview addSubview:title];
                }
                if (labelArray && btn_index < [labelArray count]) {
                    UILabel* label = [labelArray objectAtIndex:btn_index];
                    [label setFrame:CGRectMake(xx, yy + btn_height/2 - v_gap/2, btn_width, v_gap)];
                    [subview insertSubview:label aboveSubview:[contentArray objectAtIndex:btn_index]];
                    if ([label.text isEqualToString:@""]) {
                        label.hidden = YES;
                    }
                }
            }
        }
        [scrollView addSubview:subview];
        [subview release];
    }
    switch (pageControlPosition) {
        case PAGE_CTRL_TOP:
            pageControl.frame = CGRectMake(0, 5, scrollWidth, 15);
            pageControl.numberOfPages = totalPageNumbers;
            pageControl.currentPage = page;
            break;
        case PAGE_CTRL_BOTTOM:
            pageControl.frame = CGRectMake(0, (scrollHeight - 30), scrollWidth, 15);
            pageControl.numberOfPages = totalPageNumbers;
            pageControl.currentPage = page;
            break;
        case NO_PAGE_CTRL:
            pageControl.frame = CGRectMake(0, 0, 0, 0);
            break;
        default:
            break;
    }
    scrollView.delegate = self;
}

- (void)addNewButton:(UIImage *)buttonImg {
    UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];  // size will be adjusted later in get() function.
    imageButton.layer.cornerRadius = 6.0;
    imageButton.layer.masksToBounds = YES;
    [imageButton setImage:buttonImg forState:UIControlStateNormal];
    [imageButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [contentArray addObject:imageButton];
    [imageButton release];
}

- (void)removeButtonAtIndex:(int)index {
    if (0 <= index && index < [contentArray count]) {
        [contentArray removeObjectAtIndex:index];
    }
}

- (void)changeButton:(int)btnIndex withNewImage:(NSString*)filename {
    UIButton * btn = [contentArray objectAtIndex:btnIndex];
    [btn setImage:[UIImage imageNamed:filename] forState:UIControlStateNormal];
}

- (void)changeButton:(int)btnIndex withNewLabel:(NSString*)l {
    UILabel* ll = (UILabel*)[labelArray objectAtIndex:btnIndex];
    [ll setText:l];
    ll.hidden = NO;
}

- (void)clearButtonLabel:(int)btnIndex {
    [(UILabel*)[labelArray objectAtIndex:btnIndex] setText:@""];
}

- (void)clearAllButtonLabels {
    for (int i = 0; i < [labelArray count]; i++) {
        [(UILabel*)[labelArray objectAtIndex:i] setText:@""];
    }
}

- (void)get {  
    [self getWithPosition:0];  
}

- (void)getWithPositionMemoryIdentifier {
    if (rememberPosition)
        [self getWithPosition:[[[NSUserDefaults standardUserDefaults] objectForKey:identifier] intValue]];
    else {
        printf("you need call setUniqueIdentifier first...\n");
        [self getWithPosition:0];
    }
}

#pragma delegate - scrollView
- (void)scrollViewDidEndDecelerating:(UIScrollView *)sv {  
    int page = sv.contentOffset.x / sv.frame.size.width;  
    pageControl.currentPage = page;  
    if (rememberPosition) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", page] forKey:identifier];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)dealloc {
    [contentArray release];
    [marginArray release];
    [titleArray release];
    [labelArray release];
    [pageControl release];
    [scrollView release];
    [super dealloc];  
}  

@end  
