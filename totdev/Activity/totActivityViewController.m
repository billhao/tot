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
@synthesize mCurrentActivityID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        mMessage = [[NSMutableDictionary alloc] init];
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
    NSDate* today = [NSDate date];
    NSTimeInterval interval = [today timeIntervalSince1970];
    NSString *filename = [[NSString alloc] initWithFormat:@"%d.jpg", (int)interval];

    [self saveImage:photo intoFile:filename];
    if( [mMessage objectForKey:@"storedVideo"] )
        [mMessage removeObjectForKey:@"storedVideo"];
    [mMessage setObject:filename forKey:@"storedImage"];
    [mMessage setObject:self.mCurrentActivityID forKey:@"activity"];
    
    [activityRootController switchTo:kActivityInfoView withContextInfo:mMessage];
}

- (void) cameraView:(id)cameraView didFinishSavingVideoToAlbum:(NSString*)videoPath {
    NSDate *today = [NSDate date];
    NSTimeInterval interval = [today timeIntervalSince1970];
    NSString *filename = [[NSString alloc] initWithFormat:@"%d.mov", (int)interval];
    [self saveVideo:videoPath intoFile:filename];
    
    [mMessage setObject:filename forKey:@"storedVideo"];
}

- (void) cameraView:(id)cameraView didFinishSavingThumbnail:(UIImage*)thumbnail {
    NSString *videoFilename = [mMessage objectForKey:@"storedVideo"];
    NSString *thumbFilename = [videoFilename stringByAppendingString:@".jpg"];
    
    [self saveImage:thumbnail intoFile:thumbFilename];
    [mMessage setObject:thumbFilename forKey:@"storedImage"];
    [mMessage setObject:self.mCurrentActivityID forKey:@"activity"];
    
    [activityRootController switchTo:kActivityInfoView withContextInfo:mMessage];
}

- (void) launchCamera:(id)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.rootController.cameraView setDelegate:self];
    [appDelegate.rootController.cameraView launchPhotoCamera];
}

- (void) launchVideo:(id)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.rootController.cameraView setDelegate:self];
    [appDelegate.rootController.cameraView launchVideoCamera];
}

- (void)receiveMessage: (NSMutableDictionary*)message {
    // message contains two objects:
    // images => MSMutableArray, each element is a path to the image
    // margin => MSMutableArray, each element is a yes or no

    [mSliderView cleanScrollView];
    
    NSMutableArray *activityMemberImages = [[NSMutableArray alloc] init];
    NSMutableArray *activityMemberMargin = [[NSMutableArray alloc] init];
    
    self.mCurrentActivityID = [message objectForKey:@"activity"];
    NSMutableArray *images = [message objectForKey:@"images"];
    NSMutableArray *margin = [message objectForKey:@"margin"];
    for( int i = 0; i < [images count]; i++ ) {
        [activityMemberImages addObject:[UIImage imageNamed:[images objectAtIndex:i]]];
        [activityMemberMargin addObject:[margin objectAtIndex:i]];
    }
    [mSliderView setContentArray:activityMemberImages];
    [mSliderView setMarginArray:activityMemberMargin];
    [mSliderView getWithPositionMemoryIdentifier:@"activityView"];
    
    [activityMemberImages release];
    [activityMemberMargin release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    mSliderView = [[totSliderView alloc] initWithFrame:CGRectMake(0, 10, 320, 260)];
    [mSliderView enablePageControlOnBottom];
    [self.view addSubview:mSliderView];

    // create camera buttons
    UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cameraButton.frame = CGRectMake(60, 300, 60, 40);
    [cameraButton setImage:[UIImage imageNamed:@"camera.png"] forState:UIControlStateNormal];
    [cameraButton addTarget:self action:@selector(launchCamera:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cameraButton];
    
    UIButton *videoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    videoButton.frame = CGRectMake(180, 300, 60, 40);
    [videoButton setImage:[UIImage imageNamed:@"video.png"] forState:UIControlStateNormal];
    [videoButton addTarget:self action:@selector(launchVideo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:videoButton];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [mSliderView release];
    [mCurrentActivityID release];
    [mMessage release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




@end
