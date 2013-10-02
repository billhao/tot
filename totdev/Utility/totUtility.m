//
//  totUtility.m
//  totdev
//
//  Created by Yifei Chen on 4/28/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totUtility.h"
#import <QuartzCore/QuartzCore.h>

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
    return [totUtility dateToString:now];
}

+(NSString *)dateToString:(NSDate*)date{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *dateString;
	[formatter setDateStyle:NSDateFormatterFullStyle];
	[formatter setTimeStyle:NSDateFormatterFullStyle];
	dateString =[formatter stringFromDate:date];
	[formatter release];
    return  dateString;
}

+(NSDate *)stringToDate:(NSString*)dateStr{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterFullStyle];
	[formatter setTimeStyle:NSDateFormatterFullStyle];
    NSDate* date = [formatter dateFromString:dateStr];
	[formatter release];
    return  date;
}

// utility function print a frame
+ (NSString*)getFrameString:(CGRect)frame {
    return [NSString stringWithFormat:@"x=%f y=%f w=%f h=%f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height];
}


void print(NSString* str) {
    NSLog(@"%@", str);
}


+ (void)enableBorder:(UIView*)v {
    v.layer.borderWidth = 1;
    v.layer.borderColor = [UIColor grayColor].CGColor;
}

+ (CGSize)getScreenSize {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    return screenRect.size;
}

+ (void)showAlert:(NSString*)text {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:text
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

@end
