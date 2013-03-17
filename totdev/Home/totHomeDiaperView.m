//
//  totHomeDiaperView.m
//  totdev
//
//  Created by Lixing Huang on 10/10/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "AppDelegate.h"
#import "totHomeDiaperView.h"
#import "../Model/totModel.h"
#import "../Model/totEventName.h"

@implementation totHomeDiaperView

//////////////////////////////////////////////////
// find the current time.
- (void)findCurrentTime {
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // extract hour and minute values
    NSArray *tokens = [[dateFormatter stringFromDate:now] componentsSeparatedByString:@" "];
    NSArray *comps1 = [[tokens objectAtIndex:0] componentsSeparatedByString:@"-"];
    NSArray *comps2 = [[tokens objectAtIndex:1] componentsSeparatedByString:@":"];
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    mYear   = [[f numberFromString:[comps1 objectAtIndex:0]] intValue];
    mMonth  = [[f numberFromString:[comps1 objectAtIndex:1]] intValue];
    mDay    = [[f numberFromString:[comps1 objectAtIndex:2]] intValue];
    mHour   = [[f numberFromString:[comps2 objectAtIndex:0]] intValue];
    mMinute = [[f numberFromString:[comps2 objectAtIndex:1]] intValue];
    mSecond = [[f numberFromString:[comps2 objectAtIndex:2]] intValue];
    [f release];
    [dateFormatter release];
}

// set the clock to the current time. the current time is got by calling findCurrentTime
- (void)tuneClockToCurrentTime {
    [self findCurrentTime];
    
    int h = mHour;
    if ( h > 11 ) mAp = 1;
    if ( h > 12 ) h = h - 12;
    else if ( h == 0 ) h = 12;
    [mClock setCurrentHour:h
                 andMinute:mMinute
                   andAmPm:mAp];
}

// display the time picker
- (void)showTimePicker {
    [mClock show];
}

// hide the time picker
- (void)hideTimePicker {
    [mClock dismiss];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
        self.hidden = YES;
        
        mBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        mBackground.image = [UIImage imageNamed:@"background-diaper"];
        
        mSelectionWet       = [[totImageView alloc] initWithFrame:CGRectMake(64, 208, 193, 28)];
        mSelectionSolid     = [[totImageView alloc] initWithFrame:CGRectMake(64, 249, 193, 28)];
        mSelectionWetSolid  = [[totImageView alloc] initWithFrame:CGRectMake(64, 290, 193, 28)];

        mSelectionWet.mTag = SELECTION_WET;
        mSelectionSolid.mTag = SELECTION_SOLID;
        mSelectionWetSolid.mTag = SELECTION_WETSOLID;
        
        [mSelectionWet imageFilePath:@"icons-diaper-wet_new"];
        [mSelectionWet setDelegate:self];
        [mSelectionSolid imageFilePath:@"icons-diaper-solid_new"];
        [mSelectionSolid setDelegate:self];
        [mSelectionWetSolid imageFilePath:@"icons-diaper-wetandsolid_new"];
        [mSelectionWetSolid setDelegate:self];

        mClock = [[totTimerController alloc] init:self];
        mClock.view.frame = CGRectMake(0, 0, mClock.mWidth, mClock.mHeight);
        [mClock setMode:kTime];
        [mClock setDelegate:self];
        
        mSelectedIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icons-ok"]];
        mSelectedIcon.frame = CGRectMake(320, 480, 30, 30);
        
        mDiaperType = -1;
    }
    return self;
}

- (void)showDiaperView {
    // change the background
    [self addSubview:mBackground];
    
    // constructs the layout
    // the current design consists of three sections
    mCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mCloseButton setTag:BUTTON_CLOSE];
    [mCloseButton setFrame:CGRectMake(270, 150, 40, 40)];
    [mCloseButton setImage:[UIImage imageNamed:@"icons-close.png"] forState:UIControlStateNormal];
    [mCloseButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:mCloseButton];
    
    // Time section
    // get the current time
    [self findCurrentTime];
    NSString * timeDesc = [NSString stringWithFormat:@"%02d:%02d", mHour, mMinute];
    
    mTimeLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    [mTimeLabel setTag:BUTTON_TIME];
    [mTimeLabel setFrame:CGRectMake(60, 155, 200, 40)];
    [mTimeLabel setTitleColor:[UIColor colorWithRed:128.0/255 green:130.0/255 blue:133.0/255 alpha:1] forState:UIControlStateNormal];
    [mTimeLabel setTitle:timeDesc forState:UIControlStateNormal];
    [mTimeLabel.titleLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:20.0]];
    [mTimeLabel addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:mTimeLabel];
    
    // Selection section
    [self addSubview:mSelectionWet];
    [self addSubview:mSelectionSolid];
    [self addSubview:mSelectionWetSolid];
    [self addSubview:mSelectedIcon];
    
    // Control section
