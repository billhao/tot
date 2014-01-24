//
//  totBookletView.m
//  totdev
//
//  Created by Lixing Huang on 6/11/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import <math.h>
#import "totBookletView.h"
#import "totBooklet.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "totUtility.h"

@implementation totBookBasicView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)rotate:(float)angle {
    self.transform = CGAffineTransformRotate(self.transform, angle*M_PI/180.0);
}

- (void)rotateTo:(float)angle {
    self.transform = CGAffineTransformMakeRotation(angle*M_PI/180.0);
}

- (void)scale:(float)s {
    self.transform = CGAffineTransformScale(self.transform, s, s);
}

- (void)scaleTo:(float)s {
    self.transform = CGAffineTransformMakeScale(s, s);
}

- (void)scaleToX:(float)sx andToY:(float)sy {
    self.transform = CGAffineTransformMakeScale(sx, sy);
}

- (void)moveTo:(CGPoint)p {
    self.transform = CGAffineTransformMakeTranslation(p.x, p.y);
}

@end

@implementation totPageElementViewInternal

@synthesize mData;
@synthesize mParentView;
@synthesize mTextView;
@synthesize mImage;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        mData = nil;
        mImage = nil;
        
        self.autoresizesSubviews = TRUE;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

- (id)initWithElement:(totPageElement *)data orientation:(BOOL)isLandscape {
    CGSize screenSize = [totUtility getScreenSize];
    float ratio = screenSize.height / 480.0f;
    // the top-left point has to be (0,0)
    if (isLandscape)
        self = [super initWithFrame:CGRectMake(0, 0, data.w * ratio, data.h)];
    else
        self = [super initWithFrame:CGRectMake(0, 0, data.w, data.h * ratio)];
    if (self) {
        self.mData = data;
        mImage = nil;
    }
    return self;
}

- (BOOL)isEmpty {
    return (mData == nil) || [mData isEmpty];
}

