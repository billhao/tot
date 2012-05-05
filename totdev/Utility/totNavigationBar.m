//
//  totNavigationBar.m
//  totdev
//
//  Created by Lixing Huang on 5/2/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totNavigationBar.h"

@implementation totNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setBackgroundImage:(NSString*)path {
    mBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:path]];
    [self addSubview:mBackground];
}

- (void)setLeftButton:(NSString*)path {
    mLeftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
}

- (void)setRightButton:(NSString*)path {

}

- (void)dealloc {
    [mBackground release];
    [mLeftButton release];
    [mRightButton release];
}

@end
