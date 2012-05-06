//
//  totLanguageInputViewController.m
//  totAlbumView
//
//  Created by User on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "totLanguageInputViewController.h"
#import "AppDelegate.h"

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
    UIImageView *aImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 180)];
    aImgView.image = [UIImage imageNamed:@"message_cloud.png"];
    [self.view addSubview:aImgView];    
    // Construct m_textField
    UITextView *aTxtView = [[UITextView alloc] initWithFrame:CGRectMake(80, 56, 170, 80)];
    [aTxtView  setFont: [UIFont fontWithName:@"ArialMT" size:22]];
    aTxtView.editable = YES;
    aTxtView.textAlignment = UITextAlignmentLeft;
    aTxtView.backgroundColor = [UIColor clearColor];
    m_textView = aTxtView;
    [self.view addSubview:m_textView];
    [aTxtView release];
    // Construct m_confirmButton
    UIButton *aBtn = [[UIButton alloc] initWithFrame:CGRectMake(145, 200, 30, 30)];
    aBtn.backgroundColor = [UIColor clearColor];
    [aBtn setBackgroundImage: [UIImage imageNamed:@"play_button.png"] forState:UIControlStateNormal];
    [aBtn addTarget:self action:@selector(ConfirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    m_confirmButton = aBtn;
    [self.view addSubview:m_confirmButton];
    
    //Initially hide all the views
    m_textView.hidden = YES;
    m_confirmButton.hidden = YES;
    self.view.hidden = YES;

}

- (void)Display
{
    m_textView.hidden = NO;
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
        [totModel addEvent:0 event:@"language" datetime:formattedDateString value:inputTxt ];
        
        /* Clear text */
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
        [NSTimer scheduledTimerWithTimeInterval:1.5f
                                         target:self
                                       selector:@selector(MakeNoView)
                                       userInfo:nil
                                        repeats:NO];
    } else {
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

@end
