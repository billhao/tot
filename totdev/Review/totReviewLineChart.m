//
//  totReviewLineChart.m
//  totdev
//
//  Created by Lixing Huang on 10/29/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totReviewLineChart.h"

@implementation totReviewLineChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        height = frame.size.height;
        width = frame.size.width;
        size = 0;
    }
    return self;
}

- (void)setValues:(NSArray *)v {
    const int margin = 15;
    size = [v count];
    if (size == 0) return;
    float min_value = [[v objectAtIndex:0] floatValue];
    float max_value = [[v objectAtIndex:0] floatValue];
    values = (float*) malloc (sizeof(float) * size);
    for (int i = 0; i < size; ++i) {
        values[i] = [[v objectAtIndex:i] floatValue];
        if (values[i] < min_value)
            min_value = values[i];
        if (values[i] > max_value)
            max_value = values[i];
    }
    
    if (min_value == max_value) {
        for (int i = 0; i < size; ++i) {
            values[i] = height / 2;
        }
    } else {
        for (int i = 0; i < size; ++i) {
            values[i] = (values[i] - min_value) / (max_value - min_value) * (height - 2 * margin);
            values[i] = height - margin - values[i];
        }
    }
}

- (void)setTimestamps:(NSArray *)t {
    const int margin = 15;
    size = [t count];
    if (size == 0) return;
    timestamps = (float*) malloc (sizeof(float) * size);
    for (int i = 0; i < size; ++i) {
        timestamps[i] = (float)[[t objectAtIndex:i] timeIntervalSince1970];
    }
    
    for (int i = 0; i < size; ++i) {
        timestamps[i] = (timestamps[0] - timestamps[i]) / (timestamps[0] - timestamps[size - 1]) * (width - 2 * margin);
        timestamps[i] = width - margin - timestamps[i];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if (size == 0) return;
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // draw the background
    CGRect background = CGRectMake(0, 0, width, height);
    CGContextAddRect(context, background);
    CGContextStrokePath(context);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, background);
    
    // draw the line chart
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextMoveToPoint(context, timestamps[0], values[0]);
    for (int i = 1; i < size; ++i) {
        CGContextAddLineToPoint(context, timestamps[i], values[i]);
    }
    CGContextStrokePath(context);
    
    // draw the point
    for (int i = 0; i < size; ++i) {
        CGContextAddEllipseInRect(context, CGRectMake(timestamps[i]-3, values[i]-3, 6, 6));
    }
    CGContextStrokePath(context);
}

- (void)dealloc {
    free(values);
    free(timestamps);
    [super dealloc];
}

@end
