//
//  totImageCache.m
//  totAlbumView
//
//  Created by User on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "totImageCache.h"

@implementation totImageCache

@synthesize m_imageDict;
@synthesize m_filename_fifo;

/* =================================
 * init
 *   - defautl init func
 *   - dictionary capacity fixed at 30
 * =================================
 */
-(totImageCache *)init
{
    self = [super init];
    if (self) {
        NSMutableDictionary *aDictionary = [[NSMutableDictionary alloc] initWithCapacity:30];
        self.m_imageDict = aDictionary;
        [aDictionary release];
        
        NSMutableArray *anArray = [[NSMutableArray alloc] initWithCapacity:30];
        self.m_filename_fifo = anArray;
        [anArray release];
        
        m_capacity = 30;
    }
    return self;
}

/* =================================
 * initWithCapacity
 *   - init func
 *   - dictionary capacity given as param
 * =================================
 */
-(void) initWithCapacity:(int)capacity
{
    NSMutableDictionary *aDictionary = [[NSMutableDictionary alloc] initWithCapacity:capacity];
    self.m_imageDict = aDictionary;
    [aDictionary release];
        
    NSMutableArray *anArray = [[NSMutableArray alloc] initWithCapacity:capacity];
    self.m_filename_fifo = anArray;
    [anArray release];
    
    m_capacity = capacity;
}

/* =================================
 * getImageWithKey
 *   - get the UIImage with provided filename
 *   - get nil if the image not found
 * =================================
 */
-(UIImage *) getImageWithKey:(NSString *)filename
{
    UIImage* rtnImage = [m_imageDict objectForKey:filename];
    return rtnImage;
}

/* =================================
 * addImage
 *   
 * =================================
 */
-(void) addImage: (UIImage *)image WithKey:(NSString *) filename
{
    /* if the size of imageDict is about to exceeds the capacity, remove the oldest image */
    if ([m_imageDict count] == m_capacity){
        NSString *oldestImageName = [m_filename_fifo objectAtIndex:0];
        [m_imageDict removeObjectForKey:oldestImageName];
    }
    [m_imageDict setObject:image forKey:filename];
    [m_filename_fifo addObject:filename];
}

@end
