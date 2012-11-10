//
//  totReviewLineChart.h
//  totdev
//
//  Created by Lixing Huang on 10/29/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface totReviewLineChart : UIView {
    float * values;
    float * timestamps;
    int height, width;
    int size;
}

- (void) setValues:(NSArray*)v;
- (void) setTimestamps:(NSArray*)t;

@end
