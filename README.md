TwilioSMS
=========

The simplest way to send SMS with Twilio. Zero dependencies.

This currently only supports sending SMS messages.  

Note: If during sending you get an error that the To number isn't recognised and it contains a '+', try replacing it with %2B.

Usage
=====
```objective-c
[TwilioSMS setAccountSid:@"ACCOUNTSID" authToken:@"AUTHTOKEN"];
[TwilioSMS sendTo:@"+15555551234" from:@"+15555550000" message:@"Testing. It works!"];
```