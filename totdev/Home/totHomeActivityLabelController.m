//
//  totHomeActivityLabelController.m
//  totdev
//
//  Created by Lixing Huang on 4/25/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import "totHomeRootController.h"
#import "totHomeActivityLabelController.h"

@interface totHomeActivityLabelController ()

@end

@implementation totHomeActivityLabelController
@synthesize homeRootController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor whiteColor];
        self.view.userInteractionEnabled = YES;
        mMessage = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)receiveMessage: (NSMutableDictionary*)message {
    NSString* filename = [message objectForKey:@"storedImage"];
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentDirectory = [paths objectAtIndex:0];
    NSString* imagePath = [documentDirectory stringByAppendingPathComponent:filename];
    [backgroundImage setImage:[UIImage imageWithContentsOfFile:imagePath]];
}

- (void)viewWillAppear:(BOOL)animated {}

- (void)viewWillDisappear:(BOOL)animated {}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 411)];
    [self.view addSubview:backgroundImage];
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
}

@end
