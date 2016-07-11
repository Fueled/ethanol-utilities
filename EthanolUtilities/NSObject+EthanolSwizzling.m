//
//  NSObject+EthanolSwizzling.m
//  EthanolUtilities
//
//  Created by Stephane Copin on 1/9/15.
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
