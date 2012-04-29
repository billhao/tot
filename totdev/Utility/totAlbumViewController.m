//
//  albumViewController.m
//  totAlbumView
//
//  Created by User on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "albumViewController.h"
#import "moviePlayerViewController.h"

@implementation albumViewController

@synthesize myTitleBarView;
@synthesize myScrollView;
@synthesize myFullSizeImageScrollView;
@synthesize myMoviePlayerView;

//@synthesize myImageArray;
@synthesize myPathArray;

-(void)dealloc
{
    [myTitleBarView release];
    [myScrollView release];
    [myFullSizeImageScrollView release];
    [myMoviePlayerView release];
//    [myImageArray release];
    [myPathArray release];
    [super dealloc];
}

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


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
        
    // Create scroll view
    /*
     UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
     scroll.pagingEnabled = YES;
     NSInteger numberOfViews = 3;
     for (int i = 0; i < numberOfViews; i++) {
     CGFloat yOrigin = i * self.view.frame.size.width;
     UIView *awesomeView = [[UIView alloc] initWithFrame:CGRectMake(yOrigin, 0, self.view.frame.size.width, self.view.frame.size.height)];
     awesomeView.backgroundColor = [UIColor colorWithRed:0.5/i green:0.5 blue:0.5 alpha:1];
     [scroll addSubview:awesomeView];
     [awesomeView release];
     }
     scroll.contentSize = CGSizeMake(self.view.frame.size.width * numberOfViews, self.view.frame.size.height);
     [self.view addSubview:scroll];
     [scroll release];
     */
}


/* =================================
 * ViewDidLoad
 *   Implement viewDidLoad to do additional setup after loading the view, typically from a nib. 
 * =================================
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Build myTitleBarView
    UIView *aTitleBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    aTitleBarView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
    self.myTitleBarView = aTitleBarView;
    [aTitleBarView release];
    [self.view addSubview:self.myTitleBarView];
    // Build myScrollView
    UIScrollView *aScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.myScrollView = aScrollView;
    [aScrollView release];
    [self.view addSubview:self.myScrollView];
    // Build myFullSizeImageScrollView
    UIScrollView *anotherScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.myFullSizeImageScrollView = anotherScrollView;
    [anotherScrollView release];
    [self.view insertSubview:self.myFullSizeImageScrollView belowSubview:myTitleBarView];
    // Minimize the views
    self.myTitleBarView.frame = CGRectMake(0, 0, 0, 0);
    self.myScrollView.frame = CGRectMake(0, 0, 0, 0);
    self.myFullSizeImageScrollView.frame = CGRectMake(0, 0, 0, 0);
    self.view.frame = CGRectMake(0, 0, 0, 0);
    self.view.backgroundColor = [UIColor blackColor];
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

/* =================================
 * MakeNoView
 *   Called by/when:
 *     - the return button in myTitleBarView is pressed down.
 * =================================
 */
- (void)MakeNoView
{
    // Remove title and return botton from myTitleBarView
    for(UIView *subview in [myTitleBarView subviews]) {
        [subview removeFromSuperview];
    }
    // Remove image thumnails from myScrollView
    for(UIView *subview in [myScrollView subviews]) {
        [subview removeFromSuperview];
    }
    [myScrollView setContentOffset:CGPointMake(0, 0)];  // show the first page the next time albumView is invoked
    // Remove image thumnails from myFullSizeImageScrollView
    for(UIView *subview in [myFullSizeImageScrollView subviews]) {
        [subview removeFromSuperview];
    }
    // Minimize all the frames
    self.myTitleBarView.frame = CGRectMake(0, 0, 0, 0);
    self.myScrollView.frame = CGRectMake(0, 0, 0, 0);
    self.myFullSizeImageScrollView.frame = CGRectMake(0, 0, 0, 0);
    self.view.frame = CGRectMake(0, 0, 0, 0);
    // Release images in myImageArray
    //[self.myImageArray release];
}

/* =================================
 * MakeFullView
 *   Called by/when:
 *     - a controller want to display a photo album 
 * =================================
 */
