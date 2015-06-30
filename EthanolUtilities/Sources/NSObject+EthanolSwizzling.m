//
//  NSObject+EthanolSwizzling.m
//  EthanolUtilities
//
//  Created by Stephane Copin on 1/9/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

#import "NSObject+EthanolSwizzling.h"
#import <objc/runtime.h>

NS_ROOT_CLASS
@interface EthanolSwizzleLogHelper

@end

@implementation EthanolSwizzleLogHelper

+ (void)swizzleSelectorInClass:(Class)class :(SEL)originalSelector :(SEL)swizzledSelector {
  Method originalMethod = class_getInstanceMethod(class, originalSelector);
  Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
  
  BOOL didAddMethod = class_addMethod(class,
                                      originalSelector,
                                      method_getImplementation(swizzledMethod),
                                      method_getTypeEncoding(swizzledMethod));
  
  if (didAddMethod) {
    class_replaceMethod(class,
                        swizzledSelector,
                        method_getImplementation(originalMethod),
                        method_getTypeEncoding(originalMethod));
  } else {
    method_exchangeImplementations(originalMethod, swizzledMethod);
  }
}

@end

void eth_swizzleSelectorInClass(Class class, SEL originalSelector, SEL swizzledSelector) {
  [EthanolSwizzleLogHelper swizzleSelectorInClass:class :originalSelector :swizzledSelector];
}

@implementation NSObject (EthanolSwizzling)

+ (void)eth_swizzleSelector:(SEL)originalSelector withSelector:(SEL)swizzledSelector {
  eth_swizzleSelectorInClass([self class], originalSelector, swizzledSelector);
}

+ (void)eth_swizzleClassSelector:(SEL)originalSelector withSelector:(SEL)swizzledSelector {
  eth_swizzleSelectorInClass(object_getClass([self class]), originalSelector, swizzledSelector);
}

@end
