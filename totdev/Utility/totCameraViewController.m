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
#import "totEventName.h"
#import "totActivityUtility.h"
#import "totUtility.h"

@implementation totCameraViewController

@synthesize imagePicker, delegate, cropWidth, cropHeight;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc {
    [editor release];
    editor = nil;
    
    [super dealloc];
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

// if editing is true go to editor after select a image or take a picture
- (void)launchCamera:(UIViewController*)vc withEditing:(BOOL)withEditing {
    [self launchCamera:vc type:UIImagePickerControllerSourceTypeCamera withEditing:withEditing];
}

- (void)launchCamera:(UIViewController*)vc type:(UIImagePickerControllerSourceType)type withEditing:(BOOL)withEditing {
    // TODO release imagePicker first?
    
    editing = withEditing;
    hostVC = vc;
    self.view.frame = CGRectMake(0, 0, 320, 460);
    if ( (type == UIImagePickerControllerSourceTypeCamera) &&
         [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString*)kUTTypeMovie, (NSString*)kUTTypeImage, nil];
        imagePicker.allowsEditing = NO;
        
        // create overlay button for go to photo library
        UIImage* photoLibImg = [UIImage imageNamed:@"photo_lib"];
        CGRect f = CGRectMake(imagePicker.view.bounds.size.width-photoLibImg.size.width-10, imagePicker.view.bounds.size.height-photoLibImg.size.height-10-54, photoLibImg.size.width, photoLibImg.size.height);
        UIButton* overlay = [UIButton buttonWithType:UIButtonTypeCustom];
        overlay.frame = f;
        overlay.alpha = 0.5;
        [overlay setImage:photoLibImg forState:UIControlStateNormal];
        [overlay addTarget:self action:@selector(photoLibButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        imagePicker.cameraOverlayView = overlay;
        [vc presentViewController:imagePicker animated:TRUE completion:nil];
    }
    else if ( //(type == UIImagePickerControllerSourceTypePhotoLibrary) &&
              [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString*)kUTTypeMovie, (NSString*)kUTTypeImage, nil];
        imagePicker.allowsEditing = NO;
        [vc presentViewController:imagePicker animated:TRUE completion:nil];
    }
}


- (void)photoLibButtonPressed:(id)sender {
    NSLog(@"switch to photo library");
    [imagePicker dismissViewControllerAnimated:FALSE completion:^{
        [imagePicker release];
        [self launchCamera:hostVC type:UIImagePickerControllerSourceTypePhotoLibrary withEditing:TRUE];
    }];
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info {

    // save original
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString*)kUTTypeImage]) {
        // only save the image to camera roll if it is from the camera
        // do not save an image from photo library or camera roll
        if( picker.sourceType == UIImagePickerControllerSourceTypeCamera ) {
            UIImage *photo = (UIImage*)[info objectForKey:@"UIImagePickerControllerOriginalImage"];
            UIImageWriteToSavedPhotosAlbum(photo, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
    }
    else if ([mediaType isEqualToString:(NSString*)kUTTypeMovie]) {
        if( picker.sourceType == UIImagePickerControllerSourceTypeCamera ) {
            // TODO check where video is saved (should be in media dir)
            NSString* filepath = [(NSURL*)[info valueForKey:UIImagePickerControllerMediaURL] absoluteString];
            filepath = [filepath substringFromIndex:16];
            // Check if the video file can be saved to camera roll.
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(filepath)){
                // YES. Copy it to the camera roll.
                UISaveVideoAtPathToSavedPhotosAlbum(filepath, self, @selector(video:didFinishSavingWithError:contextInfo:), filepath);
            }
        }
    }
    else
        return;
    
    [imagePicker dismissViewControllerAnimated:FALSE completion:^{
        if ([mediaType isEqualToString:(NSString*)kUTTypeImage]) {
            NSURL* assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
            if( editing ) {
                // call photo editor
                if(!editor) editor = [[AviaryPhotoEditor alloc] init:nil];
                editor.vc = hostVC;
                editor.delegate = self;
                editor.cropWidth = cropWidth;
                editor.cropHeight = cropHeight;
                [editor launchEditorWithAssetURL:assetURL];
            }
            else {
                UIImage *img = (UIImage*)[info objectForKey:@"UIImagePickerControllerOriginalImage"];
                img = [editor editingResImageForAssetURL:assetURL];
                [self saveImage:img];
            }
        }
        else if ([mediaType isEqualToString:(NSString*)kUTTypeMovie]) {
            // do nothing right now
        }
    }];
    [self hideCamera];
}

// This is called when the user taps "Done" in the photo editor.
- (void) photoEditor:(AFPhotoEditorController *)editor finishedWithImage:(UIImage *)image {
    [self saveImage:image];
}

- (void)saveImage:(UIImage*)image {
    MediaInfo* mediaInfo = [[[MediaInfo alloc] init] autorelease];
    
    // generate a filename for the image
    NSDate* today = [NSDate date];
    NSTimeInterval interval = [today timeIntervalSince1970];
    NSString *filename = [NSString stringWithFormat:@"%d.jpg", (int)interval];
    mediaInfo.filename = [NSString stringWithString:filename];
    
    // Save the image file and add it to cache.
    NSString* filepath = [self saveImage:image intoFile:filename];
    
//    // TODO this may use a lot of memory. commented out for now.
//    // re-enable this when cache can release memory on memory warning
//    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
//    [appdelegate.mCache addImage:image WithKey:filename];
//    
//    if( [delegate respondsToSelector:@selector(cameraView:didFinishSavingImageToAlbum:image:)] ) {
//        [delegate cameraView:self didFinishSavingImageToAlbum:filepath image:image];
//    }
//    [filename release];
    
    mediaInfo.dateTimeTaken = today;
    [totMediaLibrary addPhoto:mediaInfo];
    
    if( [delegate respondsToSelector:@selector(cameraView:didFinishSavingMedia:)] ) {
        [delegate cameraView:self didFinishSavingMedia:mediaInfo];
    }
    
}

- (void)hideCamera {
    [imagePicker release];
    imagePicker = nil;
    self.view.frame = CGRectMake(0, 0, 0, 0);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker {
    [imagePicker dismissViewControllerAnimated:TRUE completion:nil];
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
    CGSize screen = [totUtility getScreenSize];
    float ratio = screen.width/screen.height;
    CGSize psize = photo.size;
    float pratio = psize.width/psize.height;
    if( pratio > ratio ) {
        // photo is wider than screen, scale by width
        psize = CGSizeMake(screen.width, psize.height*(screen.width/psize.width));
    }
    else {
        // photo is taller than screen, scale by height
        psize = CGSizeMake(psize.width*(screen.height/psize.height), screen.height);
    }
    
    int scale = [UIScreen mainScreen].scale;
    psize = CGSizeMake(psize.width*scale, psize.height*scale);
    
    UIImage *resizedPhoto = [totActivityUtility imageWithImage:photo scaledToSize:psize];
    NSString *imagePath = [totMediaLibrary getMediaPath:filename];
    NSData *data = UIImageJPEGRepresentation(resizedPhoto, 1.0);
    [data writeToFile:imagePath atomically:NO];
    return imagePath;
    
    // TODO need to save original image as well
}

@end
