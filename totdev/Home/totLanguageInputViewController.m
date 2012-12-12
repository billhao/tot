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
    [self.view setFrame:CGRectMake(0, 0, 320, 480)];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
    
    // Add the message cloud into m_topView
    UIImageView *aImgView = [[UIImageView alloc] initWithFrame:CGRectMake(14.4, 8, 291.2, 250)];
    aImgView.image = [UIImage imageNamed:@"icons-language.png"];
    [self.view addSubview:aImgView];
    [aImgView release];
    
    // Construct m_textField
    UITextView *aTxtView = [[UITextView alloc] initWithFrame:CGRectMake(35, 25, 250, 150)];
    [aTxtView  setFont: [UIFont fontWithName:@"ArialMT" size:30]];
    aTxtView.editable = YES;
    aTxtView.delegate = self;
    aTxtView.textAlignment = UITextAlignmentLeft;
    aTxtView.backgroundColor = [UIColor clearColor];
    NSString* defaultTxt = @"what did the baby say?"; // define default text   
    aTxtView.text = defaultTxt;  // set default text
    aTxtView.textColor = [UIColor lightGrayColor]; // set color for default text
    self.m_textView = aTxtView;
    [aTxtView release];
    [self.view addSubview:m_textView];
    
    // Construct m_confirmButton
    UIButton *aBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 185, 60, 45)];
    aBtn.backgroundColor = [UIColor clearColor];
    [aBtn setBackgroundImage: [UIImage imageNamed:@"icons-ok.png"] forState:UIControlStateNormal];
    [aBtn addTarget:self action:@selector(ConfirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.m_confirmButton = aBtn;
    [self.view addSubview:m_confirmButton];
    [aBtn release];
    
    // Construct history button
    UIButton *bBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bBtn.frame = CGRectMake(130, 185, 60, 45);
    bBtn.backgroundColor = [UIColor clearColor];
    [bBtn setBackgroundImage: [UIImage imageNamed:@"icons-history.png"] forState:UIControlStateNormal];
    [bBtn addTarget:self action:@selector(ConfirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bBtn];
    
    // Construct share button
    UIButton *cBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cBtn.frame = CGRectMake(210, 185, 60, 45);
    cBtn.backgroundColor = [UIColor clearColor];
    [cBtn setBackgroundImage: [UIImage imageNamed:@"icons-share.png"] forState:UIControlStateNormal];
    [cBtn addTarget:self action:@selector(ConfirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cBtn];
    
    //Initially hide all the views
    m_textView.hidden = YES;
    m_confirmButton.hidden = YES;
    self.view.hidden = YES;

}

- (void)Display
{
    /* Display m_textView and set default text */
    m_textView.hidden = NO;
    NSString* defaultTxt = @"what did the baby say?"; // define default text
    m_textView.text = defaultTxt;
    m_textView.textColor = [UIColor lightGrayColor];
    /* Display confirm button */
    m_confirmButton.hidden = NO;
    self.view.hidden = NO;
}

- (void)MakeNoView
{
    // Remove the Done image added in ConfirmButtonClicked
    for (UIView *subview in [self.view subviews]) {
        if (subview.tag == 99) {
            [subview removeFromSuperview];
        }
    }
    
    // Clear text in m_textView
    m_textView.text = @"";
    
    // Hide views
    m_textView.hidden = YES;
    m_confirmButton.hidden = YES;
    self.view.hidden = YES;
}

- (void)ConfirmButtonClicked
{
    /* Save text into database */
    if(m_textView.hasText == YES) {
        /* Get current date */
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate* curDate = [NSDate date];
        NSString *formattedDateString = [dateFormatter stringFromDate:curDate];
        
        /* Get input text */
        NSString* inputTxt = m_textView.text;
        /* Add to database */
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        totModel* totModel = [appDelegate getDataModel];
        [totModel addEvent:0 event:EVENT_BASIC_LANGUAGE datetimeString:formattedDateString value:inputTxt ];
        
        /* Clear textview text */
        m_textView.text = @"";
        
        /* Hide keyboard */
        [self.m_textView resignFirstResponder];
        
        /* Add Done image */
        UIImageView *aImgView = [[UIImageView alloc] initWithFrame:CGRectMake(80, 56, 170, 80)];
        aImgView.image = [UIImage imageNamed:@"done-01.png"];
        aImgView.tag = 99;
        [self.view addSubview:aImgView];
        [aImgView release];
        
        /* Set timer to call MakeNoView */
        [NSTimer scheduledTimerWithTimeInterval:1.8f
                                         target:self
                                       selector:@selector(MakeNoView)
                                       userInfo:nil
                                        repeats:NO];
        [dateFormatter release];
    } else {
        /* Hide keyboard */
        [self.m_textView resignFirstResponder];

        [self MakeNoView];
    }
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

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

////
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if (self.m_textView.textColor == [UIColor lightGrayColor]) {
        self.m_textView.text = @"";
        self.m_textView.textColor = [UIColor blackColor];
    }
    
    return YES;
}

@end
