//
//  totServerCommController.h
//  tot_server
//
//  Created by LZ on 13-9-21.
//  Copyright (c) 2013年 tot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface totServerCommController : NSObject {
    NSString *m_reg_url;  // url to the registration handler
    NSString *m_login_url; // url to the login handler
    NSString *m_changePasscode_url;  // url to the change passcode handler
    NSString *m_forgetPasscode_url;  // url to the forget passcode handler
}

- (NSString *) sendRegInfo: (NSString*) usrname
                 withEmail: (NSString*) email
              withPasscode: (NSString*) passcode;

- (NSString *) sendLoginInfo: (NSString*) email withPasscode: (NSString*) passcode;

- (NSString *) sendResetPasscodeForUser: (NSString*) email
                                   from: (NSString*) old_passcode
                                     to: (NSString*) new_passcode;

- (NSString *) sendForgetPasscodeforUser: (NSString*) usrname;

//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;

@end
