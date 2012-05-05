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
-(void)leftButtonPressed:(id)sender;
-(void)rightButtonPressed:(id)sender;

@end

@interface totNavigationBar : UIView {
    UIImageView *mBackground;
    UIButton *mLeftButton;
    UIButton *mRightButton;
    id<totNavigationBarDelegate> delegate;
}

@end
