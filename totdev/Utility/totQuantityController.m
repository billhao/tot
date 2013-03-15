//
//  totQuantityController.m
//  totdev
//
//  Created by Chengjie on 03/14/2013
//  Copyright (c) 2013 USC. All rights reserved.
//

#import "totQuantityController.h"
#import "totUtility.h"

#define PICKER_COMPONENT_WIDTH 150
#define PICKER_HEIGHT          200
#define BUTTON_WIDTH           90
#define BUTTON_HEIGHT          50


@implementation totTimerController

@synthesize mQuantityPicked;
@synthesize mUnitPicked;
@synthesize mWidth;
@synthesize mHeight;
@synthesize delegate;
@synthesize mQuantityPicker;

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
    return 2;
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


xxxxxxxxxxxxxxxxxx setQuantityPicked
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


// call delegate saveCurrentTime with date/time in both string and NSDate formats
- (void)buttonPressed: (id)sender {
    UIButton *btn = (UIButton*)sender;
    int tag = btn.tag;
    if( tag == kButtonOK ) {
        if( [delegate respondsToSelector:@selector(saveQuantity:)] ) {
            NSString *q = nil; //quantity
            
            q = [[NSString alloc] initWithFormat:@"%s %s",
                 [[mQuantity objectAtIndex:mQuantityPicked] UTF8String],
                 [[mUnit objectAtIndex:mUnitPicked] UTF8String]];
            
            // call the delegate
            [delegate saveQuantity:q];
            [q release];
        }
    } else if( tag == kButtonCancel ) {
        if( [delegate respondsToSelector:@selector(cancelQuantity)] ) {
            [delegate cancelQuantity];
        }
    }
}

+ (NSString*)getUnitString:(int)u {
    switch (month) {
        case 1:
            return @"oz";
            break;
        case 2:
            return @"count";
            break;
        case 3:
            return @"lb";
            break;
        case 4:
            return @"g";
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
    
    mQuantity = [[NSMutableArray alloc] init];
    for ( int i = 0.1; i <= 0.9; i++ )
        [mQuantity addObject:[NSString stringWithFormat:@"%d", i]];
    for ( int i = 1; i <= 15; i+=0.5 )
        [mQuantity addObject:[NSString stringWithFormat:@"%d", i]];
    
    mUnit = [[NSMutableArray alloc] init];
    [mUnit addObject:[NSString stringWithFormat:@"oz"]];
    [mUnit addObject:[NSString stringWithFormat:@"count"]];
    [mUnit addObject:[NSString stringWithFormat:@"lb"]];
    [mUnit addObject:[NSString stringWithFormat:@"g"]];

    mQuantityPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, -10, mWidth, mComponentHeight)];
    mQuantityPicker.dataSource = self;
    mQuantityPicker.delegate = self;
    mTimePicker.showsSelectionIndicator = YES;
    
    [self.view addSubview:mQuantityPicker];
    
    // set the size of this picker, x and y doesn't really matter here, it seems ios sets y accordingly
    //self.view.frame = CGRectMake(0, 0, 320, 200);

    // create a hidden text view, the input view of which is associated with this picker
    mHiddenText = [[UITextView alloc]initWithFrame:CGRectMake(-1, -1, 0, 0)];
    [mSuperView addSubview:mHiddenText];
    mHiddenText.inputView = self.view;
    mHiddenText.inputAccessoryView = [self createInputAccessoryView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [mQuantityPicker release];
    
    [mQuantity release];
    [mUnit release];
    
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
    
    return keyboardDoneButtonView;
}

@end
