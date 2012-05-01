//
//  totPhotoView.m
//  totdev
//
//  Created by Lixing Huang on 4/29/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totPhotoView.h"

@implementation totPhotoView

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    mScrollView.pagingEnabled = YES;
    mScrollView.showsVerticalScrollIndicator = NO;
    mScrollView.showsHorizontalScrollIndicator = YES;
    mScrollView.scrollsToTop = NO;
    mScrollView.bounces = YES;
    mScrollView.directionalLockEnabled = YES;
    mScrollView.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:mScrollView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [mScrollView release];
}

#pragma mark - totImageView delegate
- (void)touchesEndedDelegate:(NSSet *)touches withEvent:(UIEvent *)event {
    [UIView beginAnimations:@"swipe" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5f];
    
    self.view.frame = CGRectMake(0, -460, 320, 460);
    
    [UIView commitAnimations];
}

- (void)addImages:(NSMutableArray *)images startWith:(int)index {
    int num = [images count];
    mScrollView.frame = CGRectMake(0, 0, 320, 480);
    mScrollView.contentSize = CGSizeMake(320*num, 480);
    [mScrollView setContentOffset:CGPointMake(320*index, 0)];
    
    for( int i = 0; i < num; i++ ) {
        totImageView *img = [[totImageView alloc] initWithFrame:CGRectMake(320*i, 0, 320, 480)];
        [img setDelegate:self];
        [img setImage:[UIImage imageWithContentsOfFile:[images objectAtIndex:i]]];
        [mScrollView addSubview:img];
        [img release];
    }
    
    self.view.frame = CGRectMake(0, 0, 320, 460);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
