//
//  totReviewStoryView.m
//  totdev
//
//  Created by Lixing Huang on 6/2/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totReviewStoryView.h"
#import "AppDelegate.h"
#import "../Model/totModel.h"
#import "../Model/totEvent.h"

@implementation totReviewStoryView

@synthesize height;
@synthesize width;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor whiteColor]];
        
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
- (BOOL) isFirstOccurrence:(NSString*)event_type forBaby:(int)babyId inDatabase:(totModel*)db {
    NSArray* events = [db getEvent:babyId event:event_type];
    if ([events count] == 1) {
        return YES;
    } else {
        return NO;
    }
}
- (NSString*)getStoryDescription:(totReviewStory*)story {
    NSString* desc = nil;
    NSArray* tokens = [story.mEventType componentsSeparatedByString:@"/"];
    NSString* category = [tokens objectAtIndex:0];
    NSString* rawValue = story.mRawContent;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    totModel* database = [appDelegate getDataModel];
    
    if ([category isEqualToString:@"basic"]) {
        NSString* subcategory = [tokens objectAtIndex:1];
        
        if ([subcategory isEqualToString:@"diaper"]) {
            desc = [NSString stringWithFormat:@"has a %s diaper", [rawValue UTF8String]];
        } else if ([subcategory isEqualToString:@"language"]) {
            desc = [NSString stringWithFormat:@"said %s", [rawValue UTF8String]];
        } else if ([subcategory isEqualToString:@"sleep"]) {
            if ([rawValue isEqualToString:@"end"]) {
                
            }
        } else if ([subcategory isEqualToString:@"height"]) {
            desc = [NSString stringWithFormat:@"is %s now", [rawValue UTF8String]];
        } else if ([subcategory isEqualToString:@"weight"]) {
            desc = [NSString stringWithFormat:@"is %s now", [rawValue UTF8String]];
        } else if ([subcategory isEqualToString:@"head"]) {
            desc = [NSString stringWithFormat:@"is %s now", [rawValue UTF8String]];
        }
    } else if ([category isEqualToString:@"eye_contact"]) {
        if ([self isFirstOccurrence:category forBaby:appDelegate.mBabyId inDatabase:database]) {
            desc = @"first eye contact";
        } else {
            desc = @"has an eye contact";
        }
    } else if ([category isEqualToString:@"vision_attention"]) {
        if ([self isFirstOccurrence:category forBaby:appDelegate.mBabyId inDatabase:database]) {
            desc = @"first vision attention";
        } else {
            desc = @"has a vision attention";
        }
    } else if ([category isEqualToString:@"chew"]) {
        if ([self isFirstOccurrence:category forBaby:appDelegate.mBabyId inDatabase:database]) {
            desc = @"first chew";
        } else {
            desc = @"chewed";
        }
    } else if ([category isEqualToString:@"mirror_test"]) {
        if ([self isFirstOccurrence:category forBaby:appDelegate.mBabyId inDatabase:database]) {
            desc = @"first mirror test";
        } else {
            desc = @"has a mirror test";
        }
    } else if ([category isEqualToString:@"imitation"]) {
        if ([self isFirstOccurrence:category forBaby:appDelegate.mBabyId inDatabase:database]) {
            desc = @"first imitation";
        } else {
            desc = @"has an imitation";
        }
    } else if ([category isEqualToString:@"motor_skill"]) {
        NSString* subcategory = [tokens objectAtIndex:1];
        if ([self isFirstOccurrence:story.mEventType forBaby:appDelegate.mBabyId inDatabase:database]) {
            desc = [NSString stringWithFormat:@"first %s", [subcategory UTF8String]];
        } else {
            desc = [NSString stringWithFormat:@"%s", [subcategory UTF8String]];
        }
    } else if ([category isEqualToString:@"emotion"]) {
        NSString* subcategory = [tokens objectAtIndex:1];
        if ([self isFirstOccurrence:story.mEventType forBaby:appDelegate.mBabyId inDatabase:database]) {
            desc = [NSString stringWithFormat:@"first %s", [subcategory UTF8String]];
        } else {
            desc = [NSString stringWithFormat:@"%s", [subcategory UTF8String]];
        }
    } else if ([category isEqualToString:@"gesture"]) {
        NSString* subcategory = [tokens objectAtIndex:1];
        if ([self isFirstOccurrence:story.mEventType forBaby:appDelegate.mBabyId inDatabase:database]) {
            desc = [NSString stringWithFormat:@"first %s", [subcategory UTF8String]];
        } else {
            desc = [NSString stringWithFormat:@"%s", [subcategory UTF8String]];
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
    
    NSString *description = [self getStoryDescription:story];
    if (description) {
        UILabel *storyDesc = [[UILabel alloc] initWithFrame:CGRectMake(50, -15, 200, 50)];
        storyDesc.backgroundColor = [UIColor clearColor];
        storyDesc.text = description;
        [storyDesc setFont:[UIFont fontWithName:@"verdana" size:13]];
        [self addSubview:storyDesc];
        [storyDesc release];
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
