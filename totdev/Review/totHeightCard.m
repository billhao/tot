//
//  totHeightCard.m
//  totdev
//
//  Created by Lixing Huang on 8/11/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import "totHeightCard.h"

@implementation totHeightEditCard

+ (int) height { return 150; }
+ (int) width { return 310; }

- (void)pickerView:(STHorizontalPicker *)picker didSelectValue:(CGFloat)value {
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        picker_height = [STHorizontalPicker getPickerForHeight:CGRectMake(20, 50, 200, 50)];
        [picker_height setDelegate:self];
        [self addSubview:picker_height];
        
        [self setBackground];
        
        [self loadButtons];
    }
    return self;
}

- (void) confirm: (UIButton*) btn {
    [parentView flip];
}
- (void) cancel: (UIButton*) btn {}

- (void) loadButtons {
    confirm_button = [[UIButton alloc] initWithFrame:CGRectMake(30, 100, 100, 30)];
    cancel_button = [[UIButton alloc] initWithFrame:CGRectMake(190, 100, 100, 30)];
    
    confirm_button.backgroundColor = [UIColor redColor];
    cancel_button.backgroundColor = [UIColor redColor];
    
    [confirm_button setTitle:@"Yes" forState:UIControlStateNormal];
    [cancel_button setTitle:@"No" forState:UIControlStateNormal];
    [confirm_button addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    [cancel_button addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:confirm_button];
    [self addSubview:cancel_button];
}

- (void) setBackground {
    self.backgroundColor = [UIColor whiteColor];
}

- (void) dealloc {
    [super dealloc];
    [picker_height release];
    [confirm_button release];
    [cancel_button release];
}

@end




@implementation totHeightShowCard

+ (int) height { return 150; }
+ (int) width { return 310; }

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {}
    
    [self setBackground];
    
    return self;
}

- (void) setBackground {
    self.backgroundColor = [UIColor whiteColor];
}

- (void) dealloc {
    [super dealloc];
}

@end




