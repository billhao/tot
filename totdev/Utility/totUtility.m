//
//  totUtility.m
//  totdev
//
//  Created by Yifei Chen on 4/28/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totUtility.h"

@implementation totUtility


+(UIImage *)squareCropImage:(UIImage *)origImage{
    UIImage *squareImage;
    
    if(origImage.size.width == origImage.size.height){
        squareImage = origImage;
    }
    else{
        CGRect rect;
        
        if(origImage.size.width > origImage.size.height){
            rect = CGRectMake(round((double)(origImage.size.width-origImage.size.height)/2), 
                              0, 
                              origImage.size.height,
                              origImage.size.height);
            
        }
        else{
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


+(NSString *)nowTimeString{
    
    NSDate *now = [NSDate date];
	NSDateFormatter *formatter = nil;
    NSString *nowString;
	formatter = [[NSDateFormatter alloc] init];
	[formatter setTimeStyle:NSDateFormatterShortStyle];//mm:ss AM
	nowString =[formatter stringFromDate:now];
	[formatter release];
    
    return  nowString;
}


// utility function print a frame
+ (NSString*)getFrameString:(CGRect)frame {
    return [NSString stringWithFormat:@"x=%f y=%f w=%f h=%f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height];
}


void print(NSString* str) {
    NSLog(@"%@", str);
}

@end
