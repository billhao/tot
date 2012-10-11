//
//  totHomeFeedingViewController.m
//  totdev
//
//  Created by Yifei Chen on 5/6/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "AppDelegate.h"
#import "totHomeFeedingViewController.h"
#import "totEventName.h"
#import "totEvent.h"
#import "../Utility/totUtility.h"
#import "../Utility/totImageView.h"


#define DEFAULT_QUANTITY 2.3 //magic number

@implementation totHomeFeedingViewController

@synthesize homeRootController;
@synthesize mRecentlyUsedSlider;
@synthesize mCategoriesSlider;
@synthesize mFoodChosenSlider;
@synthesize mCurrentFoodID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        mTotModel = [appDelegate getDataModel];

    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)pickerView:(STHorizontalPicker *)picker didSelectValue:(CGFloat)value {
    NSLog(@"didSelectValue %f", value);
    // change the associate number on buttons
    
    //testing
    //NSString *temp =[[NSString alloc] initWithFormat:@"%.1f", picker_quantity.currentValue];
    //[mOKButton setTitle:temp forState:UIControlStateNormal];
    //[temp release];
    
    //need to expose an API in 
    [mFoodChosenSlider setButton:buttonSelected andWithValue:picker_quantity.currentValue];

    quantityList[buttonSelected] =picker_quantity.currentValue;    
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void)buttonPressed: (id)sender {
    UIButton *btn = (UIButton*)sender;
    int tag = [btn tag];
    tag = tag - 1;
    
    picker_quantity.hidden = NO;
    [picker_quantity setValue:DEFAULT_QUANTITY];
    
    buttonSelected = tag;
        
    //reset all button bacground color;
    [mFoodChosenSlider clearButtonBGColor];
    ((UIButton *)sender).backgroundColor = [UIColor redColor];

}

