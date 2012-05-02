//
//  totActivityUtility.h
//  totdev
//
//  Created by Lixing Huang on 4/29/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class totEvent;

@interface totActivityUtility : NSObject

+ (int)getCurrentBabyID;
+ (void)extractFromEvent:(totEvent*)evt intoImageArray:(NSMutableArray*)imgs;
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

@end
