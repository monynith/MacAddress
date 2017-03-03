//
//  MacAddressPlugin.h
//  MacAddressPlugin
//
//  Created by Admin on 04/04/13.
//
//

#import <Cordova/CDV.h>

@interface MacAddressPlugin : CDVPlugin
@property(strong) NSString* callbackID;

- (void)getMacAddress:(CDVInvokedUrlCommand*)command;

@end
