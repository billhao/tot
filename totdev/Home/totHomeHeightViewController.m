//
//  totHomeHeightViewController.m
//  totdev
//
//  Created by Hao on 5/5/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totHomeRootController.h"
#import "totHomeHeightViewController.h"
#import "AppDelegate.h"
#import "totEventName.h"
#import "totEvent.h"

@implementation totHomeHeightViewController

@synthesize homeRootController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        model = [appDelegate getDataModel];
        picker_height = nil;
        picker_weight = nil;
        picker_head = nil;
        
//        mClockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        mClockBtn.frame = CGRectMake(100, 100, 25, 25);
//        [mClockBtn setImage:[UIImage imageNamed:@"clock.png"] forState:UIControlStateNormal];
//        [mClockBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:mClockBtn];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // add bg
    UIImage* img = [UIImage imageNamed:@"weight_bg"];
    UIImageView* bgview = [[UIImageView alloc] initWithImage:img];
    bgview.frame = CGRectMake(0, 0, img.size.width, img.size.height);
    [self.view addSubview:bgview];
    [self.view sendSubviewToBack:bgview];

    // height scroll bar
    picker_height = [[STHorizontalPicker alloc] initWithFrame:CGRectMake(66, 169, 190, 40)];
    picker_height.name = @"picker_height";
//    NSMutableArray* heights = [NSMutableArray arrayWithObjects:
//                                                             @"1'4\"", @"1'5\"", @"1'6\"", @"1'7\"", @"1'8\"", @"1'9\"", @"1'10\"", @"1'11\"",
//                               @"2'1\"", @"2'2\"", @"2'3\"", @"2'4\"", @"2'5\"", @"2'6\"", @"2'7\"", @"2'8\"", @"2'9\"", @"2'10\"", @"2'11\"",
//                               @"3'1\"", @"3'2\"", @"3'3\"", @"3'4\"", @"3'5\"", @"3'6\"", @"3'7\"", @"3'8\"", @"3'9\"", @"3'10\"", @"3'11\"",
//                               @"4'1\"", @"4'2\"", @"4'3\"", @"4'4\"", @"4'5\"", @"4'6\"", @"4'7\"", @"4'8\"", @"4'9\"", @"4'10\"", @"4'11\"",
//                               nil];
//    [picker_height setValues:heights];
    [picker_height setMinimumValue:18.0];
    [picker_height setMaximumValue:48.0];
    [picker_height setSteps:120];
    //[picker_height setValue:20.0];
    [picker_height setDelegate:self];
    [self.view addSubview:picker_height];
    [picker_height release];
    
    // weight scroll bar
//    picker_weight = [[STHorizontalPicker alloc] initWithFrame:mWeightPlaceHolder.frame];
//    picker_weight.name = @"picker_weight";
//    [picker_weight setMinimumValue:4.0];
//    [picker_weight setMaximumValue:40.0];
//    [picker_weight setSteps:360];
//    [picker_weight setDelegate:self];
//    [picker_weight setValue:4.0];
//    [self.view addSubview:picker_weight];
//    [picker_weight release];
    
    // head circumference scroll bar
