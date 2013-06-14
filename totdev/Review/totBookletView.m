//
//  totBookletView.m
//  totdev
//
//  Created by Lixing Huang on 6/11/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import "totBookletView.h"
#import "totBooklet.h"
#import <QuartzCore/QuartzCore.h>

@implementation totBookBasicView

static int mRotate = 0;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    mRotate += 10; [self rotate:mRotate];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {}

- (void)rotate:(float)r {
    self.transform = CGAffineTransformMakeRotation(r / 180.0 * M_PI);
}

@end

@implementation totPageElementView

@synthesize mData;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithElement:(totPageElement *)data {
    self = [super initWithFrame:CGRectMake(0, 0, data.w, data.h)];
    if (self) {
        self.mData = data;
    }
    return self;
}

- (void)display {
    if (self.mData) {
        NSString* image_path = [self.mData getResource:[totPageElement image]];
        if (image_path) {
            UIImageView* image = [[UIImageView alloc] initWithFrame:self.frame];
            image.image = [UIImage imageNamed:image_path];
            image.layer.cornerRadius = 10.0f;
            image.layer.masksToBounds = YES;
            image.layer.borderColor = [UIColor colorWithRed:0.7f green:0.7f blue:0.7f alpha:1.0f].CGColor;
            image.layer.borderWidth = 3.0f;
            [self addSubview:image];
            [image release];
        }
    }
}

- (void)dealloc {
    [super dealloc];
    [mData release];
}

@end


@implementation totPageView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

@end

@implementation totBookView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

@end