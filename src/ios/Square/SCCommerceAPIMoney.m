//
//  SCCommerceAPIMoney.m
//  SquareCommerceSDK
//
//  Created by Mark Jen on 2/9/14.
//  Copyright (c) 2014 Square, Inc. All rights reserved.
//

#import "SquareCommerceSDKDefines.h"
#import "SCCommerceAPIMoney.h"


NSString *const SCCommerceAPIMoneyAmountKey = @"amount";
NSString *const SCCommerceAPIMoneyCurrencyCodeKey = @"currency_code";


@implementation SCCommerceAPIMoney

#pragma mark - Initialization

- (instancetype)initWithAmount:(NSInteger)amount currencyCode:(NSString*)currencyCode;
{
    self = [super init];
    if (!self) {
        return nil;
    }

    _amount = amount;
    _currencyCode = currencyCode;
    [self _validate];

    return self;
}

#pragma mark - Public Methods

- (void)setAmount:(NSInteger)amount;
{
    _amount = amount;
    [self _validate];
}

- (void)setCurrencyCode:(NSString *)currencyCode;
{
    _currencyCode = currencyCode;
    [self _validate];
}

- (NSDictionary *)dictionaryValue;
{
    if (self.error) {
        return nil;
    }
    return @{SCCommerceAPIMoneyAmountKey:@(self.amount),
             SCCommerceAPIMoneyCurrencyCodeKey:self.currencyCode};
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone;
{
    return [[[self class] allocWithZone:zone] initWithAmount:self.amount currencyCode:self.currencyCode];
}

#pragma mark - Private Methods

- (void)_validate;
{
    SCCommerceAPIMoneyErrorCode code = SCCommerceAPIMoneyErrorCodeNoError;
    if (self.amount < 0) {
        code = SCCommerceAPIMoneyErrorCodeInvalidCents;
    } else if (self.currencyCode) {
        if (![@[@"USD", @"CAD", @"JPY"] containsObject:self.currencyCode]) {
            code = SCCommerceAPIMoneyErrorCodeUnsupportedCurrencyCode;
        }
    } else {
        code = SCCommerceAPIMoneyErrorCodeMissingCurrencyCode;
    }

    if (code) {
        _error = [NSError errorWithDomain:SCCommerceAPIErrorDomain code:code userInfo:nil];
    }
}
@end
