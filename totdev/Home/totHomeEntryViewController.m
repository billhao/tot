//
//  totHomeViewController.m
//  totdev
//
//  Created by Lixing Huang on 4/11/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totHomeEntryViewController.h"
#import "totHomeSleepingView.h"
#import "totLanguageInputViewController.h"
#import "totHomeRootController.h"
#import "../Utility/totImageView.h"

@implementation totHomeEntryViewController

@synthesize homeRootController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        mHomeSleepingView = [[totHomeSleepingView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        mLanguageInputView = [[totLanguageInputViewController alloc] init];
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

- (void)buttonPressed: (id)sender {
    UIButton *btn = (UIButton*)sender;
    int tag = btn.tag;
    switch (tag) {
        case kBasicSleep:
            if( mHomeSleepingView.mIsSleeping )
                [mHomeSleepingView stopSleeping];
            else
                [mHomeSleepingView startSleeping];
            break;
        case kBasicLanguage:
            [mLanguageInputView Display];
            break;
        case kBasicFood:
            [homeRootController switchTo:kHomeViewFeedView withContextInfo:nil];
            break;
        case kBasicHeight:
        case kBasicWeight:
        case kBasicHead:
            [homeRootController switchTo:kHomeViewHeightView withContextInfo:nil];
            break;
        case kBasicDiaper:
            [homeRootController switchTo:kHomeViewDiaperView withContextInfo:nil];
            break;
        default:
            break;
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // create background
    totImageView *background = [[totImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    [background imageFilePath:@"home_background.png"];
    [self.view addSubview:background];
    [background release];

    // create buttons
    int buttonW[8] = {117, 120, 102, 67, 112, 85, 90, 65};
    int buttonH[8] = {127, 97, 275, 87, 90, 87, 92, 75};
    int buttonX[8] = {7, 200, 5, 240, 112, 225, 225, 132};
    int buttonY[8] = {22, 45, 150, 142, 247, 230, 318, 85};
    const char *buttonName[8] = {
        "language.png", 
        "sleep.png", 
        "height.png", 
        "food.png", 
        "diaper.png", 
        "health.png", 
        "weight.png", 
        "head.png"
    };
    for( int i = 0; i <= 7; i++ ) {
        UIButton *function = [UIButton buttonWithType:UIButtonTypeCustom];
        function.frame = CGRectMake(buttonX[i], buttonY[i], buttonW[i], buttonH[i]);
        function.tag = i;
        [function setImage:[UIImage imageNamed:[NSString stringWithUTF8String:buttonName[i]]] forState:UIControlStateNormal];
        [function addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:function];
    }
    
    // create subview
    mHomeSleepingView.mParentView = self.view;
    [self.view addSubview:mHomeSleepingView];
    [mHomeSleepingView addTimeDisplayLabel];
    
    [self.view addSubview:mLanguageInputView.view];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [mHomeSleepingView release];
    [mLanguageInputView release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
