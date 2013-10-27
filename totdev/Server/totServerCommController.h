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

enum SERVER_RESPONSE_CODE {
    SERVER_RESPONSE_CODE_FAIL = -1,
    SERVER_RESPONSE_CODE_SUCCESS = 0,
    SERVER_RESPONSE_CODE_REG_USER_EXIST = 1,
};

@interface totServerCommController : NSObject {
    
    NSString *m_reg_url;  // url to the registration handler
    NSString *m_login_url; // url to the login handler
    NSString *m_changePasscode_url;  // url to the change passcode handler
    NSString *m_forgetPasscode_url;  // url to the forget passcode handler
}

- (int) sendRegInfo: (NSString*) usrname withEmail: (NSString*) email withPasscode: (NSString*) passcode returnMessage:(NSString**)message;
- (int) sendLoginInfo: (NSString*) email withPasscode: (NSString*) passcode returnMessage:(NSString**)message;
- (int) sendResetPasscodeForUser: (NSString*) email from: (NSString*) old_passcode to: (NSString*) new_passcode returnMessage: (NSString**)message;
- (int) sendForgetPasscodeforUser: (NSString*) email returnMessage:(NSString**)message;

//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;

@end
