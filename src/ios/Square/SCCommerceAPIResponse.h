//
//  SCCommerceAPIResponse.h
//  SquareCommerceSDK
//
//  Created by Mark Jen on 2/9/14.
//  Copyright (c) 2014 Square, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, SCCommerceAPIResponseStatus) {
    SCCommerceAPIResponseStatusOK = 0,
    SCCommerceAPIResponseStatusError
};


typedef NS_ENUM(NSUInteger, SCCommerceAPIErrorCode) {
    SCCommerceAPIErrorCodeNoError = 0,

    SCCommerceAPIErrorCodePaymentCanceled,

    SCCommerceAPIErrorCodePayloadMissingOrInvalid,

    SCCommerceAPIErrorCodeAppNotLoggedIn,
    SCCommerceAPIErrorCodeLoginCodeInvalidOrExpired,
    SCCommerceAPIErrorCodeMerchantIDMismatch,
    SCCommerceAPIErrorCodeUserNotActivated,

    SCCommerceAPIErrorCodeCurrencyMissingOrInvalid,
    SCCommerceAPIErrorCodeCurrencyUnsupported,
    SCCommerceAPIErrorCodeCurrencyMismatch,
    SCCommerceAPIErrorCodeAmountMissingOrInvalid,
    SCCommerceAPIErrorCodeAmountTooSmall,
    SCCommerceAPIErrorCodeAmountTooLarge,

    SCCommerceAPIErrorCodeInvalidTenderType,
    SCCommerceAPIErrorCodeUnsupportedTenderType,

    SCCommerceAPIErrorCodeCouldNotPerform,

    SCCommerceAPIErrorCodeNoNetworkConnection,

    SCCommerceAPIErrorCodeUnknown
};


typedef NS_ENUM(NSUInteger, SCCommerceAPIResponseErrorCode) {
    SCCommerceAPIResponseErrorCodeMissingOrInvalidData = 1 << 16,
    SCCommerceAPIResponseErrorCodeEmptyOrInvalidJSONData,
    SCCommerceAPIResponseErrorCodeMissingOrInvalidStatus,
    SCCommerceAPIResponseErrorCodeMissingOrInvalidPaymentID,
    SCCommerceAPIResponseErrorCodeMissingOrInvalidErrorCode
};


extern NSString *const SCCommerceAPIResponseDataKey;
extern NSString *const SCCommerceAPIResponseStatusKey;
extern NSString *const SCCommerceAPIResponseErrorCodeKey;
extern NSString *const SCCommerceAPIResponsePaymentIDKey;
extern NSString *const SCCommerceAPIResponseStateKey;

extern NSString *const SCCommerceAPIResponseStatusStringOK;
extern NSString *const SCCommerceAPIResponseStatusStringError;

extern NSString *const SCCommerceAPIErrorStringPaymentCanceled;
extern NSString *const SCCommerceAPIErrorStringPayloadMissingOrInvalid;
extern NSString *const SCCommerceAPIErrorStringAppNotLoggedIn;
extern NSString *const SCCommerceAPIErrorStringLoginCodeInvalidOrExpired;
extern NSString *const SCCommerceAPIErrorStringMerchantIDMismatch;
extern NSString *const SCCommerceAPIErrorStringUserNotActivated;
extern NSString *const SCCommerceAPIErrorStringCurrencyMissingOrInvalid;
extern NSString *const SCCommerceAPIErrorStringCurrencyUnsupported;
extern NSString *const SCCommerceAPIErrorStringCurrencyMismatch;
extern NSString *const SCCommerceAPIErrorStringAmountMissingOrInvalid;
extern NSString *const SCCommerceAPIErrorStringAmountTooSmall;
extern NSString *const SCCommerceAPIErrorStringAmountTooLarge;
extern NSString *const SCCommerceAPIErrorStringInvalidTenderType;
extern NSString *const SCCommerceAPIErrorStringUnsupportedTenderType;
extern NSString *const SCCommerceAPIErrorStringCouldNotPerform;
extern NSString *const SCCommerceAPIErrorStringNoNetworkConnection;


@interface SCCommerceAPIResponse : NSObject

- (instancetype)initWithURL:(NSURL *)URL;

@property (nonatomic, copy, readonly) NSError *error;

@property (nonatomic, assign, readonly) SCCommerceAPIResponseStatus status;
@property (nonatomic, copy, readonly) NSString *paymentID;
@property (nonatomic, copy, readonly) NSString *userInfoString;

@end
