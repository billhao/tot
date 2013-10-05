//
//  totHomeViewController.m
//  totdev
//
//  Created by Lixing Huang on 4/11/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "AppDelegate.h"
#import "totUITabBarController.h"
#import "totHomeEntryViewController.h"
#import "totHomeSleepingView.h"
#import "totLanguageInputViewController.h"
#import "totHomeRootController.h"
#import "totHomeDiaperView.h"
#import "../Utility/totImageView.h"
#import "../Activity/totActivityUtility.h"
#import "totEventName.h"
#import "totUtility.h"
#import "../Utility/totMediaLibrary.h"
#import "totHomeFeedingViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation totHomeEntryViewController

@synthesize homeRootController, MAX_SELECTED_ACTIVITIES;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        mediaLib = [[totMediaLibrary alloc] init];
//        mHomeSleepingView = [[totHomeSleepingView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
//        mHomeDiaperView = [[totHomeDiaperView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
//        mLanguageInputView = [[totLanguageInputViewController alloc] init];
//        
//        mMessage = [[NSMutableDictionary alloc] init];
        
        allActivities = nil;
        
        MAX_SELECTED_ACTIVITIES = 3;
        
        autoPlay = FALSE;
    }
    return self;
}

#pragma mark - View lifecycle
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setMultipleTouchEnabled:TRUE];
    
    // add photo view
    mPhotoViewA = [[totImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    mPhotoViewA.contentMode = UIViewContentModeScaleAspectFit;
    mPhotoViewA.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mPhotoViewA];
    mPhotoViewB = [[totImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    mPhotoViewB.contentMode = UIViewContentModeScaleAspectFit;
    mPhotoViewB.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mPhotoViewB];
    
    // add setting icon
    UIButton* settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    settingBtn.frame = CGRectMake(270, 0, 30, 60);
    settingBtn.backgroundColor = [UIColor colorWithRed:159.0/255.0 green:198.0/255.0 blue:231.0/255.0 alpha:1.0f];
    [settingBtn addTarget:self action:@selector(settingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingBtn];
    
    // add camera icon
    cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* cameraImg = [UIImage imageNamed:@"camera_button"];
    CGRect f = self.view.frame;
    int margin_x = 14;
    int margin_y = 4;
    cameraBtn.frame = CGRectMake(f.size.width-cameraImg.size.width-margin_x, f.size.height-cameraImg.size.height-margin_y, cameraImg.size.width, cameraImg.size.height);
    [cameraBtn setImage:cameraImg forState:UIControlStateNormal];
    [cameraBtn setImage:[UIImage imageNamed:@"camera_button_pressed"] forState:UIControlStateHighlighted];
    [cameraBtn addTarget:self action:@selector(cameraButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cameraBtn];
    
    // add scrapbook icon
    margin_x = margin_y;
    UIImage* sbImg = [UIImage imageNamed:@"scrapbook_button"];
    scrapbookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    scrapbookBtn.frame = CGRectMake(f.size.width-sbImg.size.width-margin_x, cameraBtn.frame.origin.y-sbImg.size.height+2, sbImg.size.width, sbImg.size.height);
    [scrapbookBtn setImage:sbImg forState:UIControlStateNormal];
    [scrapbookBtn setImage:[UIImage imageNamed:@"scrapbook_button_pressed"] forState:UIControlStateHighlighted];
    [scrapbookBtn addTarget:self action:@selector(scrapbookButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scrapbookBtn];

    // add auto play icon
    margin_x = margin_y;
    UIButton* autoplayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    autoplayBtn.frame = CGRectMake(f.size.width-sbImg.size.width-margin_x, cameraBtn.frame.origin.y-2*sbImg.size.height+2, sbImg.size.width, sbImg.size.height);
    autoplayBtn.backgroundColor = [UIColor clearColor];
    [autoplayBtn addTarget:self action:@selector(autoPlayButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:autoplayBtn];
    //[totUtility enableBorder:autoplayBtn];

    // add photo position in db
    int w = 36;
    int h = 16;
    photoPositionLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin_x, self.view.bounds.size.height-h-margin_y, w, h)];
    photoPositionLabel.alpha = 0.7;
    photoPositionLabel.backgroundColor = [UIColor grayColor];
    photoPositionLabel.textColor = [UIColor whiteColor];
    photoPositionLabel.font = [UIFont fontWithName:@"Raleway" size:10.0];
    photoPositionLabel.textAlignment = NSTextAlignmentCenter;
    photoPositionLabel.layer.cornerRadius = 2;
    [self.view addSubview:photoPositionLabel];
    
    // add menu icon
//    menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    menuBtn.frame = CGRectMake(285, 10, 25, 25);
//    [menuBtn setImage:[UIImage imageNamed:@"menu_button"] forState:UIControlStateNormal];
//    [menuBtn setImage:[UIImage imageNamed:@"menu_button_pressed"] forState:UIControlStateHighlighted];
//    [menuBtn addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:menuBtn];
    
    // add activity
    [self createActivityView];
    
    [self createSelectedActivitesView];
    [self updateSelectedActivitesView];
    
    // bind gesture events
    // left swipe
    UISwipeGestureRecognizer* leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGestureEvent:)];
    leftSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftSwipeRecognizer];
    [leftSwipeRecognizer release];
    
    // right swipe
    UISwipeGestureRecognizer* rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGestureEvent:)];
    rightSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipeRecognizer];
    [rightSwipeRecognizer release];

    // up swipe
    UISwipeGestureRecognizer* upSwipeRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGestureEvent:)];
    upSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:upSwipeRecognizer];
    [upSwipeRecognizer release];
    
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
    [self.view addGestureRecognizer:tapRecognizer];
    
    // show the most recent photo
    [self showPhoto:Animation_None];
}

