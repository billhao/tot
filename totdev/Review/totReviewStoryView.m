//
//  totReviewStoryView.m
//  totdev
//
//  Created by Lixing Huang on 6/2/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totReviewStoryView.h"
#import "AppDelegate.h"
#import "totReviewLineChart.h"
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
                desc = @"woke up";
            } else if ([rawValue isEqualToString:@"start"]) {
                desc = @"fell asleep";
            }
        } else if ([subcategory isEqualToString:@"height"]) {
            desc = [NSString stringWithFormat:@"is %s now", [rawValue UTF8String]];
        } else if ([subcategory isEqualToString:@"weight"]) {
            desc = [NSString stringWithFormat:@"is %s now", [rawValue UTF8String]];
        } else if ([subcategory isEqualToString:@"head"]) {
            desc = [NSString stringWithFormat:@"is %s now", [rawValue UTF8String]];
        }
    } else if ([category isEqualToString:@"eye_contact"]) {
        if ([self isFirstOccurrence:category forBaby:appDelegate.baby.babyID inDatabase:database]) {
            desc = @"first eye contact";
        } else {
            desc = @"has an eye contact";
        }
    } else if ([category isEqualToString:@"vision_attention"]) {
        if ([self isFirstOccurrence:category forBaby:appDelegate.baby.babyID inDatabase:database]) {
            desc = @"first vision attention";
        } else {
            desc = @"has a vision attention";
        }
    } else if ([category isEqualToString:@"chew"]) {
        if ([self isFirstOccurrence:category forBaby:appDelegate.baby.babyID inDatabase:database]) {
            desc = @"first chew";
        } else {
            desc = @"chewed";
        }
    } else if ([category isEqualToString:@"mirror_test"]) {
        if ([self isFirstOccurrence:category forBaby:appDelegate.baby.babyID inDatabase:database]) {
            desc = @"first mirror test";
        } else {
            desc = @"has a mirror test";
        }
    } else if ([category isEqualToString:@"imitation"]) {
        if ([self isFirstOccurrence:category forBaby:appDelegate.baby.babyID inDatabase:database]) {
            desc = @"first imitation";
        } else {
            desc = @"has an imitation";
        }
    } else if ([category isEqualToString:@"motor_skill"]) {
        NSString* subcategory = [tokens objectAtIndex:1];
        if ([self isFirstOccurrence:story.mEventType forBaby:appDelegate.baby.babyID inDatabase:database]) {
            desc = [NSString stringWithFormat:@"first %s", [subcategory UTF8String]];
        } else {
            desc = [NSString stringWithFormat:@"%s", [subcategory UTF8String]];
        }
    } else if ([category isEqualToString:@"emotion"]) {
        NSString* subcategory = [tokens objectAtIndex:1];
        if ([self isFirstOccurrence:story.mEventType forBaby:appDelegate.baby.babyID inDatabase:database]) {
            desc = [NSString stringWithFormat:@"first %s", [subcategory UTF8String]];
        } else {
            desc = [NSString stringWithFormat:@"%s", [subcategory UTF8String]];
        }
    } else if ([category isEqualToString:@"gesture"]) {
        NSString* subcategory = [tokens objectAtIndex:1];
        if ([self isFirstOccurrence:story.mEventType forBaby:appDelegate.baby.babyID inDatabase:database]) {
            desc = [NSString stringWithFormat:@"first %s", [subcategory UTF8String]];
        } else {
            desc = [NSString stringWithFormat:@"%s", [subcategory UTF8String]];
        }
    }
    return desc;
}

// get time description
- (NSString*)getStoryTime:(totReviewStory*)story {
    NSString * time_desc = nil;
    NSDate * evet_time = story.mWhen;
    NSDate * curr_time = [NSDate date];
    
    NSArray *tokens, *comps1, *comps2;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    
    // current time
    tokens = [[dateFormatter stringFromDate:curr_time] componentsSeparatedByString:@" "];
    comps1 = [[tokens objectAtIndex:0] componentsSeparatedByString:@"-"];
    comps2 = [[tokens objectAtIndex:1] componentsSeparatedByString:@":"];
    
    int current_year  = [[f numberFromString:[comps1 objectAtIndex:0]] intValue];
    int current_month = [[f numberFromString:[comps1 objectAtIndex:1]] intValue];
    int current_day   = [[f numberFromString:[comps1 objectAtIndex:2]] intValue];
    int current_hour  = [[f numberFromString:[comps2 objectAtIndex:0]] intValue];
    int current_minute= [[f numberFromString:[comps2 objectAtIndex:1]] intValue];
    int current_second= [[f numberFromString:[comps2 objectAtIndex:2]] intValue];
    
    // event time
    tokens = [[dateFormatter stringFromDate:evet_time] componentsSeparatedByString:@" "];
    comps1 = [[tokens objectAtIndex:0] componentsSeparatedByString:@"-"];
    comps2 = [[tokens objectAtIndex:1] componentsSeparatedByString:@":"];
    
    int event_year  = [[f numberFromString:[comps1 objectAtIndex:0]] intValue];
    int event_month = [[f numberFromString:[comps1 objectAtIndex:1]] intValue];
    int event_day   = [[f numberFromString:[comps1 objectAtIndex:2]] intValue];
    int event_hour  = [[f numberFromString:[comps2 objectAtIndex:0]] intValue];
    int event_minute= [[f numberFromString:[comps2 objectAtIndex:1]] intValue];
    int event_second= [[f numberFromString:[comps2 objectAtIndex:2]] intValue];
    
    // construct the time description
    if (current_year == event_year && current_month == event_month && current_day == event_day) {
        if (current_hour == event_hour && current_minute == event_minute) {
            time_desc = [NSString stringWithFormat:@"%d seconds ago", (current_second - event_second)];
        } else if (current_hour == event_hour) {
            time_desc = [NSString stringWithFormat:@"%d minutes ago", (current_minute - event_minute)];
        } else {
            time_desc = [NSString stringWithFormat:@"about %d hours ago", (current_hour - event_hour)];
        }
    } else if (current_year == event_year && current_month == event_month) {
        time_desc = [NSString stringWithFormat:@"%d days ago", (current_day - event_day)];
    } else {
        time_desc = [NSString stringWithString:[dateFormatter stringFromDate:evet_time]];
    }
    
    [f release];
    [dateFormatter release];
    
    return time_desc;
}

