#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "AFPhotoEditorController.h"

@protocol AviaryPhotoEditor<NSObject>
@optional

- (void)photoEditor:(AFPhotoEditorController *)editor finishedWithImage:(UIImage *)image;

@end

@interface AviaryPhotoEditor : NSObject  <AFPhotoEditorControllerDelegate, UIPopoverControllerDelegate> {
    
//    AFPhotoEditorController * photoEditor;
}

@property (nonatomic, retain) UIViewController* vc;
@property (nonatomic, strong) ALAssetsLibrary * assetLibrary;
@property (nonatomic, strong) NSMutableArray * sessions;
@property (nonatomic, retain) id<AviaryPhotoEditor> delegate;

// for crop
@property (nonatomic, assign) float cropWidth;
@property (nonatomic, assign) float cropHeight;

-(id)init:(UIViewController*)viewController;
- (void) launchEditorWithAssetURL:(NSURL *)assetURL;
- (void) launchEditorWithAsset:(ALAsset *)asset;
- (void) launchPhotoEditorWithImage:(UIImage *)editingResImage highResolutionImage:(UIImage *)highResImage;

// get image in screen szie
- (UIImage*)editingResImageForAssetURL:(NSURL*)assetURL;

@end
