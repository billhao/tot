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

@end

@interface totImageView : UIImageView {
    id<totImageViewDelegate> delegate;
}

@property (nonatomic, retain) id<totImageViewDelegate> delegate;

- (void)imageFilePath:(NSString*)path;
- (void)imageFromFileContent:(NSString*)path;

@end
