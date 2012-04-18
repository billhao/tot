//
//  totActivityEntryViewController.m
//  totdev
//
//  Created by Lixing Huang on 4/15/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totActivityEntryViewController.h"
#import "totImageView.h"
#import "AppDelegate.h"
#import "totUITabBarController.h"

@implementation totActivityEntryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        const char *names [] = {
            "vision_attention.png", 
            "eye_contact.png",
            "mirror_test.png",
            "imitation.png",
            "gesture.png",
            "emotion.png",
            "chew.png",
            "motor_skill.png"
        };
        
        mActivityNames = [[NSMutableArray alloc] init];
        for( int i=0; i<8; i++ ) {
            [mActivityNames addObject:[NSString stringWithUTF8String:names[i]]];
        }
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

// delegates of CameraView
- (void) cameraView:(id)cameraView didFinishSavingImageToAlbum:(UIImage*)photo {
    printf("Save image to album\n");
}

- (void) cameraView:(id)cameraView didFinishSavingVideoToAlbum:(NSString*)videoPath {
    printf("Save video to album\n");
}

- (void) cameraView:(id)cameraView didFinishSavingThumbnail:(UIImage*)thumbnail {
    printf("Get the thumbnail\n");
}

- (void) launchCamera {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.rootController.cameraView setDelegate:self];
//    [appDelegate.rootController.cameraView launchPhotoCamera];
    [appDelegate.rootController.cameraView launchVideoCamera];
}

- (void)buttonPressed: (id)sender {
    UIButton *btn = (UIButton*)sender;
    int tag = [btn tag];
    switch (tag) {
        case kActivityVisionAttention:
            printf("VisionAttention\n");
            [self launchCamera];
            break;
        case kActivityEyeContact:
            printf("EyeContact\n");
            break;
        case kActivityMirrorTest:
            printf("MirroTest\n");
            break;
        case kActivityImitation:
            printf("Imitation\n");
            break;
        case kActivityGesture:
            printf("Gesture\n");
            break;
        case kActivityEmotion:
            printf("Emotion\n");
            break;
        case kActivityChew:
            printf("Chew\n");
            break;
        case kActivityMotorSkill:
            printf("MotorSkill\n");
            break;
        default:
            break;
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    totImageView *background = [[totImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 411)];
    [background imageFilePath:@"challenge_background.png"];
    [self.view addSubview:background];
    [background release];
    
    // create eight buttons
    int x[8] = {10, 122, 235, 10, 235, 10, 122, 235};
    int y[8] = {33, 33, 33, 158, 158, 283, 283, 283};
    int w    = 75;
    int h    = 75;
    
    for( int i=0; i<8; i++ ) {
        UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        imageButton.frame = CGRectMake(x[i], y[i], w, h);
        imageButton.tag = i;
        [imageButton setImage:[UIImage imageNamed:[mActivityNames objectAtIndex:i]] 
                     forState:UIControlStateNormal];
        [imageButton addTarget:self action:@selector(buttonPressed:) 
              forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:imageButton];
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [mActivityNames release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
