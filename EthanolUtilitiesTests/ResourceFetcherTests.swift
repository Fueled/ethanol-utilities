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
	static let webURLTimoutDuration: NSTimeInterval = 15.0

	func testFetchingInitialPage() {
		let initialPageExpectation = expectationWithDescription("Completed Fetching Initial Page")
		let pageLimit = 5
		let customFetcher = TestResourceFetcher(pageLimit: pageLimit)
		customFetcher.successChance = 100
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

	func testFetchingLastPage() {
		let pageLimit = 5
		let customFetcher = TestResourceFetcher(pageLimit: pageLimit)

		customFetcher.successChance = 100
		customFetcher.lastPageNumer = 2

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
						XCTAssertFalse(result.hasMoreDataToLoad, "Cannot have more data to load!")
						XCTAssertLessThan(allObjectsCount, (pageLimit * customFetcher.lastPageNumer), "Cannot have more objects than the limit")
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

	func testFetchingInAdvance() {

		let pageLimit = 5
		let customFetcher = TestResourceFetcher(pageLimit: pageLimit)
		customFetcher.lastPageNumer = 5
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
						XCTAssertLessThan(allObjectsCount, pageLimit * customFetcher.lastPageNumer, "All Objects Not equal to all possible fetched objects!")

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

	func testFetchingPageError() {

		let errorExpectation = expectationWithDescription("Error")

		let pageLimit = 5
		let customFetcher = TestResourceFetcher(pageLimit: pageLimit)
		customFetcher.successChance = 0

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

}
