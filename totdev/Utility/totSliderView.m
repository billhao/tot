//
//  totSliderView.m
//  totdev
//
//  Created by Yifei Chen on 4/26/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "totSliderView.h"
#import "totImageView.h"
#import "../Utility/totUtility.h"


#define totGUIScrollViewImagePageIdentifier         @"totGUIScrollViewImagePageIdentifier"  
#define totGUIScrollViewImageDefaultPageIdentifier  @"Default"  

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

- (void)setBtnPerRow:(int)buttonPerRow { btnPerRow = buttonPerRow; }

- (void)setBtnPerCol:(int)buttonPerCol { btnPerCol = buttonPerCol; }


// copy data
- (void)retainContentArray: (NSArray*)images {
    if (contentArray) {
        [contentArray release];
    }
    if (!images || [images count] == 0) {
        printf("totSliderView.m setContentArray images cannot be empty\n");
        exit(1);
    }
    contentArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [images count]; i++) {
        if ([images objectAtIndex:i])  // make sure not nil
            [contentArray addObject:[images objectAtIndex:i]];
    }
}

- (void)retainMarginArray: (NSArray*)margins {
    if (marginArray) {
        [marginArray release];
    }
    if (!margins || [margins count] == 0) {
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
        [titleArray addObject:titleLabel];
        [titleLabel release];
    }
}

- (void)buttonPressed:(id)sender {
    if( [delegate respondsToSelector:@selector(sliderView:buttonPressed:)] ) {
        [delegate sliderView:self buttonPressed:sender];
    }
}

- (void)setPageCtrlPosition:(int)position {
    pageControlPosition = position;
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
    int btn_size = h_gap * RATIO_BTN_SIZE_AND_GAP;
    
    // vertical layout
    int v_gap = (scrollHeight - btnPerCol * btn_size) / (btnPerCol + 1);
    
    // add buttons
    for (int i = 0; i < totalPageNumbers; i++) {
        UIView *subview = [[UIView alloc] initWithFrame:CGRectMake(i*scrollWidth, 0, scrollWidth, scrollHeight)];
        for (int col = 0; col < btnPerRow; col++){
            for (int row = 0; row < btnPerCol; row ++) {
                int xx = (col + 1) * h_gap + col * btn_size;
                int yy = (row + 1) * v_gap + row * btn_size;
                int btn_index = i * btnPerPage + row * btnPerRow + col;
                
                if (btn_index >= [contentArray count] )
                    break;
                
                // buttons
                UIButton * imageButton = [[UIButton alloc] initWithFrame:CGRectMake(xx, yy, btn_size, btn_size)];
                imageButton.layer.cornerRadius = 6.0;
                imageButton.layer.masksToBounds = YES;
                
                UIImage * image = [contentArray objectAtIndex:btn_index];
                [imageButton setImage:image forState:UIControlStateNormal];
                [imageButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
                [imageButton setTag:btn_index + 1];
                [subview addSubview:imageButton];
                
                // margins
                if (marginArray && [[marginArray objectAtIndex:btn_index] boolValue]) {
                    UIImageView *margin = [[UIImageView alloc] initWithFrame:CGRectMake(xx, yy, btn_size+4, btn_size+4)];
                    margin.image = [UIImage imageNamed:@"margin.png"];
                    [subview addSubview:margin];
                    [margin release];
                }

                // titles
                if (titleArray) {
                    UILabel * title = [titleArray objectAtIndex:btn_index];
                    [title setFrame:CGRectMake(xx, yy + btn_size, btn_size, v_gap)];
                    [subview addSubview:title];
                }

                // labels
                if (labelArray) {
                    UILabel * label = [labelArray objectAtIndex:btn_index];
                    [label setFrame:CGRectMake(xx, yy + btn_size/2, btn_size, v_gap)];
                    [subview insertSubview:label aboveSubview:imageButton];
                }
                
                [imageButton release];
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

- (void)changeButton:(int)btnIndex withNewLabel:(NSString*)l {
    UILabel * label = [labelArray objectAtIndex:btnIndex];
    [label setText:l];
}

- (void)clearButtonLabel:(int)btnIndex {
    UILabel * label = [labelArray objectAtIndex:btnIndex];
    [label setText:@""];
}

- (void)clearAllButtonLabels {
    
}

- (void)enablePositionMemoryWithIdentifier:(NSString *)identifier {  
    rememberPosition = YES;  
    if (!identifier) 
        identifier = totGUIScrollViewImageDefaultPageIdentifier;  
    positionIdentifier = identifier;  
}

- (void)cleanScrollView {
    for(UIView *subview in [scrollView subviews]) {
        [subview removeFromSuperview];  // removeFromSuperview will call release on subview itself...
    }
}

- (void)get {  
    [self getWithPosition:0];  
}

//- (void)getWithPositionMemoryIdentifier:(NSString *)identifier {
//    [self enablePositionMemoryWithIdentifier:identifier];
//    [self getWithPosition:[[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@", totGUIScrollViewImagePageIdentifier, positionIdentifier]] intValue]];
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sv {  
    int page = sv.contentOffset.x / sv.frame.size.width;  
    pageControl.currentPage = page;  
    //if (rememberPosition) {
    //    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", page] forKey:[NSString stringWithFormat:@"%@%@", totGUIScrollViewImagePageIdentifier, positionIdentifier]];
    //    [[NSUserDefaults standardUserDefaults] synchronize];
    //}
}

- (void)dealloc {  
    if (contentArray) {
        [contentArray release];
    }
    if (marginArray) {
        [marginArray release];
    }
    if (titleArray) {
        [titleArray release];
    }
    if (labelArray) {
        [labelArray release];
    }    
    [pageControl release];
    [scrollView release];
    [super dealloc];  
}  

@end  
