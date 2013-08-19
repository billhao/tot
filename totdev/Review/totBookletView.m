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
#import "totUITabBarController.h"


#define FULL_PAGE_W 320.0f
#define FULL_PAGE_H 480.0f

@implementation totBookBasicView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)rotate:(float)radians {
    self.transform = CGAffineTransformRotate(self.transform, radians);
}

- (void)rotateTo:(float)radians {
    self.transform = CGAffineTransformMakeRotation(radians);
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
    if (self.mData) {
        NSString* image_path = [self.mData getResource:[totPageElement image]];
        if (image_path) {
            mImage = [[UIImageView alloc] initWithFrame:self.frame];
            UIImage* img = [UIImage imageWithContentsOfFile:image_path];
            mImage.image = img;
            [self addSubview:mImage];
        } else {
            mImage = [[UIImageView alloc] initWithFrame:self.frame];
            mImage.image = [UIImage imageNamed:@"add_image.png"];  // default.
            [self addSubview:mImage];
        }
        [self setStyle:TRUE];
    }
}

- (void)setStyle:(BOOL)style {
    if( style ) {
        mImage.layer.cornerRadius = 10.0f;
        mImage.layer.masksToBounds = YES;
        mImage.layer.borderColor = [UIColor colorWithRed:0.7f green:0.7f blue:0.7f alpha:1.0f].CGColor;
        mImage.layer.borderWidth = 3.0f;
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
}

- (void)animateRemaining {
    [UIView beginAnimations:@"page_element_animation" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationWillStartSelector:@selector(animationDidStart:context:)];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    if (bIsFullPage) {
        [self setFrame:CGRectMake(mView.mData.x, mView.mData.y, mView.mData.w, mView.mData.h)];
        [mView resizeTo:CGRectMake(0, 0, mView.mData.w, mView.mData.h)];
        [mView rotateTo:mView.mData.radians];
        bIsFullPage = NO;
        [mView setStyle:TRUE];
        [bookvc hideOptionMenuAndButton:FALSE];
    } else {
        [mView rotateTo:0];
        [mView resizeTo:CGRectMake(0, 0, FULL_PAGE_W, FULL_PAGE_H)];
        [self setFrame:CGRectMake(0, 0, FULL_PAGE_W, FULL_PAGE_H)];
        bIsFullPage = YES;
        [mView setStyle:FALSE];
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
    [global.cameraView launchCamera:self.bookvc];
}

- (void) launchVideo:(id)sender {
//    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//    [appDelegate.mainTabController.cameraView setDelegate:self];
//    [appDelegate.mainTabController.cameraView launchCamera];
    [global.cameraView setDelegate:self];
    [global.cameraView launchCamera:self.bookvc];
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

- (CGPoint)fullPageSize {
    return CGPointMake(FULL_PAGE_W, FULL_PAGE_W);
}

- (void)setup {
    self.clipsToBounds = TRUE;
    
    // Setup the background image
    mBackground = [[UIImageView alloc] initWithFrame:self.frame];
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
        [self insertSubview:view aboveSubview:mBackground];
    }
}

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

@end

@implementation totBookView

@synthesize mBook, currentPageIndex, mPageViews;

- (void)handleTap:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:UITapGestureRecognizer.class] && [gestureRecognizer.view isKindOfClass:totPageView.class]) {
        printf("Tap at book\n");
        if( [delegate respondsToSelector:@selector(tapAtBook:)] ) {
            [delegate tapAtBook:self];
        }
        // get next book
        [self addNewPage:@"FirstYearTemplateP1"];  // For testing...
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

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        mTemplateBook = nil;
        mPageViews = [[NSMutableArray alloc] init];
        currentPageIndex = -1;
        
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

- (void)loadTemplateFile:(NSString*)filename {
    NSString* path = [[NSBundle mainBundle] pathForResource:filename ofType:@"tpl"];
    mTemplateBook = [[totBook alloc] init];
    [mTemplateBook loadFromTemplateFile:path]; // this is an empty book so there is no book name yet.
    mBook = [[totBook alloc] init];
    mBook.templateName = mTemplateBook.templateName;
    mBook.bookname = mTemplateBook.templateName;
}

- (void)display {
    totPage* pageData = [mBook getPageWithIndex:0];
    
    // add a view.
    totPageView* newPage = [[totPageView alloc] initWithFrame:self.frame pagedata:pageData bookvc:self.bookvc];
    
    int newPageIndex = currentPageIndex + 1;
    [mPageViews insertObject:newPage atIndex:newPageIndex];
    [self addSubview:newPage];
    currentPageIndex = newPageIndex;
    [newPage release];
}

// add a random page if pageName is nil
- (void)addNewPage:(NSString*)pageName {
    if (!mTemplateBook) {
        printf("You MUST call loadTemplateFile first\n");
        return;
    }
    totPage* pageData = nil;
    if( pageName )
        pageData = [[mTemplateBook getPage:pageName] copy:mBook];
    else
        pageData = [[mTemplateBook getRandomPage] copy:mBook];
    if (!pageData) return;  // Invalid page name.
    
    // add it to mBook (since we are adding a real page.)
    int newPageIndex = currentPageIndex + 1;
    [mBook insertPage:pageData pageIndex:newPageIndex];
    
    // add a view.
    totPageView* newPage = [[totPageView alloc] initWithFrame:self.frame pagedata:pageData bookvc:self.bookvc];
    [mPageViews insertObject:newPage atIndex:newPageIndex];
    [self addSubview:newPage];
    if ([mPageViews count] > 1) {
        totPageView* curr = newPage;
        curr.frame = CGRectMake(320, 0, self.frame.size.width, self.frame.size.height);
        totPageView* prev = [mPageViews objectAtIndex:newPageIndex-1];
        
        // swipe the previous page, and display the current page.
        [UIView beginAnimations:@"swipe" context:nil];
        [UIView setAnimationDuration:0.5f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            prev.frame = CGRectMake(-320, 0, self.frame.size.width, self.frame.size.height);
            curr.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [UIView commitAnimations];
    }
    [newPage release];
    currentPageIndex = newPageIndex;
}

- (void)deleteCurrentPage {
    // swipe the previous page, and display the current page.
    totPageView* curr = [mPageViews objectAtIndex:currentPageIndex];
    curr.clipsToBounds = TRUE;
    [UIView animateWithDuration:0.5f animations: ^{
        curr.frame = CGRectMake(self.frame.size.width/2, self.frame.size.height/2, 0, 0);
    } completion:^(BOOL finished) {
        // remove both page view and data
        int lastPageIndex = currentPageIndex;
        [mPageViews removeObjectAtIndex:lastPageIndex];
        [mBook deletePage:lastPageIndex];
        
        // swipe to the next page
        if( mPageViews.count > currentPageIndex ) {
            // there is a page after it, go to that one
            totPageView* curr = [mPageViews objectAtIndex:currentPageIndex];
            [self swipeViews:nil view2:curr leftToRight:FALSE];
        }
        else if( mPageViews.count > 0 ) {
            // this is the last page, go to the page before it
            currentPageIndex--;
            totPageView* curr = [mPageViews objectAtIndex:currentPageIndex];
            [self swipeViews:curr view2:nil leftToRight:TRUE];
        }
        else {
            // this is the only page
            // add a new page, and swipe to the new page
            // next = newpage;
            currentPageIndex = -1;
            [self addNewPage:nil];
        }        
    }];
}

- (void)nextPage {
    if( currentPageIndex == mPageViews.count-1 ) {
        // indicate this is already the last page
        return;
    }
    totPageView* curr = mPageViews[currentPageIndex];
    totPageView* next = mPageViews[currentPageIndex+1];
    [self swipeViews:curr view2:next leftToRight:FALSE];
    currentPageIndex++;
}

- (void)previousPage {
    if( currentPageIndex == 0 ) {
        // indicate this is already the first page
        return;
    }
    totPageView* curr = mPageViews[currentPageIndex];
    totPageView* prev = mPageViews[currentPageIndex-1];
    [self swipeViews:prev view2:curr leftToRight:TRUE];
    currentPageIndex--;
}

- (void)swipeViews:(totPageView*)view1 view2:(totPageView*)view2 leftToRight:(BOOL)leftToRight {
    int width = self.frame.size.width;
    int height = self.frame.size.height;
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

- (void)loadBook:(NSString*)bookid bookname:(NSString*)bookname {
    mBook = [totBook loadFromDB:bookid bookname:bookname];
}

- (void)dealloc {
    [super dealloc];
    [mTemplateBook release];
    [mBook release];
    [mPageViews release];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if( [touch.view isKindOfClass:totPageView.class] )
        return YES;
    else
        return NO;
}


@end