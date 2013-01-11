//
//  totReviewFilterView.m
//  totdev
//
//  Created by Lixing Huang on 1/10/13.
//  Copyright (c) 2013 USC. All rights reserved.
//

#import "totReviewFilterView.h"

@implementation totReviewFilterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor greenColor];
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

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    mCurrTouchY = point.y;
    
    if (mStatus == FOLD) {
        if (mCurrTouchY < mPrevTouchY)
            return;
        self.frame = CGRectOffset(self.frame, 0, (mCurrTouchY-mPrevTouchY));
        mPrevTouchY = mCurrTouchY;
        if (mCurrTouchY - mBeginTouchY > 20) {
            self.userInteractionEnabled = NO;
            [UIView setAnimationWillStartSelector:@selector(animationDidStart:context:)];
            [UIView beginAnimations:@"expand_filter" context:nil];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.5f];
                self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            [UIView commitAnimations];
            [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        }
    } else if (mStatus == EXPANDED) {
        if (mCurrTouchY > mPrevTouchY)
            return;
        self.frame = CGRectOffset(self.frame, 0, (mCurrTouchY-mPrevTouchY));
        mPrevTouchY = mCurrTouchY;
        if (mBeginTouchY - mCurrTouchY > 20) {
            self.userInteractionEnabled = NO;
            [UIView setAnimationWillStartSelector:@selector(animationDidStart:context:)];
            [UIView beginAnimations:@"fold_filter" context:nil];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.5f];
                self.frame = CGRectMake(0, -200, self.frame.size.width, self.frame.size.height);
            [UIView commitAnimations];
            [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
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
