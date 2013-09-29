//
//  totLanguageCard.m
//  totdev
//
//  Created by Lixing Huang on 8/11/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import "totPhotoCard.h"
#import "totTimeUtil.h"
#import "totTimeline.h"
#import "totReviewStory.h"

@implementation totPhotoShowCard

@synthesize mediaInfo;

- (id) init {
    self = [super init];
    if (self) {
        mediaInfo = nil;
        mPhotoView = nil;

        margin_x = 5;
        margin_y = 5;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackground];
    //[self setIcon:@"language2.png"];
    
    mPhotoView = [[totImageView alloc] initWithFrame:CGRectMake(5, 5, [self width]-10, [self height]-10)];
    mPhotoView.contentMode = UIViewContentModeScaleAspectFit;
    mPhotoView.backgroundColor = [UIColor clearColor];
    mPhotoView.clipsToBounds = TRUE;
    mPhotoView.layer.cornerRadius = 0.5;
    [self.view addSubview:mPhotoView];
}


- (void)viewWillAppear:(BOOL)animated {
    // If we load card from database, should not call this function again.
    // when loading from db, story_ will not be nil.
    if (!story_) {
        //[self getDataFromDB];
    } else {
        mediaInfo = [totMediaLibrary getMediaFromEvent:e];
    }
    [self updateUI];
}

#pragma mark - Helper functions

- (void)updateUI {
    if( e && mediaInfo ) {
        card_title.text = @"";
        description.text = @"";
        [line removeFromSuperview];
        //timestamp.textColor = [UIColor whiteColor];
        [self setTimestampWithDate:e.datetime];
        
        [mPhotoView imageFromFileContent:[totMediaLibrary getMediaPath:mediaInfo.filename]];
        UIImage* img = [UIImage imageWithContentsOfFile:[totMediaLibrary getMediaPath:mediaInfo.filename]];
        CGSize s1 = img.size;
        CGSize s2 = mPhotoView.bounds.size;
        
        float w = [self width] - margin_x*2;
        float h = (mPhotoView.image.size.height/mPhotoView.image.size.width)*w;
        
        // small photo (width < photo view width) needs some special handling
        BOOL smallPhoto = FALSE;
        if( mPhotoView.image.size.width < w ) {
            smallPhoto = TRUE;
            mPhotoView.contentMode = UIViewContentModeCenter;
            h = mPhotoView.image.size.height;
        }
        else
            mPhotoView.contentMode = UIViewContentModeScaleAspectFit;

        CGRect f = self.view.bounds;
        mPhotoView.frame = CGRectMake(margin_x, margin_y, w, h);
        
        h = mPhotoView.bounds.size.height;

        // add selected activities
        int icon_width = 30;
        int icon_height = 30;
        float internal_margin_x = 2;
        float internal_margin_y = 2;
        if( mediaInfo.activities ) {
            int cnt = mediaInfo.activities.count;
            activityView = [[UIView alloc] init];
            f = CGRectMake(margin_x+internal_margin_x, margin_y+h-icon_height-3*internal_margin_y, internal_margin_x+cnt*(icon_width+internal_margin_x), icon_height+2*internal_margin_y);
            if( smallPhoto ) {
                f.origin.x = margin_x;
                f.origin.y = margin_y + h;
                activityView.backgroundColor = [UIColor clearColor];
            }
            else {
                activityView.backgroundColor = [UIColor colorWithRed:.5 green:.5 blue:.5 alpha:.5];
                activityView.layer.cornerRadius = 2;
            }
            activityView.frame = f;
            for( int i=0; i<cnt; i++ ) {
                NSString* activity = mediaInfo.activities[i];
                NSString* tmpname = [activity stringByReplacingOccurrencesOfString:@" " withString:@"_"];
                NSString* activityIconName = [NSString stringWithFormat:@"activity_%@", tmpname];
                
                UIButton* activityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                activityBtn.frame = CGRectMake(internal_margin_x+i*(internal_margin_x+icon_width), internal_margin_y, icon_width, icon_height);
                activityBtn.tag = i;
                [activityBtn setImage:[UIImage imageNamed:activityIconName] forState:UIControlStateNormal];
                [activityBtn addTarget:self action:@selector(selectedActivityButtonPressed:) forControlEvents:UIControlEventTouchDown];
                [activityView addSubview:activityBtn];
            }
            [self.view addSubview:activityView];
        }

        // update time stamp
        [timestamp sizeToFit];
        f = timestamp.frame;
        if( activityView && smallPhoto ) {
            f.origin.x = margin_x + activityView.bounds.size.width;
            f.origin.y = activityView.frame.origin.y + activityView.frame.size.height - f.size.height;
        }
        else {
            f.origin.x = margin_x;
            f.origin.y = margin_y*2 + h;
        }
        timestamp.frame = f;
        [self.view bringSubviewToFront:timestamp];
        
        // refresh view to reflect height change of this card
        [self.parentView.parent refreshView];
    }
}

- (int) height {
    float h = 100; // default height;
    if( mPhotoView ) {
        h = mPhotoView.bounds.size.height + margin_y*2 + timestamp.bounds.size.height + margin_y;
        if( activityView ) {
            h = MAX(h, activityView.frame.origin.y+activityView.frame.size.height+margin_y);
        }
    }
    return h;
}
- (int) width { return 308; }

@end

