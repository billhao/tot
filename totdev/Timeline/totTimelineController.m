//
//  totTimelineController.m
//  totdev
//
//  Created by Lixing Huang on 6/29/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import "totTimelineController.h"
#import "totTimeline.h"
#import "totSleepCard.h"
#import "AppDelegate.h"

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
    
    CGRect f = self.view.bounds;
    totTimeline* timelineView = [[totTimeline alloc] initWithFrame:CGRectMake(0, navbar_height, f.size.width, f.size.height-navbar_height)];
    timelineView.summaryCard = [timelineView addEmptyCard:SUMMARY];
    
    // check for sleep here, if it was a "start" then continue sleep
    totEvent* sleepEvent = [totSleepEditCard wasSleeping];
    if(sleepEvent != nil ) {
        // add the sleep card and continue sleep
        totReviewCardView* sleepCard = [timelineView addEmptyCard:SLEEP];
        [(totSleepEditCard*)sleepCard.mEditView beginSleep:sleepEvent.datetime];
    }
    
    // load new cards
    [timelineView loadCardsNumber:10];

    [self.view addSubview:timelineView];
    self.timeline_ = timelineView;
    self.timeline_.controller = self;
    [timelineView release];

    [self addDateTimePicker];
}

- (void)viewWillAppear:(BOOL)animated {
    // update existing cards

    // add any new cards (probably photo cards)
    [self.timeline_ refreshNewCards];
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

- (void)settingButtonPressed:(id)sender {
    if (homeController)
        [homeController switchTo:kSetting withContextInfo:nil];
}

#pragma mark - Helper functions

// return the height of the nav bar
- (int)createNavigationBar {
    float statusBarHeight = 0;
    if( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") )
        statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    // create navigation bar
    int navbarHeight = 36;
    UIView* navbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, navbarHeight+statusBarHeight)];
    navbar.backgroundColor = [UIColor colorWithRed:116.0/255 green:184.0/255 blue:229.0/255 alpha:1.0];

    // create home button
    // assume home button and setting have the same size
    UIImage* homeImg = [UIImage imageNamed:@"timeline_home"];
//    UIImage* homeImgPressed = [UIImage imageNamed:@"timeline_home_pressed"];
    UIButton* homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    float width = homeImg.size.width+24;
    float height = homeImg.size.height+24;
    homeBtn.frame = CGRectMake(9, (navbarHeight-height)/2+statusBarHeight, width, height); // make the button 24px wider and longer
    [homeBtn setImage:homeImg forState:UIControlStateNormal];
    [homeBtn setImage:homeImg forState:UIControlStateHighlighted];
    [homeBtn addTarget:self action:@selector(homeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [navbar addSubview:homeBtn];
//    [totUtility enableBorder:homeBtn];

    // setting button
    UIImage* settingImg = [UIImage imageNamed:@"settings"];
    UIImage* settingImgPressed = [UIImage imageNamed:@"settings"];
    UIButton* settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    settingBtn.frame = CGRectMake(self.view.frame.size.width-9-width, (navbarHeight-height)/2+statusBarHeight, width, height); // make the button 24px wider and longer
    [settingBtn setImage:settingImg forState:UIControlStateNormal];
    [settingBtn setImage:settingImgPressed forState:UIControlStateHighlighted];
    [settingBtn addTarget:self action:@selector(settingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [navbar addSubview:settingBtn];
//    [totUtility enableBorder:settingBtn];
    

    // title for timeline
    UILabel* title = [[UILabel alloc] init];
    title.font = [UIFont fontWithName:@"Helvetica" size:24];
    title.text = @"Timeline";
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor whiteColor];
    [title sizeToFit];
    CGRect frame = self.view.frame;
    CGRect f = title.frame;
    f.origin.x = (frame.size.width-f.size.width)/2;
    f.origin.y = (navbarHeight-f.size.height)/2 + statusBarHeight;
    title.frame = f;
    [navbar addSubview:title];
//    [totUtility enableBorder:title];
//    [totUtility enableBorder:homeBtn];
    
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
