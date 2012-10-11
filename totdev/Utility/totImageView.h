//
//  totImageView.h
//  totdev
//
//  Created by Lixing Huang on 4/15/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol totImageViewDelegate <NSObject>

@optional
- (void)touchesEndedDelegate:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEndedDelegate:(NSSet *)touches withEvent:(UIEvent *)event from:(int)tag;

@end

@interface totImageView : UIImageView {
    id<totImageViewDelegate> delegate;
    int mTag;
}

@property (nonatomic, retain) id<totImageViewDelegate> delegate;
@property (nonatomic, assign) int mTag;

- (void)imageFilePath:(NSString*)path;
- (void)imageFromFileContent:(NSString*)path;

@end
