//
//  totReviewFilterView.m
//  totdev
//
//  Created by Lixing Huang on 1/17/13.
//  Copyright (c) 2013 USC. All rights reserved.
//

#import "totReviewFilterView.h"
#import "totReviewFilterOpenerView.h"
#import "totReviewRootController.h"
#import "../Model/totEventName.h"

#define HEIGHT 0
#define WEIGHT 1
#define HEAD 2
#define DIAPER 3
#define LANGUAGE 4
#define SLEEP 5
#define EYE_CONTACT 6
#define VISION_ATTENTION 7
#define MOTOR_SKILL 8
#define EMOTION 9
#define CHEW 10
#define GESTURE 11
#define MIRROR_TEST 12
#define IMITATION 13
#define FEEDING 14

@implementation totReviewFilterView

@synthesize opener;
@synthesize parentController;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:64.0/255 green:165.0/255 blue:193.0/255 alpha:1.0];
        
        NSArray *types = [NSArray arrayWithObjects:@"height",@"weight",@"head",@"diaper",@"language",
                                                   @"sleep",@"eye_contact",@"vision_attention",@"motor_skill",
                                                   @"emotion",@"chew",@"gesture",@"mirror_test",@"imitation",
                                                   @"food", nil];  // 15 items
        int gap = 10;
        int icon_per_row = 4;
        int icon_per_col = 4;
        int icon_w = (frame.size.width - (icon_per_row+1)*gap) / icon_per_row;
        int icon_h = (frame.size.height - (icon_per_col+1)*gap) / icon_per_col;
        for (int r=1; r<=4; r++) {
            for (int c=1; c<=4; c++) {
                int x = c*gap + (c-1)*icon_w;
                int y = r*gap + (r-1)*icon_h;
                int index = (r-1)*4 + (c-1);
                if (index >= [types count])
                    break;

                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(x, y, icon_w, icon_h);
                btn.tag = index;
                NSString *iconName = [NSString stringWithFormat:@"%@.png", [types objectAtIndex:index]];
                [btn setImage:[UIImage imageNamed:iconName]
                          forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:btn];
            }
        }
        
    }
    return self;
}

- (void)buttonPressed:(id)sender {
    NSString *event = nil;
    UIButton *btn = (UIButton*)sender;
    int tag = btn.tag;
    NSArray *event_names = [NSArray arrayWithObjects:EVENT_BASIC_HEIGHT, EVENT_BASIC_WEIGHT,
                            EVENT_BASIC_HEAD, EVENT_BASIC_DIAPER, EVENT_BASIC_LANGUAGE,
                            EVENT_BASIC_SLEEP, @"eye_contact", @"vision_attention", @"motor_skill",
                            @"emotion", @"chew", @"gesture", @"mirror_test", @"imitation", @"feeding", nil];
    if (0<=tag && tag<[event_names count]) {
        event = [event_names objectAtIndex:tag];
    } else {
        event = @"total";
    }
    if ([event isEqualToString:@"total"])
        [parentController loadEvents:YES ofType:nil];
    else
        [parentController loadEvents:YES ofType:event];
    [opener fold];
}

- (void)dealloc {
    [opener release];
    [super dealloc];
}

@end
