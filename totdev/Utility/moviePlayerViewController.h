//
//  moviePlayerViewController.h
//  totAlbumView
//
//  Created by User on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
// Source: http://iphonedevelopertips.com/video/getting-mpmovieplayercontroller-to-cooperate-with-ios4-3-2-ipad-and-earlier-versions-of-iphone-sdk.html
// Another useful source: http://mobile.tutsplus.com/tutorials/iphone/mediaplayer-framework_mpmovieplayercontroller_ios4/


#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface moviePlayerViewController : UIViewController {
    MPMoviePlayerController *mp;
    NSURL *movieURL;
}

- (id)initWithPath:(NSString *)moviePath;
- (void)setPath:(NSString*)moviePath;
- (void)readyPlayer;

@end
