//
//  SCCommerceAPIRequest.h
//  SquareCommerceSDK
//
//  Created by Mark Jen on 2/9/14.
//  Copyright (c) 2014 Square, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SCCommerceAPIMoney.h"


extern NSString *const SCCommerceAPIRequestClientIDKey;
extern NSString *const SCCommerceAPIRequestAmountMoneyKey;
extern NSString *const SCCommerceAPIRequestCallbackURLKey;
extern NSString *const SCCommerceAPIRequestLoginCodeKey;
extern NSString *const SCCommerceAPIRequestStateKey;
extern NSString *const SCCommerceAPIRequestMerchantIDKey;
extern NSString *const SCCommerceAPIRequestOptionsKey;
extern NSString *const SCCommerceAPIRequestOptionsClearDefaultFeesKey;
extern NSString *const SCCommerceAPIRequestOptionsSupportedTenderTypesKey;

extern NSString *const SCCommerceAPIRequestOptionsTenderTypeStringCash;
extern NSString *const SCCommerceAPIRequestOptionsTenderTypeStringCreditCard;
extern NSString *const SCCommerceAPIRequestOptionsTenderTypeStringOther;
extern NSString *const SCCommerceAPIRequestOptionsTenderTypeStringSquareWallet;


typedef NS_OPTIONS(NSUInteger, SCCommerceAPIRequestTenderTypes) {
    SCCommerceAPIRequestTenderTypeAllowAll = 0,
    SCCommerceAPIRequestTenderTypeCreditCard = 1 << 0,
    SCCommerceAPIRequestTenderTypeCash = 1 << 1,
    SCCommerceAPIRequestTenderTypeSquareWallet = 1 << 2,
    SCCommerceAPIRequestTenderTypeOther = 1 << 3
};


typedef NS_ENUM(NSUInteger, SCCommerceAPIRequestPerformErrorCode) {
    SCCommerceAPIRequestPerformErrorCodeNoClientID = 0,
    SCCommerceAPIRequestPerformErrorCodeInvalidCallbackURL,
    SCCommerceAPIRequestPerformErrorCodeInvalidAmount,
    SCCommerceAPIRequestPerformErrorCodeCannotPerformRequest,
    SCCommerceAPIRequestPerformErrorCodeJSONEncodeFailed
};


@interface SCCommerceAPIRequest : NSObject

+ (void)setClientID:(NSString *)clientID;

@property (nonatomic, copy) NSURL *callbackURL;
@property (nonatomic, copy) SCCommerceAPIMoney *amount;

@property (nonatomic, copy) NSString *loginCode;
@property (nonatomic, copy) NSString *userInfoString;
@property (nonatomic, copy) NSString *merchantID;

@property (nonatomic, assign) SCCommerceAPIRequestTenderTypes supportedTenderTypes;
@property (nonatomic, assign) BOOL clearsDefaultFees;

- (instancetype)initWithCallbackURL:(NSURL *)callbackURL amount:(SCCommerceAPIMoney *)amount;

- (NSURL *)debugURL:(NSError **)error;

- (BOOL)canPerform:(NSError **)error;
- (BOOL)perform:(NSError **)error;

@end
