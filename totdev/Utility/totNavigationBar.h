//
//  totNavigationBar.h
//  totdev
//
//  Created by Lixing Huang on 5/2/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol totNavigationBarDelegate <NSObject>

@optional
-(void)navLeftButtonPressed:(id)sender;
-(void)navRightButtonPressed:(id)sender;

@end

@interface totNavigationBar : UIView {
    UIImageView *mBackground;
    UIButton *mLeftButton;
    UIButton *mRightButton;
    
    int mWidth, mHeight;
    
    id<totNavigationBarDelegate> delegate;
}

@property (nonatomic, retain) id<totNavigationBarDelegate> delegate;

- (void)setNavigationBarTitle:(NSString*)title andColor:(UIColor*)clr;
- (void)setBackgroundImage:(NSString*)path;

- (void)setLeftButtonImg:(NSString*)path;
- (void)setLeftButtonTitle:(NSString*)title;
- (void)setRightButtonImg:(NSString*)path;
- (void)setRightButtonTitle:(NSString*)title;

- (void)hideLeftButton;
- (void)showLeftButton;
- (void)hideRightButton;
- (void)showRightButton;

@end
