//
//  totServerCommController.h
//  tot_server
//
//  Created by LZ on 13-9-21.
//  Copyright (c) 2013年 tot. All rights reserved.
//

/*
 
 response_code = {  'login_success': 0, 'login_unmatch': 1, 'login_no_usr': 2,
                    'reg_success': 10, 'reg_usr_exist': 11,
                    'reset_success': 20, 'reset_old_pc_wrong': 21, 'reset_no_usr': 22,
                    'retrieve_link_snd': 30, 'retrieve_fail': 31
                    }
 */

#import <Foundation/Foundation.h>

#define HOSTNAME @"https://www.gettot.com"

@interface totServerCommController : NSObject {
    
    NSString *hostName;
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
