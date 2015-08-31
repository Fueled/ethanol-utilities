//
//  NSString+EthanolSecurity.m
//  Ethanol
//
//  Created by Stephane Copin on 3/21/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import <CommonCrypto/CommonCrypto.h>
#import "NSData+EthanolSecurity.h"
#import "NSString+EthanolSecurity.h"

@implementation NSString (EthanolSecurity)

#define IMPLEMENT_DEPRECATED_SECURITY_METHOD(name) \
  - (NSString *)name { \
    return [self eth_ ## name]; \
  }

#define IMPLEMENT_SECURITY_METHOD(name) \
  - (NSString *)eth_ ## name { \
    return [[self dataUsingEncoding:NSUTF8StringEncoding] eth_ ## name]; \
  } \
  IMPLEMENT_DEPRECATED_SECURITY_METHOD(name)

IMPLEMENT_SECURITY_METHOD(MD2)
IMPLEMENT_SECURITY_METHOD(MD4)
IMPLEMENT_SECURITY_METHOD(MD5)
IMPLEMENT_SECURITY_METHOD(SHA1)
IMPLEMENT_SECURITY_METHOD(SHA256)
IMPLEMENT_SECURITY_METHOD(SHA384)
IMPLEMENT_SECURITY_METHOD(SHA512)

@end
