//
//  NSString+EthanolSecurity.h
//  Ethanol
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

@interface NSString (EthanolSecurity)

/**
 Returns an MD2 hash of the given string, using UTF8 encoding.
 @return The MD2 hash string
 */
- (NSString *)eth_MD2;
/**
 Returns an MD4 hash of the given string, using UTF8 encoding.
 @return The MD4 hash string
 */
- (NSString *)eth_MD4;
/**
 Returns an MD5 hash of the given string, using UTF8 encoding.
 @return The MD5 hash string
 */
- (NSString *)eth_MD5;
/**
 Returns an SHA-1 hash of the given string, using UTF8 encoding.
 @return The SHA-1 hash string
 */
- (NSString *)eth_SHA1;
/**
 Returns an SHA-256 hash of the given string, using UTF8 encoding.
 @return The SHA-256 hash string
 */
- (NSString *)eth_SHA256;
/**
 Returns an SHA-256 hash of the given string, using UTF8 encoding.
 @return The SHA-256 hash string
 */
- (NSString *)eth_SHA384;
/**
 Returns an SHA-512 hash of the given string, using UTF8 encoding.
 @return The SHA-512 hash string
 */
- (NSString *)eth_SHA512;

@end
