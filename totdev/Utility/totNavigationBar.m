//
//  totNavigationBar.m
//  totdev
//
//  Created by Lixing Huang on 5/2/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totNavigationBar.h"

#define LFT_BUTTON_X 40
#define RGT_BUTTON_X 220
#define BUTTON_Y 5
#define BUTTON_W 60
#define BUTTON_H 30

@implementation totNavigationBar

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        mWidth = frame.size.width;
        mHeight= frame.size.height;
    }
    return self;
}

// delegate
- (void)leftButtonPressed:(id)sender {
    if( [delegate respondsToSelector:@selector(navLeftButtonPressed:)] ) {
        [delegate navLeftButtonPressed:sender];
    }
}

- (void)rightButtonPressed:(id)sender {
    if( [delegate respondsToSelector:@selector(navRightButtonPressed:)] ) {
        [delegate navRightButtonPressed:sender];
    }
}

// background
- (void)setBackgroundImage:(NSString*)path {
    mBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mWidth, mHeight)];
    [mBackground setImage:[UIImage imageNamed:path]];
    [self addSubview:mBackground];
}

// navigation bar title
- (void)setNavigationBarTitle:(NSString *)title andColor:(UIColor *)clr {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 200, 30)];
    label.text = title;
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = clr;
    label.backgroundColor = [UIColor clearColor];
    [label setFont:[UIFont fontWithName:@"Roboto-Bold" size:18.0]];
    [self addSubview:label];
    [label release];
}

// left button
- (void)hideLeftButton {
    if( mLeftButton )
        mLeftButton.hidden = YES;
}
- (void)showLeftButton {
    if( mLeftButton )
        mLeftButton.hidden = NO;
}
- (void)setLeftButtonTitle:(NSString *)title {
    mLeftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    mLeftButton.frame = CGRectMake(LFT_BUTTON_X, BUTTON_Y, BUTTON_W, BUTTON_H);
    [mLeftButton setTitle:title forState:UIControlStateNormal];
    [mLeftButton addTarget:self action:@selector(leftButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:mLeftButton];
}

- (void)setLeftButtonImg:(NSString*)path {
    mLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    mLeftButton.frame = CGRectMake(LFT_BUTTON_X, BUTTON_Y, BUTTON_W, BUTTON_H);
    [mLeftButton setImage:[UIImage imageNamed:path] forState:UIControlStateNormal];
    [mLeftButton addTarget:self action:@selector(leftButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:mLeftButton];
}

// right button
- (void)hideRightButton {
    if( mRightButton )
        mRightButton.hidden = YES;
}
- (void)showRightButton {
    if( mRightButton )
        mRightButton.hidden = NO;
}
- (void)setRightButtonTitle:(NSString *)title {
    mRightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    mRightButton.frame = CGRectMake(RGT_BUTTON_X, BUTTON_Y, BUTTON_W, BUTTON_H);
    [mRightButton setTitle:title forState:UIControlStateNormal];
    [mRightButton addTarget:self action:@selector(rightButtonPressed:) forControlEvents:UIControlEventTouchUpInside];    
    [self addSubview:mRightButton];
}

- (void)setRightButtonImg:(NSString*)path {
    mRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    mRightButton.frame = CGRectMake(RGT_BUTTON_X, BUTTON_Y, BUTTON_W, BUTTON_H);
    [mRightButton setImage:[UIImage imageNamed:path] forState:UIControlStateNormal];
    [mRightButton addTarget:self action:@selector(rightButtonPressed:) forControlEvents:UIControlEventTouchUpInside];    
    [self addSubview:mRightButton];
}

- (void)dealloc {
    [mBackground release];
    [mLeftButton release];
    [mRightButton release];
    [super dealloc];
}

@end
