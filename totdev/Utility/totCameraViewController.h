//
//  totCameraViewController.h
//  totdev
//
//  Created by Lixing Huang on 4/15/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface totCameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    UIImagePickerController *imagePicker;
    
    BOOL bPhotoCamera;
}

@property (nonatomic, retain) UIImagePickerController *imagePicker;

- (void) launchPhotoCamera;
- (void) launchVideoCamera;

@end
