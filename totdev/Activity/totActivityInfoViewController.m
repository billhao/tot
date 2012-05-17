//
//  totActivityInfoViewController.m
//  totdev
//
//  Created by Lixing Huang on 4/15/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "AppDelegate.h"
#import "totActivityInfoViewController.h"
#import "totActivityEntryViewController.h"
#import "totActivityUtility.h"
#import "totActivityConst.h"
#import "../Utility/totImageView.h"
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
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        mTotModel = [appDelegate getDataModel];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)backToActivityView {
    NSMutableDictionary *message = [[NSMutableDictionary alloc] init];
    [activityRootController.activityEntryViewController prepareMessage:message for:[mCurrentActivityID intValue]];
    [activityRootController switchTo:kActivityView withContextInfo:message];
    [message release];
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

#pragma mark - UITextView delegates
// called when the keyboard appears
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    //printf("textViewShouldBeginEditing\n");
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    //printf("textViewDidBeginEditing\n");
}

// called when the keyboard disappears
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    //printf("textViewShouldEndEditing\n");
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    //printf("textViewDidEndEditing\n");
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

#pragma mark - totSliderView delegate
- (void)buttonPressed:(id)sender {
    UIButton *btn = (UIButton*)sender;
    int tag = [btn tag];
    tag = tag - 1; // index starts from 0
    
    NSString *activity = [NSString stringWithUTF8String: ACTIVITY_NAMES[[mCurrentActivityID intValue]]];
    NSString *memb_str = [NSString stringWithUTF8String: ACTIVITY_MEMBERS[[mCurrentActivityID intValue]]];
    NSArray *member = [memb_str componentsSeparatedByString:@","];
    NSString *the_member = [member objectAtIndex:tag];
    
    sprintf(mEventName, "%s/%s", [activity UTF8String], [the_member UTF8String]);
    printf("Event name: %s\n", mEventName);
    
    // pop up alertView, confirm to save to db
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"" 
                                                      message:@"Press OK to Save" 
                                                     delegate:self 
                                            cancelButtonTitle:@"Cancel" 
                                            otherButtonTitles:@"OK", nil];
    [message show];
}

#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if( [title isEqualToString:@"OK"] ) {
        //save to db
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *now = [NSDate date];
        NSString *formattedDateString = [dateFormatter stringFromDate:now];
        [dateFormatter release];
        
        char data[256]={0};
        sprintf(data, "image=%s", mImagePath);
        if( mIsVideo )
            sprintf(data, "%s;video=%s", data, mVideoPath);
        if( mActivityDesc.text.length != 0 )
            sprintf(data, "%s;desc=%s", data, [mActivityDesc.text UTF8String]);
        
        printf("insert to db: %s\n", data);
        
        [mTotModel addEvent:[totActivityUtility getCurrentBabyID] 
                      event:[NSString stringWithUTF8String:mEventName] 
                   datetimeString:formattedDateString 
                      value:[NSString stringWithUTF8String:data]];
        
        [mActivityDesc setText:@""];
        [mActivityDesc resignFirstResponder];
        
        [self backToActivityView];
    }
}


// receive parameters passed by other module for initialization or customization
- (void)receiveMessage: (NSMutableDictionary*)message {
    [mSliderView cleanScrollView];
    
    NSString *videoFilename = [message objectForKey:@"storedVideo"];
    NSString *filename = [message objectForKey:@"storedImage"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    NSString *imagePath = [documentDirectory stringByAppendingPathComponent:filename];
    sprintf(mImagePath, "%s", [imagePath UTF8String]);
    if( videoFilename ) {
        NSString *videoPath = [documentDirectory stringByAppendingPathComponent:videoFilename];
        sprintf(mVideoPath, "%s", [videoPath UTF8String]);
        mIsVideo = YES;
    } else {
        mIsVideo = NO;
    }
    
    self.mCurrentActivityID = [message objectForKey:@"activity"];
    NSString *memb_str = [NSString stringWithUTF8String:ACTIVITY_MEMBERS[[self.mCurrentActivityID intValue]]];
    NSArray  *member = [memb_str componentsSeparatedByString:@","];
    
    // insert the image
    //[mThumbnail setImage:[UIImage imageWithContentsOfFile:imagePath]];
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [mThumbnail setImage:[delegate.mCache getImageWithKey:filename]];
    
    // display the slider view
    NSMutableArray *images = [[NSMutableArray alloc] init];
    NSMutableArray *margin = [[NSMutableArray alloc] init];
    NSMutableArray *icon = [[NSMutableArray alloc] init];
    
    for( int i=0; i<[member count]; i++ ) {
        [images addObject:[UIImage imageNamed:[[member objectAtIndex:i] stringByAppendingString:@".png"]]];
        [margin addObject:[NSNumber numberWithBool:NO]];
        [icon addObject:[NSNumber numberWithBool:YES]];
    }
    
    [mSliderView setContentArray:images];
    [mSliderView setMarginArray:margin];
    [mSliderView setIsIconArray:icon];
    [images release];
    [margin release];
    [icon release];
    
    [mSliderView getWithPositionMemoryIdentifier:@"infoview"];
}

#pragma mark - totNavigationBar delegate
- (void)navLeftButtonPressed:(id)sender {
    // delete file in the document directory
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:[NSString stringWithUTF8String:mImagePath] error:nil];
    if( mIsVideo )
        [fileManager removeItemAtPath:[NSString stringWithUTF8String:mVideoPath] error:nil];
    
    [mActivityDesc setText:@""];
    [mActivityDesc resignFirstResponder];
    [self backToActivityView];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

    [mActivityDesc setDelegate:self];
    
    // add navigation bar
    mNavigationBar = [[totNavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [mNavigationBar setDelegate:self];
    [mNavigationBar setLeftButtonTitle:@"Back"];
    [mNavigationBar setBackgroundColor:[UIColor grayColor]];
    [mNavigationBar setAlpha:0.5];
    [self.view addSubview:mNavigationBar];
    
    // add thumbnail of the just taken photo
    mThumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(0, 60, 50, 50)];
    [self.view addSubview:mThumbnail];
    
//    UIImageView *textbubble = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"messagebox.png"]];
//    textbubble.frame = CGRectMake(0, 35, 360, 180);
//    [self.view insertSubview:textbubble belowSubview:mActivityDesc];
//    [textbubble release];
    
    // create the slider view
    mSliderView = [[totSliderView alloc] initWithFrame:CGRectMake(25, 180, 270, 260)];
    //mSliderView = [[totSliderView alloc] initWithFrame:CGRectMake(0, 151, 320, 260)];
    [mSliderView setDelegate:self];
    [mSliderView enablePageControlOnBottom];
    [self.view addSubview:mSliderView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [mNavigationBar release];
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
