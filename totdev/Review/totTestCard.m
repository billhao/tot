//
//  totTestCard.m
//  totdev
//
//  Created by Lixing Huang on 6/29/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import "totTestCard.h"

@implementation totTestEditCard

- (void)handleTap:(UIGestureRecognizer *)gestureRecognizer {
    [parentView flip];
}

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
    [mLabel release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    mLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 60)];
    mLabel.text = @"Editting Mode";
    mLabel.backgroundColor = [UIColor greenColor];
    [self.view addSubview:mLabel];
    
    // Register tap gesture recognizers.
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
    [tap release];
}

@end

@implementation totTestShowCard

- (void)handleTap:(UIGestureRecognizer *)gestureRecognizer {
    [parentView flip];
}

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
    [mLabel release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    mLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 60)];
    mLabel.text = @"Showing Mode";
    mLabel.backgroundColor = [UIColor blueColor];
    [self.view addSubview:mLabel];
    
    // Register tap gesture recognizers.
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
    [tap release];
}
@end
