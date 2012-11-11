//
//  totActivityViewController.m
//  totdev
//
//  Created by Lixing Huang on 4/15/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "AppDelegate.h"
#import "totActivityViewController.h"
#import "totUITabBarController.h"
#import "totActivityUtility.h"
#import "totActivityEntryViewController.h"
#import "totActivityConst.h"
#import "../Utility/totSliderView.h"
#import "../Utility/totImageView.h"
#import "../Utility/totAlbumViewController.h"

@implementation totActivityViewController

@synthesize activityRootController;
@synthesize mSliderView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        mMessage = [[NSMutableDictionary alloc] init];
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        mTotModel = [appDelegate getDataModel];
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
- (void) printFileSize:(NSString*) path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *fileAttr = [fileManager attributesOfItemAtPath:path error:nil];
    if( fileAttr ) {
        NSString *fileSize = [fileAttr objectForKey:@"NSFileSize"];
        NSLog(@"%@\n", fileSize);
    }
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

#pragma totCameraViewController delegate
- (void) cameraView:(id)cameraView didFinishSavingImageToAlbum:(UIImage*)photo {
    NSDate* today = [NSDate date];
    NSTimeInterval interval = [today timeIntervalSince1970];
    NSString *filename = [[NSString alloc] initWithFormat:@"%d.jpg", (int)interval];

    // Save the image file and add it to cache.
    [self saveImage:photo intoFile:filename];
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate.mCache addImage:photo WithKey:filename];
    
    [mMessage removeAllObjects];
    [mMessage setObject:filename forKey:@"storedImage"];
    [mMessage setObject:[NSNumber numberWithInt:mCurrentActivityID] forKey:@"activity"];
    [filename release];
    
    [activityRootController switchTo:kActivityInfoView withContextInfo:mMessage];
}

- (void) cameraView:(id)cameraView didFinishSavingVideoToAlbum:(NSString*)videoPath {
    NSDate *today = [NSDate date];
    NSTimeInterval interval = [today timeIntervalSince1970];
    NSString *filename = [[NSString alloc] initWithFormat:@"%d.mov", (int)interval];
    [self saveVideo:videoPath intoFile:filename];
    [mMessage setObject:filename forKey:@"storedVideo"];
    [filename release];
}

- (void) cameraView:(id)cameraView didFinishSavingThumbnail:(UIImage*)thumbnail {
    NSString *videoFilename = [mMessage objectForKey:@"storedVideo"];
    NSString *thumbFilename = [videoFilename stringByAppendingString:@".jpg"];
    [self saveImage:thumbnail intoFile:thumbFilename];  // save the thumbnail.
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate.mCache addImage:thumbnail WithKey:thumbFilename];
    [mMessage setObject:thumbFilename forKey:@"storedImage"];
    [mMessage setObject:[NSNumber numberWithInt:mCurrentActivityID] forKey:@"activity"];
    
    [activityRootController switchTo:kActivityInfoView withContextInfo:mMessage];
}

#pragma totSliderView delegate
- (void)buttonPressed: (id)sender {
    UIButton *btn = (UIButton*)sender;
    int tag = [btn tag] - 1;
    
    NSString * memb_str = [NSString stringWithUTF8String: ACTIVITY_MEMBERS[mCurrentActivityID]];
    NSArray  * members  = [memb_str componentsSeparatedByString:@","];

    int currentBabyId = [totActivityUtility getCurrentBabyID];
    NSString * query = nil;
    if ([members count] < 2) {  // split empty string => [""]
        query = [NSString stringWithFormat:@"%s", ACTIVITY_NAMES[mCurrentActivityID]];
    } else {
        query = [NSString stringWithFormat:@"%s/%s", ACTIVITY_NAMES[mCurrentActivityID], [[members objectAtIndex:tag] UTF8String]];
    }
    NSMutableArray * query_result = [mTotModel getEvent:currentBabyId event:query];
    int result_size = [query_result count];
    if (result_size == 0)
        return;
      
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for( int i = 0; i < result_size; i++ ) {
        [totActivityUtility extractFromEvent:[query_result objectAtIndex:i] intoImageArray:images];
    }
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.mainTabController.albumView MakeFullView:images];
    [images release];
}

// launch camera
- (void) launchCamera:(id)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.mainTabController.cameraView setDelegate:self];
    [appDelegate.mainTabController.cameraView launchPhotoCamera];
}

