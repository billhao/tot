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

@implementation totHomeFeedingViewController

@synthesize homeRootController;
@synthesize mSliderView;
@synthesize mCurrentFoodID;
@synthesize navigationBar;
@synthesize mOKButton;
@synthesize mDatetime;

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
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // create the slider view
    mSliderView = [[totSliderView alloc] initWithFrame:CGRectMake(25, 45, 270, 300)];
    [mSliderView setDelegate:self];
    //[mSliderView enablePageControlOnTop];
    [mSliderView enablePageControlOnBottom];
    
    //load image
    NSMutableArray *foodImages = [[NSMutableArray alloc] init];
    [foodImages addObject:[UIImage imageNamed:@"emotion_angry.png"]];
    [foodImages addObject:[UIImage imageNamed:@"gesture_salut.png"]];
    [foodImages addObject:[UIImage imageNamed:@"gesture_wave.png"]];
    [foodImages addObject:[UIImage imageNamed:@"motor_skill_crawl.png"]];
    [foodImages addObject:[UIImage imageNamed:@"motor_skill_jump.png"]];
    [foodImages addObject:[UIImage imageNamed:@"gesture_suck_toe.png"]];
    [foodImages addObject:[UIImage imageNamed:@"gesture_point.png"]];
    [foodImages addObject:[UIImage imageNamed:@"emotion_happy.png"]];
    [mSliderView setContentArray:foodImages];
    [foodImages release];
    
    [mSliderView getWithPositionMemoryIdentifier:@"homeFeedingView"];

    [self.view addSubview:mSliderView];
    
    //create title navigation bar
    navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    [self.view addSubview:navigationBar];
    
    //create picker for oz
    /*
    picker_quantity = [[STHorizontalPicker alloc] initWithFrame:CGRectMake(0, 0, 320, 31)];
    picker_quantity.name = @"picker_weight";
    [picker_quantity setMinimumValue:0.0];
    [picker_quantity setMaximumValue:6.0];
    [picker_quantity setSteps:60];
    [picker_quantity setDelegate:self];
    [picker_quantity setValue:2.3];
    [self.view addSubview:picker_quantity];
//    [picker_quantity release];
     */
    
    //create ok button
    mOKButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    mOKButton.frame = CGRectMake(150, 347, 160, 40);
    [mOKButton setTitle:@"OK" forState:UIControlStateNormal];
    [self.view addSubview:mOKButton];
    


    mDatetime = [UIButton buttonWithType:UIButtonTypeCustom];
    mDatetime.frame = CGRectMake(10, 347, 130, 40);
    [mDatetime setTitle:[totUtility nowTimeString] forState:UIControlStateNormal];
    [self.view addSubview:mDatetime];  
    
    // set up events
    [mOKButton addTarget:self action:@selector(OKButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mDatetime addTarget:self action:@selector(DatetimeClicked:) forControlEvents:UIControlEventTouchUpInside];

    
    // set up date picker
    mWidth = self.view.frame.size.width;
    mHeight= self.view.frame.size.height;
    
    mClock = [[totTimerController alloc] init];
    mClock.view.frame = CGRectMake((mWidth-mClock.mWidth)/2, mHeight, mClock.mWidth, mClock.mHeight);
    [mClock setMode:kTime];
    [mClock setDelegate:self];
    [self.view addSubview:mClock.view];

}


- (void)OKButtonClicked: (UIButton *)button {
    NSLog(@"%@", @"[feeding] ok button clicked");
    int baby_id = 0;
    NSDate* date = [NSDate date];
    NSString* quantity = [[NSString alloc] initWithFormat:@"%.1f", picker_quantity.value];
    
    
    [mTotModel addEvent:baby_id event:EVENT_FEEDING_MILK datetime:date value:quantity];
    
    NSString* summary = [NSString stringWithFormat:@"%@\n@ %@%@", @"today", @"Milk", quantity,@"Oz" ];
   
    /*
    [mSummary setTitle:summary forState:UIControlStateNormal];
    [self.view bringSubviewToFront:mSummary];
    [mSummary setHidden:false];
    
    // get a list of events containing "emotion"
    NSString* event = [[NSString alloc] initWithString:@"basic"];
    // return from getEvent is an array of totEvent object
    // a totEvent represents a single event
    NSMutableArray *events = [model getEvent:0 event:event];
    for (totEvent* e in events) {
        NSLog(@"Return from db: %@", [e toString]);        
    }
    [event release];
    */
    
    [quantity release];
    
    

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
    mClock.view.frame = CGRectMake((mWidth-mClock.mWidth)/2, mHeight, mClock.mWidth, mClock.mHeight);
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
    // e.g. self.myOutlet = nil;
    [mBackground release];
    [mSliderView release];
    [mMessage release];
    [navigationBar release];
    [picker_quantity release];
    [mOKButton release];
    [mClock release];
    [mDatetime release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
