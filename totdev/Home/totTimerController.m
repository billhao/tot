//
//  totTimerController.m
//  totdev
//
//  Created by Lixing Huang on 5/5/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totTimerController.h"
#import "totUtility.h"

#define PICKER_COMPONENT_WIDTH 100
#define PICKER_HEIGHT          200
#define BUTTON_WIDTH           90
#define BUTTON_HEIGHT          50

#define START_YEAR             2013
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
@synthesize mTimePicker, datetime;

- (id)init:(UIView*)superView {
    self = [super init];
    if( self ) {
        mComponentHeight= PICKER_HEIGHT;
        mComponentWidth = PICKER_COMPONENT_WIDTH;
        mWidth = 3*mComponentWidth+20;
        mHeight= mComponentHeight;//+10+BUTTON_HEIGHT;
        
        mSuperView = [superView retain];
    }
    return self;
}

// show this picker
- (void)show {
    [mHiddenText becomeFirstResponder];
}

// dismiss this picker
- (void)dismiss {
    [mHiddenText resignFirstResponder];
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

- (void)setMode:(int)m {
    mMode = m;
    // need to reload all components
    [mTimePicker reloadAllComponents];
}

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
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            NSString* dt;
            if( mMode == kTime ) {
                // prepare the string object for the delegate
                dt = [NSString stringWithFormat:@"%@:%@ %@",
                        [mHour objectAtIndex:mCurrentHourIdx],
                        [mMinute objectAtIndex:mCurrentMinuteIdx],
                        [mAmPm objectAtIndex:mCurrentAmPm]];
                
                // prepare the NSDate object for the delegate
                // set the date to today because a NSDate object must have a date component
                [dateFormatter setDateStyle:NSDateFormatterShortStyle];
                [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
                dt = [NSString stringWithFormat:@"%@ %@", [dateFormatter stringFromDate:datetime], dt];
            } else {
                // prepare the NSDate object for the delegate
                [dateFormatter setDateStyle:NSDateFormatterNoStyle];
                [dateFormatter setTimeStyle:NSDateFormatterShortStyle];

                // prepare the string object for the delegate
                dt = [NSString stringWithFormat:@"%@/%@/%@ %@",
                        [mMonth objectAtIndex:mCurrentMonthIdx],
                        [mDay objectAtIndex:mCurrentDayIdx],
                        [mYear objectAtIndex:mCurrentYearIdx],
                        [dateFormatter stringFromDate:datetime]];
            }

            [dateFormatter setDateFormat:@"MM/dd/yy h:m a"];
            NSDate* date = [dateFormatter dateFromString:dt];

            // call the delegate
            [delegate saveCurrentTime:dt datetime:date];
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
    
    // this is important. without this the system will auto resize this view to keyboard size
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;

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
    
    mTimePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, mWidth, mComponentHeight)];
    mTimePicker.dataSource = self;
    mTimePicker.delegate = self;
    mTimePicker.showsSelectionIndicator = YES;
    
    [self.view addSubview:mTimePicker];
    
    // set the size of this picker, x and y doesn't really matter here, it seems ios sets y accordingly
    //self.view.frame = CGRectMake(0, 0, 320, 200);

    // create a hidden text view, the input view of which is associated with this picker
    mHiddenText = [[UITextView alloc]initWithFrame:CGRectMake(-1, -1, 0, 0)];
    [mSuperView addSubview:mHiddenText];
    mHiddenText.inputView = self.view;
    mHiddenText.inputAccessoryView = [self createInputAccessoryView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // this is important. it sets the height of this view according to picker height
    CGRect f = self.view.frame;
    f.size.height = mTimePicker.frame.size.height;
    self.view.frame = f;
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
    [mHiddenText release];
    [mSuperView release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UIView*)createInputAccessoryView{
    // create a done view + done button, attach to it a doneClicked action, and place it in a toolbar as an accessory input view...
    // Prepare done button
    UIToolbar* keyboardDoneButtonView	= [[[UIToolbar alloc] init] autorelease];
    keyboardDoneButtonView.barStyle		= UIBarStyleBlack;
    keyboardDoneButtonView.translucent	= YES;
    keyboardDoneButtonView.tintColor	= nil;
    [keyboardDoneButtonView sizeToFit];
    
    UIBarButtonItem* okButton     = [[UIBarButtonItem alloc] initWithTitle:@"OK" style:UIBarButtonItemStyleDone  target:self action:@selector(buttonPressed:)];
    okButton.tag = kButtonOK;
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered  target:self action:@selector(buttonPressed:)];
    cancelButton.tag = kButtonCancel;
    
    // I put the spacers in to push the doneButton to the right side of the picker view
    UIBarButtonItem *spacer    = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:cancelButton, spacer, okButton, nil]];
    [spacer release];
    
    return keyboardDoneButtonView;
}

@end
