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

	static let webURLTimoutDuration: NSTimeInterval = 25.0
	let pageLimit = 5


	func fetchingInitialPage(customFetcher: ResourceFetcher, pageLimit: Int) {
		let initialPageExpectation = expectationWithDescription("Completed Fetching Initial Page")
		customFetcher.startFetchingProducts { (inner) -> Void in
			do {

				let result = try inner()
				let allObjectsCount = (result.resourceFetcher?.allObjects.count) ?? 0

				if result.hasMoreDataToLoad {
					XCTAssert(allObjectsCount == pageLimit)
				} else {
					XCTAssert(allObjectsCount < pageLimit)
				}

				initialPageExpectation.fulfill()
			} catch {
				print("Error : \(error)")
			}
		}

		waitForExpectationsWithTimeout(ResourceFetcherTests.webURLTimoutDuration) { (error) -> Void in
			XCTAssertNil(error, "Error")
		}
	}

	func fetchingLastPage(customFetcher: ResourceFetcher, pageLimit: Int, lastPageNumber: Int) {
		let lastPageExpectation = expectationWithDescription("Completed Fetching Final Page")

		customFetcher.startFetchingProducts { (inner) -> Void in
			do {

				let result = try inner()
				XCTAssert(result.hasMoreDataToLoad)

				customFetcher.fetchNextPage { (inner) -> Void in
					do {
						let result = try inner()
						let allObjectsCount = customFetcher.allObjects.count
						XCTAssertNotNil(result.resourceFetcher, "Resource Fetcher should not be nil!")
						if customFetcher.isKindOfClass(TestResourceFetcher) {
							XCTAssertFalse(result.hasMoreDataToLoad, "Cannot have more data to load!")
						}
						XCTAssertLessThan(allObjectsCount, (pageLimit * lastPageNumber), "Cannot have more objects than the limit")
						lastPageExpectation.fulfill()
					} catch {
						print("error occurred.")
					}
				}
			} catch {
				print("Error : \(error)")
			}

		}

		waitForExpectationsWithTimeout(ResourceFetcherTests.webURLTimoutDuration) { (error) -> Void in
			XCTAssertNil(error, "Error")
		}
	}

	func fetchingInAdvance(customFetcher: ResourceFetcher, lastPageNumber: Int) {

		let pageLimit = 5
		let customFetcher = TestResourceFetcher(pageLimit: pageLimit)
		customFetcher.lastPageNumber = lastPageNumber
		customFetcher.delayTime = 1

		let thirdPageExpectation = expectationWithDescription("Completed Fetching Third Page")

		customFetcher.startFetchingProducts { (inner) -> Void in // First Page
			do {

				let result = try inner()

				XCTAssert(result.hasMoreDataToLoad, "No More data to load!")
				XCTAssertNotNil(result.resourceFetcher, "No Resource Fetcher!")
				XCTAssertEqual(result.objects.count, pageLimit, "Objects Not Equal to Page Limit!")

				customFetcher.fetchNextPage { (inner) -> Void in // Second Page
					do {
						let result = try inner()
						let allObjectsCount = customFetcher.allObjects.count

						XCTAssertEqual(result.objects.count, pageLimit, "Objects Not Equal to Page Limit!")
						XCTAssertLessThan(allObjectsCount, pageLimit * customFetcher.lastPageNumber, "All Objects Not equal to all possible fetched objects!")

						delay(5.0, closure: { () -> () in // Third Page in Background

							let currentAllObjects = customFetcher.allObjects.count
							let currentAdvancedObjectsCount = customFetcher.advanceLoadedObjects?.count ?? 0

							customFetcher.fetchNextPage({ (inner) -> Void in // Fourth Page
								do{
									let (_, objects, _) = try inner()
									let newAllObjectsCount = customFetcher.allObjects.count
									let newAdvancedLoadedObjects = customFetcher.advanceLoadedObjects

									XCTAssertEqual(newAllObjectsCount, (currentAllObjects + currentAdvancedObjectsCount), "Current Advanced L")
									XCTAssertEqual(objects.count, currentAdvancedObjectsCount, "Current Advanced L")
									XCTAssertNil(newAdvancedLoadedObjects, "New Objects found immediately after Loading a Page?!")

									thirdPageExpectation.fulfill()
								}
								catch {
									print(error)
									XCTAssertNotNil(error as NSError)
								}
							})
						})
					} catch {
						print("error occurred.")
						XCTAssertNotNil(error as NSError)
					}
				}
			} catch {
				print("Error : \(error)")
				XCTAssertNotNil(error as NSError)
			}

		}

		waitForExpectationsWithTimeout(ResourceFetcherTests.webURLTimoutDuration) { (error) -> Void in
			XCTAssertNil(error, "Error")
		}
	}

	func fetchingPageError(customFetcher: ResourceFetcher) {

		let errorExpectation = expectationWithDescription("Error")
		customFetcher.startFetchingProducts { (inner) -> Void in
			do {
				let _ = try inner()
			} catch {
				print("Error : \(error)")
				XCTAssertNotNil(error as NSError)
				errorExpectation.fulfill()
			}
		}
		waitForExpectationsWithTimeout(ResourceFetcherTests.webURLTimoutDuration) { (error) -> Void in
			XCTAssertNil(error, "Error")
		}
	}


	//MARK: Tests for Resource Fetcher

	func testFetchingInitialPageForTestResourceFetcher() {
		let customFetcher = TestResourceFetcher(pageLimit: pageLimit)
		customFetcher.successChance = 100
		fetchingInitialPage(customFetcher, pageLimit: pageLimit)
	}

	func testFetchingLastPageForTestResourceFetcher() {
		let customFetcher = TestResourceFetcher(pageLimit: pageLimit)
		customFetcher.successChance = 100
		customFetcher.lastPageNumber = 2
		fetchingLastPage(customFetcher, pageLimit: pageLimit, lastPageNumber: customFetcher.lastPageNumber)
	}

	func testFetchingInAdvanceForTestResourceFetcher() {
		let lastPageNumber = 5
		let customFetcher = TestResourceFetcher(pageLimit: pageLimit)
		customFetcher.lastPageNumber = lastPageNumber
		customFetcher.delayTime = 1
		fetchingInAdvance(customFetcher, lastPageNumber: lastPageNumber)
	}

	func testFetchingPageErrorForTestResourceFetcher() {
		let customFetcher = TestResourceFetcher(pageLimit: pageLimit)
		customFetcher.successChance = 0
		fetchingPageError(customFetcher)
	}

	//MARK: Tests for CursorBased Resource Fetcher

	func testFetchingInitialPageForTestCursorResourceFetcher() {
		let customFetcher = TestCursorResourceFetcher(pageLimit: pageLimit)
		customFetcher.successChance = 100
		fetchingInitialPage(customFetcher, pageLimit: pageLimit)
	}

	func testFetcherFetchingLastPageForTestCursorResourceFetcher() {
		let customFetcher = TestCursorResourceFetcher(pageLimit: pageLimit)
		customFetcher.successChance = 100
		customFetcher.lastPageURL = "5"
		fetchingLastPage(customFetcher, pageLimit: pageLimit, lastPageNumber: 5)
	}

	func testFetchingInAdvanceForTestCursorResourceFetcher() {
		let customFetcher = TestCursorResourceFetcher(pageLimit: pageLimit)
		customFetcher.lastPageURL = "5"
		customFetcher.delayTime = 1
		fetchingInAdvance(customFetcher, lastPageNumber: 5)
	}

	func testFetchingPageErrorForTestCursorResourceFetcher() {
		let customFetcher = TestCursorResourceFetcher(pageLimit: pageLimit)
		customFetcher.successChance = 0
		fetchingPageError(customFetcher)
	}
	
}
