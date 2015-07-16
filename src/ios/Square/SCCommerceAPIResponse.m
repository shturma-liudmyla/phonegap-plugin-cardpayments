//
//  SCCommerceAPIResponse.m
//  SquareCommerceSDK
//
//  Created by Mark Jen on 2/9/14.
//  Copyright (c) 2014 Square, Inc. All rights reserved.
//

#import "SquareCommerceSDKDefines.h"
#import "SCCommerceAPIResponse.h"

#import "NSDictionary+SCAdditions.h"
#import "NSURL+SCAdditions.h"
#import "SCCommerceAPIResponse+Register.h"


NSString *const SCCommerceAPIResponseDataKey = @"data";
NSString *const SCCommerceAPIResponseStatusKey = @"status";
NSString *const SCCommerceAPIResponseErrorCodeKey = @"error_code";
NSString *const SCCommerceAPIResponsePaymentIDKey = @"payment_id";
NSString *const SCCommerceAPIResponseStateKey = @"state";

NSString *const SCCommerceAPIResponseStatusStringOK = @"ok";
NSString *const SCCommerceAPIResponseStatusStringError = @"error";

NSString *const SCCommerceAPIErrorStringPaymentCanceled = @"payment_canceled";
NSString *const SCCommerceAPIErrorStringPayloadMissingOrInvalid = @"data_invalid";
NSString *const SCCommerceAPIErrorStringAppNotLoggedIn = @"not_logged_in";
NSString *const SCCommerceAPIErrorStringLoginCodeInvalidOrExpired = @"login_code_invalid";
NSString *const SCCommerceAPIErrorStringMerchantIDMismatch = @"user_id_mismatch";
NSString *const SCCommerceAPIErrorStringUserNotActivated = @"user_not_active";
NSString *const SCCommerceAPIErrorStringCurrencyMissingOrInvalid = @"currency_code_missing";
NSString *const SCCommerceAPIErrorStringCurrencyUnsupported = @"unsupported_currency_code";
NSString *const SCCommerceAPIErrorStringCurrencyMismatch = @"currency_code_mismatch";
NSString *const SCCommerceAPIErrorStringAmountMissingOrInvalid = @"amount_invalid_format";
NSString *const SCCommerceAPIErrorStringAmountTooSmall = @"amount_too_small";
NSString *const SCCommerceAPIErrorStringAmountTooLarge = @"amount_too_large";
NSString *const SCCommerceAPIErrorStringInvalidTenderType = @"invalid_tender_type";
NSString *const SCCommerceAPIErrorStringUnsupportedTenderType = @"unsupported_tender_type";
NSString *const SCCommerceAPIErrorStringCouldNotPerform = @"could_not_perform";
NSString *const SCCommerceAPIErrorStringNoNetworkConnection = @"no_network_connection";


@implementation SCCommerceAPIResponse

#pragma mark - Initialization

- (instancetype)initWithURL:(NSURL *)URL;
{
    self = [super init];
    if (!self) {
        return nil;
    }

    NSDictionary *parameters = [URL SC_parameters];
    NSString *dataString = [parameters SC_stringForKey:SCCommerceAPIResponseDataKey];
    if (!dataString.length) {
        _error = [NSError errorWithDomain:SCCommerceAPIResponseErrorDomain code:SCCommerceAPIResponseErrorCodeMissingOrInvalidData userInfo:nil];
        return self;
    }

    NSError *error = nil;
    NSObject *JSONObject = (NSObject *)[NSJSONSerialization JSONObjectWithData:[dataString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    if (error) {
        _error = error;
        return self;
    }
    if (![JSONObject isKindOfClass:[NSDictionary class]]) {
        _error = [NSError errorWithDomain:SCCommerceAPIResponseErrorDomain code:SCCommerceAPIResponseErrorCodeEmptyOrInvalidJSONData userInfo:nil];
    }

    NSDictionary *data = (NSDictionary *)JSONObject;

    NSString *statusString = [data SC_stringForKey:SCCommerceAPIResponseStatusKey];
    if (!statusString.length) {
        _error = [NSError errorWithDomain:SCCommerceAPIResponseErrorDomain code:SCCommerceAPIResponseErrorCodeMissingOrInvalidStatus userInfo:nil];
        return self;
    }
    NSNumber *status = [[[self class] _responseStatusesByString] SC_numberForKey:statusString];
    if (!status) {
        _error = [NSError errorWithDomain:SCCommerceAPIResponseErrorDomain code:SCCommerceAPIResponseErrorCodeMissingOrInvalidStatus userInfo:nil];
        return self;
    }
    _status = status.unsignedIntegerValue;

    if (_status == SCCommerceAPIResponseStatusError) {
        NSString *errorString = [data SC_stringForKey:SCCommerceAPIResponseErrorCodeKey];
        if (!errorString.length) {
            _error = [NSError errorWithDomain:SCCommerceAPIResponseErrorDomain code:SCCommerceAPIResponseErrorCodeMissingOrInvalidErrorCode userInfo:nil];
        }
        NSNumber *errorCode = [[[self class] errorCodesByString] SC_numberForKey:errorString];
        NSDictionary *userInfo = @{SCCommerceAPIResponseErrorCodeKey: errorString};
        if (!errorCode) {
            _error = [NSError errorWithDomain:SCCommerceAPIErrorDomain code:SCCommerceAPIErrorCodeUnknown userInfo:userInfo];
        } else {
            _error = [NSError errorWithDomain:SCCommerceAPIErrorDomain code:errorCode.unsignedIntegerValue userInfo:userInfo];
        }
    } else {
        _paymentID = [data SC_stringForKey:SCCommerceAPIResponsePaymentIDKey];
        if (!_paymentID.length) {
            _error = [NSError errorWithDomain:SCCommerceAPIResponseErrorDomain code:SCCommerceAPIResponseErrorCodeMissingOrInvalidPaymentID userInfo:nil];
        }
    }

    _userInfoString = [data SC_stringForKey:SCCommerceAPIResponseStateKey];

    return self;
}

- (NSString *)description;
{
    return [NSString stringWithFormat:@"SCCommerceAPIResponse Status=%lu PaymentID=%@ UserInfoString=%@ error=%@", (unsigned long)self.status, self.paymentID, self.userInfoString, self.error];
}

#pragma mark - Private Methods

+ (NSDictionary *)_responseStatusesByString;
{
    static NSDictionary* statusByString = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        statusByString = @{
                           SCCommerceAPIResponseStatusStringOK: @(SCCommerceAPIResponseStatusOK),
                           SCCommerceAPIResponseStatusStringError: @(SCCommerceAPIResponseStatusError)};
    });
    return statusByString;
}

@end
