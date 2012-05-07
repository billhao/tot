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
#import "../Utility/totImageView.h"

@implementation totHomeEntryViewController

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
            [mHomeSleepingView setParentView:self.view];
            [mHomeSleepingView startSleeping];
            break;
        case kBasicLanguage:
            [mLanguageInputView Display];
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
    UIButton *sleepButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sleepButton.frame = CGRectMake(20, 20, 75, 75);
    sleepButton.tag = kBasicSleep;
    [sleepButton setImage:[UIImage imageNamed:@"sleep.png"] forState:UIControlStateNormal];
    [sleepButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sleepButton];
    
    UIButton *languageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    languageButton.frame = CGRectMake(100, 100, 75, 75);
    languageButton.tag = kBasicLanguage;
    [languageButton setImage:[UIImage imageNamed:@"language.png"] forState:UIControlStateNormal];
    [languageButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:languageButton];
    
    // create subview
    [self.view addSubview:mHomeSleepingView];
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
