//
//  totCameraViewController.h
//  totdev
//
//  Created by Lixing Huang on 4/15/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "totMediaLibrary.h"
#import "AviaryPhotoEditor.h"

@protocol CameraViewDelegate <NSObject>

@optional
- (void) cameraView:(id)cameraView didFinishSavingImageToAlbum:(NSString*)imagePath image:(UIImage*)photo;
- (void) cameraView:(id)cameraView didFinishSavingVideoToAlbum:(NSString*)videoPath;
- (void) cameraView:(id)cameraView didFinishSavingThumbnail:(UIImage*)thumbnail;
- (void) cameraView:(id)cameraView didFinishSavingMedia:(MediaInfo*)mediaInfo;

@end

@interface totCameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, AviaryPhotoEditor> {
    UIImagePickerController *imagePicker;
    id <CameraViewDelegate> delegate;
    BOOL bPhotoCamera;
    
    UIViewController* hostVC; // temp
    
    AviaryPhotoEditor* editor;
    BOOL editing; // if true go to editor after select a image or take a picture
}

@property (nonatomic, retain) UIImagePickerController *imagePicker;
@property (nonatomic, retain) id<CameraViewDelegate> delegate;

// for photo editor
@property (nonatomic, assign) float cropWidth;
@property (nonatomic, assign) float cropHeight;

//- (void) setDelegate:(id<CameraViewDelegate>)aDelegate;
- (void) launchPhotoCamera;
- (void) launchVideoCamera;
- (void)launchCamera:(UIViewController*)vc withEditing:(BOOL)withEditing;
- (void)launchCamera:(UIViewController*)vc type:(UIImagePickerControllerSourceType)type withEditing:(BOOL)withEditing;

@end
