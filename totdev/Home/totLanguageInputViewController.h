//
//  totLanguageInputViewController.h
//  totAlbumView
//
//  Created by User on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "totEvent.h"
#import "totModel.h"

@interface totLanguageInputViewController : UIViewController <UITextViewDelegate>
{
    UITextView* m_textView;
    UIButton* m_confirmButton;
}

@property (nonatomic, retain) UITextView* m_textView;
@property (nonatomic, retain) UIButton* m_confirmButton;

-(void) Display;
-(void) MakeNoView;
-(void) ConfirmButtonClicked;


@end
