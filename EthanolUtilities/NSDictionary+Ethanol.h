//
//  NSDictionary+Ethanol.h
//  EthanolUtilities
//
//  Created by Stephane Copin on 9/2/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETHPreprocessorUtils.h"

@interface NSDictionary (Ethanol)

+ (instancetype)eth_dictionaryWithKeyValueNumber:(NSUInteger)keyValueNumber keyValues:(id)firstKey, ...;

@end

#define ETHDICT_(...) \
  [NSDictionary eth_dictionaryWithKeyValueNumber:ETH_NARG(__VA_ARGS__) keyValues:__VA_ARGS__] \

/**
 *  Create a dictionary that allows nil values which will be ignored.
 */
#define ETHDICT(...) ETHDICT_(nil, nil, ## __VA_ARGS__)