- (void) launchVideo:(id)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.mainTabController.cameraView setDelegate:self];
    [appDelegate.mainTabController.cameraView launchVideoCamera];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateInterface];
}

- (void)receiveMessage: (NSMutableDictionary*)message {
    mState = [NSDictionary dictionaryWithDictionary:message];
}

- (void)updateInterface {
    // mState contains two objects:
    // images => MSMutableArray, each element is a path to the image
    // margin => MSMutableArray, each element is a yes or no
    [mSliderView cleanScrollView];
    
    NSMutableArray * activityMemberImages = [[NSMutableArray alloc] init];
    NSMutableArray * activityMemberMargin = [[NSMutableArray alloc] init];
    NSMutableArray * isIcon = [[NSMutableArray alloc] init];
    
    mCurrentActivityID  = [[mState objectForKey:@"activity"] intValue];
    NSMutableArray * images  = [mState objectForKey:@"images"];
    NSMutableArray * margin  = [mState objectForKey:@"margin"];
    
    switch ( mCurrentActivityID ) {
        case kActivityEmotion:
            [mBackground setImage:[UIImage imageNamed:@"emotion_bg.png"]];
            break;
        case kActivityMotorSkill:
            [mBackground setImage:[UIImage imageNamed:@"motor_skill_bg.png"]];
            break;
        case kActivityGesture:
            [mBackground setImage:[UIImage imageNamed:@"gesture_bg.png"]];
            break;
        default:  // for now, use gesture background as default background
            [mBackground setImage:[UIImage imageNamed:@"gesture_bg.png"]];
            break;
    }
    
    for( int i = 0; i < [images count]; i++ ) {
        NSArray * tokens = [[images objectAtIndex:i] componentsSeparatedByString:@"."];
        NSString * ext = [tokens lastObject];
        
        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        UIImage *cachedImg = [delegate.mCache getImageWithKey:[images objectAtIndex:i]];
        
        if( [ext isEqualToString:@"jpg"] ) {
            if( cachedImg )
                [activityMemberImages addObject:cachedImg];
            else
                [activityMemberImages addObject:[UIImage imageWithContentsOfFile:[images objectAtIndex:i]]];
            [isIcon addObject:[NSNumber numberWithBool:NO]];
        } else {
            [activityMemberImages addObject:[UIImage imageNamed:[images objectAtIndex:i]]];
            [isIcon addObject:[NSNumber numberWithBool:YES]];
        }
        [activityMemberMargin addObject:[margin objectAtIndex:i]];
    }
    
    [mSliderView setContentArray:activityMemberImages];
    [mSliderView setMarginArray:activityMemberMargin];
    [mSliderView setIsIconArray:isIcon];
    [mSliderView getWithPositionMemoryIdentifier:@"activityView"];
    
    [activityMemberImages release];
    [activityMemberMargin release];
    [isIcon release];
}

#pragma mark - totNavigationBar delegate
- (void)navLeftButtonPressed:(id)sender {
    [activityRootController switchTo:kActivityEntryView];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // create background
    mBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [self.view addSubview:mBackground];
    
    // create navigation bar
    mNavigationBar = [[totNavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [mNavigationBar setDelegate:self];
    [mNavigationBar setLeftButtonImg:@"return.png"];
    [mNavigationBar setBackgroundColor:[UIColor whiteColor]];
    [mNavigationBar setAlpha:0.5];
    [self.view addSubview:mNavigationBar];
    
    // create the slider view
    mSliderView = [[totSliderView alloc] initWithFrame:CGRectMake(25, 78, 270, 300)];
    [mSliderView setDelegate:self];
    [mSliderView enablePageControlOnBottom];
    [self.view addSubview:mSliderView];

    // create camera buttons
    UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraButton.frame = CGRectMake(74, 316, 90, 60);
    [cameraButton setImage:[UIImage imageNamed:@"camera.png"] forState:UIControlStateNormal];
    [cameraButton addTarget:self action:@selector(launchCamera:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cameraButton];
    
    UIButton *videoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    videoButton.frame = CGRectMake(160, 316, 90, 60);
    [videoButton setImage:[UIImage imageNamed:@"video.png"] forState:UIControlStateNormal];
    [videoButton addTarget:self action:@selector(launchVideo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:videoButton];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [mMessage release];
    [mBackground release];
    [mSliderView release];
    [mNavigationBar release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
