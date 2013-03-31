/* Add tutorial images as tutorial_x@2x.png
 * in the order of 1, 2, 3 ...
 * The code will automatically use all images in above names.
 */

#import "totTutorialViewController.h"
#import "../AppDelegate.h"
#import "../Model/totEventName.h"
#import "totUtility.h"

@interface totTutorialViewController ()

@end

@implementation totTutorialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    tutorialScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    tutorialScrollView.pagingEnabled = true;
    tutorialScrollView.showsVerticalScrollIndicator = NO;
    tutorialScrollView.showsHorizontalScrollIndicator = NO;
    tutorialScrollView.delegate = self;
    
    
    int x=0;
    int y=0;
    int width=tutorialScrollView.frame.size.width;
    int height=tutorialScrollView.frame.size.height;
    image_cnt = 0;
    while( image_cnt < 20 ) {
        NSString* imgName = [NSString stringWithFormat:@"tutorial_%d", (image_cnt+1)];
        UIImage* img = [UIImage imageNamed:imgName];
        if( img == nil ) break;
        
        UIImageView* imgView = [[UIImageView alloc] initWithImage:img];
        imgView.frame = CGRectMake(x, y, width, height);
        [tutorialScrollView addSubview:imgView];
        [imgView release];
        x += width;
        image_cnt++;
    }
    scrollCanceled = false;
    tutorialScrollView.contentSize = CGSizeMake(width * (image_cnt), height);
    [self.view addSubview:tutorialScrollView];
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    pageControl.frame = CGRectMake(0, (height - 30), width, 15);
    pageControl.numberOfPages = image_cnt;
    pageControl.currentPage = 0;
    [self.view addSubview:pageControl];
}

//- (void)viewWillAppear:(BOOL)animated {
//    NSLog(@"totTutorialViewController viewWillAppear");
//}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    //NSLog(@"scrollViewDidScroll %f", scrollView.contentOffset.x);
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)sv {
//    NSLog(@"scrollViewDidEndDecelerating %f", sv.contentOffset.x);
//    int page = sv.contentOffset.x / sv.frame.size.width;
//    pageControl.currentPage = page;
//}
//
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
        
        [[self getAppDelegate] popup];
        
        // stop tutorial, go to main view
        [[self getAppDelegate] showFirstView];
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
