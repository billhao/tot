//
//  AFSDKDemoViewController.m
//  AviaryDemo-iOS
//
//  Created by Michael Vitrano on 1/23/13.
//  Copyright (c) 2013 Aviary. All rights reserved.
//

#import "AFSDKDemoViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import "AFPhotoEditorController.h"
#import "AFPhotoEditorCustomization.h"
#import "AFOpenGLManager.h"

#define kAFSDKDemoImageViewInset 10.0f
#define kAFSDKDemoBorderAspectRatioPortrait 3.0f/4.0f
#define kAFSDKDemoBorderAspectRatioLandscape 4.0f/3.0f

@interface AFSDKDemoViewController () < UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate, AviaryPhotoEditor>

@property (strong, nonatomic) UIImageView * imagePreviewView;
@property (nonatomic, strong) UIView * borderView;
@property (nonatomic, strong) UIPopoverController * popover;
@property (nonatomic, assign) BOOL shouldReleasePopover;

@property (nonatomic, strong) ALAssetsLibrary * assetLibrary;
@property (nonatomic, strong) NSMutableArray * sessions;

@end

@implementation AFSDKDemoViewController

#pragma mark - View Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    editor = [[AviaryPhotoEditor alloc] init:self];
    editor.delegate = self;

    // Allocate Sessions Array
    NSMutableArray * sessions = [NSMutableArray new];
    [self setSessions:sessions];
    
    [self setupView];
}

- (void)viewWillLayoutSubviews
{
    [self layoutImageViews];
}


#pragma Photo Editor Delegate Methods

// This is called when the user taps "Done" in the photo editor. 
- (void) photoEditor:(AFPhotoEditorController *)editor finishedWithImage:(UIImage *)image
{
    [[self imagePreviewView] setImage:image];
    [[self imagePreviewView] setContentMode:UIViewContentModeScaleAspectFit];

}

#pragma mark - Photo Editor Customization

- (void) setPhotoEditorCustomizationOptions
{
//    // Set Tool Order
//    NSArray * toolOrder = @[kAFEffects, kAFFocus, kAFFrames, kAFStickers, kAFEnhance, kAFOrientation, kAFCrop, kAFAdjustments, kAFSplash, kAFDraw, kAFText, kAFRedeye, kAFWhiten, kAFBlemish, kAFMeme];
//    [AFPhotoEditorCustomization setToolOrder:toolOrder];
//    
//    // Set Custom Crop Sizes
//    [AFPhotoEditorCustomization setCropToolOriginalEnabled:NO];
//    [AFPhotoEditorCustomization setCropToolCustomEnabled:YES];
//    NSDictionary * fourBySix = @{kAFCropPresetHeight : @(4.0f), kAFCropPresetWidth : @(6.0f)};
//    NSDictionary * fiveBySeven = @{kAFCropPresetHeight : @(5.0f), kAFCropPresetWidth : @(7.0f)};
//    NSDictionary * square = @{kAFCropPresetName: @"Square", kAFCropPresetHeight : @(1.0f), kAFCropPresetWidth : @(1.0f)};
//    [AFPhotoEditorCustomization setCropToolPresets:@[fourBySix, fiveBySeven, square]];
//    
//    // Set Supported Orientations
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        NSArray * supportedOrientations = @[@(UIInterfaceOrientationPortrait), @(UIInterfaceOrientationPortraitUpsideDown), @(UIInterfaceOrientationLandscapeLeft), @(UIInterfaceOrientationLandscapeRight)];
//        [AFPhotoEditorCustomization setSupportedIpadOrientations:supportedOrientations];
//    }
}

#pragma mark - UIImagePicker Delegate

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSURL * assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:^{
            [editor launchEditorWithAssetURL:assetURL];
        }];
    }
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Interface Actions


- (IBAction)choosePhoto:(id)sender
{
    if ([self hasValidAPIKey]) {
        UIImagePickerController * imagePicker = [UIImagePickerController new];
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        [imagePicker setDelegate:self];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }
}


#pragma mark - Private Helper Methods

- (BOOL) hasValidAPIKey
{
    NSString * key = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Aviary-API-Key"];
    if ([key isEqualToString:@"<YOUR_API_KEY>"]) {
        [[[UIAlertView alloc] initWithTitle:@"Oops!" message:@"You forgot to add your API key!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return NO;
    }
    return YES;
}

- (void)setupView
{
    // Set View Background Color
    UIColor * backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    [[self view] setBackgroundColor:backgroundColor];
    
    // Set Up Image View and Border
    UIView * borderView = [UIView new];
    UIColor * borderColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"border.png"]];
    [borderView setBackgroundColor:borderColor];
    
    CALayer * borderLayer = [borderView layer];
    [borderLayer setCornerRadius:10.0f];
    [borderLayer setBorderColor:[[UIColor blackColor] CGColor]];
    [borderLayer setBorderWidth:2.0f];
    [borderLayer setMasksToBounds:YES];
    [self setBorderView:borderView];
    [[self view] addSubview:borderView];
    
    UIImageView * previewView = [UIImageView new];
    [previewView setContentMode:UIViewContentModeCenter];
    [previewView setImage:[UIImage imageNamed:@"splash.png"]];
    [borderView addSubview:previewView];
    [self setImagePreviewView:previewView];
    
    // Customize UI Components
    UIImage * blueButton = [[UIImage imageNamed:@"blue_button.png"] stretchableImageWithLeftCapWidth:7.0f topCapHeight:0.0f];
    UIImage * blueButtonActive = [[UIImage imageNamed:@"blue_button_pressed.png"] stretchableImageWithLeftCapWidth:7.0f topCapHeight:0.0f];
    [[self choosePhotoButton] setBackgroundImage:blueButton forState:UIControlStateNormal];
    [[self choosePhotoButton] setBackgroundImage:blueButtonActive forState:UIControlStateHighlighted];
    
    UIImage * darkButton = [[UIImage imageNamed:@"dark_button.png"] stretchableImageWithLeftCapWidth:7.0f topCapHeight:0.0f];
    UIImage * darkButtonActive = [[UIImage imageNamed:@"dark_button_pressed.png"] stretchableImageWithLeftCapWidth:7.0f topCapHeight:0.0f];
    [[self editSampleButton] setBackgroundImage:darkButton forState:UIControlStateNormal];
    [[self editSampleButton] setBackgroundImage:darkButtonActive forState:UIControlStateHighlighted];
}

- (void) layoutImageViews
{
    CGRect bounds = [[self view] bounds];
    CGRect logoFrame = [[self logoImageView] frame];
    CGRect choosePhotoFrame = [[self choosePhotoButton] frame];
    
    CGFloat aspectRatio = UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]) ? kAFSDKDemoBorderAspectRatioPortrait : kAFSDKDemoBorderAspectRatioLandscape;
    CGFloat height = CGRectGetMinY(choosePhotoFrame) - CGRectGetMaxY(logoFrame) - 2.0f * kAFSDKDemoImageViewInset;
    CGFloat width = aspectRatio * height;
    CGRect imageFrame = CGRectMake((CGRectGetWidth(bounds) - width) / 2.0, CGRectGetMaxY(logoFrame) + kAFSDKDemoImageViewInset, width, height);
    
    [[self borderView] setFrame:imageFrame];
    
    CGRect borderBounds = [[self borderView] bounds];
    [[self imagePreviewView] setFrame:CGRectInset(borderBounds, 10.0f, 10.0f)];
}

@end
