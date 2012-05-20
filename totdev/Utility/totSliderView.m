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

#define totGUIScrollViewImagePageIdentifier         @"totGUIScrollViewImagePageIdentifier"  
#define totGUIScrollViewImageDefaultPageIdentifier  @"Default"  

#define DEFAULT_WIDTH       270
#define DEFAULT_HEIGHT      280 
#define DEFAULT_NUMOFROWS   2

// layout parameters
//#define LEFT_MARGIN         10
//#define TOP_MARGIN          20
//#define HORI_INTERVAL       15
//#define VERTI_INTERVAL      20
#define BUTTON_WIDTH        75
#define BUTTON_HEIGHT       90

@implementation totSliderView

@synthesize delegate;
@synthesize numOfRows;

- (id)initWithFrame:(CGRect)frame {
    if( self = [super initWithFrame:frame] ) {
        self.userInteractionEnabled = YES;
        //scrollWidth   = DEFAULT_WIDTH;
        //scrollHeight  = DEFAULT_HEIGHT;
        scrollWidth   = frame.size.width;
        scrollHeight  = frame.size.height;
        scrollYOrigin = frame.origin.y;
        numOfRows     = DEFAULT_NUMOFROWS;
        
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, scrollWidth, scrollHeight)];
        pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        
        [self addSubview:scrollView];
        [self addSubview:pageControl];
    }
    return self;
}

- (int)getScrollViewWidth {  
    int num = [contentArray count];
    int pagenum = num / 6 + ((num%6)==0 ? 0 : 1);
    return (pagenum * scrollWidth);  
}  


//-(void)setPosition:(int)yOrigin{
//    scrollYOrigin = yOrigin;
//}

//-(void)setLayout:(int)noOfRows{
//    numOfRows = noOfRows;
//}

- (void)setContentArray:(NSArray *)images {  
    if( contentArray )
        [contentArray release];
    contentArray = [[NSMutableArray alloc] initWithArray:images];
    
    if( marginArray )
        [marginArray release];
    marginArray  = [[NSMutableArray alloc] init];
    
    if( isIconArray )
        [isIconArray release];
    isIconArray  = [[NSMutableArray alloc] init];
    
    if( labelArray )
        [labelArray release];
    labelArray = [[NSMutableArray alloc] init]; //containing UILabel
    
    if( buttonArray )
        [buttonArray release];
    buttonArray = [[NSMutableArray alloc] init];
    
    for( int i = 0; i < [contentArray count]; i++ ) {
        [marginArray addObject:[NSNumber numberWithBool:NO]];
        [isIconArray addObject:[NSNumber numberWithBool:YES]];
        
    }
    
}

- (void)setMarginArray:(NSArray *)margins {
    if( marginArray )
        [marginArray release];
    marginArray = [[NSMutableArray alloc] initWithArray:margins];
}

- (void)setButton:(int)idx andWithValue:(float)value{
    //add new view on button
    
    //deside label position
    NSString *value_string = [NSString stringWithFormat:@"%.1f %@", value,@"oz" ];
    
    ((UILabel*)[labelArray objectAtIndex:idx]).text = value_string;
}

- (void)clearButtonLabels{
    for(int i=0; i<[labelArray count]; i++){
        ((UILabel*)[labelArray objectAtIndex:i]).text = @"";
    }
}

- (void)clearButtonBGColor{
    for(int i=0; i<[contentArray count]; i++){
        ((UIButton*)[buttonArray objectAtIndex:i]).backgroundColor = [UIColor clearColor];
    }
}

