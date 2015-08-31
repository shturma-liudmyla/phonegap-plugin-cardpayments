//
//  NSDictionary+SCAdditions.m
//  SquareCommerceSDK
//
//  Created by Mark Jen on 2/26/14.
//  Copyright (c) 2014 Square, Inc. All rights reserved.
//

#import "NSDictionary+SCAdditions.h"


@implementation NSDictionary (SCAdditions)

- (NSString *)SC_stringForKey:(id)key;
{
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSString class]]) {
        return object;
    }
    return nil;
}

- (NSNumber *)SC_numberForKey:(id)key;
{
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSNumber class]]) {
        return object;
    }
    return nil;
}

@end


@implementation NSMutableDictionary (SCAdditions)

- (void)SC_setSafeObject:(id)object forKey:(id)key;
{
    if (key && object) {
        [self setObject:object forKey:key];
    }
}

@end
