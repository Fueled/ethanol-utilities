//
//  NSDictionary+Ethanol.h
//  EthanolUtilities
//
//  Created by Stephane Copin on 9/2/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EthanolUtilities/ETHPreprocessorUtils.h>

@interface NSDictionary (Ethanol)

+ (instancetype)eth_dictionaryWithKeyValueNumber:(NSUInteger)keyValueNumber keyValues:(id)firstKey, ... __deprecated_msg("Please do not use this method directly. Use the macro ETHDICT instead.");

@end

#define ETHDICT_(...) \
  _Pragma("clang diagnostic push") \
  _Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"") \
  [NSDictionary eth_dictionaryWithKeyValueNumber:ETH_NARG(__VA_ARGS__) keyValues:__VA_ARGS__] \
  _Pragma("clang diagnostic pop")

/**
 *  Create a dictionary that allows nil values which will be ignored.
 */
#define ETHDICT(...) ETHDICT_(nil, nil, ## __VA_ARGS__)
