//
//  totHomeViewController.h
//  totdev
//
//  Created by Lixing Huang on 4/11/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class totHomeSleepingView;
@class totLanguageInputViewController;
@class totHomeRootController;

enum {
    kBasicLanguage=0,
    kBasicSleep=1,
    kBasicHeight=2,
    kBasicFood=3,
    kBasicDiaper=4,
    kBasicHealth=5,
    kBasicWeight=6,
    kBasicHead=7
};

@interface totHomeEntryViewController : UIViewController {
    totHomeSleepingView *mHomeSleepingView;
    totLanguageInputViewController *mLanguageInputView;
    totHomeRootController *homeRootController;
}

@property (nonatomic, assign) totHomeRootController *homeRootController;

@end
