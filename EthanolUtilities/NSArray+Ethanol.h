//
//  NSArray+Ethanol.h
//  EthanolUtilities
//
//  Created by Stephane Copin on 9/2/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EthanolUtilities/ETHPreprocessorUtils.h>

@interface NSArray (Ethanol)

+ (instancetype)eth_arrayWithObjectNumber:(NSUInteger)objectNumber objects:(id)firstObject, ... __deprecated_msg("Please do not use this method directly. Use the macro ETHARRAY instead.");

@end

#define ETHARRAY_(...) \
  _Pragma("clang diagnostic push") \
  _Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"") \
  [NSArray eth_arrayWithObjectNumber:ETH_NARG(__VA_ARGS__) objects:__VA_ARGS__] \
  _Pragma("clang diagnostic pop")

/**
 *  Create an array that allows nil values which will be ignored.
 */
#define ETHARRAY(...) ETHARRAY_(nil, ## __VA_ARGS__)
