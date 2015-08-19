//
//  NSSet+Ethanol.h
//  EthanolUtilities
//
//  Created by Stephane Copin on 9/2/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSSet (Ethanol)

+ (instancetype)eth_setWithObjectNumber:(NSUInteger)objectNumber objects:(id)firstObject, ...;

@end

#define ETHSET_(...) \
  [NSSet eth_setWithObjectNumber:ETH_NARG(__VA_ARGS__) objects:__VA_ARGS__] \

/**
 *  Create a set that allows nil values which will be ignored.
 */
#define ETHSET(...) ETHSET_(nil, ## __VA_ARGS__)
