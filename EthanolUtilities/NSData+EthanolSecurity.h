//
//  NSData+EthanolSecurity.h
//  Ethanol
//
//  Created by Stephane Copin on 4/14/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (EthanolSecurity)

/**
 Returns an MD2 hash of the given data.
 @return The MD2 hash string
 */
- (NSString *)eth_MD2;
/**
 Returns an MD4 hash of the given data.
 @return The MD4 hash string
 */
- (NSString *)eth_MD4;
/**
 Returns an MD5 hash of the given data.
 @return The MD5 hash string
 */
- (NSString *)eth_MD5;
/**
 Returns an SHA-1 hash of the given data.
 @return The SHA-1 hash string
 */
- (NSString *)eth_SHA1;
/**
 Returns an SHA-256 hash of the given data.
 @return The SHA-256 hash string
 */
- (NSString *)eth_SHA256;
/**
 Returns an SHA-256 hash of the given data.
 @return The SHA-256 hash string
 */
- (NSString *)eth_SHA384;
/**
 Returns an SHA-512 hash of the given data.
 @return The SHA-512 hash string
 */
- (NSString *)eth_SHA512;

@end
