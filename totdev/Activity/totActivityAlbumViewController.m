//
//  totActivityAlbumViewController.m
//  totdev
//
//  Created by Lixing Huang on 4/15/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "AppDelegate.h"
#import "totUITabBarController.h"
#import "totActivityAlbumViewController.h"
#import "../Utility/totPhotoView.h"
#import "../Utility/totImageView.h"
#import "../Utility/moviePlayerViewController.h"


#define PAGE_HEIGHT 420

@implementation totActivityAlbumViewController

@synthesize activityRootController;

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

    mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, PAGE_HEIGHT)];
    mScrollView.pagingEnabled = YES;
    mScrollView.showsVerticalScrollIndicator = YES;
    mScrollView.showsHorizontalScrollIndicator = NO;
    mScrollView.scrollsToTop = NO;
    mScrollView.bounces = NO;
    mScrollView.directionalLockEnabled = YES;
    [self.view addSubview:mScrollView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [mScrollView release];
}

- (void) cleanScrollView {
    for(UIView *subview in [mScrollView subviews]) {
        [subview removeFromSuperview];
    }
}

- (int) CheckFileType: (NSString *)path
{
    NSArray *arr = [path componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"."]];
    NSUInteger count = [arr count];
    NSString *fileType = [arr objectAtIndex:(count-2)];
    if ([fileType isEqualToString: @"mp4"] == YES) {
        return 1;
    } else if ([fileType isEqualToString: @"m4v"] == YES) {
        return 1;
    } else {
        return 0;
    }
}

- (void)receiveMessage: (NSMutableDictionary*)message {
    NSMutableArray *images = [message objectForKey:@"images"];
    
    if( mPaths )
        [mPaths release];
    mPaths = [[NSMutableArray alloc] initWithArray:images];
    
    [self cleanScrollView];
    
    int number = [images count];
    int numOfViews = (number/12) + ((number%12==0) ? 0 : 1);
    for( int i = 0; i < numOfViews; i++ ) {
        for( int j = 0; j < 12; j++ ) {
            if( number == i*12+j ) break;

            float xOffset = 5 + 105 * (j % 3);
            float yOffset = i * PAGE_HEIGHT + 2.5 + 105 * (j / 3);
            
            UIImage *anImage = [UIImage imageWithContentsOfFile:[images objectAtIndex:(i*12+j)]];
            if( [self CheckFileType:[images objectAtIndex:(i*12+j)]] == 1 ) {
                UIImageView *movieIcon = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset, yOffset, 100, 20)];
                [movieIcon setImage:[UIImage imageNamed:@"movie_thumbnail-01.png"]];
                [mScrollView addSubview:movieIcon];
                [movieIcon release];
            }
            
            UIButton *imgButton = [[UIButton alloc] initWithFrame:CGRectMake(xOffset, yOffset, 100, 100)];
            [imgButton setImage:anImage forState:UIControlStateNormal];
            [imgButton setTag:(i*12+j)];
            [imgButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [mScrollView addSubview:imgButton];
            [imgButton release];
        }
    }
}

- (void)buttonPressed:(UIButton*)sender {
    int tag = [sender tag];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.mainTabController.photoView addImages:mPaths startWith:tag];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
