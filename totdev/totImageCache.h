//
//  totImageCache.h
//  totAlbumView
//
//  Created by User on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface totImageCache : NSObject {
    NSMutableDictionary *m_imageDict;
    NSMutableArray *m_filename_fifo;
    NSInteger m_capacity;
}

@property (retain, nonatomic) NSMutableDictionary *m_imageDict;
@property (retain, nonatomic) NSMutableArray *m_filename_fifo;

-(totImageCache *) init;
-(UIImage *) getImageWithKey:(NSString *)filename;
-(void) addImage: (UIImage *)image WithKey:(NSString *) filename;
-(void) initWithCapacity: (int)capacity;

@end
