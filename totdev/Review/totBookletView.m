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

#define FULL_PAGE_W 320.0f
#define FULL_PAGE_H 411.0f

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
            mImage.image = [UIImage imageNamed:image_path];
            mImage.layer.cornerRadius = 10.0f;
            mImage.layer.masksToBounds = YES;
            mImage.layer.borderColor = [UIColor colorWithRed:0.7f green:0.7f blue:0.7f alpha:1.0f].CGColor;
            mImage.layer.borderWidth = 3.0f;
            [self addSubview:mImage];
        } else {
            mImage = [[UIImageView alloc] initWithFrame:self.frame];
            mImage.image = [UIImage imageNamed:@"add_image.png"];  // default.
            [self addSubview:mImage];
        }
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

@synthesize mView;

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
    } else {
        [mView rotateTo:0];
        [mView resizeTo:CGRectMake(0, 0, FULL_PAGE_W, FULL_PAGE_H)];
        [self setFrame:CGRectMake(0, 0, FULL_PAGE_W, FULL_PAGE_H)];
        bIsFullPage = YES;
    }
    [UIView commitAnimations];
}

// Delegates
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer { return YES; }
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch { return YES; }
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)handleTap:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:UITapGestureRecognizer.class]) {
        if (![mView isEmpty]) {
            [self animateRemaining];
        } else {
            printf("add new element\n");
        }
    }
}

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

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        mView = nil;
    }
    return self;
}

- (id)initWithElementData:(totPageElement*)data {
    self = [super initWithFrame:CGRectMake(data.x, data.y, data.w, data.h)];
    if (self) {
        // Register gesture recognizers.
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [tap setDelegate:self];
        [self addGestureRecognizer:tap];
        [tap release];

        /*
        UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        pan.minimumNumberOfTouches = 2;
        pan.maximumNumberOfTouches = 2;
        [pan setDelegate:self];
        [self addGestureRecognizer:pan];
        [pan release];

        UIPinchGestureRecognizer* pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
        [pinch setDelegate:self];
        [self addGestureRecognizer:pinch];
        [pinch release];

        UIRotationGestureRecognizer* rotate = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotate:)];
        [rotate setDelegate:self];
        [self addGestureRecognizer:rotate];
        [rotate release];
         */

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

@end


@implementation totPageView

@synthesize mPage;

- (CGPoint)fullPageSize {
    return CGPointMake(FULL_PAGE_W, FULL_PAGE_W);
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andPageTemplateData:(NSDictionary *)data {
    self = [super initWithFrame:frame];
    if (self) {
        mPage = [[totPage alloc] init];
        [mPage loadFromDictionary:data];
        
        // Setup the background image
        mBackground = [[UIImageView alloc] initWithFrame:self.frame];
        mBackground.image = [UIImage imageNamed:self.mPage.templateFilename];
        [self addSubview:mBackground];
        
        // Setup page element views.
        mElementsView = [[NSMutableArray alloc] init];
        for (int i = 0; i < [mPage elementCount]; ++i) {
            totPageElementView* elementView = [[totPageElementView alloc] initWithElementData:[mPage getPageElementAtIndex:i]];
            [mElementsView addObject:elementView];
            [elementView release];
        }
        for (totPageElementView* view in mElementsView) {
            [self insertSubview:view aboveSubview:mBackground];
        }
    }
    return self;
}

- (void)loadFromData:(NSString *)jsonData {}

- (void)dealloc {
    [super dealloc];
    [mBackground release];
    [mPage release];
    [mElementsView release];
}

@end

@implementation totBookView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)addNewPage:(NSString*)pageName {
}

@end