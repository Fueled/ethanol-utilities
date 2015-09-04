//
//  BoundingSizeTests.m
//  EthanolUtilities
//
//  Created by Stephane Copin on 9/4/15.
//  Copyright © 2015 Stephane Copin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+BoundingSize.h"

@interface BoundingSizeTests : XCTestCase

@end

@implementation BoundingSizeTests

- (void)testStringBoundingSize {
	UIFont * font = [UIFont systemFontOfSize:456];
	CGRect normalizedFontLineHeight = CGRectIntegral(CGRectMake(0.0, 0.0, 0.0, font.lineHeight));
	CGSize size = [@"test" eth_boundingSizeWithFont:font];
	CGRect normalizedRect = CGRectIntegral(CGRectMake(0.0, 0.0, size.width, size.height));
	XCTAssertEqual(CGRectGetHeight(normalizedRect), CGRectGetHeight(normalizedFontLineHeight));
}

@end
