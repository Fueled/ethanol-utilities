//
//  SwiftTests.swift
//  EthanolUtilities
//
//  Created by Stephane Copin on 8/19/15.
//  Copyright © 2015 Stephane Copin. All rights reserved.
//

import XCTest
import EthanolUtilities

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
}
