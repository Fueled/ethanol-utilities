//
//  NSString+EthanolUtils.h
//  EthanolUtilities
//
//  Created by Stephane Copin on 3/21/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (EthanolUtils)

/**
 Returns YES if the string contains the given substring, otherwise returns NO.
 @param substring The substring to check for
 @return A BOOL describing whether or not the string contains the substring.
 */
- (BOOL)eth_containsSubstring:(NSString *)eth_substring;

/**
 *  Create a new string which doesn't contain the specified character in the character set.
 *  @param charactersToRemove The characters to remove
 *  @return A new string without the characters in charactersToRemove.
 *  @note This will call [-stringByRemovingCharacters:preserveCursor:] with a temporary cursor.
 */
- (NSString *)eth_stringByRemovingCharacters:(NSCharacterSet *)eth_charactersToRemove;

/**
 *  Create a new string which doesn't contain the specified character in the character set.
 *  @param charactersToRemove The characters to remove
 *  @param index              A pointer to a cursor whose position should be preserved.
 *  @return A new string without the characters in charactersToRemove.
 *  @note Passing a nil character set to this method will simply call [- copy] on the original string.
 *        [- copy] will also be called if no characters were removed.
 */
- (NSString *)eth_stringByRemovingCharacters:(NSCharacterSet *)eth_charactersToRemove preserveCursor:(NSInteger *)eth_cursor;

@end
