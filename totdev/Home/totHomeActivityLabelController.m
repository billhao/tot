//
//  totHomeActivityLabelController.m
//  totdev
//
//  Created by Lixing Huang on 4/25/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import "totHomeRootController.h"
#import "totHomeActivityLabelController.h"
#import "totEventName.h"
#import "totEvent.h"
#import "Global.h"
#import "totHomeFeedingViewController.h"

@interface totHomeActivityLabelController ()

@end

@implementation totHomeActivityLabelController
@synthesize homeRootController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self initActivities];
        currentChildSlider = nil;
        currentImageFileName = nil;
        currentImageData = nil;
        
        self.view.backgroundColor = [UIColor whiteColor];
        self.view.userInteractionEnabled = YES;
        mMessage = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)receiveMessage: (NSMutableDictionary*)message {
    currentImageFileName = [message objectForKey:@"storedImage"];
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentDirectory = [paths objectAtIndex:0];
    NSString* imagePath = [documentDirectory stringByAppendingPathComponent:currentImageFileName];
    [backgroundImage setImage:[UIImage imageWithContentsOfFile:imagePath]];
}

- (void)viewWillAppear:(BOOL)animated {
    if( currentImageFileName == nil ) return;
    
    // load associated data
    [self loadActivity];
    NSLog(@"%@", currentImageData);
    
    // reset activity slider
    
    // update existing activity slider
    [self updateExistingActivitySlider];
    
    title.text = currentImageFileName;
}

- (void)viewWillDisappear:(BOOL)animated {}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 411)];
    [self.view addSubview:backgroundImage];

    // title
    title = [[UILabel alloc]initWithFrame:CGRectMake(100, 20, 120, 40)];
    title.text = @"Label your photo";
    title.textAlignment = NSTextAlignmentCenter;
    title.backgroundColor = [UIColor clearColor];
    title.font = [UIFont systemFontOfSize:9];
    title.textColor = [UIColor whiteColor];
    [self.view addSubview:title];

    // category slider
    [self createActivitySlider];
    
    // create existing activity vertical slider
    [self createExistingActivitySlider];
}

-(void)createExistingActivitySlider {
    // create slider
    mExistingActivitySlider = [[totSliderView alloc] initWithFrame:CGRectMake(260, 0, 80, 300)];
    [mExistingActivitySlider setDelegate:self];
    [mExistingActivitySlider setBtnPerCol:4];
    [mExistingActivitySlider setBtnPerRow:1];
    [mExistingActivitySlider setBtnWidthHeightRatio:1.0f];
    [self.view addSubview:mExistingActivitySlider];
}

-(void)updateExistingActivitySlider {
    //load image
    NSMutableArray* categoriesImages = [[NSMutableArray alloc]init];
    NSMutableArray* labels = [currentImageData objectForKey:@"labels"];
    if( labels != nil ) {
        for( int i=0; i<labels.count; i++ ) {
            [categoriesImages addObject:[UIImage imageNamed:[labels objectAtIndex:i]]];
        }
    }

    if( mExistingActivitySlider != nil ) {
        [mExistingActivitySlider removeFromSuperview];
        [mExistingActivitySlider release];
    }
        
    mExistingActivitySlider = [[totSliderView alloc] initWithFrame:CGRectMake(260, 0, 80, 300)];
    [mExistingActivitySlider setDelegate:self];
    [mExistingActivitySlider setBtnPerCol:4];
    [mExistingActivitySlider setBtnPerRow:1];
    [mExistingActivitySlider setBtnWidthHeightRatio:1.0f];
    [mExistingActivitySlider retainContentArray:categoriesImages];
    [mExistingActivitySlider get];
    [self.view addSubview:mExistingActivitySlider];
    [categoriesImages release];
}

-(void)createActivitySlider {
    //load image
    NSMutableArray *categoriesImages = [[NSMutableArray alloc] init];
    for( int i=0; i<mActivities.count; i++ ) {
        [categoriesImages addObject:[UIImage imageNamed:[mActivities objectAtIndex:i]]];
    }

    // create slider
    mActivitySlider = [[totSliderView alloc] initWithFrame:CGRectMake(0, 260, 320, 80)];
    [mActivitySlider setDelegate:self];
    [mActivitySlider setBtnPerCol:1];
    [mActivitySlider setBtnPerRow:4];
    [mActivitySlider setBtnWidthHeightRatio:1.0f];
    
    [mActivitySlider retainContentArray:categoriesImages];
    [mActivitySlider get];
    [self.view addSubview:mActivitySlider];
    
    // set up child sliders
    mActivityChildrenSliders = [[NSMutableArray alloc] init];
    for (int i=0; i<categoriesImages.count; i++) {
        [mActivityChildrenSliders addObject:[NSNull null]];
    }

    [categoriesImages release];
}

