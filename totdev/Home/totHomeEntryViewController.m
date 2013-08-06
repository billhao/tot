//
//  totHomeViewController.m
//  totdev
//
//  Created by Lixing Huang on 4/11/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "AppDelegate.h"
#import "totUITabBarController.h"
#import "totHomeEntryViewController.h"
#import "totHomeSleepingView.h"
#import "totLanguageInputViewController.h"
#import "totHomeRootController.h"
#import "totHomeDiaperView.h"
#import "../Utility/totImageView.h"
#import "../Activity/totActivityUtility.h"
#import "totEventName.h"
#import "totUtility.h"
#import "../Utility/totMediaLibrary.h"

@implementation totHomeEntryViewController

@synthesize homeRootController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        mediaLib = [[totMediaLibrary alloc] init];
//        mHomeSleepingView = [[totHomeSleepingView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
//        mHomeDiaperView = [[totHomeDiaperView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
//        mLanguageInputView = [[totLanguageInputViewController alloc] init];
//        
//        mMessage = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - View lifecycle
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setMultipleTouchEnabled:TRUE];
    
    // add photo view
    mPhotoView = [[totImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [self.view addSubview:mPhotoView];
    
    // add camera icon
    cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraBtn.frame = CGRectMake(260, 400, 60, 60);
    [cameraBtn setImage:[UIImage imageNamed:@"camera_button"] forState:UIControlStateNormal];
    [cameraBtn setImage:[UIImage imageNamed:@"camera_button_pressed"] forState:UIControlStateHighlighted];
    [cameraBtn addTarget:self action:@selector(cameraButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cameraBtn];
    
    // add the camera view to window
    [self.view addSubview:global.cameraView.view];

    // add menu icon
    menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(285, 10, 25, 25);
    [menuBtn setImage:[UIImage imageNamed:@"menu_button"] forState:UIControlStateNormal];
    [menuBtn setImage:[UIImage imageNamed:@"menu_button_pressed"] forState:UIControlStateHighlighted];
    [menuBtn addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menuBtn];
    
    // add activity
    [self createActivityView];
    
    // bind gesture events
    // left swipe
    UISwipeGestureRecognizer* leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGestureEvent:)];
    leftSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftSwipeRecognizer];
    [leftSwipeRecognizer release];
    
    // right swipe
    UISwipeGestureRecognizer* rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGestureEvent:)];
    rightSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipeRecognizer];
    [rightSwipeRecognizer release];

    // up swipe
    UISwipeGestureRecognizer* upSwipeRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGestureEvent:)];
    upSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:upSwipeRecognizer];
    [upSwipeRecognizer release];
    
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
    [self.view addGestureRecognizer:tapRecognizer];
    
    // show the most recent photo
    [self showPhoto:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [mPhotoView release];
    
    [mMessage release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)showPhoto:(MediaInfo*)mediaInfo {
    if( mediaInfo == nil ) {
        // show default photo
        [mPhotoView imageFilePath:@"home_default_photo"];
        return;
    }
    
    // show photo
    [mPhotoView imageFromFileContent:[totMediaLibrary getMediaPath:mediaInfo.filename]];
    
    [self showActivityTags];
}

- (void)showActivityTags {
    
}

- (void)createActivityView {
    activityView = [[UIView alloc] initWithFrame:CGRectMake(10, 300, 300, 150)];
    //UIImageView* bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activity_background"]];
    UIView* bg = [[UIView alloc] init];
    bg.frame = CGRectMake(0, 0, 300, 150);
    bg.backgroundColor = [UIColor grayColor];
    bg.alpha = 0.5;
    [activityView addSubview:bg];
    [bg release];
    
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 300, 150)];
    [activityView addSubview:scrollView];
    
    scrollView.pagingEnabled = FALSE;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;

    int margin_x = 10;
    int margin_x_left = 10;
    int margin_x_right = 10;
    int margin_y = 10;
    int margin_y_top = 10;
    int margin_y_bottom = 10;
    for (int i=0; i<14; i++) {
        UIButton* activityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        activityBtn.frame = CGRectMake(margin_x_left+i*(50+margin_x), margin_y_top, 50, 50);
        [activityBtn setImage:[UIImage imageNamed:@"camera_button"] forState:UIControlStateNormal];
        [activityBtn setImage:[UIImage imageNamed:@"camera_button_pressed"] forState:UIControlStateHighlighted];
        [activityBtn addTarget:self action:@selector(activityBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:activityBtn];
    }
    scrollView.contentSize = CGSizeMake(14*50 + 13*margin_x + margin_x_left + margin_x_right, 150);
    [scrollView release];
    
    activityView.hidden = TRUE;
    [self.view addSubview:activityView];
}

- (void)toggleActivity {
    activityView.hidden = !activityView.hidden;
    [self toggleCamera];
}

- (void)toggleCamera {
    cameraBtn.hidden = !cameraBtn.hidden;
}

