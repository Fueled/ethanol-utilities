//
//  SecurityTests.m
//  EthanolUtilities
//
//  Created by Stephane Copin on 9/4/15.
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
