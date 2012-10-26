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

#define MAX_BTNPERPAGE      20
#define DEFAULT_WIDTH       270
#define DEFAULT_HEIGHT      280 
#define DEFAULT_BTNPERROW   3
#define DEFAULT_BTNPERCOL   2

// layout parameters
//#define LEFT_MARGIN         10
//#define TOP_MARGIN          20
//#define HORI_INTERVAL       15
//#define VERTI_INTERVAL      20
#define BUTTON_WIDTH        75
#define BUTTON_HEIGHT       90

@implementation totSliderView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    if( self = [super initWithFrame:frame] ) {
        self.userInteractionEnabled = YES;
        //scrollWidth   = DEFAULT_WIDTH;
        //scrollHeight  = DEFAULT_HEIGHT;
        scrollWidth   = frame.size.width;
        scrollHeight  = frame.size.height;
        scrollYOrigin = frame.origin.y;
        if(!btnPerRow)
            btnPerRow = DEFAULT_BTNPERROW;
        if(!btnPerCol)
            btnPerCol = DEFAULT_BTNPERCOL;
        if(!vMarginBetweenBtn)
            vMarginBetweenBtn = 0;
        if(!hMarginBetweenBtn)
            hMarginBetweenBtn = 0;
        
        if(!tagOffset)
            tagOffset = 0;
        
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, scrollWidth, scrollHeight)];
        pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        
        [self addSubview:scrollView];
        [self addSubview:pageControl];
    }
    return self;
}

- (int)getScrollViewWidth {  
    int num = [contentArray count];
    int numPerPage = btnPerRow * btnPerCol;
    
    int pagenum = num / numPerPage + ((num%numPerPage)==0 ? 0 : 1);
    return (pagenum * scrollWidth);  
}  


//-(void)setPosition:(int)yOrigin{
//    scrollYOrigin = yOrigin;
//}

-(void)setBtnPerRow:(int)buttonPerRow {
    btnPerRow = buttonPerRow;
}

-(void)setBtnPerCol:(int)buttonPerCol {
    btnPerCol = buttonPerCol;
}

-(void)setBtnHeight:(int)buttonHeight {
    btnHeight = buttonHeight;
}

-(void)setvMarginBetweenBtn:(int)vMargin {
    vMarginBetweenBtn = vMargin;
}

-(void)sethMarginBetweenBtn:(int)hMargin {
    hMarginBetweenBtn = hMargin;
}

- (void)setContentArray:(NSArray *)images {  
    if( contentArray ) {
        [contentArray release]; contentArray = nil;}
    if( marginArray ) {
        [marginArray release];  marginArray = nil; }
    if( isIconArray ) {
        [isIconArray release]; isIconArray = nil; }
    if( labelArray ) {
        [labelArray release];  labelArray = nil;  }
    if( buttonArray ) {
        [buttonArray release]; buttonArray = nil; }
    
    contentArray = [[NSMutableArray alloc] initWithArray:images];
    marginArray  = [[NSMutableArray alloc] init];
    isIconArray  = [[NSMutableArray alloc] init];
    labelArray   = [[NSMutableArray alloc] init];
    buttonArray  = [[NSMutableArray alloc] init];
    
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
    //deside label position
    NSString *value_string = [NSString stringWithFormat:@"%.1f %@", value,@"oz" ];
    ((UILabel*)[labelArray objectAtIndex:idx]).text = value_string;
}

- (void)setTagOffset:(int)tag_offset{
    tagOffset = tag_offset;
}

- (void)clearButtonLabels{
    for(int i=0; i<[labelArray count]; i++) {
        ((UILabel*)[labelArray objectAtIndex:i]).text = @"";
    }
}