- (void)setIsIconArray:(NSArray*)isIcon {
    if( isIconArray )
        [isIconArray release];
    isIconArray = [[NSMutableArray alloc] initWithArray:isIcon];
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

- (void)getWithPosition:(int)page {    
    if (!contentArray)  contentArray = [[NSMutableArray alloc] init]; 
        
    int totalPageNumbers = 
        ceil((double)[contentArray count]/numOfRows/3);

    if (page-1 > totalPageNumbers) 
        page = 0;
    
    [self cleanScrollView];
    
    scrollView.contentSize = CGSizeMake([self getScrollViewWidth], scrollHeight);  
    if (!bcgColor) bcgColor = [UIColor clearColor];
    scrollView.backgroundColor = bcgColor;  //by default transparent
    scrollView.alwaysBounceHorizontal = YES;  
    scrollView.contentOffset = CGPointMake(page * scrollWidth, 0);  
    scrollView.pagingEnabled = YES;  
    scrollView.showsHorizontalScrollIndicator = NO;

    //load button here: //plus blank label here
    for (int i = 0; i < totalPageNumbers; i++) {
        UIView *subview = [[UIView alloc] initWithFrame:CGRectMake(i*scrollWidth, 5, scrollWidth, scrollHeight)];
        
        int remainButtons = 0;
        if([contentArray count] >= (i+1)*numOfRows*3)
            remainButtons = numOfRows*3;
        else
            remainButtons = [contentArray count]- i*numOfRows*3;
        
        int xx[6] = {7, 97, 187, 7, 97, 187};
        int yy[6] = {5, 5, 5, 100, 100, 100};
        
        for (int j = 0; j<remainButtons; j++){
            //int xPos = LEFT_MARGIN+(BUTTON_WIDTH+HORI_INTERVAL)*(j%3);
            //int yPos = TOP_MARGIN+(BUTTON_HEIGHT+VERTI_INTERVAL)*(j/3);
            int xPos = xx[j];
            int yPos = yy[j];
            
            if( [[isIconArray objectAtIndex:i*numOfRows*3+j] boolValue] ) {
                UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(xPos, yPos, BUTTON_WIDTH, BUTTON_HEIGHT)];
                UIImage  *origImage   = [contentArray objectAtIndex:i*numOfRows*3+j];
                [imageButton setImage:origImage forState:UIControlStateNormal];
                [imageButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
                [imageButton setTag:i*numOfRows*3+j+1];
                [subview addSubview:(UIView *)imageButton];
                
                [buttonArray addObject:imageButton];
                
                [imageButton release];
            } else {
                UIImageView *bckground = [[UIImageView alloc] initWithFrame:CGRectMake(xPos, yPos, BUTTON_WIDTH, BUTTON_HEIGHT)];
                UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(xPos, yPos, BUTTON_WIDTH, BUTTON_WIDTH)];
                UIImage *origImage = [contentArray objectAtIndex:i*numOfRows*3+j];
                UIImage *squareImage = [totUtility squareCropImage:origImage];
                [imageButton setImage:squareImage forState:UIControlStateNormal];
                [imageButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
                [imageButton setTag:i*numOfRows*3+j+1];
                [subview addSubview:imageButton];
                [subview addSubview:bckground];
                [imageButton release];
                [bckground release];
            }
            
            // margin
            if ([[marginArray objectAtIndex:i*numOfRows*3+j] boolValue]){
                UIImageView *margin = [[UIImageView alloc] initWithFrame:CGRectMake(xPos,yPos,BUTTON_WIDTH+4,BUTTON_WIDTH+4)];
                margin.image=[UIImage imageNamed:@"margin.png"];
                [subview addSubview:margin];
                [margin release];
            }
            
            //add blank label
            UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPos, yPos, BUTTON_WIDTH, BUTTON_HEIGHT)];
            
            myLabel.backgroundColor = [UIColor clearColor]; // [UIColor brownColor];
            myLabel.font = [UIFont fontWithName:@"Arial" size: 14.0];
            
            myLabel.shadowColor = [UIColor yellowColor];
            myLabel.shadowOffset = CGSizeMake(1,1);
            myLabel.textColor = [UIColor blueColor];
            
            myLabel.textAlignment = UITextAlignmentCenter; 
            myLabel.text = @"";//init blank
            
            myLabel.userInteractionEnabled = NO;//user can point through
            
            [subview addSubview:myLabel];
            [labelArray addObject:myLabel];
            
            [myLabel release];
        }
        
        [scrollView addSubview:subview];
        [subview release];
    }
    
    if (pageControlEnabledTop)
        pageControl.frame = CGRectMake(0, 5, scrollWidth, 15);
    else if (pageControlEnabledBottom)
        pageControl.frame = CGRectMake(0, (scrollHeight - 30), scrollWidth, 15);
    else
        pageControl.frame = CGRectMake(0, 0, 0, 0);
    
    if (pageControlEnabledTop || pageControlEnabledBottom) {  
        pageControl.numberOfPages = totalPageNumbers;
        pageControl.currentPage = page;
    }

    //if (pageControlEnabledTop || pageControlEnabledBottom || rememberPosition) 
    scrollView.delegate = self;
}

- (void)cleanScrollView {
    for(UIView *subview in [scrollView subviews]) {
        [subview removeFromSuperview];
    }
}

- (void)get {  
    [self getWithPosition:0];  
}  

//- (UIScrollView *)getWithPositionMemory:(NSString *)identifier {  
//    [self enablePositionMemory:identifier];  
//    return [self getWithPosition:[[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@", totGUIScrollViewImagePageIdentifier, positionIdentifier]] intValue]];  
//}  

- (void)getWithPositionMemoryIdentifier:(NSString *)identifier {  
    [self enablePositionMemoryWithIdentifier:identifier];  
    [self getWithPosition:[[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@", totGUIScrollViewImagePageIdentifier, positionIdentifier]] intValue]];  
}  

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sv {  
    int page = sv.contentOffset.x / sv.frame.size.width;  
    pageControl.currentPage = page;  
    if (rememberPosition) {  
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", page] forKey:[NSString stringWithFormat:@"%@%@", totGUIScrollViewImagePageIdentifier, positionIdentifier]];  
        [[NSUserDefaults standardUserDefaults] synchronize];  
    }  
}  

- (void)buttonPressed:(id)sender {
    if( [delegate respondsToSelector:@selector(buttonPressed:)] ) {
        [delegate buttonPressed:sender];
    }
}

- (void)dealloc {  
    [contentArray release];
    [marginArray release];
    [isIconArray release];
    [pageControl release];
    [scrollView release];
    [labelArray release];
    [buttonArray release];
     
    [super dealloc];  
}  


@end  
