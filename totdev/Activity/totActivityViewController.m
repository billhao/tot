//
//  totActivityViewController.m
//  totdev
//
//  Created by Lixing Huang on 4/15/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totActivityViewController.h"
#import "totUITabBarController.h"
#import "../Utility/totSliderView.h"
#import "../Utility/totImageView.h"
#import "AppDelegate.h"

@implementation totActivityViewController

@synthesize activityRootController;
@synthesize mSliderView;

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

// utility functions
- (void) saveImage:(UIImage*)photo intoFile:(NSString*)filename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *imagePath = [documentDirectory stringByAppendingPathComponent:filename];
    NSData *data = UIImageJPEGRepresentation(photo, 0.8);
    [data writeToFile:imagePath atomically:NO];
}

- (void) saveVideo:(NSString*)videoPath intoFile:(NSString*)filename {
    NSURL *contentURL = [NSURL fileURLWithPath:videoPath];
    NSData *videoData = [NSData dataWithContentsOfURL:contentURL];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *path = [documentDirectory stringByAppendingPathComponent:filename];
    [videoData writeToFile:path atomically:NO];
}

#pragma totCameraViewController delegate
- (void) cameraView:(id)cameraView didFinishSavingImageToAlbum:(UIImage*)photo {
    [activityRootController switchTo:kActivityInfoView];
}

- (void) cameraView:(id)cameraView didFinishSavingVideoToAlbum:(NSString*)videoPath {
    
}

- (void) cameraView:(id)cameraView didFinishSavingThumbnail:(UIImage*)thumbnail {

}

- (void) launchCamera {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.rootController.cameraView setDelegate:self];
    [appDelegate.rootController.cameraView launchPhotoCamera];
}

- (void) launchVideo {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.rootController.cameraView setDelegate:self];
    [appDelegate.rootController.cameraView launchVideoCamera];
}

- (void)receiveMessage: (NSMutableDictionary*)message {
    // message contains two objects:
    // images => MSMutableArray, each element is a path to the image
    // margin => MSMutableArray, each element is a yes or no
    if( mActivityMemberImages ) {
        [mActivityMemberImages release];
    }
    mActivityMemberImages = nil;
    mActivityMemberImages = [[NSMutableArray alloc] init];

    if( mActivityMemberMargin ) {
        [mActivityMemberMargin release];
    }
    mActivityMemberMargin = nil;
    mActivityMemberMargin = [[NSMutableArray alloc] init];
    
    NSMutableArray *images = [message objectForKey:@"images"];
    NSMutableArray *margin = [message objectForKey:@"margin"];
    for( int i = 0; i < [images count]; i++ ) {
        [mActivityMemberImages addObject:[UIImage imageNamed:[images objectAtIndex:i]]];
        [mActivityMemberMargin addObject:[margin objectAtIndex:i]];
    }
    
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated {
    // create slider view
    totSliderView *sv = [[totSliderView alloc] init];
    self.mSliderView = sv;
    [mSliderView setContentArray:mActivityMemberImages]; 
    [mSliderView setMarginArray:mActivityMemberMargin];
    [mSliderView setPosition:10];
    [mSliderView enablePageControlOnBottom];
    [self.view addSubview:[mSliderView getWithPositionMemoryIdentifier:@"activityView"]];
    [sv release];
    
    // create buttons
    mCameraButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 320, 75, 40)];
    mVideoButton = [[UIButton alloc] initWithFrame:CGRectMake(160, 320, 75, 40)];
    
    [mCameraButton setImage:[UIImage imageNamed:@"camera.png"] forState:UIControlStateNormal];
    [mCameraButton addTarget:self action:@selector(launchCamera:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mCameraButton];
    
    [mVideoButton setImage:[UIImage imageNamed:@"video.png"] forState:UIControlStateNormal];
    [mVideoButton addTarget:self action:@selector(launchVideo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mVideoButton];
}

- (void)viewWillDisappear:(BOOL)animated {
    // Remove title and return botton from myTitleBarView
    for(UIView *subview in [self.view subviews]) {
        [subview removeFromSuperview];
    }
    
    [mSliderView release];
    [mVideoButton release];
    [mCameraButton release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [mSliderView release];
    
    [mActivityMemberImages release];
    [mActivityMemberMargin release];
    
    mActivityMemberImages = nil;
    mActivityMemberMargin = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




@end
