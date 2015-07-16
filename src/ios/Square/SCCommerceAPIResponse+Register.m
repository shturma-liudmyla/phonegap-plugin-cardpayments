//
//  SCCommerceAPIResponse+Register.m
//  SquareCommerceSDK
//
//  Created by Mark Jen on 3/4/14.
//  Copyright (c) 2014 Square, Inc. All rights reserved.
//

#import "SCCommerceAPIResponse+Register.h"

@implementation SCCommerceAPIResponse (Register)

#pragma mark - Class Methods

+ (NSDictionary *)errorCodesByString;
{
    static NSDictionary *mapping = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapping = @{
            SCCommerceAPIErrorStringPaymentCanceled: @(SCCommerceAPIErrorCodePaymentCanceled),
            SCCommerceAPIErrorStringPayloadMissingOrInvalid: @(SCCommerceAPIErrorCodePayloadMissingOrInvalid),
            SCCommerceAPIErrorStringAppNotLoggedIn: @(SCCommerceAPIErrorCodeAppNotLoggedIn),
            SCCommerceAPIErrorStringLoginCodeInvalidOrExpired: @(SCCommerceAPIErrorCodeLoginCodeInvalidOrExpired),
            SCCommerceAPIErrorStringMerchantIDMismatch: @(SCCommerceAPIErrorCodeMerchantIDMismatch),
            SCCommerceAPIErrorStringUserNotActivated: @(SCCommerceAPIErrorCodeUserNotActivated),
            SCCommerceAPIErrorStringCurrencyMissingOrInvalid: @(SCCommerceAPIErrorCodeCurrencyMissingOrInvalid),
            SCCommerceAPIErrorStringCurrencyUnsupported: @(SCCommerceAPIErrorCodeCurrencyUnsupported),
            SCCommerceAPIErrorStringCurrencyMismatch: @(SCCommerceAPIErrorCodeCurrencyMismatch),
            SCCommerceAPIErrorStringAmountMissingOrInvalid: @(SCCommerceAPIErrorCodeAmountMissingOrInvalid),
            SCCommerceAPIErrorStringAmountTooSmall: @(SCCommerceAPIErrorCodeAmountTooSmall),
            SCCommerceAPIErrorStringAmountTooLarge: @(SCCommerceAPIErrorCodeAmountTooLarge),
            SCCommerceAPIErrorStringInvalidTenderType: @(SCCommerceAPIErrorCodeInvalidTenderType),
            SCCommerceAPIErrorStringUnsupportedTenderType: @(SCCommerceAPIErrorCodeUnsupportedTenderType),
            SCCommerceAPIErrorStringCouldNotPerform: @(SCCommerceAPIErrorCodeCouldNotPerform),
            SCCommerceAPIErrorStringNoNetworkConnection: @(SCCommerceAPIErrorCodeNoNetworkConnection)
        };
    });
    return mapping;
}

@end
