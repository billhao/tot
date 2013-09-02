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
    
    totTimeline* timelineView = [[totTimeline alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];

    [timelineView addEmptyCard:SUMMARY];
    [timelineView addEmptyCard:FEEDING];
    [timelineView addEmptyCard:HEIGHT];
    [timelineView addEmptyCard:DIAPER];
    [timelineView addEmptyCard:LANGUAGE];
    [timelineView addEmptyCard:SLEEP];
    
    [timelineView addEmptyCard:SUMMARY];
    [timelineView addEmptyCard:SUMMARY];
    [timelineView addEmptyCard:SUMMARY];
    [timelineView addEmptyCard:SUMMARY];
    
    [self.view addSubview:timelineView];
    [timelineView release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
