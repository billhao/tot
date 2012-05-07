//
//  totHomeHeightViewController.m
//  totdev
//
//  Created by Hao on 5/5/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totHomeHeightViewController.h"
#import "AppDelegate.h"
#import "totEventName.h"
#import "totEvent.h"

@implementation totHomeHeightViewController

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
    NSLog(@"%@", @"view did load");
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // height scroll bar
    picker_height = [[STHorizontalPicker alloc] initWithFrame:mHeightPlaceHolder.frame];
    picker_height.name = @"picker_height";
    [picker_height setMinimumValue:0.0];
    [picker_height setMaximumValue:6.0];
    [picker_height setSteps:60];
    [picker_height setDelegate:self];
    [picker_height setValue:2.3];
    [self.view addSubview:picker_height];
    [picker_height release];
    
    // weight scroll bar
    picker_weight = [[STHorizontalPicker alloc] initWithFrame:mWeightPlaceHolder.frame];
    picker_weight.name = @"picker_weight";
    [picker_weight setMinimumValue:0.0];
    [picker_weight setMaximumValue:6.0];
    [picker_weight setSteps:60];
    [picker_weight setDelegate:self];
    [picker_weight setValue:2.3];
    [self.view addSubview:picker_weight];
    [picker_weight release];
    
    // head circumference scroll bar
    picker_head = [[STHorizontalPicker alloc] initWithFrame:mHeadPlaceHolder.frame];
    picker_head.name = @"picker_head";
    [picker_head setMinimumValue:0.0];
    [picker_head setMaximumValue:6.0];
    [picker_head setSteps:60];
    [picker_head setDelegate:self];
    [picker_head setValue:2.3];
    [self.view addSubview:picker_head];
    [picker_head release];

    // set up events
    [mOKButton addTarget:self action:@selector(OKButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mDatetime addTarget:self action:@selector(DatetimeClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mDatetimeImage addTarget:self action:@selector(DatetimeClicked:) forControlEvents:UIControlEventTouchUpInside];

    // set up date picker
    mWidth = self.view.frame.size.width;
    mHeight= self.view.frame.size.height;
    
    mClock = [[totTimerController alloc] init];
    mClock.view.frame = CGRectMake((mWidth-mClock.mWidth)/2, mHeight, mClock.mWidth, mClock.mHeight);
    [mClock setDelegate:self];
    [self.view addSubview:mClock.view];
}

- (void)pickerView:(STHorizontalPicker *)picker didSelectValue:(CGFloat)value{
    NSLog(@"didSelectValue %f", value);
}


// save all the numbers to db
- (void)OKButtonClicked: (UIButton *)button {
    NSLog(@"%@", @"[basic][height] ok button clicked");
    int baby_id = 0;
    NSDate* date = [NSDate date];
    NSString* height = [[NSString alloc] initWithFormat:@"%.2f", picker_height.value];
    NSString* weight = [[NSString alloc] initWithFormat:@"%.2f", picker_weight.value];
    NSString* head   = [[NSString alloc] initWithFormat:@"%.2f", picker_head.value];
    [model addEvent:baby_id event:EVENT_BASIC_HEIGHT datetime:date value:height];
    [model addEvent:baby_id event:EVENT_BASIC_WEIGHT datetime:date value:weight];
    [model addEvent:baby_id event:EVENT_BASIC_HEAD datetime:date value:head];
    
    NSString* summary = [NSString stringWithFormat:@"%@\nHeight %@\nWeight %@\nHead Circumference %@", @"today", height, weight, head ];
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
}

// display date selection
- (void)DatetimeClicked: (UIButton *)button {
    NSLog(@"%@", @"[basic][height] datetime clicked");
    [self showTimePicker];
}


- (void)showTimePicker {
    //mClockBtn.hidden = YES;
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self.view setAlpha:0.8f];
    [UIView beginAnimations:@"swipe" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5f];
    mClock.view.frame = CGRectMake((mWidth-mClock.mWidth)/2, mHeight-mClock.mHeight-80, mClock.mWidth, mClock.mHeight);
    [UIView commitAnimations];
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
