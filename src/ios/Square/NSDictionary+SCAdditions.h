//
//  NSDictionary+SCAdditions.h
//  SquareCommerceSDK
//
//  Created by Mark Jen on 2/26/14.
//  Copyright (c) 2014 Square, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDictionary (SCAdditions)

- (NSString *)SC_stringForKey:(id)key;
- (NSNumber *)SC_numberForKey:(id)key;

@end


@interface NSMutableDictionary (SCAdditions)

- (void)SC_setSafeObject:(id)object forKey:(id)key;

@end
