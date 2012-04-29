//
//  totActivityInfoViewController.m
//  totdev
//
//  Created by Lixing Huang on 4/15/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totActivityInfoViewController.h"
#import "totActivityEntryViewController.h"
#import "totImageView.h"
#import "../Utility/totSliderView.h"

@implementation totActivityInfoViewController

@synthesize activityRootController;
@synthesize mActivityDesc;
@synthesize mCurrentActivityID;

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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// called when the keyboard appears
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
//    printf("textViewShouldBeginEditing\n");
    return YES;
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
    printf("%s\n", [textView.text UTF8String]);
}

// whenever the user types the keyboard
- (BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if( [text isEqualToString:@"\n"] ) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

// whenever the user types the keyboard
//- (void)textViewDidChange:(UITextView *)textView {
//    printf("textViewDidChange\n");
//}

#pragma mark - UITouch delegates

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if ([mActivityDesc isFirstResponder] && [touch view] != mActivityDesc) {
        [mActivityDesc resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

// receive parameters passed by other module for initialization or customization
- (void)receiveMessage: (NSMutableDictionary*)message {
    const char* vals [] = { // the name should correspond to the image file name
        "task1,task2", // vision attention
        "task1,task2", // eye contact
        "task1,task2", // mirror test
        "task1,task2", // imitation
        "task1,task2", // gesture
        "3,4,5,6,7,8,9,10,11,12", // emotion
        "task1,task2", // chew
        "task1,task2"  // motorskill
    };
    
    [mSliderView cleanScrollView];
    
    NSString *filename = [message objectForKey:@"storedImage"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *path = [documentDirectory stringByAppendingPathComponent:filename];
    
    self.mCurrentActivityID = [message objectForKey:@"activity"];
    NSString *memb_str = [NSString stringWithUTF8String:vals[[self.mCurrentActivityID intValue]]];
    NSArray  *member = [memb_str componentsSeparatedByString:@","];
    
    // insert the image
    [mThumbnail setImage:[UIImage imageWithContentsOfFile:path]];
    
    // display the slider view
    NSMutableArray *images = [[NSMutableArray alloc] init];
    NSMutableArray *margin = [[NSMutableArray alloc] init];
    
    for( int i=0; i<[member count]; i++ ) {
        [images addObject:[UIImage imageNamed:[[member objectAtIndex:i] stringByAppendingString:@".png"]]];
        [margin addObject:[NSNumber numberWithBool:NO]];
    }
    
    [mSliderView setContentArray:images];
    [mSliderView setMarginArray:margin];    
    [images release];
    [margin release];
    
    [mSliderView getWithPositionMemoryIdentifier:@"infoview"];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mThumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 50, 50)];
    [self.view addSubview:mThumbnail];
    
//    UIImageView *textbubble = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"messagebox.png"]];
//    textbubble.frame = CGRectMake(0, 35, 360, 180);
//    [self.view insertSubview:textbubble belowSubview:mActivityDesc];
//    [textbubble release];
    
    mSliderView = [[totSliderView alloc] initWithFrame:CGRectMake(0, 151, 320, 260)];
    [mSliderView enablePageControlOnBottom];
    [self.view addSubview:mSliderView];
}

- (IBAction)save:(id)sender {
    NSMutableDictionary *message = [[NSMutableDictionary alloc] init];
    
    [activityRootController.activityEntryViewController prepareMessage:message for:[mCurrentActivityID intValue]];
    [activityRootController switchTo:kActivityView withContextInfo:message];
    
    [message release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [mSliderView release];
    [mThumbnail release];
    [mCurrentActivityID release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
