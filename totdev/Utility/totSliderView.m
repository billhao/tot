//
//  totSliderView.m
//  totdev
//
//  Created by Yifei Chen on 4/26/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totSliderView.h"
#import "totImageView.h"
#import "../Utility/totUtility.h"

#define totGUIScrollViewImagePageIdentifier                      @"totGUIScrollViewImagePageIdentifier"  
#define totGUIScrollViewImageDefaultPageIdentifier               @"Default"  

#define DEFAULT_WIDTH 320
#define DEFAULT_HEIGHT 260 
#define DEFAULT_NUMOFROWS 2
// layout parameters
#define LEFT_MARGIN 10
#define TOP_MARGIN 20
#define HORI_INTERVAL 15
#define VERTI_INTERVAL 20
#define BUTTON_WIDTH 90
#define BUTTON_HEIGHT 90

@implementation totSliderView

@synthesize scrollView;  
@synthesize delegate;

- (int)getScrollViewWidth {  
    return ([contentArray count] * scrollWidth);  
}  


-(void)setPosition:(int)yOrigin{
    scrollWidth = DEFAULT_WIDTH;
    scrollHeight = DEFAULT_HEIGHT;
    scrollYOrigin = yOrigin;
}


-(void)setLayout:(int)noOfRows{
    numOfRows = noOfRows;
    // btnPerRow is always 3;
}

- (void)setContentArray:(NSArray *)images {  
    contentArray = images;  
    [contentArray retain];
}  

- (void)setBackGroundColor:(UIColor *)color {  
    bcgColor = color;  
}  

- (void)enablePageControlOnTop {  
    pageControlEnabledTop = YES;  
}  

- (void)enablePageControlOnBottom {  
    pageControlEnabledBottom = YES;  
}  

- (void)enablePositionMemoryWithIdentifier:(NSString *)identifier {  
    rememberPosition = YES;  
    if (!identifier) 
        identifier = totGUIScrollViewImageDefaultPageIdentifier;  
    positionIdentifier = identifier;  
}  

- (void)enablePositionMemory:(NSString *)identifier {  
    [self enablePositionMemoryWithIdentifier:identifier];  
}  

- (void)setMarginArray:(NSArray *)margins{
    marginArray = margins;
    [marginArray retain];
}

