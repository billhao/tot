//
//  totTimerController.m
//  totdev
//
//  Created by Lixing Huang on 5/5/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totTimerController.h"

#define PICKER_COMPONENT_WIDTH 100
#define PICKER_HEIGHT          200
#define BUTTON_WIDTH           90
#define BUTTON_HEIGHT          50

#define START_YEAR             2012
#define END_YEAR               2020

@implementation totTimerController

@synthesize mMode;
@synthesize mCurrentAmPm;
@synthesize mCurrentDayIdx;
@synthesize mCurrentHourIdx;
@synthesize mCurrentMonthIdx;
@synthesize mCurrentMinuteIdx;
@synthesize mCurrentYearIdx;
@synthesize mWidth;
@synthesize mHeight;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init {
    mComponentHeight= PICKER_HEIGHT;
    mComponentWidth = PICKER_COMPONENT_WIDTH;
    mWidth = 3*mComponentWidth+20;
    mHeight= mComponentHeight+10+BUTTON_HEIGHT;
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)setCurrentTime {
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // extract hour and minute values
    NSArray *tokens = [[dateFormatter stringFromDate:now] componentsSeparatedByString:@" "];
    NSArray *comps1 = [[tokens objectAtIndex:0] componentsSeparatedByString:@"-"];
    NSArray *comps2 = [[tokens objectAtIndex:1] componentsSeparatedByString:@":"];
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    
    if( mMode == kTime ) {
        int h = [[f numberFromString:[comps2 objectAtIndex:0]] intValue];
        int m = [[f numberFromString:[comps2 objectAtIndex:1]] intValue];
        int ap = 0;
        if ( h > 11 ) ap = 1;
        if ( h > 12 ) h = h - 12;
        else if ( h == 0 ) h = 12;
        [self setCurrentHour:h andMinute:m andAmPm:ap];
    } else {
        int y = [[f numberFromString:[comps1 objectAtIndex:0]] intValue];
        int m = [[f numberFromString:[comps1 objectAtIndex:1]] intValue];
        int d = [[f numberFromString:[comps1 objectAtIndex:2]] intValue];
        [self setCurrentYear:y andMonth:m andDay:d];
    }
    
    [dateFormatter release];
    [f release];
}

