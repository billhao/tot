//
//  totHomeDiaperViewController.m
//  totdev
//
//  Created by Lixing Huang on 5/19/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totHomeDiaperViewController.h"
#import "../AppDelegate.h"
#import "../Model/totModel.h"
#import "../Model/totEventName.h"

@implementation totHomeDiaperViewController

@synthesize mHomeRootController;

static NSString *DIAPER_WET      = @"wet";
static NSString *DIAPER_SOLID    = @"solid";
static NSString *DIAPER_WETSOLID = @"wetsolid";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void)showTimePicker {
    [UIView beginAnimations:@"showPicker" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5f];
        mClock.view.frame = CGRectMake(
                                       (self.view.frame.size.width-mClock.mWidth)/2, 
                                       mClock.mHeight-100,
                                       mClock.mWidth, 
                                       mClock.mHeight);
    [UIView commitAnimations];
}

- (void)hideTimePicker {
    [UIView beginAnimations:@"hidePicker" context:nil];
	[UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5f];
        mClock.view.frame = CGRectMake(
                                       (self.view.frame.size.width-mClock.mWidth)/2, 
                                       self.view.frame.size.height,
                                       mClock.mWidth, mClock.mHeight);
    [UIView commitAnimations];
}

- (void)okButtonPressed:(id)sender {
    // get current year, month, day
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // extract hour and minute values
    NSArray *tokens = [[dateFormatter stringFromDate:now] componentsSeparatedByString:@" "];
    NSArray *comps1 = [[tokens objectAtIndex:0] componentsSeparatedByString:@"-"];
    NSArray *comps2 = [[tokens objectAtIndex:1] componentsSeparatedByString:@":"];
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    int _year   = [[f numberFromString:[comps1 objectAtIndex:0]] intValue];
    int _month  = [[f numberFromString:[comps1 objectAtIndex:1]] intValue];
    int _day    = [[f numberFromString:[comps1 objectAtIndex:2]] intValue];
    int _hour   = [[f numberFromString:[comps2 objectAtIndex:0]] intValue];
    int _minute = [[f numberFromString:[comps2 objectAtIndex:1]] intValue];
    int _second = [[f numberFromString:[comps2 objectAtIndex:2]] intValue];
    
    [dateFormatter release];
    [f release];
    
    // get hour and minute
    _hour = mClock.mCurrentHourIdx+1;
    _minute = mClock.mCurrentMinuteIdx;
    int _ap = mClock.mCurrentAmPm;
    if ( _ap == 1 && _hour != 12 )
        _hour += 12;
    
    char format_time_str[256] = {0};
    sprintf(format_time_str, "%04d-%02d-%02d %02d:%02d:%02d", _year, _month, _day, _hour, _minute, _second);
    printf("Diaper: %s\n", format_time_str);
    
    totModel *model = global.model;
    [model addEvent:global.baby.babyID
              event:EVENT_BASIC_DIAPER 
     datetimeString:[NSString stringWithUTF8String:format_time_str] 
              value:DIAPER_WET];
    
    [mHomeRootController switchTo:kHomeViewEntryView withContextInfo:nil];
}

- (void)clkButtonPressed:(id)sender {
    [mClock setCurrentTime];
    [self showTimePicker];
}

#pragma mark - totTimerController delegate
-(void)saveCurrentTime:(NSString*)time {
    int h = mClock.mCurrentHourIdx+1;
    int m = mClock.mCurrentMinuteIdx;
    int ap= mClock.mCurrentAmPm;
    if ( ap == 1 && h != 12 )   h += 12;
    
    char now[256] = {0};
    sprintf(now, "%02d:%02d", h, m);
    currentTimeLabel.text = [NSString stringWithUTF8String:now];
    [self hideTimePicker];
}

-(void)cancelCurrentTime {
    [self hideTimePicker];
}

#pragma mark - totNavigationBar delegate
- (void)navLeftButtonPressed:(id)sender {
    [mHomeRootController switchTo:kHomeViewEntryView withContextInfo:nil];
}

- (void)navRightButtonPressed:(id)sender {
    
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mClock = [[totTimerController alloc] init];
    mClock.view.frame = CGRectMake(
                                   (self.view.frame.size.width-mClock.mWidth)/2, 
                                   self.view.frame.size.height+20, 
                                   mClock.mWidth, 
                                   mClock.mHeight);
    [mClock setMode:kTime];
    [mClock setDelegate:self];
    [self.view addSubview:mClock.view];
    
    mNavigationBar= [[totNavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [mNavigationBar setLeftButtonTitle:@"Back"];
    [mNavigationBar setRightButtonTitle:@"History"];
    [mNavigationBar setNavigationBarTitle:@"Diaper Change" andColor:[UIColor blackColor]];
    [mNavigationBar setBackgroundColor:[UIColor yellowColor]];
    [mNavigationBar setDelegate:self];
    [self.view addSubview:mNavigationBar];
    
    wetDiaper = [[UILabel alloc] initWithFrame:CGRectMake(120, 100, 100, 40)];
    wetDiaper.text = @"Wet";
    wetDiaper.backgroundColor = [UIColor greenColor];
    [self.view insertSubview:wetDiaper belowSubview:mClock.view];
    
    solidDiaper = [[UILabel alloc] initWithFrame:CGRectMake(120, 160, 100, 40)];
    solidDiaper.text = @"Solid";    
    solidDiaper.backgroundColor = [UIColor greenColor];
    [self.view insertSubview:solidDiaper belowSubview:mClock.view];
    
    wetSolidDiaper = [[UILabel alloc] initWithFrame:CGRectMake(120, 220, 100, 40)];
    wetSolidDiaper.text = @"Wet & Solid";
    wetSolidDiaper.backgroundColor = [UIColor greenColor];
    [self.view insertSubview:wetSolidDiaper belowSubview:mClock.view];
    
    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    okButton.frame = CGRectMake(140, 300, 40, 30);
    [okButton setTitle:@"OK" forState:UIControlStateNormal];
    [okButton addTarget:self action:@selector(okButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:okButton belowSubview:mClock.view];
    
    UIButton *clkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clkButton.frame = CGRectMake(20, 55, 25, 25);
    [clkButton setImage:[UIImage imageNamed:@"clock.png"] forState:UIControlStateNormal];
    [clkButton addTarget:self action:@selector(clkButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clkButton];
    
    currentTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 55, 250, 40)];
    [self.view addSubview:currentTimeLabel];
}

- (void)viewWillAppear:(BOOL)animated {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    currentTimeLabel.text = [dateFormatter stringFromDate:[NSDate date]];
    [dateFormatter release];
    
    [mClock setCurrentTime];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [mNavigationBar release];
    [wetDiaper release];
    [solidDiaper release];
    [wetSolidDiaper release];
    [currentTimeLabel release];
    [mClock release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
