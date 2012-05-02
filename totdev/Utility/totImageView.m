//
//  totImageView.m
//  totdev
//
//  Created by Lixing Huang on 4/15/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totImageView.h"

@implementation totImageView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    if( self = [super initWithFrame:frame] ) {
        self.userInteractionEnabled = YES;
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
    }
}

- (void)dealloc {
    [super dealloc];
}

@end
