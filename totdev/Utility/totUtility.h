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
+(NSString *)dateToString:(NSDate*)date;
+(NSDate *)stringToDate:(NSString*)dateStr;

// utility function print a frame
+ (NSString*)getFrameString:(CGRect)frame;

+ (void)enableBorder:(UIView*)v;

+ (CGSize)getScreenSize;

+ (void)showAlert:(NSString*)text;

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

// json string to object
+ (NSArray*)JSONToObject:(NSString*) jsonstring;
// object to json string
+ (NSString*)ObjectToJSON:(id)obj;

@end

extern void print(NSString* str);