- (void)display {
    if (!self.mData) return;
    //[totUtility enableBorder:self];
    if (self.mData.type == IMAGE ){
        NSString* image_path = [self.mData getResource:[totPageElement image]];
        if (image_path) {
            if(!mImage) mImage = [[UIImageView alloc] initWithFrame:self.frame];
            mImage.backgroundColor = [UIColor clearColor];
            UIImage* img = [UIImage imageWithContentsOfFile:image_path];
            //mImage.contentMode = UIViewContentModeScaleAspectFit;
            [mImage setFrame:self.frame];
            mImage.image = img;
            [self addSubview:mImage];
        } else {
            UIImage* img = [UIImage imageNamed:@"add_image"];
            if(!mImage) mImage = [[UIImageView alloc] initWithFrame:self.frame];
            mImage.contentMode = UIViewContentModeCenter;
            mImage.image = img;  // default.
            CGSize s = img.size;
            CGRect f = mImage.frame;
            s = mImage.image.size;
            [self addSubview:mImage];
        }
        [self setStyle:TRUE];
    }
    else if( self.mData.type == TEXT ) {
        NSString* text = [self.mData getResource:[totPageElement text]];
        if(!mTextView) mTextView = [[UITextView alloc] initWithFrame:self.bounds];
        mTextView.backgroundColor = [UIColor clearColor];
        mTextView.delegate = self;
        mTextView.layer.borderColor = [UIColor grayColor].CGColor;
        mTextView.layer.borderWidth = 0;  // hide the border.
        mTextView.layer.cornerRadius = 2;
        mTextView.textAlignment = NSTextAlignmentCenter;

        if (self.mData.fontName) {
            int r = 0, g = 0, b = 0;
            if (self.mData.colorDescription) {
                NSArray* tokens = [self.mData.colorDescription componentsSeparatedByString:@","];
                if ([tokens count] != 3) {
                    printf("font-color in template must have 3 numbers.\n");
                    exit(-1);
                }
                NSString* t = nil;
                t = [[tokens objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                r = [t intValue];
                t = [[tokens objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                g = [t intValue];
                t = [[tokens objectAtIndex:2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                b = [t intValue];
            }
            if (self.mData.fontSize > 0) {
                UIFont* font = [UIFont fontWithName:self.mData.fontName size:self.mData.fontSize];
                [mTextView setTextColor:[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0f]];
                [mTextView setFont:font];
            }
        }
        
        [self addSubview:mTextView];

        UIImage* img = [UIImage imageNamed:@"add_text"];
        if(!mImage) mImage = [[UIImageView alloc] initWithFrame:self.frame];
        mImage.contentMode = UIViewContentModeCenter;
        mImage.image = img;  // default.
        CGSize s = img.size;
        CGRect f = mImage.frame;
        s = mImage.image.size;
        [self addSubview:mImage];

        if( text ) {
            mTextView.text = text;
            mImage.hidden = TRUE;
        }
    }
}

- (void)setStyle:(BOOL)style {
    if( style ) {
//        mImage.layer.cornerRadius = 10.0f;
        mImage.layer.masksToBounds = YES;
//        mImage.layer.borderColor = [UIColor colorWithRed:0.7f green:0.7f blue:0.7f alpha:1.0f].CGColor;
//        mImage.layer.borderWidth = 3.0f;
//        mImage.layer.opacity = 1;
    }
    else {
        mImage.layer.cornerRadius = 0;
        mImage.layer.masksToBounds = YES;
        mImage.layer.borderColor = [UIColor clearColor].CGColor;
        mImage.layer.borderWidth = 0;
//        mImage.layer.opacity = 0;
    }
}

- (void)removeImage {
    if (mImage) {
        [mImage removeFromSuperview];
        [mImage release]; mImage = nil;  // Group these two lines.
    }
}

- (void)resizeTo:(CGRect)size {
    [mImage setFrame:size];
    [self setFrame:size];
}

- (void)dealloc {
    [super dealloc];
    [mData release];
    [mImage release];
    [mTextView release];
}

- (BOOL)textViewShouldBeginEditing:(UITextField *)textField {
    if (mParentView) {
        [mTextView resignFirstResponder];
        mParentView.mCurrentActivePageElement = self; [mParentView showInputTextView];
        mParentView.bookvc.disablePageSwipe = TRUE;
    }
    return FALSE;
}

- (BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if( [text isEqualToString:@"\n"] ) {
        //[textView resignFirstResponder];
        //[mData addResource:[totPageElement text] withPath:textView.text];  // update data.
        //return NO;
    }
    return YES;
}

@end

@implementation totPageElementView

@synthesize mView, bookvc;

- (void)setPageView:(totPageView*)pageView {
    self.mView.mParentView = pageView;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        mView = nil;
    }
    return self;
}

- (id)initWithElementData:(totPageElement*)data bookvc:(totBookViewController*)bookViewController {
    CGSize screenSize = [totUtility getScreenSize];
    float ratio = screenSize.height / 480.0f;
    isLandscape = bookViewController.mBook.orientationLandscape;
    if ( isLandscape )
        self = [super initWithFrame:CGRectMake(data.x * ratio, data.y, data.w * ratio, data.h)];
    else
        self = [super initWithFrame:CGRectMake(data.x, data.y * ratio, data.w, data.h * ratio)];
    
    //self = [super initWithFrame:CGRectMake(data.x, data.y, data.w, data.h)];
    if (self) {
        // Register tap gesture recognizers.
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [tap setDelegate:self];
        [self addGestureRecognizer:tap];
        [tap release];
        // long press
        UILongPressGestureRecognizer* longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                action:@selector(handleLongPress:)];
        longpress.delegate = self;
        [self addGestureRecognizer:longpress];
        [longpress release];
        // Register pan gesture recognizers.
        UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        pan.minimumNumberOfTouches = pan.maximumNumberOfTouches = 2;
        [pan setDelegate:self];
        [self addGestureRecognizer:pan];
        [pan release];
        // Register pinch gesture recognizers.
        UIPinchGestureRecognizer* pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
        [pinch setDelegate:self];
        [self addGestureRecognizer:pinch];
        [pinch release];
        // Register rotate gesture recognizers.
        UIRotationGestureRecognizer* rotate = [[UIRotationGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(handleRotate:)];
        [rotate setDelegate:self];
        [self addGestureRecognizer:rotate];
        [rotate release];
        
        self.bookvc = bookViewController;
        
        // comment out these two lines. they incorrectly enlarge the element views
//        self.autoresizesSubviews = TRUE;
//        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

        mView = [[totPageElementViewInternal alloc] initWithElement:data orientation:bookViewController.mBook.orientationLandscape];
        
        [mView display];
        [mView rotateTo:data.radians];  // rotate to the specified angle.
        [self addSubview:mView];
    }
    return self;
}

- (void)setPageElementData:(totPageElement*)data {
    if (mView) {
        [mView removeFromSuperview];
        [mView release]; mView = nil;
    }
    mView = [[totPageElementViewInternal alloc] initWithElement:data orientation:self.bookvc.mBook.orientationLandscape];
    [mView display];
    [mView rotate:data.radians];
    [self addSubview:mView];
}

- (void)dealloc {
    [super dealloc];
    [mView release];
}

static BOOL bIsFullPage = NO;
static BOOL bAnimationStarted = NO;
- (void)animationDidStart:(NSString*)animationID context:(void*)context {
    bAnimationStarted = YES;
    printf("animation started\n");
}
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    bAnimationStarted = NO;
    printf("animation finished\n");
    if (bIsFullPage) {
        // bring this view to original z-index
        UIView* superview = self.superview;
        //[superview exchangeSubviewAtIndex:myIndexInSuperview withSubviewAtIndex:superview.subviews.count-1];
        [superview insertSubview:self atIndex:myIndexInSuperview];

        [mView setStyle:TRUE];
    }
    bIsFullPage = !bIsFullPage;
}

- (void)animateRemaining {
    if( !bIsFullPage ) {
        [mView setStyle:FALSE];
    }

    [UIView beginAnimations:@"page_element_animation" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationWillStartSelector:@selector(animationDidStart:context:)];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    if (bIsFullPage) {
        CGSize screenSize = [totUtility getScreenSize];
        float ratio = screenSize.height / 480;
        if ( isLandscape ) {
            [self setFrame:CGRectMake(mView.mData.x * ratio, mView.mData.y, mView.mData.w * ratio, mView.mData.h)];
            [mView resizeTo:CGRectMake(0, 0, mView.mData.w * ratio, mView.mData.h)];
        } else {
            [self setFrame:CGRectMake(mView.mData.x, mView.mData.y * ratio, mView.mData.w, mView.mData.h * ratio)];
            [mView resizeTo:CGRectMake(0, 0, mView.mData.w, mView.mData.h * ratio)];
        }
        //[self setFrame:CGRectMake(mView.mData.x, mView.mData.y, mView.mData.w, mView.mData.h)];
        mView.backgroundColor = [UIColor clearColor];
        [mView rotateTo:mView.mData.radians];
        [bookvc hideOptionMenuAndButton:FALSE];
    } else {
        // put this view to top
        UIView* superview = [self superview];
        myIndexInSuperview = [superview.subviews indexOfObject:self];
        [superview bringSubviewToFront:self];
        //[superview exchangeSubviewAtIndex:myIndexInSuperview withSubviewAtIndex:superview.subviews.count-1];

        [mView rotateTo:0];
        mView.backgroundColor = [UIColor colorWithRed:.1 green:.1 blue:.1 alpha:0.95];
        CGRect window = bookvc.fullPageFrame;
        [mView resizeTo:window];
        [self setFrame:window];
        [bookvc hideOptionMenuAndButton:TRUE];
    }
    [UIView commitAnimations];
}

// Delegates
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer { return YES; }

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    NSLog(@"%@", touch.view.class);
    return YES;
}

- (void)handleTap:(UIGestureRecognizer *)gestureRecognizer {
    [bookvc hideOptionMenu:TRUE];

    //NSLog(@"%@", gestureRecognizer.view.class);
    if ([gestureRecognizer isKindOfClass:UITapGestureRecognizer.class] && [gestureRecognizer.view isKindOfClass:totPageElementView.class]) {
        if (![mView isEmpty]) {
            if( mView.mData.type != TEXT )
                [self animateRemaining];
        } else {
            printf("add new element\n");
            // display image selector here
            if( self.mView.mData.type == TEXT ) {
                NSLog(@"Page element tap: show text editor");
            }
            else if( self.mView.mData.type == IMAGE ) {
                NSLog(@"Page element tap: show image selector");
                [self selectPhoto];
            }
            else if( self.mView.mData.type == VIDEO ) {
                NSLog(@"Page element tap: show video selector");
                [self launchVideo:nil];
            }
        }
    }
}

- (void)handleLongPress:(UIGestureRecognizer*)gestureRecognizer {
    UILongPressGestureRecognizer* longpress = (UILongPressGestureRecognizer*)gestureRecognizer;
    if( (longpress.state == UIGestureRecognizerStateBegan) && (![mView isEmpty]) ) {
        [self showPopupMenu];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"%d", buttonIndex);
    if( buttonIndex == 0 ) {
        // replace photo
        [self selectPhoto];
    }
    else if( buttonIndex == 1 ) {
        // remove photo
        [self removePhoto:TRUE];
    }
}

- (void)showPopupMenu {
    NSLog(@"show popup");
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel"
        destructiveButtonTitle:nil otherButtonTitles:@"Replace photo", @"Remove photo", nil];
    popup.actionSheetStyle = UIActionSheetStyleDefault;
    [popup showInView:self];
    [popup release];
}

- (void)removePhoto:(BOOL)save {
    [mView.mData removeResource:[totPageElement image]];
    
    if( save ) {
        // update view
        [self setPageElementData:mView.mData];
        
        // save the data
        [self savePageData];
    }
}

- (void)selectPhoto {
    [self launchCamera:nil];
}

// copied from totactivityviewcontroller
// launch camera
- (void) launchCamera:(id)sender {
//    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//    [appDelegate.mainTabController.cameraView setDelegate:self];
//    [appDelegate.mainTabController.cameraView launchCamera];
    [global.cameraView setDelegate:self];
    // f is frame after rotate
    CGRect f = mView.frame;
    global.cameraView.saveToDB = TRUE;
    global.cameraView.cropWidth = f.size.width;// self.mView.mData.w;
    global.cameraView.cropHeight = f.size.height;// self.mView.mData.h;
    [global.cameraView launchCamera:self.bookvc withEditing:TRUE];
}

- (void) launchVideo:(id)sender {
//    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//    [appDelegate.mainTabController.cameraView setDelegate:self];
//    [appDelegate.mainTabController.cameraView launchCamera];
    global.cameraView.delegate = self;
    global.cameraView.saveToDB = TRUE;
    [global.cameraView launchCamera:self.bookvc withEditing:TRUE];
}

#pragma mark - CameraViewDelegate
- (void) cameraView:(id)cameraView didFinishSavingMedia:(MediaInfo*)mediaInfo {
    NSLog(@"%@", mediaInfo.filename);
    
    //currentPhoto = mediaInfo;
    // update data
    [mView.mData addResource:[totPageElement image] withPath:[totMediaLibrary getMediaPath:mediaInfo.filename]];
    
    // update view
    [self setPageElementData:mView.mData];

    // save the data
    [self savePageData];
}

#pragma totCameraViewController delegate
- (void) cameraView:(id)cameraView didFinishSavingImageToAlbum:(NSString*)imagePath image:(UIImage*)photo {
    
    // save the data
    //[self savePageData];
}

- (void)savePageData {
    // save entire book's data to db
    [mView.mData.page.book saveToDB];
}

// Tesing code ends

- (void)handlePan:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:UIPanGestureRecognizer.class]) {
        UIPanGestureRecognizer* pan = (UIPanGestureRecognizer*)gestureRecognizer;
        CGPoint pos = [pan translationInView:self];
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
            mTouchLastTime = CGPointMake(pos.x, pos.y);
        } else if (gestureRecognizer.state != UIGestureRecognizerStateBegan) {
            float new_x = self.frame.origin.x + (pos.x - mTouchLastTime.x);
            float new_y = self.frame.origin.y + (pos.y - mTouchLastTime.y);
            [self setFrame:CGRectMake(new_x, new_y, self.frame.size.width, self.frame.size.height)];
            mTouchLastTime = CGPointMake(pos.x, pos.y);
        }
        if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
            [self animateRemaining];
        }
    }
}