// construct the context info
- (void)buildContextInfo:(totReviewStory*)story {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    totModel* database = [appDelegate getDataModel];
    
    NSArray* tokens = [story.mEventType componentsSeparatedByString:@"/"];
    NSString* category = [tokens objectAtIndex:0];
    
    if ([category isEqualToString:@"basic"]) {
        NSString* subcategory = [tokens objectAtIndex:1];
        if ([subcategory isEqualToString:@"height"]) {
            NSArray * events = [database getEvent:appDelegate.baby.babyID event:story.mEventType];
            
            int size = ([events count] > 3) ? 3 : [events count];
            NSMutableArray * values = [[NSMutableArray alloc] init];
            NSMutableArray * timestamps = [[NSMutableArray alloc] init];
            for (int i = 0; i < size; ++i) {
                totEvent * evt = [events objectAtIndex:i];
                [values addObject:evt.value];
                [timestamps addObject:evt.datetime];
                //printf("%s %s\n", [evt.value UTF8String], [[evt.datetime descriptionWithLocale:@"yyyy-MM-dd HH:mm:ss"] UTF8String]);
            }
            
            totReviewLineChart * context = [[totReviewLineChart alloc] initWithFrame:CGRectMake(40, 30, 250, 60)];
            [context setValues:values];
            [context setTimestamps:timestamps];
            [self addSubview:context];
            
            [context release];
            [timestamps release];
            [values release];
        } else if ([subcategory isEqualToString:@"language"]) {
            NSArray * events = [database getEvent:appDelegate.baby.babyID event:story.mEventType];
            NSString * desc = [NSString stringWithFormat:@"has known %d words", [events count]];
            UILabel * context = [[UILabel alloc] initWithFrame:CGRectMake(40, 40, 200, 30)];
            context.text = desc;
            [context setFont:[UIFont fontWithName:@"verdana" size:13]];
            [self addSubview:context];
            [context release];
        }
    } else if ([category isEqualToString:@"emotion"]) {
        UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake(40, 30, 40, 60)];
        NSArray  * tokens = [story.mRawContent componentsSeparatedByString:@";"];
        NSString * imgPath = nil;
        NSString * comment = nil;
        BOOL isVideo = NO;
        for (int i = 0; i < [tokens count]; ++i) {
            NSArray * comps = [[tokens objectAtIndex:i] componentsSeparatedByString:@"="];
            NSString * key = [comps objectAtIndex:0];
            NSString * val = [comps objectAtIndex:1];
            if ([key isEqualToString:@"image"]) {
                imgPath = [NSString stringWithString:val];
            } else if ([key isEqualToString:@"video"]) {
                isVideo = YES;
            } else if ([key isEqualToString:@"desc"]) {
                comment = [NSString stringWithString:val];
            }
        }
        img.image = [UIImage imageNamed:imgPath];
        [self addSubview:img];
        [img release];
    }
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
        UILabel *storyDesc = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 200, 30)];
        storyDesc.backgroundColor = [UIColor clearColor];
        storyDesc.text = description;
        [storyDesc setFont:[UIFont fontWithName:@"verdana" size:13]];
        [self addSubview:storyDesc];
        [storyDesc release];
    }
    
    NSString *time_description = [self getStoryTime:story];
    if (time_description) {
        UILabel *timeDesc = [[UILabel alloc] initWithFrame:CGRectMake(50, height - 10, 200, 20)];
        timeDesc.backgroundColor = [UIColor clearColor];
        timeDesc.text = time_description;
        [timeDesc setFont:[UIFont fontWithName:@"verdana" size:12]];
        [self addSubview:timeDesc];
        [timeDesc release];
    }
    
    // todo: construct the context info.
    [self buildContextInfo:story];
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
