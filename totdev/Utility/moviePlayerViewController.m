//
//  moviePlayerViewController.m
//  totAlbumView
//
//  Created by User on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "moviePlayerViewController.h"

#pragma mark -
#pragma mark Compiler Directives & Static Variables

@implementation moviePlayerViewController

/*---------------------------------------------------------------------------
 * 
 *--------------------------------------------------------------------------*/
- (id)initWithPath:(NSString *)moviePath
{
	// Initialize and create movie URL
    if (self = [super init])
    {
        movieURL = [NSURL fileURLWithPath:moviePath];
    }
	return self;
}

- (void)setPath:(NSString*)moviePath {
    movieURL = [NSURL fileURLWithPath:moviePath];
}

/*---------------------------------------------------------------------------
 * For 3.2 and 4.x devices
 * For 3.1.x devices see moviePreloadDidFinish:
 *--------------------------------------------------------------------------*/
- (void) moviePlayerLoadStateChanged:(NSNotification*)notification 
{
	// Unless state is unknown, start playback
	if ([mp loadState] != MPMovieLoadStateUnknown)
    {
        // Remove observer
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MPMoviePlayerLoadStateDidChangeNotification 
                                                      object:nil];
        
        // When tapping movie, status bar will appear, it shows up
        // in portrait mode by default. Set orientation to landscape
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
        
		// Rotate the view for landscape playback
        [[self view] setBounds:CGRectMake(0, 0, 480, 320)];
		[[self view] setCenter:CGPointMake(160, 240)];
		[[self view] setTransform:CGAffineTransformMakeRotation(M_PI / 2)]; 
        
		// Set frame of movieplayer
		[[mp view] setFrame:CGRectMake(0, 0, 480, 320)];
        
        // Add movie player as subview
        [[self view] addSubview:[mp view]];   
        
		// Play the movie
		[mp play];
	}
}

/*---------------------------------------------------------------------------
 * For 3.1.x devices
 * For 3.2 and 4.x see moviePlayerLoadStateChanged: 
 *--------------------------------------------------------------------------*/
- (void) moviePreloadDidFinish:(NSNotification*)notification 
{
	// Remove observer
	[[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerContentPreloadDidFinishNotification
                                                  object:nil];
    
	[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
    
    // Rotate the view for landscape playback
    [[self view] setBounds:CGRectMake(0, 0, 480, 320)];
    [[self view] setCenter:CGPointMake(160, 240)];
    [[self view] setTransform:CGAffineTransformMakeRotation(M_PI / 2)]; 
    
    // Set frame of movieplayer
    [[mp view] setFrame:CGRectMake(0, 0, 480, 320)];
    
    // Add movie player as subview
    [[self view] addSubview:[mp view]];   
    
    // Play the movie
    [mp play];
}

/*---------------------------------------------------------------------------
 * 
 *--------------------------------------------------------------------------*/
- (void) showStatusBar {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
- (void) moviePlayBackDidFinish:(NSNotification*)notification 
{    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
 	// Remove observer
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification 
                                                  object:nil];
    
	[self dismissModalViewControllerAnimated:YES];
    
    //[self performSelector:@selector(showStatusBar) withObject:nil afterDelay:0];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [mp release];
}

/*---------------------------------------------------------------------------
 *
 *--------------------------------------------------------------------------*/
- (void) readyPlayer
{
    mp =  [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    
    if ([mp respondsToSelector:@selector(loadState)]) 
    {
        // Set movie player layout
        [mp setControlStyle:MPMovieControlStyleFullscreen];
        [mp setFullscreen:YES];
        
		// May help to reduce latency
		[mp prepareToPlay];
        
		// Register that the load state changed (movie is ready)
		[[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(moviePlayerLoadStateChanged:) 
                                                     name:MPMoviePlayerLoadStateDidChangeNotification 
                                                   object:nil];
	}  
    else
    {
        // Register to receive a notification when the movie is in memory and ready to play.
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(moviePreloadDidFinish:) 
                                                     name:MPMoviePlayerContentPreloadDidFinishNotification 
                                                   object:nil];
    }
    
    // Register to receive a notification when the movie has finished playing. 
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(moviePlayBackDidFinish:) 
                                                 name:MPMoviePlayerPlaybackDidFinishNotification 
                                               object:nil];
}

/*---------------------------------------------------------------------------
 * 
 *--------------------------------------------------------------------------*/
- (void) loadView
{
    [self setView:[[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease]];
	[[self view] setBackgroundColor:[UIColor blackColor]];
}

/*---------------------------------------------------------------------------
 *  
 *--------------------------------------------------------------------------*/
- (void)dealloc 
{
	[mp release];
    [movieURL release];
	[super dealloc];
}

@end