- (void) navLeftButtonPressed:(id)sender{
    [homeRootController switchTo:kHomeViewEntryView withContextInfo:nil];
    
    //need to do clean up
    //xxxxxxxxxx
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // create background
    totImageView *background = [[totImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [background imageFilePath:@"feeding-blank.png"];
    [self.view addSubview:background];
    [background release];
    
    
    
    // create categories slider view
    mCategoriesSlider = [[totSliderView alloc] initWithFrame:CGRectMake(38, 170, 244, 120)];
    [mCategoriesSlider setDelegate:self];
    [mCategoriesSlider setBtnPerCol:2];
    [mCategoriesSlider setBtnPerRow:3];
    [mCategoriesSlider setvMarginBetweenBtn:12];
    [mCategoriesSlider sethMarginBetweenBtn:12];
    [mCategoriesSlider setBtnHeight:33];
    //[mCategoriesSlider enablePageControlOnBottom]; no page control dot
    
    //load image
    NSMutableArray *categoriesImages = [[NSMutableArray alloc] init];
    [categoriesImages addObject:[UIImage imageNamed:@"feedingcategories-cereal"]];
    [categoriesImages addObject:[UIImage imageNamed:@"feedingcategories-dairy.png"]];
    [categoriesImages addObject:[UIImage imageNamed:@"feedingcategories-fruit.png"]];
    [categoriesImages addObject:[UIImage imageNamed:@"feedingcategories-juice.png"]];
    [categoriesImages addObject:[UIImage imageNamed:@"feedingcategories-meat.png"]];
    [categoriesImages addObject:[UIImage imageNamed:@"feedingcategories-vege.png"]];

    [mCategoriesSlider setContentArray:categoriesImages];
    [categoriesImages release];
    
    [mCategoriesSlider getWithPositionMemoryIdentifier:@"feedingCategories"];

    [self.view addSubview:mCategoriesSlider];
    
    buttonSelected = 0;

    
    // create recently used slider view
    mRecentlyUsedSlider = [[totSliderView alloc] initWithFrame:CGRectMake(38, 95, 244, 60)];
    [mRecentlyUsedSlider setDelegate:self];
    [mRecentlyUsedSlider setBtnPerCol:1];
    [mRecentlyUsedSlider setBtnPerRow:4];
    [mRecentlyUsedSlider setvMarginBetweenBtn:0];
    [mRecentlyUsedSlider sethMarginBetweenBtn:0];
    //[mRecentlyUsedSlider setBtnHeight:40];
    
    //load image
    NSMutableArray *recentlyUsedImages = [[NSMutableArray alloc] init];
   // [recentlyUsedImages addObject:[UIImage imageNamed:@"feedingcategories-cereal"]];
    [recentlyUsedImages addObject:[UIImage imageNamed:@"feeding-apple.png"]];
    [recentlyUsedImages addObject:[UIImage imageNamed:@"feeding-blueberry.png"]];
    [recentlyUsedImages addObject:[UIImage imageNamed:@"feeding-papaya.png"]];
    [recentlyUsedImages addObject:[UIImage imageNamed:@"feeding-kiwi.png"]];
    [recentlyUsedImages addObject:[UIImage imageNamed:@"feeding-mango.png"]];
    [recentlyUsedImages addObject:[UIImage imageNamed:@"feeding-bread.png"]];
    [recentlyUsedImages addObject:[UIImage imageNamed:@"feeding-banana.png"]];
    [recentlyUsedImages addObject:[UIImage imageNamed:@"feeding-ricewhite.png"]];
    [recentlyUsedImages addObject:[UIImage imageNamed:@"feeding-cheerios.png"]];
    [recentlyUsedImages addObject:[UIImage imageNamed:@"feeding-peas.png"]];
 
    
    [mRecentlyUsedSlider setContentArray:recentlyUsedImages];
    [recentlyUsedImages release];
    
    [mRecentlyUsedSlider getWithPositionMemoryIdentifier:@"feedingRecentlyUsed"];
    
    [self.view addSubview:mRecentlyUsedSlider];
    
    //create title navigation bar
    //navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    //[self.view addSubview:navigationBar];
    mNavigationBar= [[totNavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [mNavigationBar setLeftButtonImg:@"return.png"];
    [mNavigationBar setBackgroundColor:[UIColor whiteColor]];
    [mNavigationBar setDelegate:self];
    [self.view addSubview:mNavigationBar];
    
    //create picker for oz
    picker_quantity = [[STHorizontalPicker alloc] initWithFrame:CGRectMake(0, 265, 320, 31)];
    picker_quantity.name = @"picker_weight";
    [picker_quantity setMinimumValue:0.0];
    [picker_quantity setMaximumValue:6.0];
    [picker_quantity setSteps:60];
    [picker_quantity setDelegate:self];
    [picker_quantity setValue:DEFAULT_QUANTITY];
    //diable picker quantity
    picker_quantity.hidden =YES;
    
    [self.view addSubview:picker_quantity];
    
    //create ok button
    mOKButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    mOKButton.frame = CGRectMake(150, 347, 160, 40);
    [mOKButton setTitle:@"OK" forState:UIControlStateNormal];
    [self.view addSubview:mOKButton];
    
    mDatetime = [UIButton buttonWithType:UIButtonTypeCustom];
    mDatetime.frame = CGRectMake(10, 347, 130, 40);
    [mDatetime setTitle:[totUtility nowTimeString] forState:UIControlStateNormal];
    [self.view addSubview:mDatetime];  
    
    mSummary = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    mSummary.frame = CGRectMake(50, 80, 220, 311);
    [mSummary setHidden:YES];
    mSummary.titleLabel.lineBreakMode=UILineBreakModeWordWrap;
    //mSummary.titleLabel.frame= mSummary.bounds;
    [self.view addSubview:mSummary];  

    
    // set up events
    [mOKButton addTarget:self action:@selector(OKButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mDatetime addTarget:self action:@selector(DatetimeClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mSummary addTarget:self action:@selector(SummaryButtonClicked:) forControlEvents: UIControlEventTouchUpInside];

    
    // set up date picker
    mWidth = self.view.frame.size.width;
    mHeight= self.view.frame.size.height;
    
    mClock = [[totTimerController alloc] init];
    mClock.view.frame = CGRectMake((mWidth-mClock.mWidth)/2, 480, mClock.mWidth, mClock.mHeight);
    [mClock setMode:kTime];
    [mClock setDelegate:self];
    [mClock setCurrentTime];
    [self.view addSubview:mClock.view];
    
    for (int i=0; i<DEFAULT_MENU ; i++) {
        quantityList[i]=0;    
    }
}


- (void)OKButtonClicked: (UIButton *)button {
    NSLog(@"%@", @"[feeding] ok button clicked");
    int baby_id = 0;
    NSDate* date = [NSDate date];
    
    NSString* summary = [NSString stringWithFormat:@"**%@", mDatetime.titleLabel.text ];
    NSLog(@"%@", summary);


    for(int i=0;i<DEFAULT_MENU;i++){
        if(quantityList[i]>0){
            NSString* temp = [NSString stringWithFormat:@"%@-%d:\t%.1f %@", @"food",i, quantityList[i],@"oz" ];
            
            summary = [NSString stringWithFormat:@"%@\n%@",summary,temp ];
            
            NSString* quantity = [NSString stringWithFormat:@"%.1f", picker_quantity.currentValue];
            
            // food list needs renew
            [mTotModel addEvent:baby_id event:EVENT_FEEDING_MILK datetime:date value:quantity];
            NSLog(@"%@",summary);
        }
        
    }
    
    [mSummary setTitle:summary forState:UIControlStateNormal];
    [self.view bringSubviewToFront:mSummary];
    [mSummary setHidden:false];
    
    // get a list of events containing "emotion"
    NSString* event = [[NSString alloc] initWithString:@"fedding"];
    // return from getEvent is an array of totEvent object
    // a totEvent represents a single event
    NSMutableArray *events = [mTotModel getEvent:0 event:event];
    for (totEvent* e in events) {
        NSLog(@"Return from db: %@", [e toString]);        
    }
    [event release];
    
    
}

-(void)SummaryButtonClicked:(UIButton *)button{
    [homeRootController switchTo:kHomeViewEntryView withContextInfo:nil];
}


- (void)showTimePicker {
    [UIView beginAnimations:@"swipe" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5f];
    mClock.view.frame = CGRectMake((mWidth-mClock.mWidth)/2, mHeight-mClock.mHeight, mClock.mWidth, mClock.mHeight);
    [UIView commitAnimations];
}

// display date selection
- (void)DatetimeClicked: (UIButton *)button {
    NSLog(@"%@", @"[feeding] datetime clicked");
    [self showTimePicker];
}

- (void)hideTimePicker {
    [UIView beginAnimations:@"swipe" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5f];
    mClock.view.frame = CGRectMake((mWidth-mClock.mWidth)/2, 480, mClock.mWidth, mClock.mHeight);
    [UIView commitAnimations];
}

#pragma mark - totTimerControllerDelegate
-(void)saveCurrentTime:(NSString*)time {
    NSLog(@"%@", time);
    NSString *formattedTime;
    //need to parse time before display
    NSArray* timeComponent = [time componentsSeparatedByString: @":"];
    
    formattedTime = [NSString stringWithFormat:@"%@:%@ %@",
                     [timeComponent objectAtIndex:0],
                     [timeComponent objectAtIndex:1],
                     [[timeComponent objectAtIndex:2] uppercaseString]];
    
    [mDatetime setTitle:formattedTime forState:UIControlStateNormal];
    
    //[formattedTime release];
    [self hideTimePicker];
}

-(void)cancelCurrentTime {
    [self hideTimePicker];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [mRecentlyUsedSlider release];
    [mFoodChosenSlider release];
    [mCategoriesSlider release];
    [picker_quantity release];
    //[mOKButton release];
    //[mDatetime release];
    //[mSummary release];
    [mClock release];
    [mNavigationBar release];
}


- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"%@", @"[height] viewWillAppear");
    //[mSummary removeFromSuperview];
    [mSummary setHidden:YES];
    //reset time
    [mDatetime setTitle:[totUtility nowTimeString] forState:UIControlStateNormal];

    //reset time picker
    [mClock setCurrentTime];
    
    //reset quantity on picker
    [picker_quantity setValue:DEFAULT_QUANTITY];
    picker_quantity.hidden = YES;
    
    //reset quantiy on buttons
    [mCategoriesSlider clearButtonLabels];
    [mCategoriesSlider clearButtonBGColor];
    
    //clear quantityList
    for(int i=0;i<DEFAULT_MENU;i++){
        quantityList[i]=0;
    }

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
