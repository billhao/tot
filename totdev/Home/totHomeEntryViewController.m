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

@synthesize homeRootController;

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
        selectedActivities = nil;
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
    mPhotoView = [[totImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [self.view addSubview:mPhotoView];
    
    // add camera icon
    cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* cameraImg = [UIImage imageNamed:@"camera_button"];
    CGRect f = self.view.frame;
    int margin_x = 10;
    int margin_y = 10;
    cameraBtn.frame = CGRectMake(f.size.width-cameraImg.size.width-margin_x, f.size.height-cameraImg.size.height-margin_y, cameraImg.size.width, cameraImg.size.height);
    [cameraBtn setImage:cameraImg forState:UIControlStateNormal];
    [cameraBtn setImage:[UIImage imageNamed:@"camera_button_pressed"] forState:UIControlStateHighlighted];
    [cameraBtn addTarget:self action:@selector(cameraButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cameraBtn];
    
    // add scrapbook icon
//    scrapbookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    scrapbookBtn.frame = CGRectMake(0, 400, 60, 60);
//    [scrapbookBtn setImage:[UIImage imageNamed:@"scrapbook_button"] forState:UIControlStateNormal];
//    [scrapbookBtn setImage:[UIImage imageNamed:@"scrapbook_button_pressed"] forState:UIControlStateHighlighted];
//    [scrapbookBtn addTarget:self action:@selector(scrapbookButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:scrapbookBtn];

    // add menu icon
//    menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    menuBtn.frame = CGRectMake(285, 10, 25, 25);
//    [menuBtn setImage:[UIImage imageNamed:@"menu_button"] forState:UIControlStateNormal];
//    [menuBtn setImage:[UIImage imageNamed:@"menu_button_pressed"] forState:UIControlStateHighlighted];
//    [menuBtn addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:menuBtn];
    
    // add the camera view to window
    [self.view addSubview:global.cameraView.view];
    
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
    [self showPhoto:nil];
}

- (void)dealloc {
    [super dealloc];
    
    if( allActivities != nil ) [allActivities release];
    if( selectedActivities != nil ) [selectedActivities release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [mPhotoView release];
    
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

- (void)showPhoto:(MediaInfo*)mediaInfo {
    if( mediaInfo == nil ) {
        // get the last viewed photo when first entering this view
        mediaInfo = [global.user getLastViewedPhoto];
        if( mediaInfo == nil) {
            // show default photo
            [mPhotoView imageFilePath:@"home_bg"];
            return;
        }
    }
    else {
        // save last viewed photo
        [global.user setLastViewedPhoto:mediaInfo];
    }
    
    // load selected activities here
    selectedActivities = [[NSMutableArray alloc] init];
    
    // show photo
    [mPhotoView imageFromFileContent:[totMediaLibrary getMediaPath:mediaInfo.filename]];
    
    [self showSelectedActivities];
}

- (void)showSelectedActivities {
    
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
    float scrollview_width = 300;
    float icon_height = 47;
    float icon_width  = 47;
    float label_height  = 20;
    float label_width = 80;
    float margin_x_left = 16;
    float margin_x_right = 16;
    float margin_x = (scrollview_width-margin_x_left-margin_x_right-numberOfIconsPerView*icon_width)/(numberOfIconsPerView-1);
    float margin_y = 10;
    float margin_y_top = 10;
    float margin_y_bottom = 10;
    int rows = 2;
    int columns = ceil((float)allActivities.count/rows);
    float scrollview_height = margin_y_top+margin_y_bottom+rows*(icon_height+label_height)+(rows-1)*margin_y;
    
    // create the activity view (top view)
    CGRect f = self.view.frame;
    activityView = [[UIView alloc] initWithFrame:CGRectMake((f.size.width-scrollview_width)/2, f.size.height-margin_y_bottom-scrollview_height, scrollview_width, scrollview_height)];
    activityView.clipsToBounds = TRUE;
    //UIImageView* bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activity_background"]];
    UIView* bg = [[UIView alloc] init];
    bg.frame = activityView.bounds;
    bg.backgroundColor = [UIColor grayColor];
    bg.alpha = 0.5;
    [activityView addSubview:bg];
    [bg release];
    
    // create the scroll view
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, scrollview_width, scrollview_height)];
    [activityView addSubview:scrollView];
    
    scrollView.pagingEnabled = FALSE;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    
    UIFont* font = [UIFont fontWithName:@"Raleway-SemiBold" size:12.0];
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
    
    activityView.hidden = TRUE;
    [self.view addSubview:activityView];
}

- (void)toggleActivity {
    activityView.hidden = !activityView.hidden;
    [self toggleCamera];
}

- (void)toggleCamera {
    cameraBtn.hidden = !cameraBtn.hidden;
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
        [mediaLib next];
        if( mediaLib.currentMediaInfo != nil) {
            [self showPhoto:mediaLib.currentMediaInfo];
            NSLog(@"photo event id: %ld", mediaLib.currentMediaInfo.eventID);
        }
    }
    else if( swipeRecognizer.direction == UISwipeGestureRecognizerDirectionRight ) {
        // show older photo
        //[self showNextImage:FALSE]; // show older image
        [mediaLib previous];
        if( mediaLib.currentMediaInfo != nil) {
            [self showPhoto:mediaLib.currentMediaInfo];
            NSLog(@"photo event id: %ld", mediaLib.currentMediaInfo.eventID);
        }
    }
    else if( swipeRecognizer.direction == UISwipeGestureRecognizerDirectionUp ) {
        // show timeline
    }
}

- (void)tapEvent:(UITapGestureRecognizer *)tapRecognizer {
    CGPoint pt = [tapRecognizer locationInView:activityView];
    if( [activityView pointInside:pt withEvent:nil] ) return; // do not respond to tap in activity view
    
    if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"tap %d", tapRecognizer.numberOfTouches);
        // show or hide activity
        [self toggleActivity];
    }
}

