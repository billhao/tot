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
#import "AppDelegate.h"

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

- (void)launchCamera {
    self.view.frame = CGRectMake(0, 0, 320, 460);
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString*)kUTTypeMovie, (NSString*)kUTTypeImage, nil];
        imagePicker.allowsEditing = NO;
        [self presentModalViewController:imagePicker animated:NO];
    }
    else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString*)kUTTypeMovie, (NSString*)kUTTypeImage, nil];
        imagePicker.allowsEditing = NO;
        [self presentModalViewController:imagePicker animated:NO];
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info {
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString*)kUTTypeImage]) {
        UIImage *photo = (UIImage*)[info objectForKey:@"UIImagePickerControllerOriginalImage"];

        // only save the image to camera roll if it is from the camera
        // do not save an image from photo library or camera roll
        if( picker.sourceType == UIImagePickerControllerSourceTypeCamera ) {
            UIImageWriteToSavedPhotosAlbum(photo, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
        
        // generate a filename for the image
        NSDate* today = [NSDate date];
        NSTimeInterval interval = [today timeIntervalSince1970];
        NSString *filename = [[NSString alloc] initWithFormat:@"%d.jpg", (int)interval];

        // Save the image file and add it to cache.
        NSString* filepath = [self saveImage:photo intoFile:filename];
        AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
        [appdelegate.mCache addImage:photo WithKey:filename];
        
        if( [delegate respondsToSelector:@selector(cameraView:didFinishSavingImageToAlbum:image:)] ) {
            [delegate cameraView:self didFinishSavingImageToAlbum:filepath image:photo];
        }
    }
    else if ([mediaType isEqualToString:(NSString*)kUTTypeMovie]) {
        NSString *tempFilePath = [(NSURL*)[info valueForKey:UIImagePickerControllerMediaURL] absoluteString];
        tempFilePath = [tempFilePath substringFromIndex:16];
        // Check if the video file can be saved to camera roll.
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(tempFilePath)){
            // YES. Copy it to the camera roll.
            UISaveVideoAtPathToSavedPhotosAlbum(tempFilePath, self, @selector(video:didFinishSavingWithError:contextInfo:), tempFilePath);
        }
    }
    [self hideCamera];
}

- (void)hideCamera {
    [imagePicker dismissModalViewControllerAnimated:YES];
    [imagePicker release];
    self.view.frame = CGRectMake(0, 0, 0, 0);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker {
    [self hideCamera];
}


- (void)image: (UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo {
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
        
        CGImageRef im = [generator copyCGImageAtTime:thumbnailTime actualTime:nil error:nil];
        UIImage *thumbnail = [[UIImage alloc] initWithCGImage:im];
        if( [delegate respondsToSelector:@selector(cameraView:didFinishSavingThumbnail:)] ) {
            [delegate cameraView:self didFinishSavingThumbnail:thumbnail];
        }
        [self hideCamera];
        [thumbnail release];
        CGImageRelease(im);
        [generator release];
        
        /*
        AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error) {
            if( result != AVAssetImageGeneratorSucceeded ) {
                NSLog(@"couldn't generate thumbnail, error:%@", error);
            } else {
                UIImage *thumbnail = [[UIImage alloc] initWithCGImage:im];
                if( [delegate respondsToSelector:@selector(cameraView:didFinishSavingThumbnail:)] ) {
                    [delegate cameraView:self didFinishSavingThumbnail:thumbnail];
                }
                [self hideCamera];
                [thumbnail release];
            }
            [generator release];
        };
        [generator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:thumbnailTime]] 
                                        completionHandler:handler];
        */
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

- (NSString*) saveImage:(UIImage*)photo intoFile:(NSString*)filename {
//    UIImage *resizedPhoto = [totActivityUtility imageWithImage:photo scaledToSize:CGSizeMake(320, 480)];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *imagePath = [documentDirectory stringByAppendingPathComponent:filename];
    NSData *data = UIImageJPEGRepresentation(photo, 1.0);
    [data writeToFile:imagePath atomically:NO];
    return imagePath;
}

@end
