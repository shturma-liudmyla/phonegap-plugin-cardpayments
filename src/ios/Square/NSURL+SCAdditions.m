//
//  NSURL+SCAdditions.m
//  SquareCommerceSDK
//
//  Created by Mark Jen on 2/26/14.
//  Copyright (c) 2014 Square, Inc. All rights reserved.
//

#import "NSURL+SCAdditions.h"


@implementation NSURL (SCAdditions)

- (NSDictionary *)SC_parameters;
{
    NSString *query = [self query];
    NSArray *keyValuePairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];

    for (NSString *pair in keyValuePairs) {
        NSArray *components = [pair componentsSeparatedByString:@"="];

        if (components.count == 2) {
            NSString *key = [[components firstObject] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *value = [[components objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

            if (key && value) {
                [parameters setObject:value forKey:key];
            }
        }
    }

    return parameters;
}

@end
