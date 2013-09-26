//
//  totServerCommController.m
//  tot_server
//
//  Created by LZ on 13-9-21.
//  Copyright (c) 2013年 tot. All rights reserved.
//

#import "totServerCommController.h"

// class extention for private method declaration
@interface totServerCommController()

- (NSString *) sendStr: (NSString*) str toURL: (NSString *) dest_url;

@end

@interface NSURLRequest (DummyInterface)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host;
@end

@implementation totServerCommController

// -----------------------------------------------
//  constructor
//    -> setup parameters to connect to server
// -----------------------------------------------
- (id) init {
    self = [super init];
    if (self) {
        m_reg_url = @"https://www.gettot.com/m/reg";
        m_login_url = @"https://www.gettot.com/m/login";
        m_changePasscode_url = @"https://www.gettot.com/m/reset";
        m_forgetPasscode_url = @"https://www.gettot.com/m/forget";
    }
    return self;
}

// -----------------------------------------------
//  sendRegInfo
//    -> usrname: baby's name
//    -> call sendUsrName to send the usr reg info
//       to reg handler on server side
// -----------------------------------------------
- (NSString *) sendRegInfo: (NSString*) usrname withEmail: (NSString*) email withPasscode: (NSString*) passcode
{
    NSString* regInfo = @"name=";
    regInfo = [regInfo stringByAppendingString:usrname];
    regInfo = [regInfo stringByAppendingString:@"&email="];
    regInfo = [regInfo stringByAppendingString:email];
    regInfo = [regInfo stringByAppendingString:@"&passcode="];
    regInfo = [regInfo stringByAppendingString:passcode];
    NSString *response = [self sendStr:regInfo toURL:m_reg_url];
    return response;
}

// -----------------------------------------------
//  sendLoginInfo
//    -> call sendUsrName to send the usr login
//       info to login handler on server side
// -----------------------------------------------
- (NSString *) sendLoginInfo: (NSString*) email withPasscode: (NSString*) passcode {
    NSString* loginInfo = @"email=";
    loginInfo = [loginInfo stringByAppendingString:email];
    loginInfo = [loginInfo stringByAppendingString:@"&passcode="];
    loginInfo = [loginInfo stringByAppendingString:passcode];
    NSString *response = [self sendStr:loginInfo toURL:m_login_url];
    return response;
}

// -----------------------------------------------
//  change passcode
// -----------------------------------------------
- (NSString *) sendResetPasscodeForUser: (NSString*) email
                                   from: (NSString*) old_passcode
                                     to: (NSString*) new_passcode
{
    NSString* loginInfo = @"email=";
    loginInfo = [loginInfo stringByAppendingString:email];
    loginInfo = [loginInfo stringByAppendingString:@"&old_passcode="];
    loginInfo = [loginInfo stringByAppendingString:old_passcode];
    loginInfo = [loginInfo stringByAppendingString:@"&new_passcode="];
    loginInfo = [loginInfo stringByAppendingString:new_passcode];
    NSString *response = [self sendStr:loginInfo toURL:m_changePasscode_url];
    return response;
}

// -----------------------------------------------
//   send forget passcode request to server
// -----------------------------------------------
- (NSString *) sendForgetPasscodeforUser: (NSString*) email withPasscode: (NSString*) passcode {
    NSString* loginInfo = @"email=";
    loginInfo = [loginInfo stringByAppendingString:email];
    loginInfo = [loginInfo stringByAppendingString:@"&passcode="];
    loginInfo = [loginInfo stringByAppendingString:passcode];
    NSString *response = [self sendStr:loginInfo toURL:m_forgetPasscode_url];
    return response;
}
// -----------------------------------------------
//  basic func to send POST req to server
//    -> remember to check whether the return is nil
// -----------------------------------------------
- (NSString *) sendStr: (NSString*) post toURL: (NSString *) dest_url
{
    NSLog(@"post string: %@", post);
    
    // Construct a HTTP POST req
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLen = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:dest_url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLen forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    // ignore SSL certificate error
    NSURL* destURL = [NSURL URLWithString:dest_url];
    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[destURL host]];
    
    // Send the req syncrhonously [will be async later]
    NSURLResponse *response;
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request
                                              returningResponse:&response
                                                          error:nil];
    NSString *strReply = [[NSString alloc] initWithBytes:[POSTReply bytes]
                                                  length:[POSTReply length]
                                                encoding:NSASCIIStringEncoding];
    
    // Debug printout
    if (POSTReply == nil) {
        NSLog(@"post response: empty");
    } else {
        NSLog(@"post response: %@", strReply);
    }
    return strReply;
}

@end






