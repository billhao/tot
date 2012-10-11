//
//  totImageView.m
//  totdev
//
//  Created by Lixing Huang on 4/15/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totImageView.h"

#define DEFAULT_TAG -1

@implementation totImageView

@synthesize delegate;
@synthesize mTag;

- (id)initWithFrame:(CGRect)frame {
    if( self = [super initWithFrame:frame] ) {
        self.userInteractionEnabled = YES;
        self.mTag = DEFAULT_TAG;
    }
    return self;
}

- (void)imageFilePath:(NSString *)path {
    UIImage *background = [UIImage imageNamed:path];
    [self setImage:background];
}

- (void)imageFromFileContent:(NSString*)path {
    UIImage *background = [UIImage imageWithContentsOfFile:path];
    [self setImage:background];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if( [delegate respondsToSelector:@selector(touchesEndedDelegate:withEvent:)] ) {
        [delegate touchesEndedDelegate:touches withEvent:event];
    } else if ( [delegate respondsToSelector:@selector(touchesEndedDelegate:withEvent:from:)] ) {
        [delegate touchesEndedDelegate:touches withEvent:event from:mTag];
    }
}

- (void)dealloc {
    [super dealloc];
}

@end
