//
//  NSString+EthanolUtils.m
//  EthanolUtilities
//
//  Created by Stephane Copin on 3/21/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import "NSString+EthanolUtils.h"

@implementation NSString (EthanolUtils)

- (BOOL)eth_containsSubstring:(NSString *)substring {
  NSRange range = [self rangeOfString:substring];
  return range.location != NSNotFound;
}

- (NSString *)eth_stringByRemovingCharacters:(NSCharacterSet *)charactersToRemove {
  NSInteger temp;
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
