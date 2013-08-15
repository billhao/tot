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
    confirm = [[UIButton alloc] initWithFrame:CGRectMake(30, 100, 100, 30)];
    cancel = [[UIButton alloc] initWithFrame:CGRectMake(190, 100, 100, 30)];
    
    confirm.backgroundColor = [UIColor redColor];
    cancel.backgroundColor = [UIColor redColor];
    [confirm setTitle:@"Yes" forState:UIControlStateNormal];
    [cancel setTitle:@"No" forState:UIControlStateNormal];
    [confirm addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    [cancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:confirm];
    [self addSubview:cancel];
}

- (void) setBackground {
    self.backgroundColor = [UIColor whiteColor];
}

- (void) dealloc {
    [super dealloc];
    [picker_height release];
    [confirm release];
    [cancel release];
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




