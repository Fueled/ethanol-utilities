//
//  NSSet+Ethanol.h
//  EthanolUtilities
//
//  Created by Stephane Copin on 9/2/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSSet (Ethanol)

+ (instancetype)eth_setWithObjectNumber:(NSUInteger)objectNumber objects:(id)firstObject, ... __deprecated_msg("Please do not use this method directly. Use the macro ETHSET instead.");

@end

#define ETHSET_(...) \
  _Pragma("clang diagnostic push") \
  _Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"") \
  [NSSet eth_setWithObjectNumber:ETH_NARG(__VA_ARGS__) objects:__VA_ARGS__] \
  _Pragma("clang diagnostic pop")

/**
 *  Create a set that allows nil values which will be ignored.
 */
#define ETHSET(...) ETHSET_(nil, ## __VA_ARGS__)
