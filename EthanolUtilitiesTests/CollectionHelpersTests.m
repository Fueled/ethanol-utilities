//
//  CollectionHelpersTests.m
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
