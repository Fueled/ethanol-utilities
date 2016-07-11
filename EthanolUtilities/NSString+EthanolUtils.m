//
//  NSString+EthanolUtils.m
//  EthanolUtilities
//
//  Created by Stephane Copin on 3/21/14.
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

#import "NSString+EthanolUtils.h"

@implementation NSString (EthanolUtils)

- (BOOL)eth_containsSubstring:(NSString *)substring {
  NSRange range = [self rangeOfString:substring];
  return range.location != NSNotFound;
}

- (NSString *)eth_stringByRemovingCharacters:(NSCharacterSet *)charactersToRemove {
  NSInteger temp = 0;
  return [self eth_stringByRemovingCharacters:charactersToRemove preserveCursor:&temp];
}

- (NSString *)eth_stringByRemovingCharacters:(NSCharacterSet *)charactersToRemove preserveCursor:(NSInteger *)cursor {
  if(charactersToRemove == nil) {
    return [self copy];
  }
  
  NSCharacterSet * charactersToKeep = [charactersToRemove invertedSet];
  NSUInteger length = [self length];
  unichar characters[length];
  unichar allowedCharacters[length];
  [self getCharacters:characters range:NSMakeRange(0, length)];
  NSUInteger j = 0;
  NSInteger originalCursor = *cursor;
  for(NSUInteger i = 0;i < length;++i) {
    if([charactersToKeep characterIsMember:characters[i]]) {
      allowedCharacters[j++] = characters[i];
    } else if(i < originalCursor) {
      --*cursor;
    }
  }
  
  if(length != j) {
    return [NSString stringWithCharacters:allowedCharacters length:j];
  }
  
  return [self copy];
}

@end