- (UIScrollView *)getWithPosition:(int)page {
    if (!contentArray)
        contentArray = [[[NSArray alloc] init] autorelease]; 
    
    if(!numOfRows)
        numOfRows = DEFAULT_NUMOFROWS; 
    
    int totalPageNumbers = 
        ceil((double)[contentArray count]/numOfRows/3);

    if (page > totalPageNumbers) 
        page = 0;  
    
    //set default parameters
    if (!scrollWidth)  
        scrollWidth = DEFAULT_WIDTH;
        
    if (!scrollHeight)
        scrollHeight = DEFAULT_HEIGHT;
    
    if(!scrollYOrigin)
        scrollYOrigin = 0;
    
    rectScrollView = CGRectMake(0, 0, scrollWidth, scrollHeight);  
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:rectScrollView];  
    self.scrollView.contentSize = CGSizeMake([self getScrollViewWidth], scrollHeight);  
    if (!bcgColor) bcgColor = [UIColor clearColor];  
    self.scrollView.backgroundColor = bcgColor;  //by default transparent
    self.scrollView.alwaysBounceHorizontal = YES;  
    self.scrollView.contentOffset = CGPointMake(page * scrollWidth, 0);  
    self.scrollView.pagingEnabled = YES;  
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    rectBase = CGRectMake(0, scrollYOrigin, scrollWidth, scrollHeight);  
    main = [[[UIView alloc] initWithFrame:rectBase] autorelease];  

    //load button here:
    for (int i = 0; i < totalPageNumbers; i++) {
        UIView *subview = [[UIView alloc] 
                           initWithFrame:CGRectMake(i*scrollWidth, 0, scrollWidth, scrollHeight)];
        
        int remainButtons = 0;
        if([contentArray count] >= (i+1)*numOfRows*3)
            remainButtons = numOfRows*3;
        else
            remainButtons = [contentArray count]- i*numOfRows*3;
        
        for (int j = 0; j<remainButtons; j++){
            int xPos, yPos;
            // button layout
            if (j == 0 || j== 3)
                xPos = LEFT_MARGIN;
            else if (j == 1 || j==4)
                xPos = LEFT_MARGIN+(BUTTON_WIDTH+HORI_INTERVAL)*1;
            else if (j== 2|| j == 5)
                xPos = LEFT_MARGIN+(BUTTON_WIDTH+HORI_INTERVAL)*2;
            
            if(j <=2)
                yPos = TOP_MARGIN;
            else
                yPos = TOP_MARGIN+BUTTON_HEIGHT+VERTI_INTERVAL;
            
            UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(xPos, yPos, 90, 90)];
                        
            imageButton.frame = CGRectMake(xPos, yPos,
                                           90 , 90 );
            
            //image resizing
            UIImage *origImage=[contentArray objectAtIndex:i*numOfRows*3+j];
            UIImage *squareImage=[totUtility squareCropImage:origImage];
                        
            [imageButton 
             setImage:squareImage
             forState:UIControlStateNormal];
            
            [imageButton 
             addTarget:self 
             action:@selector(buttonPressed:) 
             forControlEvents:UIControlEventTouchUpInside];
            [imageButton setTag:i*numOfRows*3 + j +1];
            
            [subview addSubview:(UIView *)imageButton];
            [imageButton release];
            
            if ([marginArray count] >= [contentArray count]){
                if ([[marginArray objectAtIndex:i*numOfRows*3+j] boolValue]){
                    //add margin
                    UIImageView *margin;
                    margin =[[UIImageView alloc] 
                             initWithFrame:CGRectMake(xPos,yPos,
                                                      96,96)];
                
                    margin.image=[UIImage imageNamed:@"margin.png"];
                
                    [subview addSubview:margin];
                    [margin release];
                }
            }
        }
    
        [self.scrollView addSubview:subview];
        [subview release];
    }
    
    scrollView.contentSize = CGSizeMake(scrollWidth
                                        * totalPageNumbers, 
                                        scrollHeight);
    
    [main addSubview:scrollView];
    
    if (pageControlEnabledTop) 
        rectPageControl = CGRectMake(0, 5, scrollWidth, 15);  
    else if (pageControlEnabledBottom)  
        rectPageControl = CGRectMake(0, (scrollHeight - 30), scrollWidth, 15);  

    if (pageControlEnabledTop || pageControlEnabledBottom) {  
        pageControl = [[[UIPageControl alloc] initWithFrame:rectPageControl] autorelease];  
        pageControl.numberOfPages = totalPageNumbers;
        pageControl.currentPage = page;
        [main addSubview:pageControl];  
    }  
    if (pageControlEnabledTop || pageControlEnabledBottom || rememberPosition) 
        self.scrollView.delegate = self;  
    
    return (UIScrollView *)main;  
}  

- (UIScrollView *)get {  
    return [self getWithPosition:0];  
}  

- (UIScrollView *)getWithPositionMemory:(NSString *)identifier {  
    [self enablePositionMemory:identifier];  
    return [self getWithPosition:[[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@", totGUIScrollViewImagePageIdentifier, positionIdentifier]] intValue]];  
}  

- (UIScrollView *)getWithPositionMemoryIdentifier:(NSString *)identifier {  
    [self enablePositionMemoryWithIdentifier:identifier];  
    return [self getWithPosition:[[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@", totGUIScrollViewImagePageIdentifier, positionIdentifier]] intValue]];  
}  

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sv {  
    int page = sv.contentOffset.x / sv.frame.size.width;  
    pageControl.currentPage = page;  
    if (rememberPosition) {  
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", page] forKey:[NSString stringWithFormat:@"%@%@", totGUIScrollViewImagePageIdentifier, positionIdentifier]];  
        [[NSUserDefaults standardUserDefaults] synchronize];  
    }  
}  

//button actions
- (void)buttonPressed:(id)sender {
    if( [delegate respondsToSelector:@selector(buttonPressed:)] ) {
        [delegate buttonPressed:sender];
    }
}


- (void)dealloc {  
    [contentArray release];
    [marginArray release];
    
    [scrollView release];
    
    if(!pageControlEnabledTop||!pageControlEnabledBottom)
        [pageControl release];
    
    [main release];
    [super dealloc];  
}  


@end  
