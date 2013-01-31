//
//  totActivityUtility.m
//  totdev
//
//  Created by Lixing Huang on 4/29/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totActivityUtility.h"
#import "AppDelegate.h"
#import "../Model/totEvent.h"

@implementation totActivityUtility

+ (int)getCurrentBabyID {
    return global.baby.babyID; //TODO should always use baby instead of babyID
}


// key=value;key=value
+ (void)extractFromEvent:(totEvent*)evt intoImageArray:(NSMutableArray*)imgs {
    NSArray *data = [evt.value componentsSeparatedByString:@";"];
    for( int j=0; j<[data count]; j++ ) {
        NSString *data_str = [data objectAtIndex:j];
        NSString *key = [[data_str componentsSeparatedByString:@"="] objectAtIndex:0];
        NSString *val = [[data_str componentsSeparatedByString:@"="] objectAtIndex:1];
        if( [key isEqualToString:@"image"] ) {
            [imgs addObject:val];
        }
    }
}

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
