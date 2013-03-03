//
//  totUtility.h
//  totdev
//
//  Created by Yifei Chen on 4/28/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface totUtility : NSObject


+(UIImage *)squareCropImage:(UIImage *)origImage;  
+(NSString *)nowTimeString;

// utility function print a frame
+ (NSString*)getFrameString:(CGRect)frame;

@end

extern void print(NSString* str);