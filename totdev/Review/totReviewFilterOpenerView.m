//
//  totReviewFilterView.m
//  totdev
//
//  Created by Lixing Huang on 1/10/13.
//  Copyright (c) 2013 USC. All rights reserved.
//

#import "totReviewFilterOpenerView.h"
#import "totReviewFilterView.h"

@implementation totReviewFilterOpenerView

@synthesize filter;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // resize image
        UIImage *background = [UIImage imageNamed:@"opener.png"];
        CGSize newSize = {frame.size.width, frame.size.height};
        UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
        [background drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.backgroundColor = [[UIColor alloc] initWithPatternImage:newImage];
        
        self.userInteractionEnabled = YES;
        mStatus = FOLD;
    }
    return self;
}

- (void)animationDidStart:(NSString*)animationID context:(void*)context {
    self.userInteractionEnabled = NO;
}

- (void)animationDidStop:(NSString*)animationID finished:(NSNumber*)finished context:(void*)context {
    self.userInteractionEnabled = YES;
    if ([animationID isEqualToString:@"expand_filter"])
        mStatus = EXPANDED;
    else if ([animationID isEqualToString:@"fold_filter"])
        mStatus = FOLD;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    printf("%f\n", self.frame.origin.y);
    mPrevTouchY = point.y;
    mBeginTouchY = point.y;
}

- (void)fold {
    self.userInteractionEnabled = NO;
    [UIView setAnimationWillStartSelector:@selector(animationDidStart:context:)];
    [UIView beginAnimations:@"fold_filter" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5f];
    self.filter.frame = CGRectMake(self.filter.frame.origin.x, -200, self.filter.frame.size.width, self.filter.frame.size.height);
    self.frame = CGRectMake(self.frame.origin.x, -20, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
}

- (void)expand {
    self.userInteractionEnabled = NO;
    [UIView setAnimationWillStartSelector:@selector(animationDidStart:context:)];
    [UIView beginAnimations:@"expand_filter" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5f];
    self.filter.frame = CGRectMake(self.filter.frame.origin.x, 0, self.filter.frame.size.width, self.filter.frame.size.height);
    self.frame = CGRectMake(self.frame.origin.x, 180, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    const int TRIGGER_DISTANCE = 5;
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    mCurrTouchY = point.y;
    
    if (mStatus == FOLD) {
        if (mCurrTouchY < mPrevTouchY)
            return;
        self.frame = CGRectOffset(self.frame, 0, (mCurrTouchY-mPrevTouchY));
        mPrevTouchY = mCurrTouchY;
        if (mCurrTouchY - mBeginTouchY > TRIGGER_DISTANCE) {
            [self expand];
        }
    } else if (mStatus == EXPANDED) {
        if (mCurrTouchY > mPrevTouchY)
            return;
        self.frame = CGRectOffset(self.frame, 0, (mCurrTouchY-mPrevTouchY));
        mPrevTouchY = mCurrTouchY;
        if (mBeginTouchY - mCurrTouchY > TRIGGER_DISTANCE) {
            [self fold];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

- (void)dealloc {
    [filter release];
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