- (void)MakeFullView: (NSMutableArray *)inputPathArray
{
    // Dummy Parameters
    /*
    NSArray *inputPathArray = [NSArray arrayWithObjects:
                               @"a01.jpg",
                               @"a02.jpg",
                               @"a03.jpg",
                               @"a04.jpg",
                               @"a05.jpg",
                               @"a06.jpg",
                               @"a07.jpg",
                               @"a08.jpg",
                               @"a09.jpg",
                               @"a10.jpg",
                               @"a01.jpg",
                               @"a02.jpg",
                               @"a03.jpg",
                               @"a00.mp4.jpg",
                               @"a04.jpg",
                               @"a05.jpg",
                               @"a06.jpg",
                               @"a07.jpg",
                               @"a08.jpg",
                               @"a09.jpg",
                               @"a10.jpg",
                               @"fox.mp4.jpg",
                               nil];
     */
    
    // Copy parameter to myPathArray
    int count = [inputPathArray count];
    NSMutableArray *aPathArray = [[NSMutableArray alloc] initWithCapacity:count];
    for (int i = 0; i < count; i++) {
        NSString *aPath = [inputPathArray objectAtIndex: i];
        [aPathArray addObject:aPath];
    }
    myPathArray = aPathArray;

    // Make the views full-screen
    self.view.frame = CGRectMake(0, 0, 320, 480);
    self.myScrollView.frame = CGRectMake(0, 60, 320, 420);
    self.myTitleBarView.frame = CGRectMake(0, 0, 320, 60);
    [[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
    
    // Add content to myTitleBarView
    /*** Title ***/
    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 15, 200, 30)];
    myLabel.text = @"Photo";
    [myLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18.0]];
    myLabel.textAlignment = UITextAlignmentCenter;
    myLabel.textColor = [UIColor whiteColor];
    myLabel.backgroundColor = [UIColor clearColor];
    [self.myTitleBarView addSubview:myLabel];
    [myLabel release];
    /*** RETURN button ***/
    UIButton *rtnButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 20, 20, 20)];
    rtnButton.backgroundColor = [UIColor clearColor];
    [rtnButton setBackgroundImage: [UIImage imageNamed:@"rtn_button.png"] forState:UIControlStateNormal];
    [rtnButton addTarget:self action:@selector(ReturnButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.myTitleBarView addSubview:rtnButton];
    [rtnButton release];
    
    // Set property of myScrollView
    myScrollView.pagingEnabled = YES;
    myScrollView.showsVerticalScrollIndicator = YES;
    myScrollView.showsHorizontalScrollIndicator = NO;
    myScrollView.scrollsToTop = NO;
    myScrollView.bounces = NO;
    myScrollView.directionalLockEnabled = YES;
    
    // Add thumbnails to myScrollView
    NSUInteger numberOfObjects = [myPathArray count];
    NSUInteger numberOfViews = numberOfObjects / 12;
    if ( numberOfObjects % 12 != 0) numberOfViews++;
    myScrollView.contentSize = CGSizeMake(myScrollView.frame.size.width, myScrollView.frame.size.height * numberOfViews);
    for (int i = 0; i < numberOfViews; i++) {
        for (int j = 0; j < 12; j++) {
            if (numberOfObjects == (i * 12 + j)) break; // Have added all the images in the array
            UIImage *aImage = [UIImage imageNamed:[myPathArray objectAtIndex:(i * 12 + j)]];
            UIImage *aSquareImage = [self getSquareImage:aImage];
            // Add movie icon for video capture
            uint isVideoFile = [self CheckFileType:[myPathArray objectAtIndex:(i * 12 + j)]];
            if (isVideoFile == 1) {
                UIImage* movieIconImage = [UIImage imageNamed:@"movie_thumbnail-01.png"];
                aSquareImage = [self addImageToImage:aSquareImage :movieIconImage];
            }
            CGFloat xOffset = 5 + 105 * (j % 3);
            CGFloat yOffset = i * 420 + 2.5 + 105 * (j / 3);
            UIButton *imgButton = [[UIButton alloc] initWithFrame:CGRectMake(xOffset, yOffset, 100, 100)];
            imgButton.tintColor = [UIColor clearColor];
            [imgButton setBackgroundImage:aSquareImage forState:UIControlStateNormal];
            [imgButton setTag:(i * 12 + j)];
            [imgButton addTarget:self action:@selector(thumbnailClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.myScrollView addSubview:imgButton];
            [imgButton release];
            //[aSquareImage release]; //!!!
            //[aImage release]; //!!!
        }
    }
}

/* =================================
 * getSquareImage
 *   Read a 320*480 UIImage and generate a 320*320 UIImage 
 *   Called by/when:
 *     - MakeFullView adds the thumbnail to myScrollView
 *   Source: http://xbiii3s.iteye.com/blog/1188008
 * =================================
 */
-(UIImage*)getSquareImage:(UIImage*)origImage
{  
    /*
    CGRect rect = CGRectMake(0, 80, 320, 320);
    CGImageRef subImageRef = CGImageCreateWithImageInRect(origImage.CGImage, rect);  
    UIGraphicsBeginImageContext(rect.size);  
    CGContextRef context = UIGraphicsGetCurrentContext();  
    CGContextDrawImage(context, rect, subImageRef);  
    UIImage* squareImage = [UIImage imageWithCGImage:subImageRef];  
    UIGraphicsEndImageContext();
    CGImageRelease(subImageRef);
    return squareImage;
    */
    
    UIImage *squareImage;
    
    if(origImage.size.width == origImage.size.height){
        squareImage = origImage;
    } else {
        CGRect rect;
        
        if(origImage.size.width > origImage.size.height){
            rect = CGRectMake(round((double)(origImage.size.width-origImage.size.height)/2), 
                              0, 
                              origImage.size.height,
                              origImage.size.height);
        } else{
            rect = CGRectMake(0,
                              round((double)(origImage.size.height-origImage.size.width)/2), 
                              origImage.size.width,
                              origImage.size.width);
        }
        
        CGImageRef subImageRef = CGImageCreateWithImageInRect(origImage.CGImage, rect);  
        UIGraphicsBeginImageContext(rect.size);  
        CGContextRef context = UIGraphicsGetCurrentContext();  
        CGContextDrawImage(context, rect, subImageRef);  
        squareImage = [UIImage imageWithCGImage:subImageRef];  
        UIGraphicsEndImageContext();
        CGImageRelease(subImageRef);
    }
    return squareImage;
}

/* =================================
 * thumbnailClicked()
 *   Check whether the thumbnails is a video or an image by calling CheckFileType().
 *   Invoke corresponding mechanisms to play the movie or display full-screen image.
 *   Called by/when:
 *     - a thumbnail in myScrollView is touched-up-inside
 * =================================
 */
-(void) thumbnailClicked: (UIButton *)clickedButton
{
    int selectedPathIndex = [clickedButton tag];
    NSString *selectedPath = [myPathArray objectAtIndex:selectedPathIndex];
    uint fileType = [self CheckFileType:selectedPath];
    if ( fileType == 1 ) {
        NSString *videoPath = [self GetVideoPath:selectedPath];
        [self StartMoviePlayer:videoPath];
        return;
    }
    
    // Set property of myFullSizeImageScrollView
    myFullSizeImageScrollView.pagingEnabled = YES;
    myFullSizeImageScrollView.showsVerticalScrollIndicator = NO;
    myFullSizeImageScrollView.showsHorizontalScrollIndicator = YES;
    myFullSizeImageScrollView.scrollsToTop = NO;
    myFullSizeImageScrollView.bounces = YES;
    myFullSizeImageScrollView.directionalLockEnabled = YES;
    myFullSizeImageScrollView.backgroundColor = [UIColor blackColor];
    
    // Add content to myFullSizeImageScrollView
    myTitleBarView.hidden = YES;
    myScrollView.hidden = YES;
    int numberOfImage= [myPathArray count];
    myFullSizeImageScrollView.frame = CGRectMake(0, 0, 320, 480);
    myFullSizeImageScrollView.contentSize = CGSizeMake(myScrollView.frame.size.width * numberOfImage, myScrollView.frame.size.height);
    [myFullSizeImageScrollView setContentOffset:CGPointMake(myScrollView.frame.size.width * selectedPathIndex, 0)];
    for (int i = 0; i < numberOfImage; i++) {
        UIButton *imgButton = [[UIButton alloc] initWithFrame:CGRectMake(i*320, 0, 320, 480)];
        imgButton.tintColor = [UIColor clearColor];
        [imgButton setBackgroundImage:[UIImage imageNamed:[myPathArray objectAtIndex:(i)]] forState:UIControlStateNormal];
        [imgButton addTarget:self action:@selector(FullScreenImageClicked:) forControlEvents:UIControlEventTouchDown];
        [imgButton setTag:i];
        [self.myFullSizeImageScrollView addSubview:imgButton];
        [imgButton release];
    }
}

/* =================================
 * FullScreenImageClicked()
 *   Display or Hide the title bar when a full-size image is clicked.
 *   If a video capture image is clicked. Also show the Play button on the title bar.
 *   Called by/when:
 *      A full-screen image is touched-up-inside.
 * =================================
 */
-(void) FullScreenImageClicked: (UIButton *)clickedButton
{
    if (myTitleBarView.hidden == YES /*already displaying full-screen image*/) {
        myFullSizeImageScrollView.frame = CGRectMake(0, 0, 320, 480);
        myFullSizeImageScrollView.scrollEnabled = NO;
        myTitleBarView.hidden = NO;
        myTitleBarView.frame = CGRectMake(0, 0, 320, 60);
        // IF the a video capture is clicked, add a Play button on the title bar.
        int selectedImage = [clickedButton tag];
        NSString *selectedPath = [myPathArray objectAtIndex:selectedImage];
        uint fileType = [self CheckFileType:selectedPath];
        if (fileType == 1) {
            UIButton *playButton = [[UIButton alloc] initWithFrame:CGRectMake(285, 20, 20, 20)];
            playButton.backgroundColor = [UIColor clearColor];
            [playButton setBackgroundImage: [UIImage imageNamed:@"play_button.png"] forState:UIControlStateNormal];
            [playButton addTarget:self action:@selector(PlayButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [playButton setTag:selectedImage];
            [self.myTitleBarView addSubview:playButton];
            [playButton release];
        }
    } else /*already displaying title bar and image*/{
        myTitleBarView.hidden = YES;
        myFullSizeImageScrollView.frame = CGRectMake(0, 0, 320, 480);
        myFullSizeImageScrollView.scrollEnabled = YES;
        myTitleBarView.frame = CGRectMake(0, 0, 0, 0);
        // Remove any possible Play button
        int PossiblePlayButtonTag = [clickedButton tag];
        for (UIView *subview in [self.myTitleBarView subviews]) {
            if (subview.tag == PossiblePlayButtonTag) {
                [subview removeFromSuperview];
            }
        }
    }
}

/* =================================
 * PlayButtonClicked()
 *   Play the video corresponding to the video capture image selected.
 *   Called by/when:
 *      The Play button on the title bar of a video capture image is clicked
 * =================================
 */
- (void) PlayButtonClicked: (UIButton *)clickedButton
{
    int selectedImage = [clickedButton tag];
    NSString *selectedPath = [myPathArray objectAtIndex:selectedImage];
    uint fileType = [self CheckFileType:selectedPath];
    if (fileType == 1) {
        NSString *videoPath = [self GetVideoPath:selectedPath];
        [self StartMoviePlayer:videoPath];
    }
}


-(void) ReturnButtonClicked
{
    if (myFullSizeImageScrollView.frame.size.height > 0 /*Current at FullSizeImageScrollVIew*/) {
        // Remove Play button from title bar
        CGPoint curFullScreenImagePos = self.myFullSizeImageScrollView.contentOffset;
        CGFloat offsetX = curFullScreenImagePos.x;
        int offsetIndex = offsetX / 320;
        for (UIView *subview in [self.myTitleBarView subviews]) {
            if (subview.tag == offsetIndex) {
                [subview removeFromSuperview];
            }
        }
        
        // Remove image thumnails from myFullSizeImageScrollView
        for(UIView *subview in [self.myFullSizeImageScrollView subviews]) {
            [subview removeFromSuperview];
        }
        // Return to thumbnail scroll view
        self.myFullSizeImageScrollView.frame = CGRectMake(0, 0, 0, 0);
        self.myScrollView.frame = CGRectMake(0, 60, 320, 420);
        self.myScrollView.hidden = NO;
        self.myTitleBarView.frame = CGRectMake(0, 0, 320, 60);
        self.myTitleBarView.hidden = NO;
    } else /*Current at thumnail scroll view*/ {
        [self MakeNoView];
    }
}

-(void) StartMoviePlayer: (NSString *)filename
{
    // Play movie from the bundle
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"mp4" inDirectory:nil];
    
	// Create custom movie player   
    myMoviePlayerView = [[[moviePlayerViewController alloc] initWithPath:path] autorelease];
    
	// Show the movie player as modal
 	[self presentModalViewController:myMoviePlayerView animated:YES];
    
	// Prep and play the movie
    [myMoviePlayerView readyPlayer];    
}

/* ===================================================
 * CheckFileType()
 *   - check whether the path is to a video or an image
 *   - return: 1 - mp4 video file; 0 - other files
 *   - called by:
 *       - self.thumbnailClicked()
 * ===================================================
 */
-(uint) CheckFileType: (NSString *)path
{
    NSArray *arr = [path componentsSeparatedByCharactersInSet:
                    [NSCharacterSet characterSetWithCharactersInString:@"."]];
    NSUInteger count = [arr count];
    NSString *fileType = [arr objectAtIndex:(count-2)];
    if ([fileType isEqualToString: @"mp4"] == YES) {
        return 1;
    } else {
        return 0;
    }
}

/* ===================================================
 * GetVideoPath()
 *   - truncate the .mp4.jpg substring from the NSString
 *   - return the truncated filename to a mp4 video file
 *   - called by:
 *       - self.thumbnailClicked()
 * ===================================================
 */
-(NSString *) GetVideoPath: (NSString *)path
{
    NSString *videoPath = [path substringToIndex:([path length] - 8)];
    [videoPath retain];
    return videoPath;
}



-(UIImage*) addImageToImage:(UIImage*)img:(UIImage*)img2
{
    CGSize size = CGSizeMake(img.size.height, img.size.width);
    UIGraphicsBeginImageContext(size);
    
    CGPoint pointImg1 = CGPointMake(0,0);
    [img drawAtPoint:pointImg1 ];
    
    CGPoint pointImage2 = CGPointMake(0, 0);
    [img2 drawAtPoint:pointImage2 ];
    
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

@end