- (void)handlePinch:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:UIPinchGestureRecognizer.class]) {
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan || gestureRecognizer.state == UIGestureRecognizerStateChanged) {
            UIPinchGestureRecognizer* pinch = (UIPinchGestureRecognizer*)gestureRecognizer;
            [mView scale:pinch.scale];
            [pinch setScale:1];
        }
        if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
            [self animateRemaining];
        }
    }
}

- (void)handleRotate:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:UIRotationGestureRecognizer.class]) {
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan || gestureRecognizer.state == UIGestureRecognizerStateChanged) {
            UIRotationGestureRecognizer* rotate = (UIRotationGestureRecognizer*)gestureRecognizer;
            [mView rotate:rotate.rotation];
            [rotate setRotation:0];
        }
        if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
            [self animateRemaining];
        }
    }
}

@end


@implementation totPageView

@synthesize mPage;
@synthesize mCurrentActivePageElement;

//- (id)initWithFrame:(CGRect)frame andPageTemplateData:(NSDictionary *)data bookvc:(totBookViewController*)bookvc {
//    self = [super initWithFrame:frame];
//    if (self) {
//        totPage* aPage = [[totPage alloc] init:bookvc.bookview.mBook];
//        [aPage loadFromDictionary:data];
//        self.mPage = aPage;
//        [aPage release];
//        self.bookvc = bookvc;
//        [self setup];
//    }
//    return self;
//}

