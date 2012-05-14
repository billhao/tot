//
//  albumViewController.h
//  totAlbumView
//
//  Created by User on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "totNavigationBar.h"

@class moviePlayerViewController;

@interface albumViewController : UIViewController <totNavigationBarDelegate> {
    //UIView *myTitleBarView;  // The control bars at the top of a view
    totNavigationBar *myTitleBarView;
    UIScrollView *myScrollView;  // thumbnail scroll view
    UIScrollView *myFullSizeImageScrollView;  // full-size image scroll view
    moviePlayerViewController *myMoviePlayerView;  // full screen movie player view
    
    NSMutableArray* myPathArray;
}

@property (retain, nonatomic) UIView *myTitleBarView;
@property (retain, nonatomic) UIScrollView *myScrollView;
@property (retain, nonatomic) UIScrollView *myFullSizeImageScrollView;
//@property (retain, nonatomic) moviePlayerViewController *myMoviePlayerView;

@property (retain, nonatomic) NSMutableArray *myPathArray;

- (void) MakeNoView;
- (void) MakeFullView: (NSMutableArray *)inputPathArray;
- (UIImage*) getSquareImage: (UIImage *)origImage;
- (void) thumbnailClicked: (UIButton *)clickedButton;
- (void) FullScreenImageClicked: (UIButton *)clickedButton;
- (void) ReturnButtonClicked;
- (void) StartMoviePlayer: (NSString *)path;
- (uint) CheckFileType: (NSString *)path;
- (NSString *) GetVideoPath: (NSString *)path;
- (void) PlayButtonClicked: (UIButton *)clickedButton;
- (UIImage*) addImageToImage:(UIImage*)img:(UIImage*)img2;

@end
