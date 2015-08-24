//
//  CollectionHelpersTests.m
//  EthanolUtilities
//
//  Created by Stephane Copin on 8/19/15.
//  Copyright © 2015 Stephane Copin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSArray+Ethanol.h"
#import "NSSet+Ethanol.h"
#import "NSDictionary+Ethanol.h"

@interface CollectionHelpersTests : XCTestCase

@end

@implementation CollectionHelpersTests

- (void)testSet {
  XCTAssertEqualObjects((ETHARRAY(@1, nil, @"super", nil, @2)), (@[@1, @"super", @2]));
}

- (void)testArray {
  XCTAssertEqualObjects((ETHSET(@1, nil, @"super", nil, @2)), ([NSSet setWithArray:@[@1, @"super", @2]]));
}

- (void)testDictionary {
  XCTAssertEqualObjects((ETHDICT(@"1", @1, @"2", nil, @"3", @"super", @"4", nil, @"5", @2)), (@{@"1": @1, @"3": @"super", @"5": @2}));
}

@end