- (id)initWithFrame:(CGRect)frame pagedata:(totPage*)pagedata bookvc:(totBookViewController*)bookvc {
    self = [super initWithFrame:frame];
    if (self) {
        self.mPage = pagedata;
        self.bookvc = bookvc;
        
        self.autoresizesSubviews = TRUE;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        [self setup];
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
    [mBackground release];
    [mPage release];
    [mElementsView release];
    [mTextInput release];
    [mPopupTextInputView release];
}

- (void)setup {
    self.clipsToBounds = TRUE;
    
    // Setup the background image
    mBackground = [[UIImageView alloc] initWithFrame:self.bounds];
    mBackground.contentMode = UIViewContentModeScaleToFill;
    mBackground.image = [UIImage imageNamed:self.mPage.templateFilename];
    [self addSubview:mBackground];
    
    // Setup page element views.
    mElementsView = [[NSMutableArray alloc] init];
    for (int i = 0; i < [mPage elementCount]; ++i) {
        totPageElementView* elementView = [[totPageElementView alloc] initWithElementData:[mPage getPageElementAtIndex:i] bookvc:self.bookvc];
        [elementView setPageView:self];
        [mElementsView addObject:elementView];
        [elementView release];
    }
    for (totPageElementView* view in mElementsView) {
        if( view.mView.mData.type == TEXT ) {
            [self insertSubview:view aboveSubview:mBackground];
        }
        else {
            [self insertSubview:view belowSubview:mBackground];
        }
    }
    
    // Pop up the text input view.
    CGSize screenSize = [totUtility getScreenSize];
    if (self.bookvc.mBook.orientationLandscape)
        mTextInput = [[UITextField alloc] initWithFrame:CGRectMake(30, 40, screenSize.height - 60, 86)];
    else
        mTextInput = [[UITextField alloc] initWithFrame:CGRectMake(10, 60, screenSize.width - 20, 86)];
    mTextInput.borderStyle = UITextBorderStyleRoundedRect;
    mTextInput.backgroundColor = [UIColor whiteColor];
    mTextInput.delegate = self;
    
    if (self.bookvc.mBook.orientationLandscape)
        mPopupTextInputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.height, 240)];
    else
        mPopupTextInputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 400)];
    mPopupTextInputView.backgroundColor = [UIColor colorWithRed:0.4f green:0.4f blue:0.4f alpha:0.7f];
    mPopupTextInputView.hidden = YES;
    [mPopupTextInputView addSubview:mTextInput];
    [self addSubview:mPopupTextInputView];
}

