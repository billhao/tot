//
//  totLanguageInputViewController.m
//  totAlbumView
//
//  Created by User on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "totLanguageInputViewController.h"
#import "AppDelegate.h"
#import "../Model/totEventName.h"

#define HORIZ_DISPLACEMENT 0

@implementation totLanguageInputViewController

@synthesize m_textView;
@synthesize m_confirmButton;

-(void)dealloc
{
    [m_textView release];
    [m_confirmButton release];
    [super dealloc];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
}

// ViewDidLoad
- (void) viewDidLoad
{
    [super viewDidLoad];
    
    defaultTxt = @"what did the baby say?";

    [self.view setFrame:CGRectMake(0, 0, 320, 480)];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
    
    // Add the message cloud into m_topView
    //UIImageView *aImgView = [[UIImageView alloc] initWithFrame:CGRectMake(14.4, 8, 291.2, 250)];
    UIButton* bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bgBtn.frame = CGRectMake(0, 0, 320, 480);
    [bgBtn addTarget:self action:@selector(backgroundTap) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *aImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    aImgView.image = [UIImage imageNamed:@"backgrounds-language"];
    [bgBtn addSubview:aImgView];
    [self.view addSubview:bgBtn];
    [aImgView release];
    
    // add the cloud for the text
    UIImage* cloudImg = [UIImage imageNamed:@"icons-language"];
    UIImageView* cloudImgView = [[UIImageView alloc] initWithImage:cloudImg];
    cloudImgView.frame = CGRectMake(17, 43, cloudImg.size.width, cloudImg.size.height);
    [self.view addSubview:cloudImgView];
    [cloudImgView release];
    
    // Construct m_textField
    UITextView *aTxtView = [[UITextView alloc] initWithFrame:CGRectMake(40+HORIZ_DISPLACEMENT, 65, 185, 100)];
    aTxtView.editable = YES;
    aTxtView.delegate = self;
    aTxtView.textAlignment = UITextAlignmentCenter;
    aTxtView.backgroundColor = [UIColor clearColor];
    aTxtView.font = [UIFont fontWithName:@"Roboto-Regular" size:16.0];
    aTxtView.textColor = [UIColor colorWithRed:128.0/255 green:130.0/255 blue:133.0/255 alpha:1];
    // disable auto correction, capitalization and etc
    aTxtView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    aTxtView.autocorrectionType = UITextAutocorrectionTypeNo;
    aTxtView.spellCheckingType = UITextSpellCheckingTypeNo;
    
    self.m_textView = aTxtView;
    [aTxtView release];
    [self.view addSubview:m_textView];
    
    // Construct m_confirmButton
    UIImage* okBtnImg = [UIImage imageNamed:@"icons-ok"];
    UIButton *aBtn = [[UIButton alloc] initWithFrame:CGRectMake(160+HORIZ_DISPLACEMENT, 180, okBtnImg.size.width, okBtnImg.size.height)];
    aBtn.backgroundColor = [UIColor clearColor];
    [aBtn setBackgroundImage:okBtnImg forState:UIControlStateNormal];
    [aBtn addTarget:self action:@selector(ConfirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.m_confirmButton = aBtn;
    [self.view addSubview:m_confirmButton];
    [aBtn release];
    
    // Construct history button
//    UIButton *bBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    bBtn.frame = CGRectMake(140+HORIZ_DISPLACEMENT, 180, 60, 45);
//    bBtn.backgroundColor = [UIColor clearColor];
//    [bBtn setBackgroundImage: [UIImage imageNamed:@"icons-history.png"] forState:UIControlStateNormal];
//    [bBtn addTarget:self action:@selector(ConfirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:bBtn];
    
    /*
    // Construct share button
    UIButton *cBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cBtn.frame = CGRectMake(180, 180, 60, 45);
    cBtn.backgroundColor = [UIColor clearColor];
    [cBtn setBackgroundImage: [UIImage imageNamed:@"icons-share.png"] forState:UIControlStateNormal];
    [cBtn addTarget:self action:@selector(ConfirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cBtn];
    */
    
    // Construct close button
    UIButton *dBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dBtn.frame = CGRectMake(215+HORIZ_DISPLACEMENT, 10, 32, 31);
    dBtn.backgroundColor = [UIColor clearColor];
    [dBtn setBackgroundImage: [UIImage imageNamed:@"icons-close.png"] forState:UIControlStateNormal];
    [dBtn addTarget:self action:@selector(CloseButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dBtn];
    
    //Initially hide all the views
    m_textView.hidden = YES;
    m_confirmButton.hidden = YES;
    self.view.hidden = YES;
}

- (void)Display
{
    /* Init and display m_textView */
    m_textView.hidden = NO;
    m_textView.text = defaultTxt;
    /* Display confirm button */
    m_confirmButton.hidden = NO;
    self.view.hidden = NO;
}

- (void)MakeNoView
{
    /* Remove the confirmation message added in ConfirmButtonClicked */
    for (UIView *subview in [self.view subviews]) {
        if (subview.tag == 99 || subview.tag == 98) {
            [subview removeFromSuperview];
        }
    }
    /* Clear text in m_textView */
    m_textView.text = @"";
    m_textView.textColor = [UIColor lightGrayColor];  // make sure next time the default text can be removed once the m_textView is touched
    /* Hide views */
    m_textView.hidden = YES;
    m_confirmButton.hidden = YES;
    self.view.hidden = YES;
}

- (void)ConfirmButtonClicked
{
    /* Save text into database */
    NSString *text = [m_textView.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    if(m_textView.hasText == YES && (![text isEqualToString:defaultTxt]) ) {
        /* Get current date */
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate* curDate = [NSDate date];
        NSString *formattedDateString = [dateFormatter stringFromDate:curDate];
        [dateFormatter release];
        
        /* Get input text */
        /* Add to database */
        totModel* totModel = global.model;
        [totModel addEvent:0 event:EVENT_BASIC_LANGUAGE datetimeString:formattedDateString value:text ];
        
        /* Clear textview text */
        m_textView.text = defaultTxt;
        
        /* Hide keyboard */
        [self.m_textView resignFirstResponder];
        
        m_textView.hidden = YES;
        
        /* Add Done image */
        /*UIImageView *aImgView = [[UIImageView alloc] initWithFrame:CGRectMake(80, 56, 170, 80)];
        aImgView.image = [UIImage imageNamed:@"done-01.png"];
        aImgView.tag = 99;
        [self.view addSubview:aImgView];
        [aImgView release];
        */
        // Display a confirmation message
        UITextView *confirmTxtView = [[UITextView alloc] initWithFrame:CGRectMake(40+HORIZ_DISPLACEMENT, 65, 185, 100)];
        confirmTxtView.font = [UIFont fontWithName:@"Roboto-Regular" size:16.0];
        confirmTxtView.editable = NO;
        confirmTxtView.delegate = self;
        confirmTxtView.textAlignment = UITextAlignmentCenter;
        confirmTxtView.backgroundColor = [UIColor clearColor];
        NSString* defaultConfirmTxt = @"Bravo! Tom has learnd 15 words this week^o^"; // define default text
        confirmTxtView.text = defaultConfirmTxt;  // set default text
        confirmTxtView.textColor = [UIColor colorWithRed:210.0/255 green:0.0 blue:63.0/255 alpha:1.0]; // set color for default text
        confirmTxtView.tag = 99;
        [self.view addSubview:confirmTxtView];
        [confirmTxtView release];
        // Construct share button
//        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        shareBtn.frame = CGRectMake(110, 130, 60, 45);
//        shareBtn.backgroundColor = [UIColor clearColor];
//        shareBtn.tag = 98;
//        [shareBtn setBackgroundImage: [UIImage imageNamed:@"icons-share.png"] forState:UIControlStateNormal];
//        [shareBtn addTarget:self action:@selector(ConfirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:shareBtn];
        
        /* Set timer to call MakeNoView */
        /*[NSTimer scheduledTimerWithTimeInterval:2.0f
                                         target:self
                                       selector:@selector(MakeNoView)
                                       userInfo:nil
                                        repeats:NO];*/
    } else {
        /* Hide keyboard */
        [self.m_textView resignFirstResponder];
        [self MakeNoView];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITextView delegates
- (void)textViewDidBeginEditing:(UITextView *)textView {
    //    printf("textViewDidBeginEditing\n");
}

// called when the keyboard disappears
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    //    printf("textViewShouldEndEditing\n");
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    //    printf("textViewDidEndEditing\n");
}

// whenever the user types the keyboard
- (BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if( [text isEqualToString:@"\n"] ) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

//// define the action when the textview is selected for editing
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    NSString *text = [m_textView.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    if ( [text isEqualToString:defaultTxt]) {
        self.m_textView.text = @"";
    }
    
    return YES;
}

////
- (void) CloseButtonClicked
{
    // Clear text in m_textView and Reset textColor so that textViewShouldBeginEditing can correctly function
    m_textView.text = @"";
    m_textView.textColor = [UIColor lightGrayColor];
    
    //// hide keyboard
    [self.m_textView resignFirstResponder];
    
    // Hide views
    m_textView.hidden = YES;
    m_confirmButton.hidden = YES;
    self.view.hidden = YES;
    
    [self MakeNoView];
}

// dismiss this view when tap on the background button
- (void) backgroundTap {
    NSString *text = [m_textView.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    if ( [text isEqualToString:defaultTxt] && (![m_textView isFirstResponder]) ) {
        [self CloseButtonClicked];
    }
}

@end
