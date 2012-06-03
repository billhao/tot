//
//  totReviewStoryView.m
//  totdev
//
//  Created by Lixing Huang on 6/2/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totReviewStoryView.h"

@implementation totReviewStoryView

@synthesize height;
@synthesize width;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor grayColor]];
        height = frame.size.height;
        width  = frame.size.width;
    }
    return self;
}

// generate story view
- (void)generate:(totReviewStory*)story {
    if (!story) {
        printf("story is null. check it out.\n");
        exit(1);
    }
    
    UILabel *headline = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 40)];
    [headline setText:story.who];
    [self addSubview:headline];
    [headline release];
    
    UIImageView *attachment1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, width/2, 120)];
    UIImageView *attachment2 = [[UIImageView alloc] initWithFrame:CGRectMake(width/2, 50, width/2, 120)];
    UIImage *img1 = [UIImage imageNamed:@"gesture.png"];
    UIImage *img2 = [UIImage imageNamed:@"imitation.png"];
    [attachment1 setImage:img1];
    [attachment2 setImage:img2];
    [self addSubview:attachment1];
    [self addSubview:attachment2];
    [attachment1 release];
    [attachment2 release];
}

- (void)setReviewStory:(totReviewStory *)story {
    [self generate:story];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc {

}

@end
