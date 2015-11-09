//
//  NSArray+Ethanol.h
//  EthanolUtilities
//
//  Created by Stephane Copin on 9/2/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETHPreprocessorUtils.h"

@interface NSArray (Ethanol)

+ (instancetype)eth_arrayWithObjectNumber:(NSUInteger)objectNumber objects:(id)firstObject, ...;

@end

#define ETHARRAY_(...) \
  [NSArray eth_arrayWithObjectNumber:ETH_NARG(__VA_ARGS__) objects:__VA_ARGS__] \

/**
 *  Create an array that allows nil values which will be ignored.
 */
#define ETHARRAY(...) ETHARRAY_(nil, ## __VA_ARGS__)
