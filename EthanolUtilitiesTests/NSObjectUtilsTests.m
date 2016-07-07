//
//  NSObjectUtilsTests.m
//  EthanolUtilities
//
//  Created by Stephane Copin on 8/19/15.
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
#import "NSObject+EthanolExecuteOnDealloc.h"
#import "NSObject+EthanolSwizzling.h"

@protocol SwizzlingTestOptional

@optional
+ (NSInteger)testClassMethod;

@end

@interface SwizzlingTestClass : NSObject <SwizzlingTestOptional>

- (NSInteger)testMethod;

@end

@implementation SwizzlingTestClass

- (NSInteger)testMethod {
  return 123;
}

@end

@interface SwizzlingTestClass (SwizzlingInAction)

- (NSInteger)swizzle_testMethod;
+ (NSInteger)swizzle_testClassMethod;

@end

@implementation SwizzlingTestClass (SwizzlingInAction)

- (NSInteger)swizzle_testMethod {
  return 321 + [self swizzle_testMethod];
}

+ (NSInteger)swizzle_testClassMethod {
  return 654;
}

@end

@interface NSObjectUtilsTests : XCTestCase

@end

@implementation NSObjectUtilsTests

- (void)testExecuteOnDealloc {
  XCTestExpectation * expectation = [self expectationWithDescription:@"Testing Execute On Dealloc method"];
  {
    NSObject * object = [[NSObject alloc] init];
    [object eth_performBlockOnDealloc:^(id object) {
      [expectation fulfill];
    }];
  }
  [self waitForExpectationsWithTimeout:0.0 handler:nil];
}

- (void)testExecuteOnDeallocNilBlock {
  XCTestExpectation * expectation = [self expectationWithDescription:@"Testing Execute On Dealloc method"];
  {
    NSObject * object = [[NSObject alloc] init];
    [object eth_performBlockOnDealloc:^(id object) {
      XCTFail();
    }];
    [object eth_performBlockOnDealloc:nil];
  }
  dispatch_async(dispatch_get_main_queue(), ^{
    [expectation fulfill];
  });
  [self waitForExpectationsWithTimeout:0.1 handler:nil];
}

- (void)testExecuteOnDeallocNewBlock {
  XCTestExpectation * expectation = [self expectationWithDescription:@"Testing Execute On Dealloc method"];
  {
    NSObject * object = [[NSObject alloc] init];
    [object eth_performBlockOnDealloc:^(id object) {
      XCTFail();
    }];
    [object eth_performBlockOnDealloc:^(id object) {
      XCTAssertTrue(YES);
    }];
  }
  dispatch_async(dispatch_get_main_queue(), ^{
    [expectation fulfill];
  });
  [self waitForExpectationsWithTimeout:0.1 handler:nil];
}

- (void)testMethodSwizzling {
  XCTAssertEqual([[[SwizzlingTestClass alloc] init] testMethod], 123);
  
  [[SwizzlingTestClass class] eth_swizzleSelector:@selector(testMethod) withSelector:@selector(swizzle_testMethod)];
  
  XCTAssertEqual([[[SwizzlingTestClass alloc] init] testMethod], 444);
  
  [[SwizzlingTestClass class] eth_swizzleSelector:@selector(swizzle_testMethod) withSelector:@selector(testMethod)];
  
  XCTAssertEqual([[[SwizzlingTestClass alloc] init] testMethod], 123);
}

- (void)testClassMethodSwizzling {
  XCTAssertThrows([SwizzlingTestClass testClassMethod]);
  
  [[SwizzlingTestClass class] eth_swizzleClassSelector:@selector(testClassMethod) withSelector:@selector(swizzle_testClassMethod)];
  
  XCTAssertEqual([SwizzlingTestClass testClassMethod], 654);
  
  [[SwizzlingTestClass class] eth_swizzleClassSelector:@selector(swizzle_testClassMethod) withSelector:@selector(testClassMethod)];
  
  XCTAssertEqual([SwizzlingTestClass testClassMethod], 654);
}

@end
