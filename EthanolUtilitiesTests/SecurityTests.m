//
//  SecurityTests.m
//  EthanolUtilities
//
//  Created by Stephane Copin on 9/4/15.
//  Copyright © 2015 Stephane Copin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+EthanolSecurity.h"

@interface SecurityTests : XCTestCase

@end

@implementation SecurityTests

#define TEST_STRING @"securitytest"

#define GENERATE_SECURITY_TEST(hashMethod, expectedHash) \
  - (void)test ## hashMethod ## Hash { \
  	XCTAssertEqualObjects([TEST_STRING eth_ ## hashMethod], expectedHash); \
  }

GENERATE_SECURITY_TEST(MD2, @"7cd7ff73db32821724450390bfecfd0e")
GENERATE_SECURITY_TEST(MD4, @"8f052f5c6f9f23753f7592466584484d")
GENERATE_SECURITY_TEST(MD5, @"32e348374d1ef0187ae067a92273df62")
GENERATE_SECURITY_TEST(SHA1, @"c951da49d871d09f5220c2f739ac695ecf0ad45c")
GENERATE_SECURITY_TEST(SHA256, @"48c8a6f104f1b6628b7096a30e80ad190975456c39ed752936cafa92cf788359")
GENERATE_SECURITY_TEST(SHA384, @"63b6d57995daa252507b39e047661be051c590a7d5bf5bf9f39b067df3fc662f2dfd1095cc12ab5fc4a9e14676317336")
GENERATE_SECURITY_TEST(SHA512, @"66656c2647123ef0c2c1ab2fca6b6ec2e1751d1018bfdd3ec0439acffae387e4846658e0b761b7de2f3aa920b1c7c8c759d75dad4bfe00ec557d359d33c6ca06")

@end
