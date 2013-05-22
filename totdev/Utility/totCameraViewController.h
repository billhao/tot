//
//  totCameraViewController.h
//  totdev
//
//  Created by Lixing Huang on 4/15/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CameraViewDelegate <NSObject>

@optional
- (void) cameraView:(id)cameraView didFinishSavingImageToAlbum:(UIImage*)photo;
- (void) cameraView:(id)cameraView didFinishSavingVideoToAlbum:(NSString*)videoPath;
- (void) cameraView:(id)cameraView didFinishSavingThumbnail:(UIImage*)thumbnail;

@end

@interface totCameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    UIImagePickerController *imagePicker;
    id <CameraViewDelegate> delegate;
    BOOL bPhotoCamera;
}

@property (nonatomic, retain) UIImagePickerController *imagePicker;
@property (nonatomic, retain) id<CameraViewDelegate> delegate;

//- (void) setDelegate:(id<CameraViewDelegate>)aDelegate;
- (void) launchPhotoCamera;
- (void) launchVideoCamera;
- (void) launchCamera;

@end
