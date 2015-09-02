//
//  NSData+EthanolSecurity.m
//  Ethanol
//
//  Created by Stephane Copin on 4/14/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "NSData+EthanolSecurity.h"

@implementation NSData (EthanolSecurity)

#define IMPLEMENT_CRYPTO_METHOD(name) \
  - (NSString *)eth_ ## name { \
    unsigned char output[CC_ ## name ## _DIGEST_LENGTH]; \
    CC_ ## name([self bytes], (CC_LONG)[self length], output); \
    return [self toHexString:output length:CC_ ## name ##_DIGEST_LENGTH]; \
  } 

IMPLEMENT_CRYPTO_METHOD(MD2)
IMPLEMENT_CRYPTO_METHOD(MD4)
IMPLEMENT_CRYPTO_METHOD(MD5)
IMPLEMENT_CRYPTO_METHOD(SHA1)
IMPLEMENT_CRYPTO_METHOD(SHA256)
IMPLEMENT_CRYPTO_METHOD(SHA384)
IMPLEMENT_CRYPTO_METHOD(SHA512)

- (NSString *)toHexString:(unsigned char *)data length:(unsigned int)length {
  NSMutableString *hash = [NSMutableString stringWithCapacity:length * 2];
  for (unsigned int i = 0; i < length; i++) {
    [hash appendFormat:@"%02x", data[i]];
    data[i] = 0;
  }
  return hash;
}

@end
