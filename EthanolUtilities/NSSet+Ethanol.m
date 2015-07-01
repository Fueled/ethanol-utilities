//
//  NSSet+Ethanol.m
//  EthanolUtilities
//
//  Created by Stephane Copin on 9/2/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import "NSSet+Ethanol.h"

@implementation NSSet (Ethanol)

+ (instancetype)eth_setWithObjectNumber:(NSUInteger)objectNumber objects:(id)firstObject, ... {
  NSMutableSet * set = [NSMutableSet set];
  va_list args;
  va_start(args, firstObject);
  id object = firstObject;
  for(NSUInteger i = 0;i < objectNumber;++i) {
    if(object != nil) {
      [set addObject:object];
    } else {
    }
    if(i < objectNumber - 1) {
      object = va_arg(args, id);
    }
  }
  va_end(args);
  return set;
}

@end
