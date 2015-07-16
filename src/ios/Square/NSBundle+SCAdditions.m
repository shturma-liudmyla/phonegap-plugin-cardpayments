//
//  NSBundle+SCAdditions.m
//  SquareCommerceSDK
//
//  Created by Kyle Van Essen on 12/13/2013.
//  Copyright (c) 2013 Square, Inc. All rights reserved.
//

#import "NSBundle+SCAdditions.h"


@interface SCMainBundleFinderClass : NSObject
@end


@implementation SCMainBundleFinderClass
@end


@implementation NSBundle (SCAdditions)

+ (NSBundle *)squareCommerceSDKResourcesBundle;
{
    static NSBundle *bundle = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSBundle *mainBundle = [NSBundle bundleForClass:[SCMainBundleFinderClass class]];
        NSURL *bundleURL = [mainBundle URLForResource:@"SquareCommerceSDKResources" withExtension:@"bundle"];
        
        NSAssert(bundleURL != nil, @"Could not find resource bundle for SquareCommerceSDK within main application bundle.");
        
        bundle = [NSBundle bundleWithURL:bundleURL];
    });
    
    return bundle;
}

@end
