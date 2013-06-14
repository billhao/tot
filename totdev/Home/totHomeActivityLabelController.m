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
#import "totEvent.h"

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
}

- (void)showImage:(NSString*)imageFileName {
    currentImageFileName = imageFileName;
    
    if( currentImageFileName == nil ) return;
    
    // load associated data
    [self loadActivity];
    NSLog(@"%@", currentImageData);
    
    // reset activity slider
    
    // update existing activity slider
    [self updateExistingActivitySlider];
    
    NSNumber* event_id = [currentImageData objectForKey:@"event_id"];
    title.text = [NSString stringWithFormat:@"%d", event_id.intValue];//currentImageFileName;

    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentDirectory = [paths objectAtIndex:0];
    NSString* imagePath = [documentDirectory stringByAppendingPathComponent:currentImageFileName];
    [backgroundImage setImage:[UIImage imageWithContentsOfFile:imagePath]];
}

// show next (newer) image if previous is false. show previous (older) image if true.
- (void)showNextImage:(BOOL)previous {
    // get the image file name to show
    NSDate* currentImageDate = [totEvent dateFromString:[currentImageData objectForKey:@"added_at"]];
    NSString* nextImageFileName = nil;
    
    NSArray* events;
    if( previous ) {
        events = [global.model getEvent:global.baby.babyID event:ACTIVITY_PHOTO limit:1 offset:-1 startDate:nil endDate:currentImageDate orderByDesc:TRUE];
        NSLog(@"Previous");
    }
    else {
        events = [global.model getEvent:global.baby.babyID event:ACTIVITY_PHOTO limit:1 offset:-1 startDate:currentImageDate endDate:nil orderByDesc:FALSE];
        NSLog(@"Next");
    }
    if( events.count > 0 ) {
        totEvent* event = [events objectAtIndex:0];
        // release???
        NSMutableDictionary* obj = [(NSMutableDictionary*)[totHomeFeedingViewController JSONToObject:event.value] retain];
        nextImageFileName = [obj objectForKey:@"filename"];
        NSLog(@"%d", event.event_id);
    }
    
    if( nextImageFileName != nil )
        [self showImage:nextImageFileName];
}

- (void)viewWillAppear:(BOOL)animated {
    [self showImage:currentImageFileName];
}

- (void)viewWillDisappear:(BOOL)animated {}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 411)];
    [self.view addSubview:backgroundImage];

    // title
    title = [[UILabel alloc]initWithFrame:CGRectMake(100, 20, 120, 20)];
    title.text = @"Label your photo";
    title.textAlignment = NSTextAlignmentCenter;
    title.backgroundColor = [UIColor blackColor];
    title.alpha = 1.0f;
    title.font = [UIFont systemFontOfSize:11];
    title.textColor = [UIColor whiteColor];
    [self.view addSubview:title];

    // score
    score = [[UILabel alloc]initWithFrame:CGRectMake(260, 20, 40, 20)];
    score.text = @"score";
    score.textAlignment = NSTextAlignmentCenter;
    score.backgroundColor = [UIColor blackColor];
    score.alpha = 0.5f;
    score.font = [UIFont systemFontOfSize:9];
    score.textColor = [UIColor whiteColor];
    [self.view addSubview:score];

    // exit button
    UIButton* exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    exitBtn.frame = CGRectMake(20, 20, 40, 20);
    [exitBtn setTitle:@"Exit" forState:UIControlStateNormal];
    [exitBtn setTitle:@"Exit" forState:UIControlStateSelected];
    [exitBtn setTitle:@"Exit" forState:UIControlStateHighlighted];
    [exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [exitBtn setBackgroundColor:[UIColor blackColor]];
    [exitBtn setAlpha:0.5f];
    [exitBtn addTarget:self action:@selector(exitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [exitBtn.titleLabel setFont:[UIFont systemFontOfSize:9]];
    [self.view addSubview:exitBtn];

    // category slider
    [self createActivitySlider];
    
    // create existing activity vertical slider
    [self createExistingActivitySlider];
    
    // init left and right gestures
    UISwipeGestureRecognizer* leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGestureEvent:)];
    leftSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftSwipeRecognizer];
    
    UISwipeGestureRecognizer* rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGestureEvent:)];
    rightSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipeRecognizer];
}

- (void)exitButtonPressed:(UIButton*)sender {
    [homeRootController switchTo:kHomeViewEntryView withContextInfo:nil];
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

+ (NSString*)getActivityName:(NSString*)currentImageFileName {
    //return @"activity/photo/1369913416.jpg";
    return [NSString stringWithFormat:ACTIVITY_PHOTO_REPLACABLE, currentImageFileName];
}

- (void)saveActivity {
    [global.model setItem:global.baby.babyID name:[totHomeActivityLabelController getActivityName:currentImageFileName] value:currentImageData];
}

// Respond to a swipe gesture
- (IBAction)swipeGestureEvent:(UISwipeGestureRecognizer *)swipeRecognizer {
    // Get the location of the gesture
    CGPoint location = [swipeRecognizer locationInView:self.view];
    NSLog(@"Swipe");
    if( swipeRecognizer.direction == UISwipeGestureRecognizerDirectionLeft ) {
        [self showNextImage:TRUE]; // show newer image
    }
    else if( swipeRecognizer.direction == UISwipeGestureRecognizerDirectionRight ) {
        [self showNextImage:FALSE]; // show older image
    }
//
//    // Display an image view at that location
//    [self drawImageForGestureRecognizer:recognizer atPoint:location];
//    
//    // If gesture is a left swipe, specify an end location
//    // to the left of the current location
//    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
//        location.x -= 220.0;
//    } else {
//        location.x += 220.0;
//    }
//    
//    // Animate the image view in the direction of the swipe as it fades out
//    [UIView animateWithDuration:0.5 animations:^{
//        self.imageView.alpha = 0.0;
//        self.imageView.center = location;
//    }];
}

- (void)dealloc {
    [super dealloc];
    [backgroundImage release];
    [mMessage release];
    if( currentImageData != nil ) [currentImageData release];
}

- (void)loadActivity {
    if( currentImageData != nil ) {
        [currentImageData release];
        currentImageData = nil;
    }
    
    totEvent* event = [global.model getItem:global.baby.babyID name:[totHomeActivityLabelController getActivityName:currentImageFileName]];
    if( event != nil ) {
        currentImageData = (NSMutableDictionary*)[totHomeFeedingViewController JSONToObject:event.value];
        [currentImageData retain];
        [currentImageData setObject:[NSNumber numberWithInt:event.event_id] forKey:@"event_id"];
    }
    else
        currentImageData = [[NSMutableDictionary alloc]init]; // create if not exist in db
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
