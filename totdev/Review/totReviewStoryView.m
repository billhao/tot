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

// get the type icon file name
- (NSString*)getTypeIcon:(totReviewStory*)story {
    NSArray* tokens = [story.mEventType componentsSeparatedByString:@"/"];
    NSString* category = [tokens objectAtIndex:0];
    if ([category isEqualToString:@"basic"]) {
        return [NSString stringWithFormat:@"%s.png", [[tokens objectAtIndex:1] UTF8String]];
    } else if ([category isEqualToString:@"eye_contact"]) {
        return @"eye_contact.png";
    } else if ([category isEqualToString:@"vision_attention"]) {
        return @"vision_attention.png";
    } else if ([category isEqualToString:@"chew"]) {
        return @"chew.png";
    } else if ([category isEqualToString:@"mirror_test"]) {
        return @"mirror_test.png";
    } else if ([category isEqualToString:@"imitation"]) {
        return @"imitation.png";
    } else if ([category isEqualToString:@"motor_skill"]) {
        return [NSString stringWithFormat:@"%s.png", [[tokens objectAtIndex:1] UTF8String]];
    } else if ([category isEqualToString:@"emotion"]) {
        return [NSString stringWithFormat:@"%s.png", [[tokens objectAtIndex:1] UTF8String]];
    } else if ([category isEqualToString:@"gesture"]) {
        return [NSString stringWithFormat:@"%s.png", [[tokens objectAtIndex:1] UTF8String]];
    } else {
        printf("Has not implemented yet.\n");
        return nil;
    }
}

// get the story description
- (NSString*)getStoryDescription:(totReviewStory*)story {
    NSString* desc = nil;
    NSArray* tokens = [story.mEventType componentsSeparatedByString:@"/"];
    NSString* category = [tokens objectAtIndex:0];
    if ([category isEqualToString:@"basic"]) {
        NSString* subcategory = [tokens objectAtIndex:1];
        if ([subcategory isEqualToString:@"diaper"]) {
            NSString* rawValue = story.mRawContent;
            desc = [NSString stringWithFormat:@"%s", [rawValue UTF8String]];
        }
    }
    return desc;
}

// get time description
- (NSString*)getStoryTime:(totReviewStory*)story {
    NSString* time = nil;
    return time;
}

// generate story view
- (void)generate:(totReviewStory*)story {
    if (!story) {
        printf("story is null. check it out.\n");
        exit(1);
    }
    
    NSString *icon_filename = [self getTypeIcon:story];
    if (icon_filename) {
        UIImageView * icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [icon setImage:[UIImage imageNamed:icon_filename]];
        [self addSubview:icon];
        [icon release];
    }
    
    
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
    [super dealloc];
}

@end
