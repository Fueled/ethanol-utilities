//
//  NSDictionary+Ethanol.m
//  EthanolUtilities
//
//  Created by Stephane Copin on 9/2/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import "NSDictionary+Ethanol.h"

@implementation NSDictionary (Ethanol)

+ (instancetype)eth_dictionaryWithKeyValueNumber:(NSUInteger)keyValueNumber keyValues:(id)firstKey, ... {
  NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
  va_list args;
  va_start(args, firstKey);
  id key = firstKey;
  for(NSUInteger i = 1;i < keyValueNumber;++i) {
    id value = va_arg(args, id);
    if(key != nil && value != nil) {
      dictionary[key] = value;
    }
    if(++i < keyValueNumber) {
      key = va_arg(args, id);
    }
  }
  va_end(args);
  return dictionary;
}

@end
