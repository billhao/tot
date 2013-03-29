//
//  totHomeHeightViewController.m
//  totdev
//
//  Created by Hao on 5/5/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totHomeRootController.h"
#import "totHomeHeightViewController.h"
#import "AppDelegate.h"
#import "totEventName.h"
#import "totEvent.h"

@implementation totHomeHeightViewController

@synthesize homeRootController, initialPicker, selectedDate=_selectedDate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        model = global.model;
        picker_height = nil;
        picker_weight = nil;
        picker_head = nil;
        all_numbers = nil;
        initialPicker = 0;
        
//        mClockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        mClockBtn.frame = CGRectMake(100, 100, 25, 25);
//        [mClockBtn setImage:[UIImage imageNamed:@"clock.png"] forState:UIControlStateNormal];
//        [mClockBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:mClockBtn];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"%@", @"[height] viewDidLoad");
    
    // add bg
    UIImage* img = [UIImage imageNamed:@"weight_bg"];
    UIImageView* bgview = [[UIImageView alloc] initWithImage:img];
    bgview.frame = CGRectMake(0, 0, img.size.width, img.size.height);
    [self.view addSubview:bgview];
    [self.view sendSubviewToBack:bgview];
    [bgview release];

    // height picker
    picker_height = [STHorizontalPicker getPickerForHeight:CGRectMake(66, 169, 190, 40)];
    [picker_height setDelegate:self];

    // weight picker
    picker_weight = [STHorizontalPicker getPickerForWeight:CGRectMake(66, 169, 190, 40)];
    [picker_weight setDelegate:self];
    
    // head circumference picker
    picker_head = [STHorizontalPicker getPickerForHeadC:CGRectMake(66, 169, 190, 40)];
    [picker_head setDelegate:self];
    
    // 0 - height
    // 1 - weight
    // 2 - hc
    all_imgs    = [[NSMutableArray alloc] initWithObjects: [UIImage imageNamed:@"text_height"], [UIImage imageNamed:@"text_weight"], [UIImage imageNamed:@"text_hc"], nil];
    all_imgs_grey    = [[NSMutableArray alloc] initWithObjects: [UIImage imageNamed:@"text_height_grey"], [UIImage imageNamed:@"text_weight_grey"], [UIImage imageNamed:@"text_hc_grey"], nil];
    // save the pickers
    all_pickers = [[NSMutableArray alloc] initWithObjects: picker_height, picker_weight, picker_head, nil];
    [picker_height release];
    [picker_weight release];
    [picker_head release];
    
    // set appearances for date
    UIFont* font1 = [UIFont fontWithName:@"Roboto-Regular" size:16.0];
    [self setDate:[NSDate date]];
    [mDatetime.titleLabel setFont:font1];
    [mDatetime setTitleColor:[UIColor colorWithRed:147.0/255 green:149.0/255 blue:152.0/255 alpha:1] forState:UIControlStateNormal];
    [mDatetime setTitleColor:[UIColor colorWithRed:147.0/255 green:149.0/255 blue:152.0/255 alpha:1] forState:UIControlStateHighlighted];
    
    [mLabel0 setFont:font1];
    [mLabel1 setFont:font1];
    [mLabel2 setFont:font1];
    [mLabel0 setTextColor:[UIColor colorWithRed:128.0/255 green:130.0/255 blue:133.0/255 alpha:1]];
    [mLabel1 setTextColor:[UIColor colorWithRed:128.0/255 green:130.0/255 blue:133.0/255 alpha:1]];
    [mLabel2 setTextColor:[UIColor colorWithRed:128.0/255 green:130.0/255 blue:133.0/255 alpha:1]];

    // set up events
    [mOKButton addTarget:self action:@selector(OKButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mCloseButton addTarget:self action:@selector(CloseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mDatetime addTarget:self action:@selector(DatetimeClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mDatetimeImage addTarget:self action:@selector(DatetimeClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mLabel1Button addTarget:self action:@selector(LabelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mLabel2Button addTarget:self action:@selector(LabelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    // set up date picker
    mWidth = self.view.frame.size.width;
    mHeight= self.view.frame.size.height;
    
    mClock = [[totTimerController alloc] init:self.view];
    mClock.view.frame = CGRectMake((mWidth-mClock.mWidth)/2, mHeight, mClock.mWidth, mClock.mHeight);
    [mClock setDelegate:self];
    [self.view addSubview:mClock.view];

    // set appearances for the summary view
    UIImage* summaryImg = [UIImage imageNamed:@"summary_bg"];
    mSummaryView = [[UIImageView alloc] initWithImage:summaryImg];
    mSummaryView.frame = CGRectMake((320-summaryImg.size.width)/2, 100, summaryImg.size.width, summaryImg.size.height);
    
    mSummaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 30, 182, 95)];
    mSummaryLabel.numberOfLines = 5;
    mSummaryLabel.textAlignment = UITextAlignmentCenter;
    mSummaryLabel.backgroundColor = [UIColor clearColor];
    mSummaryLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:14.0];
    mSummaryLabel.textColor = [UIColor colorWithRed:147.0/255 green:149.0/255 blue:152.0/255 alpha:1];
    [mSummaryView addSubview:mSummaryLabel];
    
    mSummaryCover = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    mSummaryCover.frame = self.view.bounds;
    mSummaryCover.backgroundColor = [UIColor clearColor];
    [mSummaryCover addTarget:self action:@selector(SummaryClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    [self resetView];
}

- (void)resetView {
    //    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"weight_bg"]];
    [self hideSummary];
    
    // reset all values
    all_numbers = [[NSMutableArray alloc] initWithObjects: @"", @"", @"", nil];
    
    [self loadPicker:initialPicker currentPicker:-1];
    
    // set picker position to last measurement in db
    
    // assign labels and buttons
    int a = 0, b = 1;
    if( initialPicker == 0 ) {
        a = 1; b = 2;
    }
    else if( initialPicker == 1 ) {
        a = 0; b = 2;
    }
    else if( initialPicker == 2 ) {
        a = 0; b = 1;
    }
    
    [self setContent:initialPicker button:mLabel0Button label:mLabel0 top:TRUE];
    [self setContent:a button:mLabel1Button label:mLabel1 top:FALSE];
    [self setContent:b button:mLabel2Button label:mLabel2 top:FALSE];
    
    // reset date to today
    [self setDate:[NSDate date]];    
}

- (NSString*)getDateString:(NSDate*)date {
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    return [dateFormatter stringFromDate:date];
}

- (void)pickerView:(STHorizontalPicker *)picker didSelectValue:(CGFloat)value{
    NSLog(@"didSelectValue %f", value);
    // save new value to the array so it will switch when user changes to a different measure (height/weight/hc)
    int i = mLabel0Button.tag; // get current/top item
    //NSLog(@"picker = %d", i);
    NSString* str = NULL;
    if( i==0 || i==2 )
        // height or head
        str = [NSString stringWithFormat:@"%.2f inches",value];
    else if( i== 1 )
        // weight
        str = [NSString stringWithFormat:@"%.2f pound",value];
    [all_numbers replaceObjectAtIndex:i withObject:str];
    mSelectedValue.text = str;
}

// save all the numbers to db
- (void)OKButtonClicked: (UIButton *)button {
    NSLog(@"%@", @"[basic][height] ok button clicked");

    NSString* summary = [NSString stringWithFormat:@"On %@, %@ ", mDatetime.titleLabel.text, global.baby.name];

    int n = 0; // # of items user edited
    //if( ![all_numbers[0] isEqual: @""] ) {
    if( ![ [all_numbers objectAtIndex:0] isEqual:@""]) {
        NSString* height = [all_numbers objectAtIndex:0];
        [model addEvent:global.baby.babyID event:EVENT_BASIC_HEIGHT datetime:self.selectedDate value:height];
        summary = [summary stringByAppendingFormat:@"is %@ high", height];
        n++;
    }
    
    if( ![ [all_numbers objectAtIndex:1] isEqual: @""] ) {
        NSString* weight = [all_numbers objectAtIndex:1];
        [model addEvent:global.baby.babyID event:EVENT_BASIC_WEIGHT datetime:self.selectedDate value:weight];
        if( n > 0 ) summary = [summary stringByAppendingString:@", "];
        summary = [summary stringByAppendingFormat:@"weighs %@", weight];
        n++;
    }
    if( ![ [all_numbers objectAtIndex:2] isEqual: @""] ) {
        NSString* head   = [all_numbers objectAtIndex:2];
        [model addEvent:global.baby.babyID event:EVENT_BASIC_HEAD datetime:self.selectedDate value:head];
        if( n > 0 ) summary = [summary stringByAppendingString:@" and "];
        summary = [summary stringByAppendingFormat:@"is %@ in head circumference", head];
        n++;
    }
    if( n == 0 ) return;

    // show cover and summary views
    [self showSummary:summary];
}

- (void)showSummary:(NSString*)text {
    mSummaryLabel.text = text;
    [self.view addSubview:mSummaryView];
    [self.view bringSubviewToFront:mSummaryView];
    
    [self.view addSubview:mSummaryCover];
    [self.view bringSubviewToFront:mSummaryCover];
}

- (void)hideSummary {
    // remove the summary view
    [mSummaryCover removeFromSuperview];
    [mSummaryView removeFromSuperview];
}

- (void)CloseButtonClicked: (UIButton *)button {
    [homeRootController switchTo:kHomeViewEntryView withContextInfo:nil];
}

// click on summary, return to home
- (void)SummaryClicked: (UIButton *)button {
    [homeRootController switchTo:kHomeViewEntryView withContextInfo:nil];
}

// display date selection
- (void)DatetimeClicked: (UIButton *)button {
    NSLog(@"%@", @"[basic][height] datetime clicked");
    [self showTimePicker];
}

- (void) navLeftButtonPressed:(id)sender{
    [homeRootController switchTo:kHomeViewEntryView withContextInfo:nil];
    
}

- (void)showTimePicker {
    [mClock setCurrentTime];
    [mClock show];
}

- (void)hideTimePicker {
    [mClock dismiss];
}

// when user click on one of the two labels at the bottom, switch it with the current/top label
- (void)LabelButtonClicked: (UIButton *)button {    
    // switch buttons
    UILabel* label = NULL;
    if( button == mLabel1Button )
        label = mLabel1;
    else if( button == mLabel2Button )
        label = mLabel2;

    int a = mLabel0Button.tag;
    int b = button.tag;
    [self setContent:b button:mLabel0Button label:mLabel0 top:TRUE];
    [self setContent:a button:button label:label top:FALSE];

    // reload picker
    [self loadPicker:b currentPicker:a];
}

// top: whether the text is on the top or one of the bottom two (in grey)
- (void)setContent:(int)i button:(UIButton*)button label:(UILabel*)label top:(BOOL)top {
    button.tag = i;
    if( top ) {
        [button setImage:[all_imgs objectAtIndex:i] forState:UIControlStateNormal];
    }
    else {
        [button setImage:[all_imgs_grey objectAtIndex:i] forState:UIControlStateNormal];
        [button setImage:[all_imgs_grey objectAtIndex:i] forState:UIControlStateHighlighted];
        [button setImage:[all_imgs_grey objectAtIndex:i] forState:UIControlStateSelected];
    }
    label.text = [all_numbers objectAtIndex:i];
}

- (void)loadPicker:(int)i currentPicker:(int)currentPicker {
    for( int i=0; i<=2; i++ )
    //if( currentPicker >= 0 )
    [[all_pickers objectAtIndex:i] removeFromSuperview];
    [self.view addSubview:[all_pickers objectAtIndex:i]];
    [self.view sendSubviewToBack:[all_pickers objectAtIndex:i]];
}

#pragma mark - totTimerControllerDelegate
-(void)saveCurrentTime:(NSString*)time datetime:(NSDate*)datetime {
    NSLog(@"%@", time);
    [self setDate:datetime];
    [self hideTimePicker];
}

-(void)cancelCurrentTime {
    [self hideTimePicker];
}

// set the text of the date label and save the date as selectedDate
-(void)setDate:(NSDate*) date {
    self.selectedDate = date;
    [mDatetime setTitle:[self getDateString:date] forState:UIControlStateNormal];
}

- (void)viewDidUnload
{
    NSLog(@"[height] viewDidUnload");
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [mClock release];
    [mNavigationBar release];
    [all_imgs release];
    [all_numbers release];
    [all_pickers release];
    [mSummaryCover release];
    [mSummaryView release];
    //[picker_head release];
    //[picker_height release];
    //[picker_weight release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
