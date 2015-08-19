//
//  NSObject+EthanolExecuteOnDealloc.m
//  EthanolUtilities
//
//  Created by Stephane Copin on 3/31/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import "NSObject+EthanolExecuteOnDealloc.h"
#import <objc/runtime.h>

static char ETHInternalDeallocExecuterKey;

@interface ETHInternalDeallocExecuter : NSObject

@property (nonatomic, copy) ETHPerformOnDeallocBlock deallocBlock;
@property (nonatomic, unsafe_unretained) id object;

@end

@implementation ETHInternalDeallocExecuter

- (void)dealloc {
  if(_deallocBlock != nil) {
    _deallocBlock(_object);
  }
}

@end

@implementation NSObject (EthanolExecuteOnDealloc)

- (void)eth_performBlockOnDealloc:(ETHPerformOnDeallocBlock)deallocBlock {
  ETHInternalDeallocExecuter * deallocExecuter = objc_getAssociatedObject(self, &ETHInternalDeallocExecuterKey);
  if(deallocExecuter == nil && deallocBlock != nil) {
    deallocExecuter = [[ETHInternalDeallocExecuter alloc] init];
    deallocExecuter.object = self;
    deallocExecuter.deallocBlock = deallocBlock;
    
    objc_setAssociatedObject(self, &ETHInternalDeallocExecuterKey, deallocExecuter, OBJC_ASSOCIATION_RETAIN);
  } else if(deallocExecuter != nil) {
    deallocExecuter.deallocBlock = deallocBlock;
  } else if(deallocBlock == nil) {
    deallocExecuter.deallocBlock = nil;
    objc_setAssociatedObject(self, &ETHInternalDeallocExecuterKey, nil, OBJC_ASSOCIATION_ASSIGN);
  }
}

@end
