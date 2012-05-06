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

enum {
    kBasicLanguage,
    kBasicSleep
};

@interface totHomeEntryViewController : UIViewController {
    totHomeSleepingView *mHomeSleepingView;
    totLanguageInputViewController *mLanguageInputView;
}

@end
