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
	
	func testCompareWithDeltaEqualNaN1Function() {
		XCTAssertFalse(compareWithDelta(Double.NaN, compareTo: 5.0, delta: 0.1))
	}
	
	func testCompareWithDeltaEqualNaN2Function() {
		XCTAssertFalse(compareWithDelta(5.09, compareTo: Double.NaN, delta: 0.1))
	}
	
	func testCompareWithDeltaEqualNaN3Function() {
		XCTAssertFalse(compareWithDelta(5.09, compareTo: 5.0, delta: Double.NaN))
	}
	
	func testCompareWithDeltaEqualNaN4Function() {
		XCTAssertFalse(compareWithDelta(5.09, compareTo: Double.NaN, delta: Double.NaN))
	}
	
	func testCompareWithDeltaEqualNaN5Function() {
		XCTAssertFalse(compareWithDelta(Double.NaN, compareTo: 5.0, delta: Double.NaN))
	}
	
	func testCompareWithDeltaEqualNaN6Function() {
		XCTAssertFalse(compareWithDelta(Double.NaN, compareTo: Double.NaN, delta: 0.1))
	}
	
	func testCompareWithDeltaEqualNaN7Function() {
		XCTAssertFalse(compareWithDelta(Double.NaN, compareTo: Double.NaN, delta: Double.NaN))
	}
	
	func testCompareWithDeltaEqualInfinity1Function() {
		XCTAssertFalse(compareWithDelta(Double.infinity, compareTo: 5.0, delta: 0.1))
	}
	
	func testCompareWithDeltaEqualInfinity2Function() {
		XCTAssertFalse(compareWithDelta(5.09, compareTo: Double.infinity, delta: 0.1))
	}
	
	func testCompareWithDeltaEqualInfinity3Function() {
		XCTAssertTrue(compareWithDelta(5.09, compareTo: 5.0, delta: Double.infinity))
	}
	
	func testCompareWithDeltaEqualInfinity4Function() {
		XCTAssertTrue(compareWithDelta(5.09, compareTo: Double.infinity, delta: Double.infinity))
	}
	
	func testCompareWithDeltaEqualInfinity5Function() {
		XCTAssertFalse(compareWithDelta(Double.infinity, compareTo: 5.0, delta: Double.infinity))
	}
	
	func testCompareWithDeltaEqualInfinity6Function() {
		XCTAssertTrue(compareWithDelta(Double.infinity, compareTo: Double.infinity, delta: 0.1))
	}
	
	func testCompareWithDeltaEqualInfinity7Function() {
		XCTAssertFalse(compareWithDelta(Double.infinity, compareTo: Double.infinity, delta: Double.infinity))
	}
	
	func testCompareWithDeltaEqualInfinity8Function() {
		XCTAssertFalse(compareWithDelta(Double.infinity, compareTo: -Double.infinity, delta: 0.1))
	}
	
	func testCompareWithDeltaEqualInfinity9Function() {
		XCTAssertFalse(compareWithDelta(-Double.infinity, compareTo: Double.infinity, delta: 0.1))
	}
	
	func testCompareWithDeltaEqualOperator() {
		XCTAssertTrue(5.01 ~= 5.0 +- 0.1)
	}
	
	func testCompareWithDeltaNotEqualOperator() {
		XCTAssertFalse(5.11 ~= 5.0 +- 0.1)
	}
}
