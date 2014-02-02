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

#define QUANTITY_RESOLUTION 0.5
#define MIN_QUANTITY 0.5
#define MAX_QUANTITY 30


@implementation totQuantityController

@synthesize mWidth;
@synthesize mHeight;
@synthesize delegate;
@synthesize mQuantityPicker;
@synthesize mCurrentQuantityIdx;
@synthesize mCurrentUnitIdx, inputAccessoryView;

- (id)init:(UIView*)superView {
    self = [super init];
    if( self ) {
        mComponentHeight= PICKER_HEIGHT;
        mComponentWidth = PICKER_COMPONENT_WIDTH;
        mWidth = 2*mComponentWidth+20;
        mHeight= mComponentHeight;//+10+BUTTON_HEIGHT;
        
        mSuperView = [superView retain];
        
        mHiddenText = nil;
        mTextField = nil;
        inputAccessoryView = [self createInputAccessoryView];
        
        // all possible units
        mUnit = [[NSMutableArray alloc] initWithObjects:NSLocalizedString(@"oz", @""),
                                                        NSLocalizedString(@"pc", @""),
                                                        NSLocalizedString(@"lb", @""),
                                                        NSLocalizedString(@"ct", @""), nil];
    }
    return self;
}

// use super's own textField instead of creating a hidden UITextView
- (id)init:(UIView*)superView textField:(UITextField*)textField {
    self = [self init:superView];
    if( self ) {
        mTextField = textField;
    }
    return self;
}

-(void)dealloc {
    [inputAccessoryView release];
    
    [super dealloc];
}

// show this picker
- (void)show {
    if(mHiddenText) [mHiddenText becomeFirstResponder];
}

// dismiss this picker
- (void)dismiss {
    if(mHiddenText) [mHiddenText resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - UIPickerView delegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if( component == kPickerQuantity )
        mCurrentQuantityIdx = row;
    else
        mCurrentUnitIdx = row;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if ( component == kPickerQuantity )
        return [mQuantity count];
    else
        return [mUnit count];

}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if( component == kPickerQuantity ) {
        return [mQuantity objectAtIndex:row];
    }
    else {
        return [mUnit objectAtIndex:row];
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

- (void)setQuantityPicked:(int)q andUnitPicked:(int)u{
    if( q >= 0 && q <= (MAX_QUANTITY - MIN_QUANTITY)/ QUANTITY_RESOLUTION ) {
        mCurrentQuantityIdx = q;
        [mQuantityPicker selectRow:q inComponent:kPickerQuantity animated:NO];
    }
    
    if( u >= 0 && u <= mUnit.count-1 ) {
        mCurrentUnitIdx = u;
        [mQuantityPicker selectRow:u inComponent:kPickerUnit animated:NO];
    }
}


// call delegate
- (void)buttonPressed: (id)sender {
    UIButton *btn = (UIButton*)sender;
    int tag = btn.tag;
    if( tag == kQUButtonOK ) {
        if( [delegate respondsToSelector:@selector(saveQuantity:)] ) {
            NSString *qu = nil; //quantity and unit
            
            qu = [[NSString alloc] initWithFormat:@"%@ %@",
                 [mQuantity objectAtIndex:mCurrentQuantityIdx],
                 [mUnit objectAtIndex:mCurrentUnitIdx]];
            
            // call the delegate
            [delegate saveQuantity:qu];
            [qu release];
        }
    } else if( tag == kQUButtonCancel ) {
        if( [delegate respondsToSelector:@selector(cancelQuantity)] ) {
            [delegate cancelQuantity];
        }
    }
}

- (NSString*)getUnitString:(int)i {
    return mUnit[i];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
   [super viewDidLoad];

    self.view.userInteractionEnabled = YES;
    
    // this is important. without this the system will auto resize this view to keyboard size
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    int buttonWidth = BUTTON_WIDTH, 
        buttonHeight = BUTTON_HEIGHT;
    
    mQuantity = [[NSMutableArray alloc] init];
    // right now the unit and quantity are independant
    for ( double i = MIN_QUANTITY; i <= MAX_QUANTITY; i += QUANTITY_RESOLUTION )
        [mQuantity addObject:[NSString stringWithFormat:@"%g", i]];
    
    mQuantityPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, mWidth, mComponentHeight)];
    mQuantityPicker.dataSource = self;
    mQuantityPicker.delegate = self;
    mQuantityPicker.showsSelectionIndicator = YES;
    [self.view addSubview:mQuantityPicker];

    
    // create a hidden text view, the input view of which is associated with this picker
    if( mTextField ) {
        mTextField.inputView = self.view;
        mTextField.inputAccessoryView = inputAccessoryView;
    }
    else {
        mHiddenText = [[UITextView alloc]initWithFrame:CGRectMake(-1, -1, 0, 0)];
        [mSuperView addSubview:mHiddenText];
        mHiddenText.inputView = self.view;
        mHiddenText.inputAccessoryView = inputAccessoryView;
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // this is important. it sets the height of this view according to picker height
    CGRect f = self.view.frame;
    f.size.height = mQuantityPicker.frame.size.height;
    self.view.frame = f;
    
    // reset selection
    [mQuantityPicker selectRow:0 inComponent:0 animated:FALSE];
    [mQuantityPicker selectRow:0 inComponent:1 animated:FALSE];
    mCurrentQuantityIdx = 0;
    mCurrentUnitIdx = 0;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [mQuantityPicker release];
        
    [mQuantity release];
    [mUnit release];
    
    if(mHiddenText) [mHiddenText release];
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
    okButton.tag = kQUButtonOK;
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered  target:self action:@selector(buttonPressed:)];
    cancelButton.tag = kQUButtonCancel;
    
    // I put the spacers in to push the doneButton to the right side of the picker view
    UIBarButtonItem *spacer    = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:cancelButton, spacer, okButton, nil]];
    
    [spacer release];
    
    return keyboardDoneButtonView;
}

@end