- (void)clearButtonBGColor{
    for(int i=0; i<[contentArray count]; i++) {
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
    if (!contentArray) {
        printf("Must set content array before using totSliderView\n");
        exit(1);
    }
    
    int btnPerPage = btnPerRow * btnPerCol;
    
    int totalPageNumbers = 
        ceil((double)[contentArray count]/ btnPerPage);

    if (page-1 > totalPageNumbers) page = 0; //reset page
    
    [self cleanScrollView];
    
    scrollView.contentSize = CGSizeMake([self getScrollViewWidth], scrollHeight);  
    if (!bcgColor) bcgColor = [UIColor clearColor];
    scrollView.backgroundColor = bcgColor;  //by default transparent
    scrollView.alwaysBounceHorizontal = YES;  
    scrollView.contentOffset = CGPointMake(page * scrollWidth, 0);  
    scrollView.pagingEnabled = YES;  
    scrollView.showsHorizontalScrollIndicator = NO;

    
    //decide layout
    int xx[MAX_BTNPERPAGE], yy[MAX_BTNPERPAGE]; //the maximum buttons one page can hold
    int btnWidth;
    btnWidth = floor( (scrollWidth - (btnPerRow + 1) * vMarginBetweenBtn) / btnPerRow );
    if (!btnHeight)
        btnHeight = btnWidth;
    
    for (int i = 0; i<btnPerCol; i++){
        for(int j = 0; j<btnPerRow; j++){
            xx[j + btnPerRow * i] =
                vMarginBetweenBtn * (j + 1) + j*btnWidth;
            yy[j + btnPerRow*i] =
                hMarginBetweenBtn * (i + 1) + i*btnHeight;
        }
    }

    //load button here: //plus blank label here
    for (int i = 0; i < totalPageNumbers; i++) {
        UIView *subview = [[UIView alloc] initWithFrame:CGRectMake(i*scrollWidth, 0, scrollWidth, scrollHeight)];
        
        int btnToRender = 0;
        if([contentArray count] >= (i+1)*btnPerPage)
            btnToRender = btnPerPage;
        else
            btnToRender = [contentArray count]- i*btnPerPage; //render the remaining buttons
        
        //int xx[6] = {7, 97, 187, 7, 97, 187}; //should be auto computed
        //int yy[6] = {5, 5, 5, 100, 100, 100};
        
        for (int j = 0; j<btnToRender; j++){
            //int xPos = LEFT_MARGIN+(BUTTON_WIDTH+HORI_INTERVAL)*(j%3);
            //int yPos = TOP_MARGIN+(BUTTON_HEIGHT+VERTI_INTERVAL)*(j/3);
            int xPos = xx[j];
            int yPos = yy[j];
            
            if( [[isIconArray objectAtIndex:i*btnPerPage+j] boolValue] ) {
                UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(xPos, yPos, btnWidth, btnHeight)];
                UIImage  *origImage   = [contentArray objectAtIndex:i*btnPerPage+j];
                [imageButton setImage:origImage forState:UIControlStateNormal];
                [imageButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
                [imageButton setTag:i*btnPerPage+j+1+tagOffset];
                [subview addSubview:(UIView *)imageButton];
                [buttonArray addObject:imageButton];
                [imageButton release];
            } else {
                UIImageView *bckground = [[UIImageView alloc] initWithFrame:CGRectMake(xPos, yPos, btnWidth, btnHeight)];
                UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(xPos, yPos, btnWidth, btnHeight)];
                UIImage *origImage = [contentArray objectAtIndex:i*btnPerPage+j];
                //UIImage *squareImage = [totUtility squareCropImage:origImage];
                [imageButton setImage:origImage forState:UIControlStateNormal];
                [imageButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
                [imageButton setTag:i*btnPerPage+j+1+tagOffset];
                [subview addSubview:imageButton];
                [subview addSubview:bckground];
                [imageButton release];
                [bckground release];
            }
            
            // margin
            if ([[marginArray objectAtIndex:i*btnPerPage+j] boolValue]){
                UIImageView *margin = [[UIImageView alloc] initWithFrame:CGRectMake(xPos,yPos,btnWidth+4,btnHeight+4)];
                margin.image=[UIImage imageNamed:@"margin.png"];
                [subview addSubview:margin];
                [margin release];
            }
            
            //add blank label
            UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPos, yPos, btnWidth, btnHeight)];
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

    scrollView.delegate = self;
}

- (void)_cleanSubviewsIn:(UIView*)v {
    for(UIView *subview in [v subviews]) {
        [self _cleanSubviewsIn:subview];
        [subview removeFromSuperview];
        [subview release];
    }
}

- (void)cleanScrollView {
    for(UIView *subview in [scrollView subviews]) {
        //[self _cleanSubviewsIn:subview];
        [subview removeFromSuperview];
        //[subview release];
    }
}

- (void)get {  
    [self getWithPosition:0];  
}

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
    if(contentArray)[contentArray release];
    if(marginArray) [marginArray release];
    if(isIconArray) [isIconArray release];
    if(labelArray)  [labelArray release];
    if(buttonArray) [buttonArray release];
    
    [pageControl release];
    [scrollView release];
    [super dealloc];  
}  

@end  
