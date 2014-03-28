TwilioSMS
=========

The simplest way to send SMS with Twilio


Usage
=====
```objective-c
[TwilioSMS setAccountSid:@"ACCOUNTSID" authToken:@"AUTHTOKEN"];
[TwilioSMS sendTo:@"+15555551234" from:@"+15555550000" message:@"Testing. It works!"];
```