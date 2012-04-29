//
//  totActivityInfoViewController.m
//  totdev
//
//  Created by Lixing Huang on 4/15/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totActivityInfoViewController.h"
#import "totImageView.h"
#import "../Utility/totSliderView.h"
#import "../Utility/totUtility.h"

@implementation totActivityInfoViewController

@synthesize activityRootController;
@synthesize mActivityDesc;

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

- (void)setInfo:(NSMutableDictionary *)info {}


// load image content here for scroll view
- (NSArray *)getImages {
    NSMutableArray *arr = [[[NSMutableArray alloc] init] autorelease];  
    
    int eleNum = 26;
    
    for (int i=0;i<eleNum;i++){
        NSString *imageFileName = [NSString stringWithFormat:@"%d.png",i + 1];
        
        [arr addObject:[UIImage imageNamed:imageFileName]]; 
    }
    
    return (NSArray *)arr;  
}

// set optional margin array to indicate which button(s) need a margin shows it has multiple content
- (NSArray *)setMargin{
    NSMutableArray *arr = [[[NSMutableArray alloc] init] autorelease];  
    
    int eleNum = 26;
    
    for (int i=0;i<eleNum;i++){
        [arr addObject:[NSNumber numberWithBool:NO]];
    }
    
    [arr replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:YES]];
    [arr replaceObjectAtIndex:1 withObject:[NSNumber numberWithBool:YES]];
    
    return arr;
}

#pragma totSliderView delegate
- (void)buttonPressed:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Button pressed"
													message:[NSString stringWithFormat:@"You pressed the button on button %d.", [sender tag]]
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
    
    
	[alert show];
	[alert release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    int textbox_xOrigin=140;
    int textbox_yOrigin=20;
    int textbox_width = 170;
    int textbox_height = 130;
    
    UITextView *textbox = [[UITextView alloc] init];
    textbox.frame = CGRectMake(textbox_xOrigin, textbox_yOrigin,
                               textbox_width, textbox_height);   
    textbox.backgroundColor =[UIColor clearColor];
    [self.view addSubview:textbox];
    [textbox release];
    
    UIImageView *textbubble = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"messagebox.png"]];
    textbubble.frame = CGRectMake(textbox_xOrigin-40,-5,
                                  textbox_width+80, textbox_height+60);    
    
    //[self.view insertSubview:textbubble belowSubview:mActivityDesc];
    [self.view insertSubview:textbubble belowSubview:textbox];
    [textbubble release];
    
    
    //load image    
    UIImage* origImage = [UIImage imageNamed:@"1.png"];
    UIImage *squareImage = [totUtility squareCropImage:origImage];
    

    UIImageView *img = [[UIImageView alloc] init];
    img.frame = CGRectMake(10, textbox_yOrigin, 120, 120);
    img.image = squareImage;
    [self.view addSubview:img];
    [img release];
    
    //load slider view
    totSliderView *sv = [[totSliderView alloc] init];  
    [sv setDelegate:self];
    [sv setContentArray:[self getImages]]; 
    [sv setMarginArray: [self setMargin]];
    [sv setPosition:151];
    [sv enablePageControlOnBottom];  
    [self.view addSubview:[sv getWithPositionMemory:@"InfoView"]];  
    //[self.view addSubview:[sv get]];//no memory to hold last-viewed page position
    
    //for test 
    self.view.backgroundColor = [UIColor blackColor];

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

@end
