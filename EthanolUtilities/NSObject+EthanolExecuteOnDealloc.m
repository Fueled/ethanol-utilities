//
//  NSObject+EthanolExecuteOnDealloc.m
//  EthanolUtilities
//
//  Created by Stephane Copin on 3/31/14.
//  Copyright (c) 2014 Fueled Digital Media, LLC.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
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
  if(deallocBlock != nil) {
    if(deallocExecuter != nil) {
      deallocExecuter.deallocBlock = nil;
    }
    deallocExecuter = [[ETHInternalDeallocExecuter alloc] init];
    deallocExecuter.object = self;
    deallocExecuter.deallocBlock = deallocBlock;
    
    objc_setAssociatedObject(self, &ETHInternalDeallocExecuterKey, deallocExecuter, OBJC_ASSOCIATION_RETAIN);
  } else if(deallocBlock == nil) {
    deallocExecuter.deallocBlock = nil;
    objc_setAssociatedObject(self, &ETHInternalDeallocExecuterKey, nil, OBJC_ASSOCIATION_ASSIGN);
  }
}

@end
