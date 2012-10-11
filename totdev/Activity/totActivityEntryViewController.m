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
#import "totActivityConst.h"

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
        
        // mapping from button tag to activity name
        mActivityMembers = [[NSMutableDictionary alloc] init];
        for( int i=0; i<8; i++ ) {
            [mActivityMembers setObject:[NSString stringWithUTF8String:ACTIVITY_MEMBERS[i]] 
                                 forKey:[NSNumber numberWithInt:i]];
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
    NSString * type_str = [mActivityNames objectAtIndex:activity];
    NSString * memb_str = [mActivityMembers objectForKey:[NSNumber numberWithInt:activity]];
    NSArray  * members  = [memb_str componentsSeparatedByString:@","];
    
    NSMutableArray * images = [[NSMutableArray alloc] init];
    NSMutableArray * margin = [[NSMutableArray alloc] init];
    
    int currentBabyId = [totActivityUtility getCurrentBabyID];
    
    // split empty string => [""]
    if ([members count] < 2) {  // If this activity does not have child items
        NSMutableArray * query_result = [mTotModel getEvent:currentBabyId event:type_str];
        int result_size = [query_result count];
        switch (result_size) {
            case 0:
                break;
            case 1:
                [totActivityUtility extractFromEvent:[query_result objectAtIndex:0] intoImageArray:images];
                [margin addObject:[NSNumber numberWithBool:NO]];
                break;
            default:
                [totActivityUtility extractFromEvent:[query_result objectAtIndex:0] intoImageArray:images];
                [margin addObject:[NSNumber numberWithBool:YES]];
                break;
        }
    } else {
        for( int i=0; i<[members count]; ++i ) {
            NSString * query = [NSString stringWithFormat:@"%s/%s", [type_str UTF8String], [[members objectAtIndex:i] UTF8String]];
            NSMutableArray *query_result = [mTotModel getEvent:currentBabyId event:query];
            int result_size = [query_result count];
            switch(result_size) {
                case 0:
                    [images addObject:[[members objectAtIndex:i] stringByAppendingString:@".png"]];
                    [margin addObject:[NSNumber numberWithBool:NO]];
                    break;
                case 1:
                    [totActivityUtility extractFromEvent:[query_result objectAtIndex:0] intoImageArray:images];
                    [margin addObject:[NSNumber numberWithBool:NO]];
                    break;
                default:
                    [totActivityUtility extractFromEvent:[query_result objectAtIndex:0] intoImageArray:images];
                    [margin addObject:[NSNumber numberWithBool:YES]];
                    break;
            }
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
    [background imageFilePath:@"family_fun_main_bg.png"];
    [self.view addSubview:background];
    [background release];
    
    // create eight buttons
    int w    = 75;
    int h    = 75;
    int x[8] = {24, 124, 224, 24, 124, 224, 24, 124};
    int y[8] = {20, 20, 20, 124, 124, 124, 230, 230};

    for( int i=0; i<8; i++ ) {
        UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
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
