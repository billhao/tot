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
    }
    return self;
}

- (void)showLoginView {
    // go to home view
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate showLoginView:-1];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"%@", @"new baby view did load");
    // set up events
    [mExistingAccount addTarget:self action:@selector(ExistingAccountButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mBoy addTarget:self action:@selector(BoyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mGirl addTarget:self action:@selector(GirlButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mSave addTarget:self action:@selector(SaveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mName setDelegate:self];
    [mBDay addTarget:self action:@selector(BDayButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    mPicker.date = [NSDate date];
	//[mPicker addTarget:self action:@selector(changeDateInLabel:) forControlEvents:UIControlEventValueChanged];
    [self createInputAccessoryView];
    mBDay.inputView = mPicker;
    mBDay.inputAccessoryView = inputAccView;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)ExistingAccountButtonClicked: (UIButton *)button {
}

- (void)BoyButtonClicked: (UIButton *)button {
    sex = MALE;
    mGirl.selected = FALSE;
    mBoy.selected = TRUE;
}

- (void)GirlButtonClicked: (UIButton *)button {
    sex = FEMALE;
    mBoy.selected = FALSE;
    mGirl.selected = TRUE;
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
    
    NSLog(@"%@", name);
    NSLog(@"%d", sex);
    NSLog(@"%@", bday);
    
    // format sex
    NSString* str_sex = @"";
    if( sex == MALE )
        str_sex = @"MALE";
    else if( sex == FEMALE )
        str_sex = @"FEMALE";

    // format bday
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* str_bday = [dateFormatter stringFromDate:bday];
    [dateFormatter release];

    // save baby info to db
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    totModel* model = [appDelegate getDataModel];
    int baby_id = [model getNextBabyID];
    NSLog(@"next id = %d", baby_id);
    [model addPreference:baby_id preference:INFO_NAME value:name];
    [model addPreference:baby_id preference:INFO_SEX value:str_sex];
    [model addPreference:baby_id preference:INFO_BIRTHDAY value:str_bday];
    //[name release];
    
    // go to create account page
    [appDelegate showLoginView:baby_id];
}

- (void)changeDateInLabel:(id)sender {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MMM d, yyyy h:mma"];
    NSLog(@"%@", @"change");
    mBDay.text = [NSString stringWithFormat:@"%@", [df stringFromDate:mPicker.date]];
	[df release];
    bday = [mPicker.date copy];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return TRUE;
}

- (IBAction) backgroundTap:(id) sender{
    // hide keyboard for name
    [mName resignFirstResponder];
    // hide date picker
    CGRect frame = mPicker.frame;
    mPicker.frame = CGRectMake(0, 1800, frame.size.width, frame.size.height);
}

- (void)createInputAccessoryView{
    inputAccView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 310.0, 60.0)];
    
    [inputAccView setBackgroundColor:[UIColor lightGrayColor]];
    
    [inputAccView setAlpha: 0.7];
    
    btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDone setFrame:CGRectMake(240.0, 10.0f, 80.0f, 40.0f)];
    [btnDone setTitle:@"Done" forState:UIControlStateNormal];
    [btnDone setBackgroundColor:[UIColor blackColor]];
    [btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnDone addTarget:self action:@selector(doneTyping) forControlEvents:UIControlEventTouchUpInside];
    
    [inputAccView addSubview:btnDone];
}

- (void)doneTyping{
    // hide date picker
//    CGRect frame = mPicker.frame;
//    mPicker.frame = CGRectMake(0, 1800, frame.size.width, frame.size.height);
    [mBDay resignFirstResponder];
    [self changeDateInLabel:nil];
}

@end
