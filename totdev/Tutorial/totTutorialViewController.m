//
//  tutorialViewController.m
//  totdev
//
//  Created by Hao Wang on 3/28/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import "totTutorialViewController.h"
#import "../AppDelegate.h"
#import "../Model/totEventName.h"

@interface totTutorialViewController ()

@end

@implementation totTutorialViewController

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

    // tutorial
    tutorialScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    tutorialScrollView.pagingEnabled = true;
    tutorialScrollView.showsVerticalScrollIndicator = NO;
    tutorialScrollView.showsHorizontalScrollIndicator = NO;
    tutorialScrollView.delegate = self;
    
    image_cnt = 3;
    scrollCanceled = false;
    
    int x=0;
    int y=0;
    int width=tutorialScrollView.frame.size.width;
    int height=tutorialScrollView.frame.size.height;
    tutorialScrollView.contentSize = CGSizeMake(width * (image_cnt), height);
    for( int i=3; i<5; i++ ) {
        NSString* imgName = [NSString stringWithFormat:@"tutorial_%d", i];
        UIImageView* imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
        imgView.frame = CGRectMake(x, y, width, height);
        [tutorialScrollView addSubview:imgView];
        [imgView release];
        x += width;
    }
    [self.view addSubview:tutorialScrollView];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if( scrollCanceled ) return;
    
    NSLog(@"scrollViewDidScroll %f", scrollView.contentOffset.x);
    if( scrollView.contentOffset.x > scrollView.frame.size.width * (image_cnt - 1.5) ) {
        
        scrollCanceled = true;
        
        // now the tutorial has been shown, mark in db, never show it again
        [global.model addEvent:PREFERENCE_NO_BABY event:EVENT_TUTORIAL_SHOW datetime:[NSDate date] value:@"true"];
        
        // stop tutorial, go to main view
        [[self getAppDelegate] showFirstView];
    }
}

-(AppDelegate*) getAppDelegate {
    return [[UIApplication sharedApplication] delegate];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [tutorialScrollView release];
}

- (void)dealloc
{
    [tutorialScrollView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