- (void)cameraButtonPressed: (id)sender {
    [global.cameraView setDelegate:self];
    [global.cameraView launchCamera:self];
}

- (void)menuButtonPressed: (id)sender {
}

- (void)scrapbookButtonPressed: (id)sender {
    // show scrapbook
    if( scrapbookListController == nil ) {
        scrapbookListController = [[totBookListViewController alloc] init];
    }
    [self.view addSubview:scrapbookListController.view];
}

- (void)activityButtonPressed: (id)sender {
    UIButton* btn = (UIButton*)sender;
    NSLog(@"%d", btn.tag);
    
    // check if this activity has already been added
    
    // max icons in tag = 4, remove the first one if more than that
    if( selectedActivities.count >= 4 )
        [selectedActivities removeObjectAtIndex:0];
    
    // add this activity
    int i = btn.tag;
    [selectedActivities addObject:allActivities[i]];
    
    // remove this activity from list
    

    // update UI
    [self updateSelectedActivitesView];
}

#pragma mark - CameraViewDelegate
- (void) cameraView:(id)cameraView didFinishSavingMedia:(MediaInfo*)mediaInfo {
    NSLog(@"%@", mediaInfo.filename);
    currentPhoto = mediaInfo;
    
    [self showPhoto:currentPhoto];
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
    [homeRootController switchTo:kHomeActivityLabelController withContextInfo:mMessage];
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
    [homeRootController switchTo:kHomeActivityLabelController withContextInfo:mMessage];
}


#pragma mark - Helper functions

- (void)createSelectedActivitesView {
    UIImage* bg = [UIImage imageNamed:@"activity_tag"];
    UIImage* line = [UIImage imageNamed:@"activity_line"];
    selectedActivities_bgView = [[UIImageView alloc] initWithImage:bg];
    selectedActivities_lineView = [[UIImageView alloc] initWithImage:line];
    selectedActivities_bgView.frame = CGRectMake(0, 15, bg.size.width, bg.size.height);
    selectedActivities_lineView.frame = CGRectMake(0, 0, line.size.width, line.size.height);
    [selectedActivities_bgView addSubview:selectedActivities_lineView];
    selectedActivities_bgView.hidden = TRUE;
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
        if( selectedActivities.count == 0 ){
            selectedActivities_bgView.hidden = TRUE;
            return;
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
        for( int i=cnt-1; i>=0; i-- ) {
            NSString* activity = selectedActivities[i];
            NSString* tmpname = [activity stringByReplacingOccurrencesOfString:@" " withString:@"_"];
            NSString* activityIconName = [NSString stringWithFormat:@"activity_%@", tmpname];
            UIImageView* activityIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:activityIconName]];
            activityIcon.frame = CGRectMake(x_offset+margin_x*2+f_line.size.width+i*(margin_x+icon_width),
                                            (selectedActivities_bgView.frame.size.height-icon_height)/2, icon_width, icon_height);
            [selectedActivities_bgView addSubview:activityIcon];
        }
        
        // swipe in teh bookmark
        [UIView animateWithDuration:t2 animations:^{
            selectedActivities_bgView.frame = f_bg;
        }];
    }];
}

@end
