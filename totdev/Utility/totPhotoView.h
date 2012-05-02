//
//  totPhotoView.h
//  totdev
//
//  Created by Lixing Huang on 4/29/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "totImageView.h"

@interface totPhotoView : UIViewController <totImageViewDelegate> {
    UIScrollView *mScrollView;
}

- (void)addImages: (NSMutableArray*)images startWith:(int)index;

@end
