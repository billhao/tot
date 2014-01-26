//
//  totServerCommController.m
//  tot_server
//
//  Created by LZ on 13-9-21.
//  Copyright (c) 2013年 tot. All rights reserved.
//

#import "totServerCommController.h"
#import "Base64Encoder.h"

// class extention for private method declaration
@interface totServerCommController()

- (int) sendStr: (NSString*) post toURL: (NSString *) dest_url returnMessage: (NSString**)message;
- (void) sendStrAsync: (NSString*) post toURL: (NSString *) dest_url returnMessage: (NSString**)message;

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
        m_reg_url            = [NSString stringWithFormat:@"%@/m/reg",    HOSTNAME];
        m_login_url          = [NSString stringWithFormat:@"%@/m/login",  HOSTNAME];
        m_changePasscode_url = [NSString stringWithFormat:@"%@/m/reset",  HOSTNAME];
        m_forgetPasscode_url = [NSString stringWithFormat:@"%@/m/forget", HOSTNAME];
        m_sendUsrAct_url     = [NSString stringWithFormat:@"%@/m/usract", HOSTNAME];
    }
    return self;
}

// -----------------------------------------------
//  sendRegInfo
//    -> usrname: baby's name
//    -> call sendUsrName to send the usr reg info
//       to reg handler on server side
// -----------------------------------------------
- (int) sendRegInfo: (NSString*) usrname withEmail: (NSString*) email withPasscode: (NSString*) passcode returnMessage:(NSString**)message
{
    NSString* regInfo = @"name=";
    regInfo = [regInfo stringByAppendingString:usrname];
    regInfo = [regInfo stringByAppendingString:@"&email="];
    regInfo = [regInfo stringByAppendingString:email];
    regInfo = [regInfo stringByAppendingString:@"&passcode="];
    regInfo = [regInfo stringByAppendingString:passcode];
    return [self sendStr:regInfo toURL:m_reg_url returnMessage:message];
}

// -----------------------------------------------
//  sendLoginInfo
//    -> call sendUsrName to send the usr login
//       info to login handler on server side
// -----------------------------------------------
- (int) sendLoginInfo: (NSString*) email withPasscode: (NSString*) passcode returnMessage:(NSString**)message {
    NSString* loginInfo = @"email=";
    loginInfo = [loginInfo stringByAppendingString:email];
    loginInfo = [loginInfo stringByAppendingString:@"&passcode="];
    loginInfo = [loginInfo stringByAppendingString:passcode];
    return [self sendStr:loginInfo toURL:m_login_url returnMessage:message];
}

// -----------------------------------------------
//  change passcode
// -----------------------------------------------
- (int) sendResetPasscodeForUser: (NSString*) email
                                   from: (NSString*) old_passcode
                                     to: (NSString*) new_passcode
                          returnMessage: (NSString**)message
{
    NSString* loginInfo = @"email=";
    loginInfo = [loginInfo stringByAppendingString:email];
    loginInfo = [loginInfo stringByAppendingString:@"&oldpasscode="];
    loginInfo = [loginInfo stringByAppendingString:old_passcode];
    loginInfo = [loginInfo stringByAppendingString:@"&newpasscode="];
    loginInfo = [loginInfo stringByAppendingString:new_passcode];
    return [self sendStr:loginInfo toURL:m_changePasscode_url returnMessage:message];
}

// -----------------------------------------------
//   send forget passcode request to server
// -----------------------------------------------
- (int) sendForgetPasscodeforUser: (NSString*) email returnMessage:(NSString**)message {
    NSString* loginInfo = [NSString stringWithFormat:@"email=%@",email];
    return [self sendStr:loginInfo toURL:m_forgetPasscode_url returnMessage:message];
}

// -----------------------------------------------
//   send user activity to server
// -----------------------------------------------
- (int) sendUserActivityToServer: (NSString*) email withActivity: (NSString*) activity returnMessage:(NSString**)message{
    NSString* actInfo = @"email=";
    actInfo = [actInfo stringByAppendingString:email];
    actInfo = [actInfo stringByAppendingString:@"&act="];
    actInfo = [actInfo stringByAppendingString:activity];
    [self sendStrAsync:actInfo toURL:m_sendUsrAct_url returnMessage:message];
    return SERVER_RESPONSE_CODE_SUCCESS;
}


// -----------------------------------------------
//  basic func to send POST req to server
//    -> remember to check whether the return is nil
// -----------------------------------------------
- (int) sendStr: (NSString*) post toURL: (NSString *) dest_url returnMessage: (NSString**)message {
    //NSLog(@"post string: %@", post);
    
    // TODO add try catch here
    NSMutableURLRequest* request = [self getRequest:post toURL:dest_url];

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
        //NSLog(@"post response: %@", strReply);
    }
    int ret = SERVER_RESPONSE_CODE_FAIL;
    NSArray* ss = [strReply componentsSeparatedByString:@"::"];
    [strReply release];
    if( ss.count >= 1 && ss.count <= 2 ) {
        ret = [(NSString*)ss[0] intValue];
        if( ss.count == 2 ) {
            *message = [[(NSString*)ss[1] retain] autorelease];
        }
    }
    else
        *message = @"Cannot understand server's response";

    return ret;
}

- (void) sendStrAsync: (NSString*) post toURL: (NSString *) dest_url returnMessage: (NSString**)message {
    //NSLog(@"post string: %@", post);
    
    // TODO add try catch here
    NSMutableURLRequest* request = [self getRequest:post toURL:dest_url];
    
    // Send the req asyncrhonously
    [NSURLConnection sendAsynchronousRequest:request queue:nil completionHandler:nil];
}

- (NSMutableURLRequest*)getRequest:(NSString*)post toURL: (NSString *)dest_url {
    // Construct a HTTP POST req
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLen = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:dest_url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLen forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    [request setCachePolicy:NSURLCacheStorageNotAllowed];
    [request setTimeoutInterval:20.0];

    // ignore SSL certificate error
    NSURL* destURL = [NSURL URLWithString:dest_url];
    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[destURL host]];
    
    // add HTTP basic authentication header to the request
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", @"totdev", @"0000"];
    NSData *authStrData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authStrDataEncoded = [Base64Encoder encode:authStrData];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", authStrDataEncoded];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];

    return [request autorelease];
}

@end






