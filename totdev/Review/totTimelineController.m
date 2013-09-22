//
//  totTimelineController.m
//  totdev
//
//  Created by Lixing Huang on 6/29/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import "totTimelineController.h"
#import "totTimeline.h"

@interface totTimelineController ()

@end

@implementation totTimelineController

@synthesize homeController;
@synthesize timeline_, mClock;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        mClock = nil;
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
    [timeline_ release];
    if( mClock ) [mClock release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    int navbar_height = [self createNavigationBar];
    
    totTimeline* timelineView = [[totTimeline alloc] initWithFrame:CGRectMake(0, navbar_height, 320, 460-navbar_height)];
    [timelineView addEmptyCard:SUMMARY];
    [timelineView loadCardsNumber:10 startFrom:0];
    [self.view addSubview:timelineView];
    self.timeline_ = timelineView;
    self.timeline_.controller = self;
    [timelineView release];

    [self addDateTimePicker];
}

- (void)loadEventsFrom:(int)start limit:(int)limit {
    [self.timeline_ loadCardsNumber:limit startFrom:start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Event handlers

- (void)homeButtonPressed:(id)sender {
    // go back to home page
    if (homeController)
        [homeController switchTo:kHomeViewEntryView withContextInfo:nil];
}


#pragma mark - Helper functions

// return the height of the nav bar
- (int)createNavigationBar {
    // create navigation bar
    UIView* navbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 42)];
    navbar.backgroundColor = [UIColor colorWithRed:116.0/255 green:184.0/255 blue:229.0/255 alpha:1.0];

    // create home button
    UIImage* homeImg = [UIImage imageNamed:@"timeline_home"];
    UIImage* homeImgPressed = [UIImage imageNamed:@"timeline_home_pressed"];
    UIButton* homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    homeBtn.frame = CGRectMake(277.5-12, 12-12, homeImg.size.width+24, homeImg.size.height+24); // make the button 24px wider and longer
    [homeBtn setImage:homeImg forState:UIControlStateNormal];
    [homeBtn setImage:homeImgPressed forState:UIControlStateHighlighted];
    [homeBtn addTarget:self action:@selector(homeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [navbar addSubview:homeBtn];
    
    [self.view addSubview:navbar];
    [navbar release];
    
    return navbar.frame.size.height;
}

#pragma mark - date time picker
- (void)addDateTimePicker {
    mClock = [[totTimerController alloc] init:self.view];
    CGRect f = self.view.frame;
    mClock.view.frame = CGRectMake((f.size.width-mClock.mWidth)/2, f.size.height, mClock.mWidth, mClock.mHeight);
    mClock.view.hidden = TRUE;
    [self.view addSubview:mClock.view];
}

- (void)showTimePicker:(totReviewEditCardView*)editCard mode:(DATETIMEPICKERMODE)mode datetime:(NSDate*)datetime {
    [mClock setMode:mode];
    mClock.datetime = datetime;
    [mClock setDelegate:editCard];
    [mClock setCurrentTime];
    mClock.view.hidden = FALSE;
    [mClock show];
}

- (void)hideTimePicker {
    [mClock dismiss];
    mClock.view.hidden = TRUE;
}

@end