#pragma mark - UIPickerView delegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if( mMode == kTime ) {
        if( component == kPickerHour )
            mCurrentHourIdx = row;
        else if( component == kPickerMinute )
            mCurrentMinuteIdx = row;
        else
            mCurrentAmPm = row;
    } else {
        if( component == kPickerYear )
            mCurrentYearIdx = row;
        else if( component == kPickerMonth )
            mCurrentMonthIdx = row;
        else
            mCurrentDayIdx = row;
    }
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if( mMode == kTime ) {
        if ( component == kPickerAmPm )
            return [mAmPm count];
        else if ( component == kPickerMinute )
            return [mMinute count];
        else
            return [mHour count];
    } else {
        if ( component == kPickerYear )
            return [mYear count];
        else if ( component == kPickerMonth )
            return [mMonth count];
        else
            return [mDay count];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if( mMode == kTime ) {
        if( component == kPickerHour ) {
            return [mHour objectAtIndex:row];
        } else if( component == kPickerMinute ) {
            return [mMinute objectAtIndex:row];
        } else {
            return [mAmPm objectAtIndex:row];
        }
    } else {
        if( component == kPickerYear ) {
            return [mYear objectAtIndex:row];
        } else if( component == kPickerMonth ) {
            return [mMonth objectAtIndex:row];
        } else {
            return [mDay objectAtIndex:row];
        }
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return mComponentWidth;
}


#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void)setMode:(int)m { mMode = m; }

- (void)setCurrentHour:(int)h andMinute:(int)m andAmPm:(int)ap {
    if( 1 <= h && h <= 12 ) {
        mCurrentHourIdx = h-1;
        [mTimePicker selectRow:h-1 inComponent:kPickerHour animated:NO];
    }
    if( 0 <= m && m <= 59 ) {
        mCurrentMinuteIdx = m;
        [mTimePicker selectRow:m inComponent:kPickerMinute animated:NO];
    }
    if( 0 <= ap && ap <= 1 ) {
        mCurrentAmPm = ap;
        [mTimePicker selectRow:ap inComponent:kPickerAmPm animated:NO];
    }
}

- (void)setCurrentYear:(int)y andMonth:(int)m andDay:(int)d {
    if( START_YEAR <= y && y <= END_YEAR ) {
        mCurrentYearIdx = (y-START_YEAR);
        [mTimePicker selectRow:(y-START_YEAR) inComponent:kPickerYear animated:NO];
    }
    if( 1 <= m && m <= 12 ) {
        mCurrentMonthIdx = m-1;
        [mTimePicker selectRow:(m-1) inComponent:kPickerMonth animated:NO];
    }
    if( 1 <= d && d <= 31 ) {
        mCurrentDayIdx = d-1;
        [mTimePicker selectRow:(d-1) inComponent:kPickerDay animated:NO];
    }
}

// hao edited, Jan 30, 2013
// call delegate saveCurrentTime with date/time in both string and NSDate formats
- (void)buttonPressed: (id)sender {
    UIButton *btn = (UIButton*)sender;
    int tag = btn.tag;
    if( tag == kButtonOK ) {
        if( [delegate respondsToSelector:@selector(saveCurrentTime:datetime:)] ) {
            NSString *time = nil;
            NSDate* date = nil;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            if( mMode == kTime ) {
                // prepare the string object for the delegate
                time = [[NSString alloc] initWithFormat:@"%s:%s %s",
                        [[mHour objectAtIndex:mCurrentHourIdx] UTF8String],
                        [[mMinute objectAtIndex:mCurrentMinuteIdx] UTF8String],
                        [[mAmPm objectAtIndex:mCurrentAmPm] UTF8String]];
                
                // prepare the NSDate object for the delegate
                // set the date to today because a NSDate object must have a date component
                [dateFormatter setDateStyle:NSDateFormatterShortStyle];
                [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
                NSString* datetime = [NSString stringWithFormat:@"%@ %@", [dateFormatter stringFromDate:[NSDate date]], time];
                [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
                date = [dateFormatter dateFromString:datetime];
            } else {
                // prepare the string object for the delegate
                int m = [[mMonth objectAtIndex:mCurrentMonthIdx] intValue];
                time = [[NSString alloc] initWithFormat:@"%s %s, %s",
                        [[totTimerController getMonthString:m] UTF8String],
                        [[mDay objectAtIndex:mCurrentDayIdx] UTF8String],
                        [[mYear objectAtIndex:mCurrentYearIdx] UTF8String]];

                // prepare the NSDate object for the delegate
                [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
                date = [dateFormatter dateFromString:time];
            }

            // call the delegate
            [delegate saveCurrentTime:time datetime:date];
            [time release];
            [dateFormatter release];
        }
    } else if( tag == kButtonCancel ) {
        if( [delegate respondsToSelector:@selector(cancelCurrentTime)] ) {
            [delegate cancelCurrentTime];
        }
    }
}

+ (NSString*)getMonthString:(int)month {
    switch (month) {
        case 1:
            return @"Jan";
            break;
        case 2:
            return @"Feb";
            break;
        case 3:
            return @"Mar";
            break;
        case 4:
            return @"Apr";
            break;
        case 5:
            return @"May";
            break;
        case 6:
            return @"Jun";
            break;
        case 7:
            return @"Jul";
            break;
        case 8:
            return @"Aug";
            break;
        case 9:
            return @"Sep";
            break;
        case 10:
            return @"Oct";
            break;
        case 11:
            return @"Nov";
            break;
        case 12:
            return @"Dec";
            break;
    }
    return @"";
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
   [super viewDidLoad];

    self.view.userInteractionEnabled = YES;
    
    int buttonWidth = BUTTON_WIDTH, 
        buttonHeight = BUTTON_HEIGHT;
    // use am pm symbol from current local
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    mAmPm = [[NSMutableArray alloc] init];
    [mAmPm addObject:dateFormatter.AMSymbol];
    [mAmPm addObject:dateFormatter.PMSymbol];
    
    mHour = [[NSMutableArray alloc] init];
    for ( int i = 1; i <= 12; i++ ) 
        [mHour addObject:[NSString stringWithFormat:@"%d", i]];
    mMinute = [[NSMutableArray alloc] init];
    for ( int i = 0; i <= 59; i++ ) 
        [mMinute addObject:[NSString stringWithFormat:@"%02d", i]];
    
    mYear = [[NSMutableArray alloc] init];
    for( int i = 2012; i <= 2020; i++ ) 
        [mYear addObject:[NSString stringWithFormat:@"%d", i]];
    mMonth = [[NSMutableArray alloc] init];
    for( int i = 1; i <= 12; i++ ) 
        [mMonth addObject:[NSString stringWithFormat:@"%02d", i]];
    mDay = [[NSMutableArray alloc] init];
    for( int i = 1; i <= 31; i++ ) 
        [mDay addObject:[NSString stringWithFormat:@"%02d", i]];
    
    mTimePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, -10, mWidth, mComponentHeight)];
    mTimePicker.dataSource = self;
    mTimePicker.delegate = self;
    mTimePicker.showsSelectionIndicator = YES;
    
    [self.view addSubview:mTimePicker];
    
    // add buttons
    int margin = (mWidth-(2*buttonWidth+10))/2;
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    okBtn.frame = CGRectMake(margin, mComponentHeight-10, buttonWidth, buttonHeight);
    okBtn.tag = kButtonOK;    
    [okBtn setTitle:@"OK" forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelBtn.frame = CGRectMake(mWidth-margin-buttonWidth, mComponentHeight-10, buttonWidth, buttonHeight);
    cancelBtn.tag = kButtonCancel;
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [mTimePicker release];
    [mAmPm release];
    [mHour release];
    [mMinute release];
    [mYear release];
    [mMonth release];
    [mDay release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