// save the view to an image.
- (UIImage*)renderToImage
{
    // IMPORTANT: using weak link on UIKit
    if(UIGraphicsBeginImageContextWithOptions != NULL) {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    } else {
        UIGraphicsBeginImageContext(self.frame.size);
    }
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

// Pop up the input text view.
- (void)showInputTextView {
    mPopupTextInputView.hidden = NO;
    mTextInput.text = mCurrentActivePageElement.mTextView.text;
    [mTextInput becomeFirstResponder];
}

#pragma UITextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [mPopupTextInputView setHidden:YES];
    [mTextInput resignFirstResponder];
    if (mCurrentActivePageElement) {
        if (mCurrentActivePageElement.mTextView) {
            [mCurrentActivePageElement.mTextView setText:textField.text];
            [mCurrentActivePageElement.mData addResource:[totPageElement text] withPath:textField.text];  // update data.
            [mCurrentActivePageElement.mData.page.book saveToDB];
        }
        if ([textField.text length] > 0) {
            mCurrentActivePageElement.mImage.hidden = YES;
        } else {
            mCurrentActivePageElement.mImage.hidden = NO;
        }
    }
    mCurrentActivePageElement.mParentView.bookvc.disablePageSwipe = FALSE;
    return YES;
}

@end

@implementation totBookView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.autoresizesSubviews = TRUE;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [tap setDelegate:self];
        UILongPressGestureRecognizer* longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                action:@selector(handleLongPress:)];
        [self addGestureRecognizer:tap];
        [self addGestureRecognizer:longpress];
        [longpress release];
        [tap release];
    }
    return self;
}

