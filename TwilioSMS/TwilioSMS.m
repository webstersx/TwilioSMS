//
//  TwilioSMS.m
//  Twilio
//
//  Created by Shawn Webster on 3/29/2014.
//  Copyright (c) 2014 Shawn Webster. All rights reserved.
//

#import "TwilioSMS.h"

@interface TwilioSMS()

//account properties
@property (strong, nonatomic) NSString *accountSid;
@property (strong, nonatomic) NSString *authToken;

//operation queue for sending messages asyncronously
@property (strong, nonatomic) NSOperationQueue *queue;

//sending messages from the shared client
- (void) sendTo:(NSString*)to from:(NSString*)from message:(NSString*)message;

@end

@implementation TwilioSMS

/*! Get a handle on the shared TwilioSMS client
 \returns the shared client
 */
+ (TwilioSMS *) shared
{
    static TwilioSMS *_shared = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _shared = [[self alloc] init];
    });
    
    return _shared;
}

- (id) init
{
    if (self = [super init])
    {
        self.queue = [[NSOperationQueue alloc] init];
        self.queue.name = @"TwilioSMS";
    }
    
    return self;
}

#pragma mark - Class setters
/*! Sets the values to be used when sending SMS
 \param accountSid Your account sender ID
 \param authToken Your auth token
 */
+ (void) setAccountSid:(NSString *)accountSid authToken:(NSString *)authToken {
    TwilioSMS *client = [self shared];
    client.accountSid = accountSid;
    client.authToken = authToken;
}

#pragma mark - Message Sending
/*! Sends an SMS using the details provided
 \param to The recipient phone number 
            (note: if the number isn't recognised, you may need to replace + with %2B)
 \param from The sending number (note: must belong to you in Twilio)
 \param message The human-readable text to send
 */
+ (void) sendTo:(NSString *)to from:(NSString *)from message:(NSString *)message {
    [[self shared] sendTo:to from:from message:message];
}

- (void) sendTo:(NSString *)to from:(NSString *)from message:(NSString *)message {
    
    if (!to) {
        //can't send: no to
        return;
    } else if (!from) {
        //can't send: no from
        return;
    } else if (!message) {
        //can't send: no body
        return;
    }
    
    //compose the data we're going to be sending
    NSData *data = [[NSString stringWithFormat:@"To=%@&From=%@&Body=%@",
                     to,
                     from,
                     [message stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] dataUsingEncoding:NSUTF8StringEncoding];
    
    //construct the URL from its parts
    NSArray *urlParts = @[@"https://",
                          //user:password@
                          self.accountSid, @":", self.authToken, @"@",
                          //derived URL
                          @"api.twilio.com/2010-04-01/Accounts/", self.accountSid, @"/SMS/Messages.json"];
    NSURL *url = [NSURL URLWithString:[urlParts componentsJoinedByString:@""]];
    
    //make a request, give it some properties
    NSMutableURLRequest *r = [NSMutableURLRequest requestWithURL:url];
    [r setHTTPMethod:@"POST"];
    [r addValue:@(data.length).stringValue forHTTPHeaderField:@"Content-Length"];
    [r setHTTPBody:data];
    
    //start an async connection
    [NSURLConnection sendAsynchronousRequest:r queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
//only debug if this is a debug builds
#ifdef DEBUG
        NSString *resString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@\n%@\n%@\n%@", response, data, connectionError, resString);
#endif
    }];
    
}



@end


