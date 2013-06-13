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

@implementation totHomeEntryViewController

@synthesize homeRootController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        mHomeSleepingView = [[totHomeSleepingView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        mHomeDiaperView = [[totHomeDiaperView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        mLanguageInputView = [[totLanguageInputViewController alloc] init];
        
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

#pragma mark - CameraViewDelegate
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


#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void)buttonPressed: (id)sender {
    UIButton *btn = (UIButton*)sender;
    int tag = btn.tag;
    switch (tag) {
        case kBasicSleep:
            [mHomeSleepingView trigger];
            break;
        case kBasicLanguage:
            [mLanguageInputView Display];
            break;
        case kBasicFood:
            [homeRootController switchTo:kHomeViewFeedView withContextInfo:nil];
            break;
        case kBasicHeight:
            // tell the height view which measurement is on the top
            [homeRootController switchTo:kHomeViewHeightView withContextInfo:0];
            break;
        case kBasicWeight:
            // tell the height view which measurement is on the top
            [homeRootController switchTo:kHomeViewHeightView withContextInfo:(NSMutableDictionary*)1];
            break;
        case kBasicHead:
            // tell the height view which measurement is on the top
            [homeRootController switchTo:kHomeViewHeightView withContextInfo:(NSMutableDictionary*)2];
            break;
        case kBasicDiaper:
            // [homeRootController switchTo:kHomeViewDiaperView withContextInfo:nil];
            [mHomeDiaperView showDiaperView];
            break;
        case kBasicHealth:
        {
            // Starts the camera.
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            [appDelegate.mainTabController.cameraView setDelegate:self];
            [appDelegate.mainTabController.cameraView launchCamera];
            
            /**
            // Use the proper one for debugging.
            NSMutableDictionary* info = [[NSMutableDictionary alloc] init];
            // Put necessary information into the info.
            [homeRootController switchTo:kHomeActivityLabelController withContextInfo:info];  // label
            //[homeRootController switchTo:kHomeActivityBrowseController withContextInfo:info];  // browse photo by photo
            //[homeRootController switchTo:kHomeAlbumBrowseController withContextInfo:info];  // browse the whole album
            [info release];
             */

            /*
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Medical record will be available in the next version." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
             */
            break;
        }
        default:
            break;
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // create background
    totImageView *background = [[totImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    [background imageFilePath:@"home_background.png"];
    [self.view addSubview:background];
    [background release];

    // create buttons
    int buttonW[8] = {117, 120, 102, 67, 112, 85, 90, 65};
    int buttonH[8] = {127, 97, 275, 87, 90, 87, 92, 75};
    int buttonX[8] = {7, 200, 5, 240, 112, 225, 225, 132};
    int buttonY[8] = {22, 45, 150, 142, 246, 230, 318, 85};
    const char *buttonName[8] = {
        "language.png", 
        "sleep.png", 
        "height.png", 
        "food.png", 
        "diaper.png", 
        "health.png", 
        "weight.png", 
        "head.png"
    };
    for( int i = 0; i <= 7; i++ ) {
        UIButton *function = [UIButton buttonWithType:UIButtonTypeCustom];
        function.frame = CGRectMake(buttonX[i], buttonY[i], buttonW[i], buttonH[i]);
        function.tag = i;
        [function setImage:[UIImage imageNamed:[NSString stringWithUTF8String:buttonName[i]]] forState:UIControlStateNormal];
        [function addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:function];
    }
    
    // create subview
    mHomeSleepingView.mParentView = self.view;
    [self.view addSubview:mHomeSleepingView];
    [self.view addSubview:mLanguageInputView.view];
    [self.view addSubview:mHomeDiaperView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [mHomeSleepingView release];
    [mLanguageInputView release];
    [mHomeDiaperView release];
    
    [mMessage release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
