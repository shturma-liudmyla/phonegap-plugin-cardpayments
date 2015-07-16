//
//  SCCommerceAPIMoney.h
//  SquareCommerceSDK
//
//  Created by Mark Jen on 2/9/14.
//  Copyright (c) 2014 Square, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, SCCommerceAPIMoneyErrorCode) {
    SCCommerceAPIMoneyErrorCodeNoError = 0,
    SCCommerceAPIMoneyErrorCodeMissingCurrencyCode,
    SCCommerceAPIMoneyErrorCodeInvalidCurrencyCode,
    SCCommerceAPIMoneyErrorCodeUnsupportedCurrencyCode,
    SCCommerceAPIMoneyErrorCodeInvalidCents
};


extern NSString *const SCCommerceAPIMoneyAmountKey;
extern NSString *const SCCommerceAPIMoneyCurrencyCodeKey;


@interface SCCommerceAPIMoney : NSObject <NSCopying>

- (instancetype)initWithAmount:(NSInteger)amount currencyCode:(NSString *)currencyCode;

@property (nonatomic, assign) NSInteger amount;
@property (nonatomic, copy) NSString *currencyCode;
@property (nonatomic, strong, readonly) NSError *error;

- (NSDictionary *)dictionaryValue;

@end
