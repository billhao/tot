//
//  totLanguageCard.m
//  totdev
//
//  Created by Lixing Huang on 8/11/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import "totLanguageCard.h"
#import "totTimeUtil.h"
#import "totTimeline.h"

@implementation totLanguageEditCard

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackground];
    [self loadIcons];
    [self loadButtons];
}

- (void) setBackground {
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void) loadIcons {
    [self setTitle:@"New Word"];
    [self setIcon:@"language2.png" withCalendarDays:99];
}

- (void) loadButtons {
    [self setTimestamp];
    
    confirm_button = [UIButton buttonWithType:UIButtonTypeCustom];
    confirm_button.backgroundColor = [UIColor greenColor];
    [confirm_button setFrame:CGRectMake(10, 160, 100, 30)];
    [confirm_button setTitle:@"Confirm" forState:UIControlStateNormal];
    [confirm_button addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirm_button];
    
    // text input area
    new_words_input = [[UITextView alloc] initWithFrame:CGRectMake(10, 100, 290, 40)];
    new_words_input.backgroundColor = [UIColor clearColor];
    [self.view addSubview:new_words_input];
    // text input area background
    UIView* background = [[UIView alloc] initWithFrame:CGRectMake(10, 100, 290, 40)];
    background.backgroundColor = [UIColor yellowColor];
    [self.view insertSubview:background belowSubview:new_words_input];
    [background release];
}

- (void) confirm: (UIButton*)button {
    // testing...
    [self.parentView.parent moveToTop:self.parentView];
}

+ (int) height { return 200; }
+ (int) width { return 308; }

- (void) dealloc {
    [super dealloc];
    [new_words_input release];
}

@end



@implementation totLanguageShowCard

- (id) init {
    self = [super init];
    if (self) {}
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

+ (int) height { return 200; }
+ (int) width { return 308; }

@end

