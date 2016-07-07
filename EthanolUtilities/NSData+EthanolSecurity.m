//
//  NSData+EthanolSecurity.m
//  Ethanol
//
//  Created by Stephane Copin on 4/14/14.
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
