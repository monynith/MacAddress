//
//  MacAddressPlugin.m
//  MacAddressPlugin
//
//  Created by Admin on 04/04/13.
//
//

#import "MacAddressPlugin.h"
#import "MacFinder.h"
#import "MMLANScanner.h"
#include <ifaddrs.h>
#include <arpa/inet.h>

@interface MacAddressPlugin () <MMLANScannerDelegate>
@property(nonatomic,strong)MMLANScanner *lanScanner;

@end


@implementation MacAddressPlugin
@synthesize callbackID;

- (void)getMacAddress:(CDVInvokedUrlCommand*)command {
    self.callbackID = command.callbackId;
    self.lanScanner = [[MMLANScanner alloc] initWithDelegate:self];
    [self.lanScanner start];
}

- (void)lanScanDidFinishScanningWithStatus:(MMLanScannerStatus)status {
    NSString *mac = [MacFinder ip2mac:[self getIPAddress]];
    NSLog(@"MacAddressPlugin - Mac: %@", mac);
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:mac];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackID ];
}

- (void)lanScanDidFailedToScan {
    NSLog(@"MacAddressPlugin - Failed");
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Failed to get MacAddress"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackID ];
}

- (NSString *)getIPAddress {
    
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
                
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}

@end