//    mControlShare = [UIButton buttonWithType:UIButtonTypeCustom];
//    [mControlShare setTag:BUTTON_SHARE];
//    [mControlShare setFrame:CGRectMake(60, 340, 50, 50)];
//    [mControlShare setImage:[UIImage imageNamed:@"icons-share.png"] forState:UIControlStateNormal];
//    [mControlShare addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:mControlShare];
//    
//    mControlHistory = [UIButton buttonWithType:UIButtonTypeCustom];
//    [mControlHistory setTag:BUTTON_HISTORY];
//    [mControlHistory setFrame:CGRectMake(140, 340, 50, 50)];
//    [mControlHistory setImage:[UIImage imageNamed:@"icons-history.png"] forState:UIControlStateNormal];
//    [mControlHistory addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:mControlHistory];
    
    UIImage* okImg = [UIImage imageNamed:@"icons-ok"];
    mControlConfirm = [UIButton buttonWithType:UIButtonTypeCustom];
    [mControlConfirm setTag:BUTTON_CONFIRM];
    [mControlConfirm setFrame:CGRectMake(210, 350, okImg.size.width, okImg.size.height)];
    [mControlConfirm setImage:okImg forState:UIControlStateNormal];
    [mControlConfirm addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:mControlConfirm];
    
    // reset selection
    mDiaperType = -1;
    [self showSelection:SELECTION_HIDE];
    
    [self setHidden:NO];
}

- (void)hideDiaperView {
    [mBackground removeFromSuperview];
    [mSelectionWet removeFromSuperview];
    [mSelectionSolid removeFromSuperview];
    [mSelectionWetSolid removeFromSuperview];
    [mSelectedIcon removeFromSuperview];
    
    [mControlShare removeFromSuperview];
    [mControlHistory removeFromSuperview];
    [mControlConfirm removeFromSuperview];
    [mTimeLabel removeFromSuperview];
    
    [self setHidden:YES];
}

#pragma mark - totTimerControllerDelegate
-(void)saveCurrentTime:(NSString*)time datetime:(NSDate*)datetime {
    [self hideTimePicker];
    
    mAp = mClock.mCurrentAmPm;
    mHour = mClock.mCurrentHourIdx+1;
    mMinute = mClock.mCurrentMinuteIdx;
    if ( mAp == 1 && mHour != 12 ) mHour += 12;
    
    NSString * now = [NSString stringWithFormat:@"%02d:%02d", mHour, mMinute];
    [mTimeLabel setTitle:now forState:UIControlStateNormal];
}

-(void)cancelCurrentTime {
    [self hideTimePicker];
}

// save to database.
- (void)saveToDatabase:(int)selection {
    NSString * now = [NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d:%02d",
                      mYear, mMonth, mDay, mHour, mMinute, mSecond];
    printf("current time: %s selection: %d\n", [now UTF8String], selection);
    
    totModel *model = global.model;
    if (selection == SELECTION_WET) {
        [model addEvent:global.baby.babyID
                  event:EVENT_BASIC_DIAPER
         datetimeString:now
                  value:@"wet"];
    } else if (selection == SELECTION_SOLID) {
        [model addEvent:global.baby.babyID
                  event:EVENT_BASIC_DIAPER
         datetimeString:now
                  value:@"solid"];
    } else if (selection == SELECTION_WETSOLID) {
        [model addEvent:global.baby.babyID
                  event:EVENT_BASIC_DIAPER
         datetimeString:now
                  value:@"wetsolid"];
    }
}

#pragma mark - totImageView and button delegate
- (void)touchesEndedDelegate:(NSSet *)touches withEvent:(UIEvent *)event from:(int)tag {
    printf("pressed button %d in diaper view\n", tag);
    mDiaperType = tag;
    
    [self showSelection:tag];
}

- (void)showSelection:(int)tag {
    if (tag == SELECTION_WET) {
        [mSelectedIcon setFrame:CGRectMake(62, 206, 30, 30)];
    } else if (tag == SELECTION_SOLID) {
        [mSelectedIcon setFrame:CGRectMake(62, 247, 30, 30)];
    } else if (tag == SELECTION_WETSOLID) {
        [mSelectedIcon setFrame:CGRectMake(62, 288, 30, 30)];
    } else if (tag == SELECTION_HIDE) {
        // hide it
        [mSelectedIcon setFrame:CGRectMake(1000, 1000, 30, 30)];
    }
}

- (void)buttonPressed:(id)sender {
    UIButton * btn = (UIButton*)sender;
    printf("pressed button %d in diaper view\n", btn.tag);
    if (btn.tag == BUTTON_CLOSE) {
        [self hideDiaperView];
    } else if (btn.tag == BUTTON_TIME) {
        [self tuneClockToCurrentTime];
        [self showTimePicker];
    } else if (btn.tag == BUTTON_CONFIRM) {
        // save to database
        if (mDiaperType != -1) {
            [self saveToDatabase:mDiaperType];
        }
        [self hideDiaperView];
    }
}

- (void)dealloc {
    [mSelectionWetSolid release];
    [mSelectionSolid release];
    [mSelectionWet release];
    [mSelectedIcon release];
    [mBackground release];
    [mClock release];
    [super dealloc];
}

@end
