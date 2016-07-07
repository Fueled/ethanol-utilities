//
//  NSString+EthanolUtils.h
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
