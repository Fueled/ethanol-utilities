//
//  NSArray+Ethanol.m
//  EthanolUtilities
//
//  Created by Stephane Copin on 9/2/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import "NSArray+Ethanol.h"

@implementation NSArray (Ethanol)

+ (instancetype)eth_arrayWithObjectNumber:(NSUInteger)objectNumber objects:(id)firstObject, ... {
  NSMutableArray * array = [NSMutableArray array];
  va_list args;
  va_start(args, firstObject);
  id object = firstObject;
  for(NSUInteger i = 0;i < objectNumber;++i) {
    if(object != nil) {
      [array addObject:object];
    } else {
    }
    if(i < objectNumber - 1) {
      object = va_arg(args, id);
    }
  }
  va_end(args);
  return array;
}

@end
