//
//  SwiftTests.swift
//  EthanolUtilities
//
//  Created by Stephane Copin on 8/19/15.
//  Copyright © 2015 Stephane Copin. All rights reserved.
//

import XCTest
import EthanolUtilities

infix operator ~= { precedence 60 }
infix operator +- { precedence 70 }

class SwiftTests: XCTestCase {
	func testFindInSequenceFound() {
		let array = [1, 2, 3, 42, 6, 7]
		
		XCTAssertEqual(array.find({ $0 == 42 }), 3)
	}
	
	func testFindInSequenceNotFound() {
		let array = [10, 11, 12, 13, 14, 15]
		
		XCTAssertEqual(array.find({ $0 == 0 }), nil)
	}
	
	func testKeepRane() {
		let array = [1, 2, 3, 4, 5, 6, 7]
		
		XCTAssertEqual(array.keepRange(3...4), [4, 5])
	}
	
	func testDelay() {
		let expectation = self.expectationWithDescription("Testing Delay function")
		
		delay(0.5) {
			expectation.fulfill()
		}
		
		self.waitForExpectationsWithTimeout(0.6, handler: nil)
	}
	
	func testCompareWithDeltaEqualFunction() {
		XCTAssertTrue(compareWithDelta(5.09, compareTo: 5.0, delta: 0.1))
	}
	
	func testCompareWithDeltaNotEqualFunction() {
		XCTAssertFalse(compareWithDelta(5.11, compareTo: 5.0, delta: 0.1))
	}
	
	func testCompareWithDeltaEqualOperator() {
		XCTAssertTrue(5.01 ~= 5.0 +- 0.1)
	}
	
	func testCompareWithDeltaNotEqualOperator() {
		XCTAssertFalse(5.11 ~= 5.0 +- 0.1)
	}
}
