//
//  totCameraViewController.m
//  totdev
//
//  Created by Lixing Huang on 4/15/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totCameraViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MPMoviePlayerController.h>
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AVFoundation/AVTime.h>
#import <CoreMedia/CMTime.h>

@implementation totCameraViewController

@synthesize imagePicker;
@synthesize delegate;

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

//- (void)setDelegate:(id<CameraViewDelegate>)aDelegate {
//    if( self.delegate != aDelegate ) {
//        self.delegate = aDelegate;
//    }
//}

- (void)launchPhotoCamera {
    bPhotoCamera = YES;
    self.view.frame = CGRectMake(0, 0, 320, 460);
    if( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ) {
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString*)kUTTypeImage, nil];
        imagePicker.allowsEditing = NO;
        [self presentModalViewController:imagePicker animated:NO];
    }
}


- (void)launchVideoCamera {
    bPhotoCamera = NO;
    self.view.frame = CGRectMake(0, 0, 320, 460);
    if( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ) {
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString*)kUTTypeMovie, nil];
        imagePicker.allowsEditing = NO;
        [self presentModalViewController:imagePicker animated:NO];
    }
}


- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info {
    if( bPhotoCamera ) {
        UIImage *photo = (UIImage*)[info objectForKey:@"UIImagePickerControllerOriginalImage"];
                
        UIImageWriteToSavedPhotosAlbum(photo, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    } else {
        NSString *tempFilePath = [(NSURL*)[info valueForKey:UIImagePickerControllerMediaURL] absoluteString];
        tempFilePath = [[tempFilePath substringFromIndex:16] retain];
        
        // Check if the video file can be saved to camera roll.
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(tempFilePath)){
            // YES. Copy it to the camera roll.
            UISaveVideoAtPathToSavedPhotosAlbum(tempFilePath, self, @selector(video:didFinishSavingWithError:contextInfo:), tempFilePath);
        }
    }
    
    [picker dismissModalViewControllerAnimated:YES];
    [imagePicker release];
    self.view.frame = CGRectMake(0, 0, 0, 0);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker {
    [picker dismissModalViewControllerAnimated:YES];
    [imagePicker release];
    self.view.frame = CGRectMake(0, 0, 0, 0);
}


- (void)image: (UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo {
    if( [delegate respondsToSelector:@selector(cameraView:didFinishSavingImageToAlbum:)] ) {
        [delegate cameraView:self didFinishSavingImageToAlbum:image];
    }
}

- (void)video: (NSString*)videoPath didFinishSavingWithError:(NSError*)error contextInfo:(NSString*)contextInfo {
    if( [delegate respondsToSelector:@selector(cameraView:didFinishSavingVideoToAlbum:)] ) {
        [delegate cameraView:self didFinishSavingVideoToAlbum:videoPath];
    }
    
    NSURL *contentURL = [NSURL fileURLWithPath:videoPath];
    
    // generate thumbnail
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:contentURL options:nil];
    
    if( [asset tracksWithMediaCharacteristic:AVMediaTypeVideo] ) {
        AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        generator.appliesPreferredTrackTransform = TRUE;
        CMTime thumbnailTime = CMTimeMakeWithSeconds(0, 30);
        
        AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error) {
            if( result != AVAssetImageGeneratorSucceeded ) {
                NSLog(@"couldn't generate thumbnail, error:%@", error);
            } else {
                UIImage *thumbnail = [[UIImage alloc] initWithCGImage:im];
                
                UIImageWriteToSavedPhotosAlbum(thumbnail, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                
                if( [delegate respondsToSelector:@selector(cameraView:didFinishSavingThumbnail:)] ) {
                    [delegate cameraView:self didFinishSavingThumbnail:thumbnail];
                }
                
                [thumbnail release];
            }
            [generator release];
        };
        
        [generator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:thumbnailTime]] 
                                        completionHandler:handler];
    }
    
    [asset release];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [imagePicker release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
