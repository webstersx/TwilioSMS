//
//  TwilioSMS.h
//  Twilio
//
//  Created by Shawn Webster on 3/29/2014.
//  Copyright (c) 2014 Shawn Webster. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwilioSMS : NSObject

+ (TwilioSMS*) shared;
+ (void) setAccountSid:(NSString*)accountSid authToken:(NSString*)authToken;
+ (void) sendTo:(NSString*)to from:(NSString*)from message:(NSString*)message;

@end