//    picker_head = [[STHorizontalPicker alloc] initWithFrame:mHeadPlaceHolder.frame];
//    picker_head.name = @"picker_head";
//    [picker_head setMinimumValue:10.0];
//    [picker_head setMaximumValue:24.0];
//    [picker_head setSteps:140];
//    [picker_head setDelegate:self];
//    [picker_head setValue:10.0];
//    [self.view addSubview:picker_head];
//    [picker_head release];

    [mDatetime setTitle:[self getCurrentDate] forState:UIControlStateNormal];
    
    // set up events
    [mOKButton addTarget:self action:@selector(OKButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mDatetime addTarget:self action:@selector(DatetimeClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mDatetimeImage addTarget:self action:@selector(DatetimeClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mSummary addTarget:self action:@selector(SummaryClicked:) forControlEvents:UIControlEventTouchUpInside];

    // set up date picker
    mWidth = self.view.frame.size.width;
    mHeight= self.view.frame.size.height;
    
    mClock = [[totTimerController alloc] init];
    mClock.view.frame = CGRectMake((mWidth-mClock.mWidth)/2, mHeight, mClock.mWidth, mClock.mHeight);
    [mClock setDelegate:self];
    [self.view addSubview:mClock.view];

    //create title navigation bar
    // navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    //[self.view addSubview:navigationBar];
//    mNavigationBar= [[totNavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
//    [mNavigationBar setLeftButtonImg:@"return.png"];
//    [mNavigationBar setNavigationBarTitle:@"Height & Weight" andColor:[UIColor blackColor]];
//    [mNavigationBar setBackgroundColor:[UIColor whiteColor]];
//    [mNavigationBar setDelegate:self];
//    [self.view addSubview:mNavigationBar];
}

- (NSString*)getCurrentDate {
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    return [dateFormatter stringFromDate:[NSDate date]];
}

- (void)pickerView:(STHorizontalPicker *)picker didSelectValue:(CGFloat)value{
    NSLog(@"didSelectValue %f", value);
    mSelectedValue.text = [NSString stringWithFormat:@"%.2f inches",value];
}


// save all the numbers to db
- (void)OKButtonClicked: (UIButton *)button {
    NSLog(@"%@", @"[basic][height] ok button clicked");
    int baby_id = 0;
    NSDate* date = [NSDate date];
    NSString* height = [[NSString alloc] initWithFormat:@"%.2f", picker_height.currentValue];
    NSString* weight = [[NSString alloc] initWithFormat:@"%.2f", picker_weight.currentValue];
    NSString* head   = [[NSString alloc] initWithFormat:@"%.2f", picker_head.currentValue];
    [model addEvent:baby_id event:EVENT_BASIC_HEIGHT datetime:date value:height];
    [model addEvent:baby_id event:EVENT_BASIC_WEIGHT datetime:date value:weight];
    [model addEvent:baby_id event:EVENT_BASIC_HEAD datetime:date value:head];
    
    NSString* summary = [NSString stringWithFormat:@"%@\nHeight %@\nWeight %@\nHead Circumference %@", @"today", height, weight, head ];
    [mSummary setTitle:summary forState:UIControlStateNormal];
    [self.view addSubview:mSummary];
    [self.view bringSubviewToFront:mSummary];
    //[mSummary setHidden:false];

    // get a list of events containing "emotion"
    NSString* event = [[NSString alloc] initWithString:@"basic"];
    // return from getEvent is an array of totEvent object
    // a totEvent represents a single event
    NSMutableArray *events = [model getEvent:0 event:event];
    for (totEvent* e in events) {
        //NSLog(@"Return from db: %@", [e toString]);        
    }
    [event release];
    
    [head release];
    [weight release];
    [height release];
}

// click on summary, return to home
- (void)SummaryClicked: (UIButton *)button {
    [homeRootController switchTo:kHomeViewEntryView withContextInfo:nil];
}

// display date selection
- (void)DatetimeClicked: (UIButton *)button {
    NSLog(@"%@", @"[basic][height] datetime clicked");
    [self showTimePicker];
}

- (void) navLeftButtonPressed:(id)sender{
    
    [homeRootController switchTo:kHomeViewEntryView withContextInfo:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"%@", @"[height] viewWillAppear");
//    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"weight_bg"]];
    [mSummary removeFromSuperview];
}

- (void)showTimePicker {
    //mClockBtn.hidden = YES;
    //[self.view setBackgroundColor:[UIColor blackColor]];
    //[self.view setAlpha:0.8f];
    [UIView beginAnimations:@"swipe" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5f];
    mClock.view.frame = CGRectMake((mWidth-mClock.mWidth)/2, mHeight-mClock.mHeight-45, mClock.mWidth, mClock.mHeight);
    [UIView commitAnimations];
    [mClock setCurrentTime];
}

- (void)hideTimePicker {
    //self.hidden = YES;
    
    //mClockBtn.hidden = NO;
    [self.view setBackgroundColor:[UIColor clearColor]];
    [UIView beginAnimations:@"swipe" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5f];
    mClock.view.frame = CGRectMake((mWidth-mClock.mWidth)/2, mHeight, mClock.mWidth, mClock.mHeight);
    [UIView commitAnimations];
}

#pragma mark - totTimerControllerDelegate
-(void)saveCurrentTime:(NSString*)time {
    NSLog(@"%@", time);
    [mDatetime setTitle:time forState:UIControlStateNormal];
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
    [mClock release];
    [mNavigationBar release];
    //[picker_head release];
    //[picker_height release];
    //[picker_weight release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
