//
//  totLanguageCard.m
//  totdev
//
//  Created by Lixing Huang on 8/11/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import "totLanguageCard.h"
#import "totTimeUtil.h"
#import "totTimeline.h"

@implementation totLanguageEditCard

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackground];
        [self loadIcons];
        [self loadButtons];
    }
    return self;
}

- (void) setBackground {
    self.backgroundColor = [UIColor whiteColor];
}

- (void) loadIcons {
    UIImageView* icon = [[UIImageView alloc] initWithFrame:CGRectMake(CARD_ICON_X, CARD_ICON_Y, CARD_ICON_W, CARD_ICON_H)];
    icon.image = [UIImage imageNamed:@"circle_icon.jpg"];
    [self addSubview:icon];
    [icon release];
}

- (void) loadButtons {
    // Initializes timestamp.
    Walltime now; [totTimeUtil now:&now];
    
    time_button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [time_button1 setFrame:CGRectMake(TIME1_X, TIME_Y, TIME1_W, TIME_H)];
    [time_button1 setTitleColor:[UIColor colorWithRed:128.0/255 green:130.0/255 blue:130.0/255 alpha:1.0f]
                       forState:UIControlStateNormal];
    [time_button1 setTitle:[NSString stringWithFormat:@"%02d:%02d", now.hour, now.minute]
                  forState:UIControlStateNormal];
    [self addSubview:time_button1];
    
    time_button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [time_button2 setFrame:CGRectMake(TIME2_X, TIME_Y, TIME2_W, TIME_H)];
    [time_button2 setTitleColor:[UIColor colorWithRed:128.0/255 green:130.0/255 blue:130.0/255 alpha:1.0f]
                       forState:UIControlStateNormal];
    [time_button2 setTitle:[NSString stringWithFormat:@"%02d/%02d/%04d", now.month, now.day, now.year]
                  forState:UIControlStateNormal];
    [self addSubview:time_button2];
    
    confirm_button = [UIButton buttonWithType:UIButtonTypeCustom];
    confirm_button.backgroundColor = [UIColor greenColor];
    [confirm_button setFrame:CGRectMake(10, 160, 100, 30)];
    [confirm_button setTitle:@"Confirm" forState:UIControlStateNormal];
    [confirm_button addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirm_button];
    
    // text input area
    new_words_input = [[UITextView alloc] initWithFrame:CGRectMake(10, 100, 290, 40)];
    new_words_input.backgroundColor = [UIColor clearColor];
    [self addSubview:new_words_input];
    // text input area background
    UIView* background = [[UIView alloc] initWithFrame:CGRectMake(10, 100, 290, 40)];
    background.backgroundColor = [UIColor yellowColor];
    [self insertSubview:background belowSubview:new_words_input];
    [background release];
}

- (void) confirm: (UIButton*)button {
    // testing...
    [self.parentView.parent moveToTop:self.parentView];
}

+ (int) height { return 200; }
+ (int) width { return 310; }

- (void) dealloc {
    [super dealloc];
    [new_words_input release];
}

@end



@implementation totLanguageShowCard

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {}
    return self;
}

+ (int) height { return 200; }
+ (int) width { return 310; }

@end

