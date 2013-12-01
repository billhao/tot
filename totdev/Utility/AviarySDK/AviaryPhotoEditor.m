#import "AviaryPhotoEditor.h"
#import <QuartzCore/QuartzCore.h>
#import "AFPhotoEditorCustomization.h"
#import "AFOpenGLManager.h"

#define kAFSDKDemoImageViewInset 10.0f
#define kAFSDKDemoBorderAspectRatioPortrait 3.0f/4.0f
#define kAFSDKDemoBorderAspectRatioLandscape 4.0f/3.0f


@implementation AviaryPhotoEditor

@synthesize assetLibrary, vc, cropWidth, cropHeight;

#pragma mark - View Controller Methods

-(id)init:(UIViewController*)viewController {
    self = [super init];
    if( self ) {
        self.vc = viewController;
        
        // Allocate Asset Library
        assetLibrary = [[ALAssetsLibrary alloc] init];
        
        // Start the Aviary Editor OpenGL Load
        // TODO is this really needed for tot?
//        [AFOpenGLManager beginOpenGLLoad];
    }
    return self;
}

-(void)dealloc {
    [vc release];
    vc = nil;
    
    [assetLibrary release];
    assetLibrary = nil;
    
    [super dealloc];
}

#pragma mark - Photo Editor Launch Methods

- (void) launchEditorWithAssetURL:(NSURL *)assetURL {
    [[self assetLibrary] assetForURL:assetURL resultBlock:^(ALAsset *asset) {
        if (asset){
            [self launchEditorWithAsset:asset];
        }
    } failureBlock:^(NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enable access to your device's photos." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}

- (void) launchEditorWithAsset:(ALAsset *)asset
{
    UIImage * editingResImage = [self editingResImageForAsset:asset];
    UIImage * highResImage = [self highResImageForAsset:asset];
    
    [self launchPhotoEditorWithImage:editingResImage highResolutionImage:highResImage];
}

- (void) launchPhotoEditorWithImage:(UIImage *)editingResImage highResolutionImage:(UIImage *)highResImage
{    
    // Initialize the photo editor and set its delegate
    AFPhotoEditorController * photoEditor = [[AFPhotoEditorController alloc] initWithImage:highResImage];
    [photoEditor setDelegate:self];
    
    // Customize the editor's apperance. The customization options really only need to be set once in this case since they are never changing, so we used dispatch once here.
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self setPhotoEditorCustomizationOptions];
    });
    
    [self setCropAspectRatio:(float)highResImage.size.width/highResImage.size.height];
    
    // If a high res image is passed, create the high res context with the image and the photo editor.
    if (highResImage) {
        [self setupHighResContextForPhotoEditor:photoEditor withImage:highResImage];
    }
    
    // Present the photo editor.
    [vc presentViewController:photoEditor animated:YES completion:nil];

    [photoEditor release]; // this was causing the GC raster data memory leak
}

#pragma Photo Editor Delegate Methods

// This is called when the user taps "Done" in the photo editor. 
- (void) photoEditor:(AFPhotoEditorController *)editor finishedWithImage:(UIImage *)image
{
    [vc dismissViewControllerAnimated:YES completion:nil];
    
    if([[self delegate] respondsToSelector:@selector(photoEditor:finishedWithImage:)]) {
        [[self delegate] photoEditor:editor finishedWithImage:image];
    }
}

// This is called when the user taps "Cancel" in the photo editor.
- (void) photoEditorCanceled:(AFPhotoEditorController *)editor
{
    [vc dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Photo Editor Customization

- (void) setPhotoEditorCustomizationOptions
{
    // Set Tool Order
    NSArray * toolOrder = @[kAFCrop, kAFEffects];
    [AFPhotoEditorCustomization setToolOrder:toolOrder];
    
    [AFPhotoEditorCustomization setCropToolInvertEnabled:FALSE];
    [AFPhotoEditorCustomization setCropToolCellWidth:120];
    
    // Set Supported Orientations
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        NSArray * supportedOrientations = @[@(UIInterfaceOrientationPortrait), @(UIInterfaceOrientationPortraitUpsideDown), @(UIInterfaceOrientationLandscapeLeft), @(UIInterfaceOrientationLandscapeRight)];
        [AFPhotoEditorCustomization setSupportedIpadOrientations:supportedOrientations];
    }
}

// imageRation = width/height of the image
- (void)setCropAspectRatio:(float)imageRatio {
    // Set Custom Crop Sizes
    if( cropWidth>0 && cropHeight>0 ) {
        [AFPhotoEditorCustomization setCropToolCustomEnabled:NO];
        [AFPhotoEditorCustomization setCropToolOriginalEnabled:NO];
        
        float w = cropWidth;
        float h = cropHeight;

        NSDictionary * customCrop = @{kAFCropPresetName: [NSString stringWithFormat:@"%d x %d", (int)cropWidth, (int)cropHeight], kAFCropPresetHeight : @(h), kAFCropPresetWidth : @(w)};
        [AFPhotoEditorCustomization setCropToolPresets:@[customCrop]];
    }
    else {
        [AFPhotoEditorCustomization setCropToolCustomEnabled:YES];
    }
}

#pragma mark - Helper Methods

- (UIImage*)editingResImageForAssetURL:(NSURL*)assetURL {
    __block UIImage* img = nil;
    [[self assetLibrary] assetForURL:assetURL resultBlock:^(ALAsset *asset) {
        if (asset){
            img = [self editingResImageForAsset:asset];
        }
    } failureBlock:^(NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enable access to your device's photos." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
    return img;
}

- (UIImage *)editingResImageForAsset:(ALAsset*)asset
{
    CGImageRef image = [[asset defaultRepresentation] fullScreenImage];
    
    return [UIImage imageWithCGImage:image scale:1.0 orientation:UIImageOrientationUp];
}

- (UIImage *)highResImageForAsset:(ALAsset*)asset
{
    ALAssetRepresentation * representation = [asset defaultRepresentation];
    
    CGImageRef image = [representation fullResolutionImage];
    UIImageOrientation orientation = (UIImageOrientation)[representation orientation];
    CGFloat scale = [representation scale];
    
    return [UIImage imageWithCGImage:image scale:scale orientation:orientation];
}

- (void) setupHighResContextForPhotoEditor:(AFPhotoEditorController *)photoEditor withImage:(UIImage *)highResImage
{
    // Capture a reference to the editor's session, which internally tracks user actions on a photo.
    __block AFPhotoEditorSession *session = [photoEditor session];
    
    // Add the session to our sessions array. We need to retain the session until all contexts we create from it are finished rendering.
    [[self sessions] addObject:session];
    
    // Create a context from the session with the high res image.
    AFPhotoEditorContext *context = [session createContextWithImage:highResImage];
    
    __block AviaryPhotoEditor * blockSelf = self;
    
    // Call render on the context. The render will asynchronously apply all changes made in the session (and therefore editor)
    // to the context's image. It will not complete until some point after the session closes (i.e. the editor hits done or
    // cancel in the editor). When rendering does complete, the completion block will be called with the result image if changes
    // were made to it, or `nil` if no changes were made. In this case, we write the image to the user's photo album, and release
    // our reference to the session.
    [context render:^(UIImage *result) {
        if (result) {
            UIImageWriteToSavedPhotosAlbum(result, nil, nil, NULL);
        }
        
        [[blockSelf sessions] removeObject:session];
        
        blockSelf = nil;
        session = nil;
        
    }];
}


@end
