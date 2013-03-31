//
//  totReviewStoryView.m
//  totdev
//
//  Created by Lixing Huang on 6/2/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "totReviewStoryView.h"
#import "AppDelegate.h"
#import "../Model/totModel.h"
#import "../Model/totEvent.h"
#import "totHomeFeedingViewController.h"
#import "totEventName.h"

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
        
        // add bg
        UIImage* img = [UIImage imageNamed:@"review_bg"];
        UIImageView* bgview = [[UIImageView alloc] initWithImage:img];
        bgview.frame = CGRectMake(0, 0, img.size.width, img.size.height);
        [self addSubview:bgview];
        [self sendSubviewToBack:bgview];
        [bgview release];
    }
    return self;
}

// get the type icon file name
- (NSString*)getTypeIcon:(totReviewStory*)story {
    NSArray* tokens = [story.mEventType componentsSeparatedByString:@"/"];
    NSString* category = [tokens objectAtIndex:0];
    
    if ([category isEqualToString:@"basic"]) {
        return [NSString stringWithFormat:@"review-%s", [[tokens objectAtIndex:1] UTF8String]];
    }
    // ignore activity for now
    /*
    else if ([category isEqualToString:@"eye_contact"]) {
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
    }
    */
    else {
        printf("Has not implemented yet.\n");
        return nil;
    }
}

