/* Add tutorial images as tutorial_x@2x.png
 * in the order of 1, 2, 3 ...
 * The code will automatically use all images in above names.
 */

#import "totTutorialViewController.h"
#import "../AppDelegate.h"
#import "../Model/totEventName.h"
#import "totUtility.h"
#import "totHomeRootController.h"

@interface totTutorialViewController ()

@end

@implementation totTutorialViewController

@synthesize homeController, nextview;

- (id)initWithFrame:(CGRect)frame {
    self = [super init];
    if( self ) {
        _frame = frame;
        nextview = kHomeViewEntryView; // switch to the next view, default to home
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //NSLog(@"totTutorialViewController viewDidLoad");
    //NSLog(@"%@", [totUtility getFrameString:self.view.bounds]);

    // tutorial
    UIImage* bgImg = [UIImage imageNamed:@"tutorial_bg"];
    UIImageView* bgImgView = [[UIImageView alloc] initWithImage:bgImg];
    bgImgView.frame = _frame;
    [self.view addSubview:bgImgView];
    [bgImgView release];
    
    float gap = 10;
    tutorialScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(-gap, _frame.origin.y, _frame.size.width + gap*2, _frame.size.height)];
    tutorialScrollView.backgroundColor = [UIColor clearColor];
    tutorialScrollView.pagingEnabled = true;
    tutorialScrollView.showsVerticalScrollIndicator = NO;
    tutorialScrollView.showsHorizontalScrollIndicator = NO;
    tutorialScrollView.delegate = self;

    int x = 0;
    int y = 0;
    int width  = _frame.size.width + gap*2;
    int height = _frame.size.height;
    image_cnt = 0;
    while( image_cnt < 20 ) {
        NSString* imgName = [NSString stringWithFormat:@"tutorial_%d", (image_cnt)];
        UIImage* img = [UIImage imageNamed:imgName];
        if( img == nil ) break;
        
        UIImageView* imgView = [[UIImageView alloc] initWithImage:img];
        imgView.backgroundColor = [UIColor clearColor];
        imgView.frame = CGRectMake(x+gap, y, img.size.width, height);
        [tutorialScrollView addSubview:imgView];
        [imgView release];
        x += width;
        image_cnt++;
    }
    scrollCanceled = false;
    tutorialScrollView.contentSize = CGSizeMake(width * (image_cnt), height);
    [self.view addSubview:tutorialScrollView];
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _frame.origin.y + _frame.size.height - 30, _frame.size.width, 15)];
    pageControl.pageIndicatorTintColor = [UIColor colorWithRed:158.0/255 green:158.0/255 blue:158.0/255 alpha:0.8];
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:130/255.0 green:185/255.0 blue:221/255.0 alpha:0.8];
    pageControl.numberOfPages = image_cnt;
    pageControl.currentPage = 0;
    [self.view addSubview:pageControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [UIApplication sharedApplication].statusBarHidden = YES;
    tutorialScrollView.contentOffset = CGPointMake(0, 0);
    pageControl.currentPage = 0;
    scrollCanceled = false;
}

- (void)viewWillDisappear:(BOOL)animated {
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)viewDidLayoutSubviews {
    // changes need for ios7 for work properly. without these, the scrollview will be able scroll vertically
    tutorialScrollView.contentOffset = CGPointMake(0, 0);
    tutorialScrollView.contentInset = UIEdgeInsetsZero;
}

//- (void)viewWillAppear:(BOOL)animated {
//    NSLog(@"totTutorialViewController viewWillAppear");
//}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    //NSLog(@"scrollViewDidScroll %f", scrollView.contentOffset.x);
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sv {
    //NSLog(@"scrollViewDidEndDecelerating %f", sv.contentOffset.x);
    int page = sv.contentOffset.x / sv.frame.size.width;
    pageControl.currentPage = page;
}

//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)sv {
//    NSLog(@"scrollViewWillBeginDecelerating %f", sv.contentOffset.x);
//}

- (void)scrollViewDidEndDragging:(UIScrollView *)sv willDecelerate:(BOOL)decelerate {
    //NSLog(@"scrollViewDidEndDragging %f %d", sv.contentOffset.x, decelerate);
    if( scrollCanceled ) return;
    
    if( sv.contentOffset.x > sv.frame.size.width * (image_cnt - .95) ) {
        
        scrollCanceled = true;
        
        // now the tutorial has been shown, mark in db, never show it again
        [global.model addEvent:PREFERENCE_NO_BABY event:EVENT_TUTORIAL_SHOW datetime:[NSDate date] value:@"true"];
        
        // switch to home or setting depending on where it was invoked from
        [homeController switchTo:nextview withContextInfo:nil];
    }
}

-(AppDelegate*) getAppDelegate {
    return [[UIApplication sharedApplication] delegate];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [tutorialScrollView release];
}

- (void)dealloc
{
    [tutorialScrollView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
