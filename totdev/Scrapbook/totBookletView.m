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


#define FULL_PAGE_W 480.0f
#define FULL_PAGE_H 320.0f

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

- (id)initWithElement:(totPageElement *)data {
    // the top-left point has to be (0,0)
    self = [super initWithFrame:CGRectMake(0, 0, data.w, data.h)];
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
    if (self.mData.type == IMAGE ){
        NSString* image_path = [self.mData getResource:[totPageElement image]];
        if (image_path) {
            mImage = [[UIImageView alloc] initWithFrame:self.frame];
            mImage.backgroundColor = [UIColor clearColor];
            UIImage* img = [UIImage imageWithContentsOfFile:image_path];
            mImage.contentMode = UIViewContentModeScaleAspectFit;
            mImage.image = img;
            [self addSubview:mImage];
        } else {
            UIImage* img = [UIImage imageNamed:@"add_image"];
            mImage = [[UIImageView alloc] initWithFrame:self.frame];
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
        UITextView* textView = [[UITextView alloc] initWithFrame:self.bounds];
        textView.backgroundColor = [UIColor clearColor];
        textView.delegate = self;
        if( text ) textView.text = text;
        textView.layer.borderColor = [UIColor grayColor].CGColor;
        textView.layer.borderWidth = 0;  // hide the border.
        textView.layer.cornerRadius = 2;
        [self addSubview:textView];
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
}

- (BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if( [text isEqualToString:@"\n"] ) {
        [textView resignFirstResponder];

        // update data
        [mData addResource:[totPageElement text] withPath:textView.text];
        
        return NO;
    }
    return YES;
}

@end

@implementation totPageElementView

@synthesize mView, bookvc;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        mView = nil;
    }
    return self;
}

- (id)initWithElementData:(totPageElement*)data bookvc:(totBookViewController*)bookViewController {
    self = [super initWithFrame:CGRectMake(data.x, data.y, data.w, data.h)];
    if (self) {
        // Register tap gesture recognizers.
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [tap setDelegate:self];
        [self addGestureRecognizer:tap];
        [tap release];
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
        UIRotationGestureRecognizer* rotate = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotate:)];
        [rotate setDelegate:self];
        [self addGestureRecognizer:rotate];
        [rotate release];
        
        self.bookvc = bookViewController;
        
        self.autoresizesSubviews = TRUE;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

        mView = [[totPageElementViewInternal alloc] initWithElement:data];
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
    mView = [[totPageElementViewInternal alloc] initWithElement:data];
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
        [self setFrame:CGRectMake(mView.mData.x, mView.mData.y, mView.mData.w, mView.mData.h)];
        mView.backgroundColor = [UIColor clearColor];
        [mView resizeTo:CGRectMake(0, 0, mView.mData.w, mView.mData.h)];
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
        [mView resizeTo:CGRectMake(0, 0, FULL_PAGE_W, FULL_PAGE_H)];
        [self setFrame:CGRectMake(0, 0, FULL_PAGE_W, FULL_PAGE_H)];
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

    NSLog(@"%@", gestureRecognizer.view.class);
    if ([gestureRecognizer isKindOfClass:UITapGestureRecognizer.class] && [gestureRecognizer.view isKindOfClass:totPageElementView.class]) {
        if (![mView isEmpty]) {
            [self animateRemaining];
        } else {
            printf("add new element\n");
            // display image selector here
            if( self.mView.mData.type == TEXT ) {
                NSLog(@"Page element tap: show text editor");
            }
            else if( self.mView.mData.type == IMAGE ) {
                NSLog(@"Page element tap: show image selector");
                [self launchCamera:nil];
            }
            else if( self.mView.mData.type == VIDEO ) {
                NSLog(@"Page element tap: show video selector");
                [self launchVideo:nil];
            }
        }
    }
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
}

- (CGPoint)fullPageSize {
    return CGPointMake(FULL_PAGE_W, FULL_PAGE_W);
}

- (void)setup {
    self.clipsToBounds = TRUE;
    
    // Setup the background image
    mBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 480, 320)];
    mBackground.image = [UIImage imageNamed:self.mPage.templateFilename];
    [self addSubview:mBackground];
    
    // Setup page element views.
    mElementsView = [[NSMutableArray alloc] init];
    for (int i = 0; i < [mPage elementCount]; ++i) {
        totPageElementView* elementView = [[totPageElementView alloc] initWithElementData:[mPage getPageElementAtIndex:i] bookvc:self.bookvc];
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
}

// save the view to an image
- (UIImage*)renderToImage
{
    // IMPORTANT: using weak link on UIKit
    if(UIGraphicsBeginImageContextWithOptions != NULL)
    {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    } else {
        UIGraphicsBeginImageContext(self.frame.size);
    }
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
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