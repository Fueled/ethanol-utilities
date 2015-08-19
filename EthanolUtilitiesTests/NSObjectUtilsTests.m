//
//  NSObjectUtilsTests.m
//  EthanolUtilities
//
//  Created by Stephane Copin on 8/19/15.
//  Copyright © 2015 Stephane Copin. All rights reserved.
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
