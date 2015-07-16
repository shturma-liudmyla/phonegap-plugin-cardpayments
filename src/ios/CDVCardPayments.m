/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

#import "CDVCardPayments.h"
#import "SquareCommerceSDK.h"

#import <Cordova/CDVAvailability.h>

#ifndef __CORDOVA_3_2_0
#warning "The keyboard plugin is only supported in Cordova 3.2 or greater, it may not work properly in an older version. If you do use this plugin in an older version, make sure the HideKeyboardFormAccessoryBar and KeyboardShrinksView preference values are false."
#endif

@interface CDVCardPayments (hidden)

- (NSString*) statusToString: (SCCommerceAPIResponseStatus) status;

@end

// request fields
NSString *const CDVSquarePaymentRequestClientIDKey = @"clientId";
NSString *const CDVSquarePaymentRequestMerchantIDKey = @"merchantId";
NSString *const CDVSquarePaymentRequestUserInfoStringKey = @"userInfo";
NSString *const CDVSquarePaymentRequestAmountKey = @"amount";
NSString *const CDVSquarePaymentRequestCurrencyKey = @"currency";

// response fields
NSString *const CDVSquarePaymentResponsePaymentIdKey = @"paymentId";
NSString *const CDVSquarePaymentResponseStatusKey = @"status";
NSString *const CDVSquarePaymentResponseUserInfoStringKey = @"userInfo";

// error fields
NSString *const CDVSquarePaymentErrorCodeKey = @"code";
NSString *const CDVSquarePaymentErrorDomainKey = @"domain";

@implementation CDVCardPayments

 - (void)createPayment:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSError *error = nil;
    
    NSDictionary* params = [command.arguments objectAtIndex:0];

    NSString *clientID      = [params objectForKey: CDVSquarePaymentRequestClientIDKey];
    NSString *merchantID    = [params objectForKey: CDVSquarePaymentRequestMerchantIDKey];
    NSString *userInfo      = [params objectForKey: CDVSquarePaymentRequestUserInfoStringKey];
    NSNumber *amount        = [params objectForKey: CDVSquarePaymentRequestAmountKey];
    NSString *currency      = [params objectForKey: CDVSquarePaymentRequestCurrencyKey];

    // Initialize the request
    SCCommerceAPIRequest *request = [[SCCommerceAPIRequest alloc] init];
    
    [SCCommerceAPIRequest setClientID:clientID];
    
    // Specify the amount of money to charge
    request.amount = [[SCCommerceAPIMoney alloc] initWithAmount:[amount intValue] currencyCode:currency];
    
    // Specify which forms of tender the merchant can accept
    request.supportedTenderTypes = SCCommerceAPIRequestTenderTypeCreditCard;
    
    // Specify whether default fees in Square Register are cleared from this transaction
    // (Default is NO, they are not cleared)
    request.clearsDefaultFees = YES;
    
    // Replace with the current merchant's ID
    request.merchantID = merchantID;
    
    // Replace with any string you want returned from Square Register
    request.userInfoString = userInfo;
    
    // Replace with your app's callback URL
    request.callbackURL = [NSURL URLWithString: @"auto-shop://payment-complete"];
    
    // Perform the request
    [request perform:&error];
    
    if (error != nil) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                     messageAsDictionary:[error userInfo]];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) handleCallback:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* urlString = [command.arguments objectAtIndex:0];
    NSURL *url = [NSURL URLWithString: urlString];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    // Wrap the returned data in an SCCommerceAPIResponse object
    SCCommerceAPIResponse *response = [[SCCommerceAPIResponse alloc] initWithURL:url];
    
    NSString *status = [self statusToString:response.status];
    
    [dict setValue:status forKey: CDVSquarePaymentResponseStatusKey];
    [dict setValue:[response userInfoString] forKey: CDVSquarePaymentResponseUserInfoStringKey];

    if (response.error != nil) {
        NSDictionary *errorInfo = [response.error userInfo];
        NSString* errorCode = [errorInfo objectForKey: SCCommerceAPIResponseErrorCodeKey];

        [dict setValue: errorCode forKey: CDVSquarePaymentErrorCodeKey];
        [dict setValue: [response.error domain] forKey: CDVSquarePaymentErrorDomainKey];
        
        pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR
                                         messageAsDictionary: dict];
    } else {
        [dict setValue:[response paymentID] forKey: CDVSquarePaymentResponsePaymentIdKey];
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (NSString*) statusToString: (SCCommerceAPIResponseStatus) status {
    NSString *result = nil;
    
    switch(status) {
        case SCCommerceAPIResponseStatusOK:
            result = @"OK";
            break;
        case SCCommerceAPIResponseStatusError:
            result = @"ERROR";
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected status."];
    }
    
    return result;
}

@end
