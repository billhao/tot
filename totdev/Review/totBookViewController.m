//
//  totBookViewController.m
//  totdev
//
//  Created by Lixing Huang on 6/11/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import "totBookViewController.h"
#import "totBookletView.h"
#import "totBooklet.h"
#import <QuartzCore/QuartzCore.h>

@interface totBookViewController ()

@end

@implementation totBookViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initPageElement:(totPageElement*)e
                      x:(float)x
                      y:(float)y
                      w:(float)w
                      h:(float)h
                      r:(float)r
                      n:(NSString*)name
                      t:(PageElementMediaType)t {
    e.x = x;
    e.y = y;
    e.w = w;
    e.h = h;
    e.radius = r;
    e.name = name;
    e.type = t;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Setup a pageElement
    totPageElement* element = [[totPageElement alloc] init];
    [self initPageElement:element x:20 y:20 w:100 h:100 r:0 n:@"Test" t:IMAGE];
    [element addResource:[totPageElement image] withPath:@"bg_registration.png"];
    
    UIView* wrapper = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 100, 100)];
    totPageElementView* elementView = [[totPageElementView alloc] initWithElement:element];
    elementView.mData = element;
    [wrapper addSubview:elementView];
    [self.view addSubview:wrapper];
    [elementView display];
    [elementView rotate:45];

    [wrapper release];
    [elementView release];
    [element release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [super dealloc];
}

@end