-(totSliderView*)getActivityChildrenSlider:(int)index {
    totSliderView* obj = [mActivityChildrenSliders objectAtIndex:index];
    if( (NSNull*)obj != [NSNull null] ) return obj;
    
    //load image in this activity
    NSString* activity = [mActivities objectAtIndex:index];
    NSMutableArray* childActivities = [mActivityChildren objectForKey:activity];
    if( childActivities == nil ) return nil;
    
    NSMutableArray *childActivityImages = [[NSMutableArray alloc] init];
    for( int i=0; i<childActivities.count; i++ ) {
        [childActivityImages addObject:[UIImage imageNamed:[childActivities objectAtIndex:i]]];
    }
    
    // create if nil
    totSliderView* childSlider = [[totSliderView alloc] initWithFrame:CGRectMake(0, 340, 320, 80)];
    [childSlider setDelegate:self];
    [childSlider setBtnPerCol:1];
    [childSlider setBtnPerRow:4];
    [childSlider setBtnWidthHeightRatio:1.0f];
    
    [childSlider retainContentArray:childActivityImages];
    [childSlider get];
    [childActivityImages release];
    [mActivityChildrenSliders replaceObjectAtIndex:index withObject:childSlider];
    return childSlider;
}

- (void)sliderView:(totSliderView*)sv buttonPressed:(id)sender {
    UIButton *btn = (UIButton*)sender;
    int tag = [btn tag] - 1;
    NSString* activityToSave = nil;

    if( sv == mActivitySlider ) {
        currentSelectedActivity = [mActivities objectAtIndex:tag];
        NSLog(@"%d %@", tag, currentSelectedActivity);
        // hide current
        if( currentChildSlider != nil ) [currentChildSlider removeFromSuperview];
        
        // set current
        currentChildSlider = [self getActivityChildrenSlider:tag];
        if( currentChildSlider != nil )
            [self.view addSubview:currentChildSlider];
        else
            activityToSave = currentSelectedActivity;
    }
    else if (sv == mExistingActivitySlider ) {
    }
    else {
        // one of the child sliders
        NSMutableArray* childActivities = [mActivityChildren objectForKey:currentSelectedActivity];
        if( childActivities != nil ) {
            NSString* childActivity = [childActivities objectAtIndex:tag];
            NSLog(@"%d %@", tag, childActivity);
            activityToSave = childActivity;
        }
    }
    
    if( activityToSave != nil ) {
        // this activity has no children
        NSMutableArray* labels = [currentImageData objectForKey:@"labels"];
        if( labels == nil ) {
            labels = [[NSMutableArray alloc]init];
            [currentImageData setObject:labels forKey:@"labels"];
            [labels release];
        }
        // check if exists already
        if( [labels indexOfObject:activityToSave] == NSNotFound ) {
            [labels addObject:activityToSave];
            [self saveActivity];
            [self updateExistingActivitySlider];
        }
    }
}

- (NSString*)getActivityName {
    //return @"activity/photo/1369913416.jpg";
    return [NSString stringWithFormat:ACTIVITY_PHOTO, currentImageFileName];
}

- (void)saveActivity {
    [global.model setItem:global.baby.babyID name:[self getActivityName] value:currentImageData];
}

- (void)loadActivity {
    if( currentImageData != nil ) {
        [currentImageData release];
        currentImageData = nil;
    }

    totEvent* event = [global.model getItem:global.baby.babyID name:[self getActivityName]];
    if( event != nil ) {
        currentImageData = (NSMutableDictionary*)[totHomeFeedingViewController JSONToObject:event.value];
        [currentImageData retain];
    }
    else
        currentImageData = [[NSMutableDictionary alloc]init]; // create if not exist in db
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [super dealloc];
    [backgroundImage release];
    [mMessage release];
    if( currentImageData != nil ) [currentImageData release];
}

- (void)initActivities {
    mActivities = [[NSMutableArray alloc] initWithObjects:
      @"chew",
      @"emotion",
      @"eye_contact",
      @"gesture",
      @"imitation",
      @"mirror_test",
      @"motor_skill",
      @"vision_attention",
      nil
    ];
    
    mActivityChildren = [[NSMutableDictionary alloc] initWithCapacity:mActivities.count];
    [mActivityChildren setObject:[[NSMutableArray alloc] initWithObjects:
      @"emotion_angry",
      @"emotion_disgust",
      @"emotion_fear",
      @"emotion_happy",
      @"emotion_sad",
      @"emotion_surprise",
      nil] forKey:@"emotion"];
    [mActivityChildren setObject:[[NSMutableArray alloc] initWithObjects:
      @"gesture_clap",
      @"gesture_point",
      @"gesture_salut",
      @"gesture_suck_thumb",
      @"gesture_suck_toe",
      @"gesture_wave",
      nil] forKey:@"gesture"];
    [mActivityChildren setObject:[[NSMutableArray alloc] initWithObjects:
      @"motor_skill_crawl",
      @"motor_skill_cruise",
      @"motor_skill_dance",
      @"motor_skill_jump",
      @"motor_skill_kick_leg",
      @"motor_skill_lift_neck",
      @"motor_skill_roll_over",
      @"motor_skill_run",
      @"motor_skill_sit",
      @"motor_skill_stand",
      @"motor_skill_walk",
      nil] forKey:@"motor_skill"];
}
@end