// get the story description
- (BOOL) isFirstOccurrence:(totReviewStory*)story {
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    //totModel * database = [appDelegate getDataModel];
    return NO;
}
- (NSString*)getStoryDescription:(totReviewStory*)story {
    NSString * desc = nil;
    NSArray * tokens = [story.mEventType componentsSeparatedByString:@"/"];
    NSString * category = [tokens objectAtIndex:0];
    NSString * rawValue = story.mRawContent;
    
    if ([category isEqualToString:@"basic"]) {
        NSString* subcategory = [tokens objectAtIndex:1];
        
        if ([subcategory isEqualToString:@"diaper"]) {
            desc = @"Diaper";
        }
        else if ([subcategory isEqualToString:@"language"]) {
            desc = [NSString stringWithFormat:@"%@ learned %@", global.baby.name, rawValue];
        }
        else if ([subcategory isEqualToString:@"sleep"]) {
            if ([rawValue isEqualToString:@"end"]) {
                desc = @"woke up";
            } else if ([rawValue isEqualToString:@"start"]) {
                desc = @"fell asleep";
            }
        }
        else if ([subcategory isEqualToString:@"height"]) {
            desc = [NSString stringWithFormat:@"%@ is %@", global.baby.name, rawValue];
        }
        else if ([subcategory isEqualToString:@"weight"]) {
            desc = [NSString stringWithFormat:@"%@ is %@", global.baby.name, rawValue];
        }
        else if ([subcategory isEqualToString:@"head"]) {
            desc = [NSString stringWithFormat:@"%@ is %@", global.baby.name, rawValue];
        }
        else if ([subcategory isEqualToString:@"feeding"]) {
            desc = @"Feeding";  //[NSString stringWithString:@"Feeding"];
        }
    }
    // ignore activity for now
    /*
    else if ([category isEqualToString:@"eye_contact"]) {
        if ([self isFirstOccurrence:story]) {
            desc = @"first eye contact";
        } else {
            desc = @"has an eye contact";
        }
    } else if ([category isEqualToString:@"vision_attention"]) {
        if ([self isFirstOccurrence:story]) {
            desc = @"first vision attention";
        } else {
            desc = @"has a vision attention";
        }
    } else if ([category isEqualToString:@"chew"]) {
        if ([self isFirstOccurrence:story]) {
            desc = @"first chew";
        } else {
            desc = @"chewed";
        }
    } else if ([category isEqualToString:@"mirror_test"]) {
        if ([self isFirstOccurrence:story]) {
            desc = @"first mirror test";
        } else {
            desc = @"has a mirror test";
        }
    } else if ([category isEqualToString:@"imitation"]) {
        if ([self isFirstOccurrence:story]) {
            desc = @"first imitation";
        } else {
            desc = @"has an imitation";
        }
    } else if ([category isEqualToString:@"motor_skill"]) {
        NSString* subcategory = [tokens objectAtIndex:1];
        if ([self isFirstOccurrence:story]) {
            desc = [NSString stringWithFormat:@"first %s", [subcategory UTF8String]];
        } else {
            desc = [NSString stringWithFormat:@"%s", [subcategory UTF8String]];
        }
    } else if ([category isEqualToString:@"emotion"]) {
        NSString* subcategory = [tokens objectAtIndex:1];
        if ([self isFirstOccurrence:story]) {
            desc = [NSString stringWithFormat:@"first %s", [subcategory UTF8String]];
        } else {
            desc = [NSString stringWithFormat:@"%s", [subcategory UTF8String]];
        }
    } else if ([category isEqualToString:@"gesture"]) {
        NSString* subcategory = [tokens objectAtIndex:1];
        if ([self isFirstOccurrence:story]) {
            desc = [NSString stringWithFormat:@"first %s", [subcategory UTF8String]];
        } else {
            desc = [NSString stringWithFormat:@"%s", [subcategory UTF8String]];
        }
    }
    */
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
- (void)buildContextInfo:(totReviewStory*)story withFrame:(CGRect)frame withinParent:(UIView*)parent {
    totModel* database = global.model;
    
    NSArray* tokens = [story.mEventType componentsSeparatedByString:@"/"];
    NSString* category = [tokens objectAtIndex:0];
    
    int padding = 10;
    if ([category isEqualToString:@"basic"]) {
        UILabel * context
            = [[UILabel alloc] initWithFrame:CGRectMake(padding, padding, frame.size.width-padding, frame.size.height-padding)];
        context.backgroundColor = [UIColor clearColor];
        context.textColor = [UIColor colorWithRed:128.0/255 green:130.0/255 blue:133.0/255 alpha:1];
        [context setFont:[UIFont fontWithName:@"Roboto-Regular" size:12]];
        context.textAlignment = UITextAlignmentCenter;
        context.numberOfLines = 5;
        
        NSString * subcategory = [tokens objectAtIndex:1];
        
        if ([subcategory isEqualToString:@"height"]) {
            NSArray* events = [database getEvent:global.baby.babyID event:story.mEventType];

            totEvent* currEvt = [events objectAtIndex:0];
            if( events.count > 1 ) {
                totEvent* prevEvt = [events objectAtIndex:1];
                float incr = [currEvt.value floatValue] - [prevEvt.value floatValue];
            
                context.text = [NSString stringWithFormat:@"%@ is %f taller than last time", global.baby.name, incr];
            }
        }
        
        else if ([subcategory isEqualToString:@"language"]) {
            //NSArray* events = [database getEvent:global.baby.babyID event:story.mEventType];
            NSArray* events = [database getPreviousEvent:global.baby.babyID
                                                   event:story.mEventType
                                                   limit:-1
                                      current_event_date:story.mWhen];
            NSString* desc = [NSString stringWithFormat:@"%@ has learned %d words", global.baby.name, [events count]];
            
            context.text = desc;
        }
        
        else if ([subcategory isEqualToString:@"sleep"]) {
            if ([story.mRawContent isEqualToString:@"end"]) {
                // query db to get how long the baby had slept
                NSMutableArray* sleep = [global.model getPreviousEvent:global.baby.babyID event:EVENT_BASIC_SLEEP limit:1 current_event_date:story.mWhen];
                if( sleep.count > 0 ) {
                    totEvent* e = sleep[0];
                    //NSLog(@"%d %@ - %d %@", e.event_id, e.datetime, story.mEventId, story.mWhen);
                    
                    // Get conversion to months, days, hours, minutes
                    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
                    unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
                    NSDateComponents *conversionInfo = [sysCalendar components:unitFlags fromDate:e.datetime  toDate:story.mWhen options:0];
                    
                    int h = [conversionInfo hour];
                    int m = [conversionInfo minute];
                    int s = [conversionInfo second];
                    
                    NSString* text;
                    if( h>0 && m<10 ) {
                        if( h==1 )
                            text = [NSString stringWithFormat:@"%@ slept for about an hour", global.baby.name];
                        else
                            text = [NSString stringWithFormat:@"%@ slept for about %d hours", global.baby.name, h];
                    }
                    else if( m>50 ) {
                        if( h==0 )
                            text = [NSString stringWithFormat:@"%@ slept for about an hour", global.baby.name];
                        else
                            text = [NSString stringWithFormat:@"%@ slept for about %d hours", global.baby.name, h+1];
                    }
                    else if( h==0 && m==0 )
                        text = [NSString stringWithFormat:@"%@ slept for less than a minute", global.baby.name];
                    else if( h==0 && m==1 )
                        text = [NSString stringWithFormat:@"%@ slept for a minute", global.baby.name];
                    else if( h==0 && m>1 )
                        text = [NSString stringWithFormat:@"%@ slept for %d minutes", global.baby.name, m];
                    else if( h>=15 )
                        text = [NSString stringWithFormat:@"%@ slept for %d hours. Really?", global.baby.name, h];
                    else
                        text = [NSString stringWithFormat:@"%@ slept for %d hours %d minutes", global.baby.name, h, m];
                    context.text = text;
                }
                else {
                    context.text = @"";
                }
            }
        }
        else if ([subcategory isEqualToString:@"feeding"]) {
            NSArray* foodlist = [totHomeFeedingViewController stringToJSON:story.mRawContent];
            if( foodlist.count > 0 ){
                NSMutableString* summary = [[NSMutableString alloc] initWithFormat:@"%@ ate", global.baby.name];
                Boolean first = true;
                for (int i=0; i<foodlist.count; i++) {
                    NSDictionary* food = foodlist[i];
                    if( foodlist.count>=2 && i+1 == foodlist.count ) // second but last, add "and"
                        [summary appendString:@" and"];
                    else if( i > 0 ) // from the second one, add comma
                        [summary appendString:@","];
                    [summary appendFormat:@" %@oz %@", food[@"quantity"], food[@"name"] ];
                }
                context.text = summary;
                [summary release];
            }
            else
                context.text = @"";
        }
        else if ([subcategory isEqualToString:@"diaper"]) {
            context.text = [NSString stringWithFormat:@"%@ had a %@ diaper", global.baby.name, story.mRawContent];
        }
        
        [parent addSubview:context];
        [context release];
    }
    // ignore activity for now
    /*
    else if ([category isEqualToString:@"emotion"] || [category isEqualToString:@"motor_skill"] ||
             [category isEqualToString:@"gesture"] || [category isEqualToString:@"eye_contact"] ||
             [category isEqualToString:@"vision_attention"] || [category isEqualToString:@"chew"] ||
             [category isEqualToString:@"mirror_test"] || [category isEqualToString:@"imitation"]) {

        if ([tokens count] > 1) {
            NSString* subcategory = [tokens objectAtIndex:1];
            printf("subcategory: %s\n", [subcategory UTF8String]);
        }

        UIButton* img = [[UIButton alloc] initWithFrame:CGRectMake(padding, padding, 40, 60)];
        NSArray* tokens = [story.mRawContent componentsSeparatedByString:@";"];
        NSString* imgPath = nil;
        NSString* comment = nil;
        BOOL isVideo = NO;
        for (int i = 0; i < [tokens count]; ++i) {
            NSArray* comps = [[tokens objectAtIndex:i] componentsSeparatedByString:@"="];
            NSString* key = [comps objectAtIndex:0];
            NSString* val = [comps objectAtIndex:1];
            if ([key isEqualToString:@"image"]) {
                imgPath = [NSString stringWithString:val];
            } else if ([key isEqualToString:@"video"]) {
                isVideo = YES;
            } else if ([key isEqualToString:@"desc"]) {
                comment = [NSString stringWithString:val];
            }
        }
        img.layer.cornerRadius = 3.0;
        img.layer.masksToBounds = YES;
        [img setImage:[UIImage imageWithContentsOfFile:imgPath] forState:UIControlStateNormal];
        [parent addSubview:img];
        [img release];
    }
    */
}

// generate story view
- (void)generate:(totReviewStory*)story {
    if (!story) {
        printf("story is null. check it out.\n");
        exit(1);
    }
    
    NSString *icon_filename = [self getTypeIcon:story];
    if (icon_filename) {
        UIImageView * icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 45, 50, 50)];
        //icon.contentMode = UIViewContentModeScaleAspectFit;
        UIImage* img = [UIImage imageNamed:icon_filename];
        CGSize frame = img.size;
        [icon setImage:[UIImage imageNamed:icon_filename]];
//        [icon.layer setBorderColor: [[UIColor blackColor] CGColor]];
//        [icon.layer setBorderWidth: 1.0];
        [self addSubview:icon];
        [icon release];
    }
    
    NSString *description = [self getStoryDescription:story];
    if (description) {
        UILabel *storyDesc = [[UILabel alloc] initWithFrame:CGRectMake(115, 35, 160, 12)];
        storyDesc.backgroundColor = [UIColor clearColor];
        storyDesc.text = description;
        storyDesc.textAlignment = UITextAlignmentRight;
        storyDesc.textColor = [UIColor colorWithRed:128.0/255 green:130.0/255 blue:133.0/255 alpha:1];
        [storyDesc setFont:[UIFont fontWithName:@"Roboto-Regular" size:12]];
        [self addSubview:storyDesc];
        [storyDesc release];
    }
    
    NSString *time_description = [self getStoryTime:story];
    if (time_description) {
        UILabel *timeDesc = [[UILabel alloc] initWithFrame:CGRectMake(115, 19, 160, 12)];
        timeDesc.backgroundColor = [UIColor clearColor];
        timeDesc.text = time_description;
        timeDesc.textAlignment = UITextAlignmentRight;
        timeDesc.textColor = [UIColor colorWithRed:128.0/255 green:130.0/255 blue:133.0/255 alpha:1];
        [timeDesc setFont:[UIFont fontWithName:@"Roboto-Regular" size:12]];
        [self addSubview:timeDesc];
        [timeDesc release];
    }
    
    // construct the context info.
    if ([story hasContext]) {
        UIView *context = [[UIView alloc] initWithFrame:CGRectMake(122, 57, 145, 45)];
        [self buildContextInfo:story withFrame:CGRectMake(0, 0, 145, 45) withinParent:context];
        [self addSubview:context];
        [context release];
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