- (void)dealloc {
    [super dealloc];
    
    if( allActivities != nil ) [allActivities release];
    if( scrapbookListController != nil ) [scrapbookListController release];
    if( photoPositionLabel ) [photoPositionLabel release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [mPhotoViewA release];
    
    [mMessage release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return FALSE;
}



#pragma mark - Event handler

// Respond to a swipe gesture
- (IBAction)swipeGestureEvent:(UISwipeGestureRecognizer *)swipeRecognizer {
    // Get the location of the gesture
    CGPoint location = [swipeRecognizer locationInView:self.view];
    NSLog(@"Swipe %d", swipeRecognizer.direction);
    if( swipeRecognizer.direction == UISwipeGestureRecognizerDirectionLeft ) {
        // show newer photo
        //[self showNextImage:TRUE]; // show newer image
        if( [mediaLib next] )
            [self showPhoto:Animation_Right_To_Left];
        else {
            // TODO show "this is the newest photo"
        }
    }
    else if( swipeRecognizer.direction == UISwipeGestureRecognizerDirectionRight ) {
        // show older photo
        //[self showNextImage:FALSE]; // show older image
        if( [mediaLib previous] )
            [self showPhoto:Animation_Left_To_Right];
        else {
            // TODO show "this is the oldest photo"
        }
    }
    else if( swipeRecognizer.direction == UISwipeGestureRecognizerDirectionUp ) {
        // show timeline
        [self.homeRootController switchTo:kTimeline withContextInfo:nil];
    }
}

- (void)tapEvent:(UITapGestureRecognizer *)tapRecognizer {
    CGPoint pt = [tapRecognizer locationInView:activityView];
    if( (!activityView.hidden) && [activityView pointInside:pt withEvent:nil] ) return; // do not respond to tap in activity view
    
    if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
        //NSLog(@"tap %d", tapRecognizer.numberOfTouches);
        // show or hide activity
        if( !activity_animation_on ) {
            activity_animation_on = TRUE;
            [self toggleActivity];
        }
    }
}

- (void)cameraButtonPressed: (id)sender {
    global.cameraView.cropWidth  = -1;
    global.cameraView.cropHeight = -1;
    [global.cameraView setDelegate:self];
    [global.cameraView launchCamera:self withEditing:TRUE];
}

- (void)menuButtonPressed: (id)sender {
}

- (void)scrapbookButtonPressed: (id)sender {
    [self.homeRootController switchTo:kScrapbook withContextInfo:nil];
}

- (void)settingButtonPressed: (id)sender {
    [self.homeRootController switchTo:kSetting withContextInfo:nil];
}

- (void)autoPlayButtonPressed: (id)sender {
    autoPlay = !autoPlay;
    if(autoPlay) [self autoPlay];
}

// add the selected activity
- (void)activityButtonPressed: (id)sender {
    UIButton* btn = (UIButton*)sender;
    NSLog(@"%d", btn.tag);
    
    // check if this activity has already been added
    
    // max icons in tag = 4, remove the first one if more than that
    MediaInfo* m = mediaLib.currentMediaInfo;
    NSMutableArray* selectedActivities = m.activities;
    if( selectedActivities.count >= 3 )
        [selectedActivities removeObjectAtIndex:0];
    
    // add this activity
    int i = btn.tag;
    [selectedActivities addObject:allActivities[i]];
    
    // remove this activity from list
    

    // update db if not default
    if( ![m isDefault] )
        [m save];
    
    // update UI
    [self updateSelectedActivitesView];
}

// remove this selected activity
- (void)selectedActivityButtonPressed: (id)sender {
    UIButton* btn = (UIButton*)sender;
    int i = btn.tag;
    
    MediaInfo* m = mediaLib.currentMediaInfo;
    NSMutableArray* selectedActivities = m.activities;
    
    // remove from selected list
    [selectedActivities removeObjectAtIndex:i];

    // add to all list
    
    // update db if not default
    if( ![m isDefault] )
        [m save];
    
    // update UI
    [self updateSelectedActivitesView];
}


#pragma mark - CameraViewDelegate

- (void) cameraView:(id)cameraView didFinishSavingMedia:(MediaInfo*)mediaInfo {
    mediaLib.currentMediaInfo = mediaInfo;
    NSLog(@"%@", mediaInfo.filename);

    [self showPhoto:Animation_None];
    [self toggleActivity];
}


- (void) saveImage:(UIImage*)photo intoFile:(NSString*)filename {
    UIImage *resizedPhoto = [totActivityUtility imageWithImage:photo scaledToSize:CGSizeMake(320, 480)];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *imagePath = [documentDirectory stringByAppendingPathComponent:filename];
    NSData *data = UIImageJPEGRepresentation(resizedPhoto, 0.8);
    [data writeToFile:imagePath atomically:NO];
}

- (void) saveVideo:(NSString*)videoPath intoFile:(NSString*)filename {
    NSURL *contentURL = [NSURL fileURLWithPath:videoPath];
    NSData *videoData = [NSData dataWithContentsOfURL:contentURL];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *path = [documentDirectory stringByAppendingPathComponent:filename];
    [videoData writeToFile:path atomically:NO];
}

- (void) cameraView:(id)cameraView didFinishSavingImageToAlbum:(UIImage*)photo {
    NSDate* today = [NSDate date];
    NSTimeInterval interval = [today timeIntervalSince1970];
    NSString *filename = [[NSString alloc] initWithFormat:@"%d.jpg", (int)interval];
    
    // add a record to db
    NSMutableDictionary* imageData = [[NSMutableDictionary alloc] init];
    [imageData setValue:filename forKey:@"filename"];
    [imageData setValue:[totEvent formatTime:today] forKey:@"added_at"];
    NSLog(@"first time %@", [totEvent formatTime:today]);
    NSString* activityName = [NSString stringWithFormat:ACTIVITY_PHOTO_REPLACABLE, filename];
    [global.model setItem:global.baby.babyID name:activityName value:imageData];


    NSLog(@"Photo filename: %@", filename);
    [self saveImage:photo intoFile:filename];
    
    [mMessage removeAllObjects];
    [mMessage setObject:filename forKey:@"storedImage"];
    [mMessage setObject:today forKey:@"added_at"];
    [filename release];
    
    // Switches to the next view.
    //[homeRootController switchTo:kHomeActivityLabelController withContextInfo:mMessage];
}

- (void) cameraView:(id)cameraView didFinishSavingVideoToAlbum:(NSString*)videoPath {
    NSDate *today = [NSDate date];
    NSTimeInterval interval = [today timeIntervalSince1970];
    NSString *filename = [[NSString alloc] initWithFormat:@"%d.mov", (int)interval];

    NSLog(@"Video filename: %@", filename);
    [self saveVideo:videoPath intoFile:filename];
    
    [mMessage setObject:filename forKey:@"storedVideo"];
    [filename release];
}

- (void) cameraView:(id)cameraView didFinishSavingThumbnail:(UIImage*)thumbnail {
    NSString *videoFilename = [mMessage objectForKey:@"storedVideo"];
    if (!videoFilename) {
        printf("Must have video filename\n");
        exit(-1);
    }
    NSString *thumbFilename = [videoFilename stringByAppendingString:@".jpg"];
    [self saveImage:thumbnail intoFile:thumbFilename];  // save the thumbnail.
    [mMessage setObject:thumbFilename forKey:@"storedImage"];
    
    // Switches to the next view.
    //[homeRootController switchTo:kHomeActivityLabelController withContextInfo:mMessage];
}


#pragma mark - Helper functions

- (void)createSelectedActivitesView {
    float y = 7;
    UIImage* bg = [UIImage imageNamed:@"activity_tag"];
    UIImage* line = [UIImage imageNamed:@"activity_line"];
    selectedActivities_bgView = [[UIView alloc] initWithFrame:CGRectMake(0, y, bg.size.width, bg.size.height)];
    selectedActivities_bgView.backgroundColor = [[UIColor alloc] initWithPatternImage:bg];
    selectedActivities_lineView = [[UIImageView alloc] initWithImage:line];
    selectedActivities_lineView.frame = CGRectMake(0, 0, line.size.width, line.size.height);
    [selectedActivities_bgView addSubview:selectedActivities_lineView];
    selectedActivities_bgView.hidden = TRUE;
    selectedActivities_lineView.tag = -1; // set the tag so we never remove this view from bg_view when load a new photo
    [self.view addSubview:selectedActivities_bgView];
}

- (void)updateSelectedActivitesView {
    float t1 = .5;
    float t2 = .5;
    if( selectedActivities_bgView.hidden )
        t1 = 0.0;
    
    [UIView animateWithDuration:t1 animations:^{
        // swipe out the bookmark
        CGRect f = selectedActivities_bgView.frame;
        f.origin.x = -f.size.width-2;
        selectedActivities_bgView.frame = f;
    } completion:^(BOOL finished) {
        // return if no selected activity
        NSMutableArray* selectedActivities = mediaLib.currentMediaInfo.activities;
        if( selectedActivities.count == 0 ){
            selectedActivities_bgView.hidden = TRUE;
            return;
        }
        
        for( UIView* v in selectedActivities_bgView.subviews ) {
            if( v.tag != -1 )
                [v removeFromSuperview];
        }
        selectedActivities_bgView.hidden = FALSE;
        // re-align everything
        int icon_width = 30;
        int icon_height = 30;
        int margin_x = 6;
        
        int cnt = selectedActivities.count;
        CGRect f_line = selectedActivities_lineView.frame;
        CGRect f_bg = selectedActivities_bgView.frame;
        float w = cnt*(icon_width+margin_x)+margin_x*2+f_line.size.width;
        int x_offset = f_bg.size.width - w;
        f_bg.origin.x = -x_offset;
        f_line.origin.x = x_offset + margin_x;
        selectedActivities_lineView.frame = f_line;
        
        // add selected activities
        for( int i=0; i<cnt; i++ ) {
            NSString* activity = selectedActivities[i];
            NSString* tmpname = [activity stringByReplacingOccurrencesOfString:@" " withString:@"_"];
            NSString* activityIconName = [NSString stringWithFormat:@"activity_%@", tmpname];
            
            UIButton* activityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            activityBtn.frame = CGRectMake(x_offset+margin_x*2+f_line.size.width+(cnt-1-i)*(margin_x+icon_width),
                                            (selectedActivities_bgView.frame.size.height-icon_height)/2, icon_width, icon_height);
            activityBtn.tag = i;
            [activityBtn setImage:[UIImage imageNamed:activityIconName] forState:UIControlStateNormal];
            [activityBtn addTarget:self action:@selector(selectedActivityButtonPressed:) forControlEvents:UIControlEventTouchDown];
            [selectedActivities_bgView addSubview:activityBtn];
        }
        
        // swipe in the bookmark
        [UIView animateWithDuration:t2 animations:^{
            selectedActivities_bgView.frame = f_bg;
        }];
    }];
}

- (void)showPhoto:(ANIMATIONTYPE)animation {
    MediaInfo* m = mediaLib.currentMediaInfo;
    //NSLog(@"photo event id: %ld", m.eventID);
    photoPositionLabel.text = [NSString stringWithFormat:@"%ld", m.eventID];
    
    if( ![m isDefault] ) {
        // show photo
        
        switch (animation) {
            case Animation_None:
                [mPhotoViewA imageFromFileContent:[totMediaLibrary getMediaPath:m.filename]];
                break;
            case Animation_Left_To_Right:
            case Animation_Right_To_Left:
                [self animateLeftRight:m direction:animation];
                break;
            case Animation_Fade_And_Scale:
                [self animateFadeAndScale:m];
                break;
        }
        
        // save last viewed photo
        [global.user setLastViewedPhoto:m];
    }
    else {
        mPhotoViewA.image = [UIImage imageNamed:m.filename];
    }
    
    [self updateSelectedActivitesView];
}

// Load activities from the json file. Returns the json object.
- (NSArray*)loadActivitiesFromFile {
    NSString* path = [[NSBundle mainBundle] pathForResource:@"Activities" ofType:@"json"];
    NSString* jsonStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    return [totHomeFeedingViewController JSONToObject:jsonStr];
}

- (void)createActivityView {
    allActivities = [[self loadActivitiesFromFile] retain];
    
    int numberOfIconsPerView = 4;
    float scrollview_width = 307;
    float icon_height = 47;
    float icon_width  = 47;
    float label_height  = 18;
    float label_width = 80;
    float margin_x_left = 18;
    float margin_x_right = 18;
    float margin_x = (scrollview_width-margin_x_left-margin_x_right-numberOfIconsPerView*icon_width)/(numberOfIconsPerView-1);
    float margin_y = 12;
    float margin_y_top = 16;
    float margin_y_bottom = 16;
    float margin_y_bottom_outside = 12;
    int rows = 2;
    int columns = ceil((float)allActivities.count/rows);
    float scrollview_height = margin_y_top+margin_y_bottom+rows*(icon_height+label_height)+(rows-1)*margin_y;
    
    // create the activity view (top view)
    CGRect f = self.view.frame;
    activityView = [[UIView alloc] initWithFrame:CGRectMake((f.size.width-scrollview_width)/2, f.size.height-margin_y_bottom_outside-scrollview_height, scrollview_width, scrollview_height)];
    activityView.clipsToBounds = TRUE;
    UIImageView* bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activity_bg"]];
    bg.frame = activityView.bounds;
    //    UIView* bg = [[UIView alloc] init];
    //    bg.backgroundColor = [UIColor grayColor];
    //    bg.alpha = 0.5;
    [activityView addSubview:bg];
    [bg release];
    
    // create the scroll view
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, scrollview_width, scrollview_height)];
    [activityView addSubview:scrollView];
    
    scrollView.pagingEnabled = FALSE;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    
    UIFont* font = [UIFont fontWithName:@"Raleway-SemiBold" size:14.0];
    BOOL debug = false;
    for (int c=0; c<columns; c++) {
        for( int r=0; r<rows; r++) {
            int i = c*rows+r;
            if( i >= allActivities.count ) break;
            // get the icon file names, just replace space with underscore
            NSString* activity = [allActivities objectAtIndex:i];
            NSString* tmpname = [activity stringByReplacingOccurrencesOfString:@" " withString:@"_"];
            NSString* activityIcon = [NSString stringWithFormat:@"activity_%@", tmpname];
            NSString* activityIconPressed = [NSString stringWithFormat:@"activity_%@_pressed", tmpname];
            
            UIButton* activityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            activityBtn.frame = CGRectMake(margin_x_left+c*(icon_width+margin_x), margin_y_top+r*(icon_height+label_height+margin_y), icon_width, icon_height);
            [activityBtn setImage:[UIImage imageNamed:activityIcon] forState:UIControlStateNormal];
            //[activityBtn setImage:[UIImage imageNamed:activityIconPressed] forState:UIControlStateHighlighted];
            activityBtn.tag = i;
            [activityBtn addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:activityBtn];
            if(debug) {
                activityBtn.layer.borderColor = [UIColor blackColor].CGColor;
                activityBtn.layer.borderWidth = 1.0;
            }
            
            UIButton* activityLabel = [UIButton buttonWithType:UIButtonTypeCustom];
            activityLabel.frame = CGRectMake(margin_x_left+c*(icon_width+margin_x)-(label_width-icon_width)/2, margin_y_top+r*(icon_height+label_height+margin_y)+icon_height, label_width, label_height);
            activityLabel.backgroundColor = [UIColor clearColor];
            activityLabel.alpha = 0.8;
            activityLabel.titleLabel.font = font;
            activityLabel.titleLabel.textAlignment = NSTextAlignmentCenter;
            activityLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            if(debug) {
                activityLabel.layer.borderColor = [UIColor blackColor].CGColor;
                activityLabel.layer.borderWidth = 1.0;
            }
            [activityLabel setTitle:activity forState:UIControlStateNormal];
            activityLabel.tag = i;
            [activityLabel addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:activityLabel];
        }
    }
    scrollView.contentSize = CGSizeMake(margin_x_left+margin_x_right+columns*icon_width+(columns-1)*margin_x,
                                        scrollview_height);
    [scrollView release];
    
    activityView.alpha  = 0.0;
    activityView.hidden = TRUE;
    [self.view addSubview:activityView];
}

