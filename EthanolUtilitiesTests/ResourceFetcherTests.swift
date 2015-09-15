//
//  ResourceFetcherTests.swift
//  EthanolUtilities
//
//  Created by hhs-fueled on 15/09/15.
//  Copyright © 2015 Stephane Copin. All rights reserved.
//

import XCTest
@testable import EthanolUtilities

class ResourceFetcherTests: XCTestCase {

	func testFetchingInitialPage() {
		let readyExpectation = expectationWithDescription("ready")
		let pageLimit = 5
		let customFetcher = TestResourceFetcher(pageLimit: pageLimit)
		customFetcher.startFetchingProducts { (inner) -> Void in
			do {

				let result = try inner()
				let allObjectsCount = (result.resourceFetcher?.allObjects.count) ?? 0

				if result.hasMoreDataToLoad {
					XCTAssert(allObjectsCount == pageLimit)
				} else {
					XCTAssert(allObjectsCount < pageLimit)
				}

				readyExpectation.fulfill()
			} catch {
				print("Error : \(error)")
			}
		}

		waitForExpectationsWithTimeout(customFetcher.delayTime) { (error) -> Void in
			XCTAssertNil(error, "Error")
		}
	}

	func testFetchingLastPage() {
		let readyExpectation = expectationWithDescription("ready")
		let pageLimit = 5
		let customFetcher = TestResourceFetcher(pageLimit: pageLimit)
		customFetcher.lastPageNumer = 2
		customFetcher.startFetchingProducts { (inner) -> Void in
			do {

				let result = try inner()
				XCTAssert(result.hasMoreDataToLoad)
				customFetcher.fetchNextPage { (inner) -> Void in
					do {
						let result = try inner()
						let allObjectsCount = (result.resourceFetcher?.allObjects.count) ?? 0
						XCTAssert(result.hasMoreDataToLoad == false)
						XCTAssert(allObjectsCount < (pageLimit * customFetcher.lastPageNumer))
						readyExpectation.fulfill()
					} catch {
						print("error occurred.")
					}
				}
			} catch {
				print("Error : \(error)")
			}

		}
		waitForExpectationsWithTimeout(customFetcher.delayTime * Double(customFetcher.lastPageNumer+1)) { (error) -> Void in
			XCTAssertNil(error, "Error")
		}

	}

	func testFetchingPageError() {
		let readyExpectation = expectationWithDescription("ready")
		let pageLimit = 5
		let customFetcher = TestResourceFetcher(pageLimit: pageLimit)
		customFetcher.successChance = 0
		customFetcher.startFetchingProducts { (inner) -> Void in
			do {
				let _ = try inner()
			} catch {
				print("Error : \(error)")
				XCTAssertNotNil(error as NSError)
				readyExpectation.fulfill()
			}
		}
		waitForExpectationsWithTimeout(customFetcher.delayTime * Double(customFetcher.lastPageNumer+1)) { (error) -> Void in
			XCTAssertNil(error, "Error")
		}
	}

}