- (void)handleTap:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:UITapGestureRecognizer.class] && [gestureRecognizer.view isKindOfClass:totPageView.class]) {
        printf("Tap at book\n");
        if( [delegate respondsToSelector:@selector(tapAtBook:)] ) {
            [delegate tapAtBook:self];
        }
    }
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:UILongPressGestureRecognizer.class]) {
        printf("Long press at book\n");
        if ([delegate respondsToSelector:@selector(longPressAtBook:)]) {
            [delegate longPressAtBook:self];
        }
    }
}

- (void)swipeViews:(totPageView*)view1 view2:(totPageView*)view2 leftToRight:(BOOL)leftToRight {
    int width = self.frame.size.width;
    int height = self.frame.size.height;
    if( leftToRight ) {
        if(view1) view1.frame = CGRectMake(-width, 0, width, height);
    }
    else {
        if(view2) view2.frame = CGRectMake(width, 0, width, height);
    }
    [UIView animateWithDuration:0.5f animations:^ {
        if( leftToRight ) {
            if(view1) view1.frame = CGRectMake(0, 0, width, height);
            if(view2) view2.frame = CGRectMake(width, 0, width, height);
        }
        else {
            if(view1) view1.frame = CGRectMake(-width, 0, width, height);
            if(view2) view2.frame = CGRectMake(0, 0, width, height);
        }
    }];
}

- (void)saveBook:(NSString*)bookname {}

- (void)dealloc {
    [super dealloc];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if( [touch.view isKindOfClass:totPageView.class] )
        return YES;
    else
        return NO;
}


@end