- (void)toggleActivity {
    activity_animation_on = TRUE;
    BOOL hidden = activityView.hidden;
    [self toggleCamera];
    if( hidden )
        activityView.hidden = FALSE;
    [UIView animateWithDuration:.5 animations:^{
        activityView.alpha = 1.0 - activityView.alpha;
    } completion:^(BOOL finished) {
        activityView.hidden = !hidden;
        activity_animation_on = FALSE;
    }];
}

- (void)toggleCamera {
    BOOL hidden = cameraBtn.hidden;
    if( hidden ) {
        cameraBtn.hidden = FALSE;
        scrapbookBtn.hidden = FALSE;
    }
    [UIView animateWithDuration:.5 animations:^{
        cameraBtn.alpha = 1.0 - cameraBtn.alpha;
        scrapbookBtn.alpha = 1.0 - scrapbookBtn.alpha;
    } completion:^(BOOL finished) {
        cameraBtn.hidden = !hidden;
        scrapbookBtn.hidden = !hidden;
    }];
}

- (void)animateFadeAndScale:(MediaInfo*)m {
    // prepare animation
    CGRect f = CGRectMake(0, 0, 320, 480);
    float c = .1;
    f.origin.x = -f.size.width*c;
    f.origin.y = -f.size.height*c;
    f.size.height = (1+c*2)*f.size.height;
    f.size.width  = (1+c*2)*f.size.width;
    mPhotoViewB.frame = f;
    mPhotoViewB.alpha = 0;
    mPhotoViewB.hidden = FALSE;
    [mPhotoViewB imageFromFileContent:[totMediaLibrary getMediaPath:m.filename]];
    
    // fade out previous one
    [UIView animateWithDuration:1 animations:^{
        mPhotoViewA.alpha = 0;
        mPhotoViewB.alpha = 1;
    } completion:^(BOOL finished) {
    }];
    // show next one
    [UIView animateWithDuration:6.0 animations:^{
        CGRect f = CGRectMake(0, 0, 320, 480);
        mPhotoViewB.frame = f;
    } completion:^(BOOL finished) {
        // hide the other one
        mPhotoViewA.hidden = TRUE;
        // switch the two
        totImageView* v = mPhotoViewB;
        mPhotoViewB = mPhotoViewA;
        mPhotoViewA = v;

        [self autoPlay];
    }];
}

