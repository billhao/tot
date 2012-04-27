//
//  totActivityViewController.m
//  totdev
//
//  Created by Lixing Huang on 4/15/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totActivityViewController.h"
#import "totImageView.h"
#import "../Utility/totSliderView.h"

@implementation totActivityViewController

@synthesize activityRootController;

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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    totSliderView *sv = [[totSliderView alloc] init];  
    [sv setContentArray:[self getImages]]; 
    [sv setMarginArray: [self setMargin]];
    [sv setPosition:105];
    [sv enablePageControlOnBottom];  
    //[sv enablePageControlOnTop];
    [self.view addSubview:[sv getWithPositionMemory]];  
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
