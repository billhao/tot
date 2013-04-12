//
//  totNewBabyController.m
//  totdev
//
//  Created by Hao Wang on 8/24/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totNewBabyController.h"
#import "AppDelegate.h"
#import "Model/totEventName.h"

@interface totNewBabyController ()

@end

@implementation totNewBabyController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        sex = NA;
        bday = nil;
        mCurrentControl = nil;
    }
    return self;
}

- (void)showLoginView {
    // go to home view
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate showLoginView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"%@", @"new baby view did load");
    
    //set background
    self.view.backgroundColor = [[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg_newbaby.png"]] autorelease];
    
    // set up events
    [mExistingAccount addTarget:self action:@selector(ExistingAccountButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mBoy addTarget:self action:@selector(BoyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mGirl addTarget:self action:@selector(GirlButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mSave addTarget:self action:@selector(SaveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mName setDelegate:self];
    [mBDay addTarget:self action:@selector(BDayButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mBDay setDelegate:self];
    
    mPicker.date = [NSDate date];
	//[mPicker addTarget:self action:@selector(changeDateInLabel:) forControlEvents:UIControlEventValueChanged];
    inputAccView = [self createInputAccessoryView];
    mBDay.inputView = mPicker;
    mBDay.inputAccessoryView = inputAccView;
}

-(void)viewWillAppear:(BOOL)animated {
//    NSLog(@"will appear");
//    NSLog(@"h=%f w=%f", self.view.frame.size.height, self.view.frame.size.width);
//    NSLog(@"x=%f y=%f", self.view.frame.origin.x, self.view.frame.origin.y);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [mBoySelected release];
    [mGirlSelected release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)ExistingAccountButtonClicked: (UIButton *)button {
}

- (void)BoyButtonClicked: (UIButton *)button {
    sex = MALE;
    [mBoyImg setHighlighted:TRUE];
    [mGirlImg setHighlighted:FALSE];
}

- (void)GirlButtonClicked: (UIButton *)button {
    sex = FEMALE;
    [mBoyImg setHighlighted:FALSE];
    [mGirlImg setHighlighted:TRUE];
}

- (void)BDayButtonClicked: (UIControl *)ctrl {
    CGRect frame = mPicker.frame;
    mPicker.frame = CGRectMake(0, 264, frame.size.width, frame.size.height);
}

- (void)SaveButtonClicked: (UIButton *)button {
    // check name
    NSString* name = [mName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if( name.length == 0 ) {
        return;
    }
    
    // check sex
    if(sex == NA) {
        return;
    }
    
    // check bday
    if( bday == nil ) {
        return;
    }
    
    //NSLog(@"%@", name);
    //NSLog(@"%d", sex);
    //NSLog(@"%@", bday);
    

    // save baby info to db
    totBaby* baby = [totBaby newBaby:name sex:sex birthday:bday];
    
    // go to create account page
    global.baby = baby;
    [baby release];
    
    [[self getAppDelegate] showLoginView];
}

- (void)pickerDoneClicked: (UIButton *)button {
    [mBDay resignFirstResponder];
    [self changeDateInLabel:nil];
}

- (void)changeDateInLabel:(id)sender {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MMM d, yyyy h:mma"];
    NSLog(@"%@", @"change");
    mBDay.text = [NSString stringWithFormat:@"%@", [df stringFromDate:mPicker.date]];
	[df release];
    bday = [mPicker.date copy];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    mCurrentControl = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    mCurrentControl = nil;
}

// dismiss the keyboard when tapping on background
- (IBAction) backgroundTap:(id) sender{
    if( mCurrentControl == mName ) {
        // hide keyboard for name
        [mName resignFirstResponder];
    }
    else if( mCurrentControl == mBDay ) {
        // hide date picker
        [self pickerDoneClicked:nil];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return TRUE;
}

- (UIView*)createInputAccessoryView{
    // create a done view + done button, attach to it a doneClicked action, and place it in a toolbar as an accessory input view...
    // Prepare done button
    UIToolbar* keyboardDoneButtonView	= [[[UIToolbar alloc] init] autorelease];
    keyboardDoneButtonView.barStyle		= UIBarStyleBlack;
    keyboardDoneButtonView.translucent	= YES;
    keyboardDoneButtonView.tintColor	= nil;
    [keyboardDoneButtonView sizeToFit];
    
    UIBarButtonItem* doneButton    = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered  target:self action:@selector(pickerDoneClicked:)];
    
    // I put the spacers in to push the doneButton to the right side of the picker view
    UIBarButtonItem *spacer1    = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                target:nil action:nil];
    // I put the spacers in to push the doneButton to the right side of the picker view
    UIBarButtonItem *spacer    = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil action:nil];
    
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:spacer, spacer1, doneButton, nil]];
    [spacer release];
    [spacer1 release];
    
    return keyboardDoneButtonView;
}

- (void)doneTyping{
    // hide date picker
//    CGRect frame = mPicker.frame;
//    mPicker.frame = CGRectMake(0, 1800, frame.size.width, frame.size.height);
}

-(AppDelegate*) getAppDelegate {
    return [[UIApplication sharedApplication] delegate];
}

@end
