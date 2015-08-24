//
//  NSStringUtilsTests.m
//  EthanolUtilities
//
//  Created by Stephane Copin on 8/19/15.
//  Copyright © 2015 Stephane Copin. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NSString+EthanolUtils.h"

@interface NSStringUtilsTests : XCTestCase

@end

@implementation NSStringUtilsTests

- (void)testRemovingCharacters {
  XCTAssertEqualObjects([@"abcdef" eth_stringByRemovingCharacters:[NSCharacterSet characterSetWithCharactersInString:@"ace"]], @"bdf");
}

- (void)testRemovingCharactersWithCursor {
  NSInteger cursor = 3;
  NSString * result = [@"abcdef" eth_stringByRemovingCharacters:[NSCharacterSet characterSetWithCharactersInString:@"ace"] preserveCursor:&cursor];
  XCTAssertEqualObjects(result, @"bdf");
  XCTAssertTrue(cursor == 1);
}

- (void)testRemovingCharactersNoCharacterSetProvided {
  NSString * test = @"foobar";
  XCTAssertEqualObjects([test eth_stringByRemovingCharacters:nil], test);
}

- (void)testRemovingCharactersNoCharactersRemoved {
  NSString * test = @"foobar";
  XCTAssertEqualObjects([test eth_stringByRemovingCharacters:[NSCharacterSet illegalCharacterSet]], test);
}

- (void)testStringContainsSubstring {
  XCTAssertTrue([@"abcde" eth_containsSubstring:@"bcd"]);
}

@end
