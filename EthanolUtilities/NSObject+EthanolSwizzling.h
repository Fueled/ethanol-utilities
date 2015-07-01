//
//  NSObject+EthanolSwizzling.h
//  EthanolUtilities
//
//  Created by Stephane Copin on 1/9/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (EthanolSwizzling)

+ (void)eth_swizzleSelector:(SEL)originalSelector withSelector:(SEL)swizzledSelector;
+ (void)eth_swizzleClassSelector:(SEL)originalSelector withSelector:(SEL)swizzledSelector;

@end
