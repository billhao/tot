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
@synthesize timeline_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    int navbar_height = [self createNavigationBar];
    
    totTimeline* timelineView = [[totTimeline alloc] initWithFrame:CGRectMake(0, navbar_height, 320, 460-navbar_height)];
    [timelineView addEmptyCard:SUMMARY];
    
    // test load cards from db.
    [timelineView loadCardsNumber:10 startFrom:0];
    
    [self.view addSubview:timelineView];
    self.timeline_ = timelineView;
    self.timeline_.controller = self;
    [timelineView release];
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
    [homeController switchTo:kHomeViewEntryView withContextInfo:nil];
}


#pragma mark - Helper functions

// return the height of the nav bar
- (int)createNavigationBar {
    // create navigation bar
    //UIImage* navbar_img = [UIImage imageNamed:@"timeline_navbar"];
    UIView* navbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 42)];
    navbar.backgroundColor = [UIColor colorWithRed:116.0/255 green:184.0/255 blue:229.0/255 alpha:1.0];

    // create home button
    UIImage* homeImg = [UIImage imageNamed:@"timeline_home"];
    UIImage* homeImgPressed = [UIImage imageNamed:@"timeline_home_pressed"];
    UIButton* homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    homeBtn.frame = CGRectMake(277.5, 12, homeImg.size.width, homeImg.size.height);
    [homeBtn setImage:homeImg forState:UIControlStateNormal];
    [homeBtn setImage:homeImgPressed forState:UIControlStateHighlighted];
    [homeBtn addTarget:self action:@selector(homeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [navbar addSubview:homeBtn];
    
    [self.view addSubview:navbar];
    [navbar release];
    
    return navbar.frame.size.height;
}

@end
