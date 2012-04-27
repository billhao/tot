//
//  totSliderView.m
//  totdev
//
//  Created by Yifei Chen on 4/26/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totSliderView.h"
#import "totImageView.h"
#define kIGUIScrollViewImagePageIdentifier                      @"kIGUIScrollViewImagePageIdentifier"  
#define kIGUIScrollViewImageDefaultPageIdentifier               @"Default"  

@implementation totSliderView

@synthesize scrollView;  

- (int)getScrollViewWidth {  
    return ([contentArray count] * scrollWidth);  
}  

- (void)setWidth:(int)width andHeight:(int)height {  
    scrollWidth = width;  
    scrollHeight = height;  
    if (!width || !height) rectScrollView = [[UIScreen mainScreen] applicationFrame];  
    else rectScrollView = CGRectMake(0, 0, width, height);  
}  

-(void)setPosition:(int)yOrigin{
    scrollWidth = 320;
    scrollHeight = 260;
    scrollYOrigin = yOrigin;
    rectScrollView = CGRectMake(0, 0, scrollWidth, scrollHeight);  
}

- (void)setSizeFromParentView:(UIScrollView *)scView {  
    scrollWidth = scView.frame.size.width;  
    scrollHeight = scView.frame.size.height;  
    rectScrollView = CGRectMake(0, 0, scrollWidth, scrollHeight);  
}  

-(void)setLayout:(int)btnPerRow{
    buttonsPerRow = btnPerRow;
    // btnPerCol is always 3;
}

- (void)setContentArray:(NSArray *)images {  
    contentArray = images;  
}  

- (void)setBackGroudColor:(UIColor *)color {  
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
    if (!identifier) identifier = kIGUIScrollViewImageDefaultPageIdentifier;  
    positionIdentifier = identifier;  
}  

- (void)enablePositionMemory {  
    [self enablePositionMemoryWithIdentifier:nil];  
}  

- (void)setMarginArray:(NSArray *)margins{
    marginArray = margins;
}

- (UIScrollView *)getWithPosition:(int)page {  
    if (!contentArray) {  
        contentArray = [[[NSArray alloc] init] autorelease];  
    }  
    if (page > [contentArray count]) page = 0;  
    
    if (!scrollWidth || !scrollHeight) {  
        rectScrollView = [[UIScreen mainScreen] applicationFrame];  
        scrollWidth = rectScrollView.size.width;  
        scrollHeight = rectScrollView.size.height;  
    }
    if(!scrollYOrigin){
        scrollYOrigin = 0;
    }
    if(!buttonsPerRow){
        buttonsPerRow = 2; //by default;
    }
    
    rectBase = CGRectMake(0, scrollYOrigin, scrollWidth, scrollHeight);  
    rectScrollView = CGRectMake(0, 0, scrollWidth, scrollHeight);  
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:rectScrollView];  
    self.scrollView.contentSize = CGSizeMake([self getScrollViewWidth], scrollHeight);  
    if (!bcgColor) bcgColor = [UIColor blackColor];  
    self.scrollView.backgroundColor = bcgColor;  
    self.scrollView.alwaysBounceHorizontal = YES;  
    self.scrollView.contentOffset = CGPointMake(page * scrollWidth, 0);  
    self.scrollView.pagingEnabled = YES;  
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    UIView *main = [[[UIView alloc] initWithFrame:rectBase] autorelease];  

    //load button here:
    for (int i = 0; i < ceil((double)[contentArray count]/buttonsPerRow/3); i++) {
       
        UIView *subview = [[UIView alloc] 
                           initWithFrame:CGRectMake(i*scrollWidth, 0, scrollWidth, scrollHeight)];
        int remainButtons = 0;
        if([contentArray count] >= (i+1)*buttonsPerRow*3){
            remainButtons = buttonsPerRow*3;
        }
        else{
            remainButtons = [contentArray count]- i*buttonsPerRow*3;
        }
        
        for (int j = 0; j<remainButtons; j++){
            
            UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            
            int xPos;
            int yPos;
            
            if (j == 0 || j== 3){
                xPos = 10;
            }
            else if (j == 1 || j==4){
                xPos = 10+90+15;
            }
            else if (j== 2|| j == 5){
                xPos = 10+90+15+90+15;
            }
            
            if(j <=2){
                yPos = 20;
            }
            else{
                yPos = 20+90+20;
                
            }
            imageButton.frame = CGRectMake(xPos, yPos,
                                           90 , 90 );
            
            [imageButton 
             setImage:[contentArray objectAtIndex:i*buttonsPerRow*3+j]  
             forState:UIControlStateNormal];
            
            [imageButton 
             addTarget:self 
             action:@selector(buttonPressed:) 
             forControlEvents:UIControlEventTouchUpInside];
            [imageButton setTag:i*buttonsPerRow*3 + j +1];
            
            [subview addSubview:(UIView *)imageButton];
            //[imageButton release];
            
            if ([marginArray count] >= [contentArray count]){
                if ([[marginArray objectAtIndex:i*buttonsPerRow*3+j] boolValue]){
                    //add margin
                
                    UIImageView *margin;
                    margin =[[UIImageView alloc] initWithFrame:CGRectMake(
                                                                      xPos,
                                                                      yPos,
                                                                      96,
                                                                      96)];
                
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
                                        * ceil((double)[contentArray count]/buttonsPerRow/3), 
                                        scrollHeight);
    
    [main addSubview:scrollView];
    
    if (pageControlEnabledTop) {  
        rectPageControl = CGRectMake(0, 5, scrollWidth, 15);  
    }  
    else if (pageControlEnabledBottom) {  
        rectPageControl = CGRectMake(0, (scrollHeight - 20), scrollWidth, 15);  
    }  
    if (pageControlEnabledTop || pageControlEnabledBottom) {  
        pageControl = [[[UIPageControl alloc] initWithFrame:rectPageControl] autorelease];  
        pageControl.numberOfPages = ceil((double)[contentArray count]/buttonsPerRow/3);
        pageControl.currentPage = page;
        [main addSubview:pageControl];  
    }  
    if (pageControlEnabledTop || pageControlEnabledBottom || rememberPosition) self.scrollView.delegate = self;  
    return (UIScrollView *)main;  
}  

- (UIScrollView *)get {  
    return [self getWithPosition:0];  
}  

- (UIScrollView *)getWithPositionMemory {  
    [self enablePositionMemory];  
    return [self getWithPosition:[[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@", kIGUIScrollViewImagePageIdentifier, kIGUIScrollViewImageDefaultPageIdentifier]] intValue]];  
}  

- (UIScrollView *)getWithPositionMemoryIdentifier:(NSString *)identifier {  
    [self enablePositionMemoryWithIdentifier:identifier];  
    return [self getWithPosition:[[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@", kIGUIScrollViewImagePageIdentifier, positionIdentifier]] intValue]];  
}  

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sv {  
    int page = sv.contentOffset.x / sv.frame.size.width;  
    pageControl.currentPage = page;  
    if (rememberPosition) {  
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", page] forKey:[NSString stringWithFormat:@"%@%@", kIGUIScrollViewImagePageIdentifier, positionIdentifier]];  
        [[NSUserDefaults standardUserDefaults] synchronize];  
    }  
}  

//button actions
- (void)buttonPressed:(id)sender {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Button pressed"
													message:[NSString stringWithFormat:@"You pressed the button on button %d.", [sender tag]]
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
    
    
	[alert show];
	[alert release];
    
}


- (void)dealloc {  
    [scrollView release];  
    [super dealloc];  
}  


@end  
