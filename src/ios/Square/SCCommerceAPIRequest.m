//
//  SCCommerceAPIRequest.m
//  SquareCommerceSDK
//
//  Created by Mark Jen on 2/9/14.
//  Copyright (c) 2014 Square, Inc. All rights reserved.
//

#import "SquareCommerceSDKDefines.h"
#import "SCCommerceAPIRequest.h"

#import "NSDictionary+SCAdditions.h"


NSString *const SCSDKVersion = @"1";
NSString *const SCAPIVersion = @"1";
NSString *const SCAPIURLSchemeBase = @"square-commerce";

NSString *const SCCommerceAPIRequestSDKVersionKey = @"sdk_version";
NSString *const SCCommerceAPIRequestClientIDKey = @"client_id";
NSString *const SCCommerceAPIRequestAmountMoneyKey = @"amount_money";
NSString *const SCCommerceAPIRequestCallbackURLKey = @"callback_url";
NSString *const SCCommerceAPIRequestLoginCodeKey = @"login_code";
NSString *const SCCommerceAPIRequestStateKey = @"state";
NSString *const SCCommerceAPIRequestMerchantIDKey = @"merchant_id";
NSString *const SCCommerceAPIRequestOptionsKey = @"options";
NSString *const SCCommerceAPIRequestOptionsSupportedTenderTypesKey = @"supported_tender_types";
NSString *const SCCommerceAPIRequestOptionsClearDefaultFeesKey = @"clear_default_fees";

NSString *const SCCommerceAPIRequestOptionsTenderTypeStringCash = @"CASH";
NSString *const SCCommerceAPIRequestOptionsTenderTypeStringCreditCard = @"CREDIT_CARD";
NSString *const SCCommerceAPIRequestOptionsTenderTypeStringOther = @"OTHER";
NSString *const SCCommerceAPIRequestOptionsTenderTypeStringSquareWallet = @"SQUARE_WALLET";


@implementation SCCommerceAPIRequest

#pragma mark - Class Methods

static NSString *commerceAPIClientID = nil;

+ (void)setClientID:(NSString *)clientID;
{
    commerceAPIClientID = clientID;
}

+ (NSString *)_clientID;
{
    return commerceAPIClientID;
}

+ (NSDictionary *)_tenderTypeStringsByType;
{
    static NSDictionary* tenderTypeStringsByType;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tenderTypeStringsByType = @{
            @(SCCommerceAPIRequestTenderTypeCreditCard): SCCommerceAPIRequestOptionsTenderTypeStringCreditCard,
            @(SCCommerceAPIRequestTenderTypeCash): SCCommerceAPIRequestOptionsTenderTypeStringCash,
            @(SCCommerceAPIRequestTenderTypeOther): SCCommerceAPIRequestOptionsTenderTypeStringOther,
            @(SCCommerceAPIRequestTenderTypeSquareWallet): SCCommerceAPIRequestOptionsTenderTypeStringSquareWallet
        };
    });
    return tenderTypeStringsByType;
}

+ (BOOL)_canPerformRequestWithURL:(NSURL *)URL error:(NSError *__autoreleasing *)error;
{
    if (![[UIApplication sharedApplication] canOpenURL:URL]) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:SCCommerceAPIErrorDomain code:SCCommerceAPIRequestPerformErrorCodeCannotPerformRequest userInfo:nil];
        }
        return NO;
    }
    return YES;
}

+ (BOOL)_performRequestWithURL:(NSURL *)URL error:(NSError *__autoreleasing *)error;
{
    if ([self _canPerformRequestWithURL:URL error:error]) {
        return [[UIApplication sharedApplication] openURL:URL];
    }
    return NO;
}

+ (NSString *)_URLScheme;
{
    static NSString *URLScheme;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        URLScheme = [NSString stringWithFormat:@"%@-v%@", SCAPIURLSchemeBase, SCAPIVersion];
    });
    return URLScheme;
}

#pragma mark - Initialization

- (instancetype)initWithCallbackURL:(NSURL *)callbackURL amount:(SCCommerceAPIMoney *)amount;
{
    NSAssert(callbackURL.scheme.length, @"Callback URL must be specified and have a scheme.");
    NSAssert(amount, @"SCCommerceAPIMoney amount must be specified.");
    NSAssert(!amount.error, @"Invalid SCCommerceAPIMoney amount object specified.");

    self = [super init];
    if (!self) {
        return nil;
    }

    _callbackURL = callbackURL;
    _amount = [amount copy];

    return self;
}