#pragma mark - Event handler

// Respond to a swipe gesture
- (IBAction)swipeGestureEvent:(UISwipeGestureRecognizer *)swipeRecognizer {
    // Get the location of the gesture
    CGPoint location = [swipeRecognizer locationInView:self.view];
    NSLog(@"Swipe %d", swipeRecognizer.direction);
    if( swipeRecognizer.direction == UISwipeGestureRecognizerDirectionLeft ) {
        // show newer photo
        //[self showNextImage:TRUE]; // show newer image
        [mediaLib next];
        if( mediaLib.currentMediaInfo != nil) {
            [self showPhoto:mediaLib.currentMediaInfo];
            NSLog(@"photo event id: %ld", mediaLib.currentMediaInfo.eventID);
        }
    }
    else if( swipeRecognizer.direction == UISwipeGestureRecognizerDirectionRight ) {
        // show older photo
        //[self showNextImage:FALSE]; // show older image
        [mediaLib previous];
        if( mediaLib.currentMediaInfo != nil) {
            [self showPhoto:mediaLib.currentMediaInfo];
            NSLog(@"photo event id: %ld", mediaLib.currentMediaInfo.eventID);
        }
    }
    else if( swipeRecognizer.direction == UISwipeGestureRecognizerDirectionUp ) {
        // show timeline
    }
}

- (void)tapEvent:(UITapGestureRecognizer *)tapRecognizer {
    if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"tap %d", tapRecognizer.numberOfTouches);
        // show or hide activity
        [self toggleActivity];
    }
}

- (void)cameraButtonPressed: (id)sender {
    [global.cameraView setDelegate:self];
    [global.cameraView launchCamera:self];
}

- (void)menuButtonPressed: (id)sender {
}

#pragma mark - CameraViewDelegate
- (void) cameraView:(id)cameraView didFinishSavingMedia:(MediaInfo*)mediaInfo {
    NSLog(@"%@", mediaInfo.filename);
    currentPhoto = mediaInfo;
    
    [self showPhoto:currentPhoto];
    [self toggleActivity];
}


- (void) saveImage:(UIImage*)photo intoFile:(NSString*)filename {
    UIImage *resizedPhoto = [totActivityUtility imageWithImage:photo scaledToSize:CGSizeMake(320, 480)];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *imagePath = [documentDirectory stringByAppendingPathComponent:filename];
    NSData *data = UIImageJPEGRepresentation(resizedPhoto, 0.8);
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

- (void) cameraView:(id)cameraView didFinishSavingImageToAlbum:(UIImage*)photo {
    NSDate* today = [NSDate date];
    NSTimeInterval interval = [today timeIntervalSince1970];
    NSString *filename = [[NSString alloc] initWithFormat:@"%d.jpg", (int)interval];
    
    // add a record to db
    NSMutableDictionary* imageData = [[NSMutableDictionary alloc] init];
    [imageData setValue:filename forKey:@"filename"];
    [imageData setValue:[totEvent formatTime:today] forKey:@"added_at"];
    NSLog(@"first time %@", [totEvent formatTime:today]);
    NSString* activityName = [NSString stringWithFormat:ACTIVITY_PHOTO_REPLACABLE, filename];
    [global.model setItem:global.baby.babyID name:activityName value:imageData];


    NSLog(@"Photo filename: %@", filename);
    [self saveImage:photo intoFile:filename];
    
    [mMessage removeAllObjects];
    [mMessage setObject:filename forKey:@"storedImage"];
    [mMessage setObject:today forKey:@"added_at"];
    [filename release];
    
    // Switches to the next view.
    [homeRootController switchTo:kHomeActivityLabelController withContextInfo:mMessage];
}

- (void) cameraView:(id)cameraView didFinishSavingVideoToAlbum:(NSString*)videoPath {
    NSDate *today = [NSDate date];
    NSTimeInterval interval = [today timeIntervalSince1970];
    NSString *filename = [[NSString alloc] initWithFormat:@"%d.mov", (int)interval];

    NSLog(@"Video filename: %@", filename);
    [self saveVideo:videoPath intoFile:filename];
    
    [mMessage setObject:filename forKey:@"storedVideo"];
    [filename release];
}

- (void) cameraView:(id)cameraView didFinishSavingThumbnail:(UIImage*)thumbnail {
    NSString *videoFilename = [mMessage objectForKey:@"storedVideo"];
    if (!videoFilename) {
        printf("Must have video filename\n");
        exit(-1);
    }
    NSString *thumbFilename = [videoFilename stringByAppendingString:@".jpg"];
    [self saveImage:thumbnail intoFile:thumbFilename];  // save the thumbnail.
    [mMessage setObject:thumbFilename forKey:@"storedImage"];
    
    // Switches to the next view.
    [homeRootController switchTo:kHomeActivityLabelController withContextInfo:mMessage];
}



/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


@end
