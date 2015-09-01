//
//  NSURL+SCAdditions.h
//  SquareCommerceSDK
//
//  Created by Mark Jen on 2/26/14.
//  Copyright (c) 2014 Square, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSURL (SCAdditions)

- (NSDictionary *)SC_parameters;

@end

@interface NSString (SCAdditions)

- (NSString *) SC_URLEncode;

@end