- (void)animateLeftRight:(MediaInfo*)m direction:(ANIMATIONTYPE)direction {
    // prepare animation
    CGRect f;
    if( direction == Animation_Left_To_Right )
        f = CGRectMake(-330, 0, 320, 480);
    else
        f = CGRectMake(330, 0, 320, 480);
    mPhotoViewB.frame = f;
    mPhotoViewB.alpha = 1;
    mPhotoViewB.hidden = FALSE;
    [mPhotoViewB imageFromFileContent:[totMediaLibrary getMediaPath:m.filename]];
    
    // show next one
    [UIView animateWithDuration:1.0 animations:^{
        CGRect f = CGRectMake(0, 0, 320, 480);
        mPhotoViewB.frame = f;
        if( direction == Animation_Left_To_Right )
            mPhotoViewA.frame = CGRectMake(330, 0, 320, 480);
        else
            mPhotoViewA.frame = CGRectMake(-330, 0, 320, 480);
    } completion:^(BOOL finished) {
        // hide the other one
        mPhotoViewA.hidden = TRUE;
        // switch the two
        totImageView* v = mPhotoViewB;
        mPhotoViewB = mPhotoViewA;
        mPhotoViewA = v;
        
        [self autoPlay];
    }];
}

// auto play
- (void)autoPlay {
    if( autoPlay ) {
        if( [mediaLib next] )
            [self showPhoto:Animation_Fade_And_Scale];
    }
}

@end
