//
//  totHomeFeedingViewController.m
//  totdev
//
//  Created by Yifei Chen on 5/6/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "totHomeFeedingViewController.h"
#import "totHomeRootController.h"
#import "../Utility/totSliderView.h"
#import "../Model/totModel.h"
#import "../STHorizontalPicker.h"


@implementation totHomeFeedingViewController

@synthesize homeRootController;
@synthesize mSliderView;
@synthesize mCurrentFoodID;
@synthesize navigationBar;
@synthesize mOKButton;

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

- (void)pickerView:(STHorizontalPicker *)picker didSelectValue:(CGFloat)value {

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
    int tag = [btn tag];
    tag = tag - 1;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // create the slider view
    mSliderView = [[totSliderView alloc] initWithFrame:CGRectMake(25, 45, 270, 300)];
    [mSliderView setDelegate:self];
    [mSliderView enablePageControlOnTop];
    
    //load image
    NSMutableArray *foodImages = [[NSMutableArray alloc] init];
    [foodImages addObject:[UIImage imageNamed:@"emotion_angry.png"]];
    [foodImages addObject:[UIImage imageNamed:@"gesture_salut.png"]];
    [foodImages addObject:[UIImage imageNamed:@"gesture_wave.png"]];
    [foodImages addObject:[UIImage imageNamed:@"motor_skill_crawl.png"]];
    [foodImages addObject:[UIImage imageNamed:@"motor_skill_jump.png"]];
    [foodImages addObject:[UIImage imageNamed:@"gesture_suck_toe.png"]];
    [foodImages addObject:[UIImage imageNamed:@"gesture_point.png"]];
    [foodImages addObject:[UIImage imageNamed:@"emotion_happy.png"]];
    [mSliderView setContentArray:foodImages];
    [foodImages release];
    
    [mSliderView getWithPositionMemoryIdentifier:@"homeFeedingView"];

    [self.view addSubview:mSliderView];
    
    //create title navigation bar
    navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    [self.view addSubview:navigationBar];
    
    //create picker for oz
    /*
    picker_quantity = [[STHorizontalPicker alloc] initWithFrame:CGRectMake(0, 0, 320, 31)];
    picker_quantity.name = @"picker_weight";
    [picker_quantity setMinimumValue:0.0];
    [picker_quantity setMaximumValue:6.0];
    [picker_quantity setSteps:60];
    [picker_quantity setDelegate:self];
    [picker_quantity setValue:2.3];
    [self.view addSubview:picker_quantity];
//    [picker_quantity release];
     */
    
    //create ok button
    mOKButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    mOKButton.frame = CGRectMake(20, 347, 280, 40);
    [mOKButton setTitle:@"OK" forState:UIControlStateNormal];
    [self.view addSubview:mOKButton];

}

- (void)OKButtonClicked: (UIButton *)button {}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [mBackground release];
    [mSliderView release];
    [mMessage release];
    [navigationBar release];
    [picker_quantity release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
