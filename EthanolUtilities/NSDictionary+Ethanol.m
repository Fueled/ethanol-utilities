//
//  NSDictionary+Ethanol.m
//  EthanolUtilities
//
//  Created by Stephane Copin on 9/2/14.
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
