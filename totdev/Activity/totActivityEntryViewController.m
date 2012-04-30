//
//  totActivityEntryViewController.m
//  totdev
//
//  Created by Lixing Huang on 4/15/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totActivityEntryViewController.h"
#import "totImageView.h"
#import "totActivityRootController.h"
#import "AppDelegate.h"
#import "totActivityUtility.h"

@implementation totActivityEntryViewController

@synthesize activityRootController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        mActivityNames = [[NSMutableArray alloc] init];
        for( int i=0; i<8; i++ ) {
            [mActivityNames addObject:[NSString stringWithUTF8String:ACTIVITY_NAMES[i]]];
        }
        
        // mapping from activity to its child items
        const int keys[] = {
            kActivityVisionAttention,
            kActivityEyeContact,
            kActivityMirrorTest,
            kActivityImitation,
            kActivityGesture,
            kActivityEmotion,
            kActivityChew,
            kActivityMotorSkill
        };
        
        mActivityMembers = [[NSMutableDictionary alloc] init];
        for( int i=0; i<8; i++ ) {
            [mActivityMembers setObject:[NSString stringWithUTF8String:ACTIVITY_MEMBERS[i]] 
                                 forKey:[NSNumber numberWithInt:keys[i]]];
        }
        
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


#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void)prepareMessage:(NSMutableDictionary*)message for:(int)activity{
    char query[256] = {0};
    NSString *type_str = [mActivityNames objectAtIndex:activity];
    NSString *memb_str = [mActivityMembers objectForKey:[NSNumber numberWithInt:activity]];
    NSArray  *members  = [memb_str componentsSeparatedByString:@","];
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    NSMutableArray *margin = [[NSMutableArray alloc] init];
    
    int currentBabyId = [totActivityUtility getCurrentBabyID];
    
    for( int i=0; i<[members count]; i++ ) {
        const char* c_str_type = [type_str UTF8String];
        const char* c_str_memb = [[members objectAtIndex:i] UTF8String];
        sprintf(query, "%s/%s", c_str_type, c_str_memb);
        
        NSMutableArray *queryResult = [mTotModel getEvent:currentBabyId event:[NSString stringWithUTF8String:query]];
        
        int querySize = [queryResult count];
        switch(querySize) {
            case 0:
                [images addObject:[[members objectAtIndex:i] stringByAppendingString:@".png"]];
                [margin addObject:[NSNumber numberWithBool:NO]];
                break;
            case 1:
                [totActivityUtility extractFromEvent:[queryResult objectAtIndex:0] 
                        intoImageArray:images];
                [margin addObject:[NSNumber numberWithBool:NO]];
                break;
            default:
                [totActivityUtility extractFromEvent:[queryResult objectAtIndex:0] 
                        intoImageArray:images];
                [margin addObject:[NSNumber numberWithBool:YES]];
                break;
        }
    }
    
    [message setObject:images forKey:@"images"];
    [message setObject:margin forKey:@"margin"];
    [message setObject:[NSNumber numberWithInt:activity] forKey:@"activity"];
    
    [margin release];
    [images release];
}

- (void)buttonPressed: (id)sender {
    NSMutableDictionary *message = [[NSMutableDictionary alloc] init];
    UIButton *btn = (UIButton*)sender;
    int tag = [btn tag];
    
    printf("%s\n", [[mActivityNames objectAtIndex:tag] UTF8String]);
    
    // message contains two objects:
    // images => MSMutableArray, each element is a path to the image
    // margin => MSMutableArray, each element is a yes or no
    [self prepareMessage:message for:tag];
    [activityRootController switchTo:kActivityView withContextInfo:message];
    
    [message release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    totImageView *background = [[totImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 411)];
    [background imageFilePath:@"challenge_background.png"];
    [self.view addSubview:background];
    [background release];
    
    // create eight buttons
    int w    = 75;
    int h    = 75;
    int x[8] = {10, 122, 235, 10, 235, 10, 122, 235};
    int y[8] = {33, 33, 33, 158, 158, 283, 283, 283};

    for( int i=0; i<8; i++ ) {
        UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        imageButton.frame = CGRectMake(x[i], y[i], w, h);
        imageButton.tag = i;
        
        NSString *imageName = [[mActivityNames objectAtIndex:i] stringByAppendingString:@".png"];
        [imageButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [imageButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:imageButton];
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [mActivityNames release];
    [mActivityMembers release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