#pragma mark - Public Methods

- (NSURL *)debugURL:(NSError *__autoreleasing *)error;
{
    if (error == NULL) {
        NSError __autoreleasing *placeholderError;
        error = &placeholderError;
    }

    if (![[self class] _clientID].length) {
        *error = [NSError errorWithDomain:SCCommerceAPIErrorDomain code:SCCommerceAPIRequestPerformErrorCodeNoClientID userInfo:nil];
        return nil;
    }

    if (!self.amount || self.amount.error) {
        *error = [NSError errorWithDomain:SCCommerceAPIErrorDomain code:SCCommerceAPIRequestPerformErrorCodeInvalidAmount userInfo:nil];
        return nil;
    }

    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
                               
    [data SC_setSafeObject:SCSDKVersion forKey:SCCommerceAPIRequestSDKVersionKey];
    [data SC_setSafeObject:[[self class] _clientID] forKey:SCCommerceAPIRequestClientIDKey];
    [data SC_setSafeObject:self.amount.dictionaryValue forKey:SCCommerceAPIRequestAmountMoneyKey];
    [data SC_setSafeObject:[self.callbackURL absoluteString] forKey:SCCommerceAPIRequestCallbackURLKey];
    [data SC_setSafeObject:self.loginCode forKey:SCCommerceAPIRequestLoginCodeKey];
    [data SC_setSafeObject:self.userInfoString forKey:SCCommerceAPIRequestStateKey];
    [data SC_setSafeObject:self.merchantID forKey:SCCommerceAPIRequestMerchantIDKey];

    NSMutableDictionary *options = [[NSMutableDictionary alloc] init];
    [options SC_setSafeObject:[self _tenderTypeStringsWithTenderTypes:self.supportedTenderTypes]
                       forKey:SCCommerceAPIRequestOptionsSupportedTenderTypesKey];
    [options SC_setSafeObject:@(self.clearsDefaultFees) forKey:SCCommerceAPIRequestOptionsClearDefaultFeesKey];
    if (options.count) {
        [data SC_setSafeObject:options forKey:SCCommerceAPIRequestOptionsKey];
    }

    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:data options:0 error:error];
    if (*error) {
        return nil;
    }
    if (!JSONData) {
        *error = [NSError errorWithDomain:SCCommerceAPIErrorDomain code:SCCommerceAPIRequestPerformErrorCodeJSONEncodeFailed userInfo:nil];
        return nil;
    }

    NSString *query = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
        kCFAllocatorDefault,
        (CFStringRef)query,
        NULL,
        CFSTR(":/?#[]@!$&'()*+,;="),
        kCFStringEncodingUTF8));

    return [NSURL URLWithString:[NSString stringWithFormat:@"%@://payment/create?data=%@", [[self class] _URLScheme], encodedString]];
}

- (BOOL)canPerform:(NSError *__autoreleasing *)error;
{
    NSURL *URL = [self debugURL:error];
    if (URL) {
        return [[self class] _canPerformRequestWithURL:URL error:error];
    }
    return NO;
}

- (BOOL)perform:(NSError *__autoreleasing *)error;
{
    NSURL *URL = [self debugURL:error];
    if (URL) {
        return [[self class] _performRequestWithURL:URL error:error];
    }
    return NO;
}

#pragma mark - Private Methods

- (NSArray *)_tenderTypeStringsWithTenderTypes:(SCCommerceAPIRequestTenderTypes)tenderTypes;
{
    NSMutableSet *tenderTypeStrings = [[NSMutableSet alloc] init];
    NSDictionary *tenderTypesByString = [[self class] _tenderTypeStringsByType];
    for (NSNumber *tenderType in tenderTypesByString) {
        if (self.supportedTenderTypes & tenderType.unsignedIntegerValue) {
            [tenderTypeStrings addObject:tenderTypesByString[tenderType]];
        }
    }
    if (tenderTypeStrings.count) {
        return [tenderTypeStrings allObjects];
    }
    return nil;
}

@end
