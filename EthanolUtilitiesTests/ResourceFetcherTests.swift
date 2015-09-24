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

	static let webURLTimoutDuration: NSTimeInterval = 35.0
	let PageLimit = 5


	func fetchingInitialPage(customFetcher: ResourceFetcher) {
		let pageLimit = customFetcher.pageLimit
		let initialPageExpectation = expectationWithDescription("Completed Fetching Initial Page")
		customFetcher.startFetchingProducts { (inner) -> Void in
			do {

				let result = try inner()
				let allObjectsCount = customFetcher.allObjects.count

				if result.hasMoreDataToLoad {
					XCTAssert(allObjectsCount == pageLimit)
				} else {
					XCTAssert(allObjectsCount < pageLimit)
				}

				initialPageExpectation.fulfill()
			} catch {
				print("Error : \(error)")
				print("ErrorDesc : \(error.resourceFetcherError.message)")
				XCTAssertNotNil(error)

				initialPageExpectation.fulfill()
			}
		}

		waitForExpectationsWithTimeout(ResourceFetcherTests.webURLTimoutDuration) { (error) -> Void in
			XCTAssertNil(error, "Error")
		}
	}

	func fetchingLastPage(customFetcher: ResourceFetcher, lastPageNumber: Int) {
		let pageLimit = customFetcher.pageLimit
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
						print("Error : \(error)")
						print("ErrorDesc : \(error.resourceFetcherError.message)")
						lastPageExpectation.fulfill()
					}
				}
			} catch {
				print("Error : \(error)")
				print("ErrorDesc : \(error.resourceFetcherError.message)")
				lastPageExpectation.fulfill()
			}

		}

		waitForExpectationsWithTimeout(ResourceFetcherTests.webURLTimoutDuration) { (error) -> Void in
			XCTAssertNil(error, "Error")
		}
	}

	func fetchingInAdvanceBeforeCompletion(customFetcher: ResourceFetcher, lastPageNumber: Int) {

		let pageLimit = customFetcher.pageLimit

		let secondPageExpectation = expectationWithDescription("Completed Fetching Second Page")

		customFetcher.startFetchingProducts { (inner) -> Void in
			do {
				let _ = try inner()

				let currentAllObjects = customFetcher.allObjects.count
				XCTAssertNotNil(currentAllObjects)

				delay(1, closure: { () -> () in
					customFetcher.fetchNextPage({ (inner) -> Void in
						do {
							let (hasMoreDataToLoad, objects, _) = try inner()
							let newAllObjectsCount = customFetcher.allObjects.count
							let newAdvancedLoadedObjects = customFetcher.advanceLoadedObjects

							XCTAssert(hasMoreDataToLoad ? objects.count == pageLimit : objects.count < pageLimit)

							XCTAssertLessThan(objects.count, pageLimit * lastPageNumber)

							XCTAssertNil(newAdvancedLoadedObjects)
							XCTAssert(newAllObjectsCount > 0)
							XCTAssertLessThanOrEqual(newAllObjectsCount, pageLimit * lastPageNumber)
							secondPageExpectation.fulfill()

						} catch {
							print("Error : \(error)")
							print("ErrorDesc : \(error.resourceFetcherError.message)")
							secondPageExpectation.fulfill()
						}
					})
				})
			} catch {
				print("Error : \(error)")
				print("ErrorDesc : \(error.resourceFetcherError.message)")
				secondPageExpectation.fulfill()
			}
		}


		waitForExpectationsWithTimeout(ResourceFetcherTests.webURLTimoutDuration) { (error) -> Void in
			XCTAssertNil(error)
		}
	}

	func fetchingInAdvanceAfterCompletion(customFetcher: ResourceFetcher, lastPageNumber: Int) {

		let pageLimit = customFetcher.pageLimit

		let thirdPageExpectation = expectationWithDescription("Completed Fetching Third Page")
		customFetcher.startFetchingProducts { (inner) -> Void in // First Page
			do {

				let result = try inner()

				XCTAssert(result.hasMoreDataToLoad, "No More data to load!")
				XCTAssertNotNil(result.resourceFetcher, "No Resource Fetcher!")
				XCTAssertEqual(result.objects.count, pageLimit, "Objects Not Equal to Page Limit!")

				customFetcher.fetchNextPage { (inner) -> Void in // Second Page
					do {
						let (_, objects, _) = try inner()

						XCTAssertEqual(objects.count, pageLimit, "Objects Not Equal to Page Limit!")

						delay(2, closure: { () -> () in // Third Page in Background

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
									print("Error : \(error)")
									print("ErrorDesc : \(error.resourceFetcherError.message)")
									XCTAssertNotNil(error as NSError)
									thirdPageExpectation.fulfill()

								}
							})
						})
					} catch {
						print("Error : \(error)")
						print("ErrorDesc : \(error.resourceFetcherError.message)")
						XCTAssertNotNil(error as NSError)
						thirdPageExpectation.fulfill()
					}
				}
			} catch {
				print("Error : \(error)")
				print("ErrorDesc : \(error.resourceFetcherError.message)")
				XCTAssertNotNil(error as NSError)
				thirdPageExpectation.fulfill()
			}

		}

		waitForExpectationsWithTimeout(ResourceFetcherTests.webURLTimoutDuration) { (error) -> Void in
			XCTAssertNil(error, "Error")
		}
	}

	func fetchingPageError(customFetcher: ResourceFetcher) {

		if let _ = customFetcher as? TestResourceFetcher {
			(customFetcher as! TestResourceFetcher).successChance = 0
		}
		if let _ = customFetcher as? TestCursorResourceFetcher {
			(customFetcher as! TestCursorResourceFetcher).successChance = 0
		}

		let errorExpectation = expectationWithDescription("Error")
		customFetcher.startFetchingProducts { (inner) -> Void in
			do {
				let _ = try inner()
				errorExpectation.fulfill()
			} catch {
				errorExpectation.fulfill()
				print("Error : \(error)")
				print("ErrorDesc : \(error.resourceFetcherError.message)")
				XCTAssertNotNil(error as NSError)
			}
		}
		waitForExpectationsWithTimeout(ResourceFetcherTests.webURLTimoutDuration) { (error) -> Void in
			XCTAssertNil(error, "Error")
		}
	}
	//MARK: Tests for Resource Fetcher

	func testFetchingInitialPageForTestResourceFetcher() {
		let customFetcher = TestResourceFetcher(pageLimit: PageLimit)
		customFetcher.successChance = 100
		fetchingInitialPage(customFetcher)
	}

	func testFetchingInitialPageWhenLoadingForResourceFetcher() {
		let pageLimit = PageLimit

		let customFetcher = TestResourceFetcher(pageLimit: pageLimit)
		customFetcher.successChance = 100
		customFetcher.delayTime = 2

		let initialPageExpectation = expectationWithDescription("Completed Fetching Initial Page")
		let nextPageExpectation = expectationWithDescription("Completed Fetching Next Page")

		customFetcher.startFetchingProducts { (inner) -> Void in
			do {

				let result = try inner()
				let allObjectsCount = customFetcher.allObjects.count

				if result.hasMoreDataToLoad {
					XCTAssert(allObjectsCount == pageLimit)
				} else {
					XCTAssert(allObjectsCount < pageLimit)
				}

				initialPageExpectation.fulfill()
			} catch {
				print("Error : \(error)")
				print("ErrorDesc : \(error.resourceFetcherError.message)")
				XCTAssertNotNil(error)

				initialPageExpectation.fulfill()
			}
		}

		delay(0.5) { () -> () in
			customFetcher.fetchNextPage() { (inner) -> Void in
				do {

					let result = try inner()
					let allObjectsCount = customFetcher.allObjects.count

					if result.hasMoreDataToLoad {
						print("page \(customFetcher.currentPage)")
						XCTAssert(allObjectsCount <= pageLimit * customFetcher.currentPage)
					} else {
						XCTAssert(allObjectsCount < pageLimit * customFetcher.currentPage)
					}

					nextPageExpectation.fulfill()
				} catch {
					print("Error : \(error)")
					print("ErrorDesc : \(error.resourceFetcherError.message)")
					XCTAssertNotNil(error)

					nextPageExpectation.fulfill()
				}
			}
		}
		waitForExpectationsWithTimeout(ResourceFetcherTests.webURLTimoutDuration) { (error) -> Void in
			XCTAssertNil(error, "Error")
		}
	}

	func testFetchingInitialPageWhenFailedForResourceFetcher() {
		let pageLimit = PageLimit
		let customFetcher = TestResourceFetcher(pageLimit: pageLimit)
		customFetcher.successChance = 100
		delay(0.5) { () -> () in
			customFetcher.successChance = 0
		}
		fetchingInitialPage(customFetcher)
	}

	func testFetchingAdvanceAfterInitialPageForResourceFetcher() {
		let pageLimit = PageLimit
		let customFetcher = TestResourceFetcher(pageLimit: pageLimit)
		customFetcher.successChance = 100


		let initialPageExpectation = expectationWithDescription("Completed Fetching Initial Page")
		let nextPageExpectation = expectationWithDescription("Completed Fetching Next Page")

		customFetcher.startFetchingProducts { (inner) -> Void in
			do {

				let result = try inner()
				let allObjectsCount = customFetcher.allObjects.count

				if result.hasMoreDataToLoad {
					XCTAssert(allObjectsCount == pageLimit)
				} else {
					XCTAssert(allObjectsCount < pageLimit)
				}

				initialPageExpectation.fulfill()
			} catch {
				print("Error : \(error)")
				print("ErrorDesc : \(error.resourceFetcherError.message)")
				XCTAssertNotNil(error)

				initialPageExpectation.fulfill()
			}
		}

		delay(3) { () -> () in
			customFetcher.fetchNextPage() { (inner) -> Void in
				do {

					let result = try inner()
					let allObjectsCount = customFetcher.allObjects.count

					if result.hasMoreDataToLoad {
						print("page \(customFetcher.currentPage)")
						XCTAssert(allObjectsCount <= pageLimit * customFetcher.currentPage)
					} else {
						XCTAssert(allObjectsCount < pageLimit * customFetcher.currentPage)
					}

					delay(3) {
						nextPageExpectation.fulfill()
					}
				} catch {
					print("Error : \(error)")
					print("ErrorDesc : \(error.resourceFetcherError.message)")
					XCTAssertNotNil(error)

					delay(3) {
						nextPageExpectation.fulfill()
					}
				}
			}
		}

		waitForExpectationsWithTimeout(ResourceFetcherTests.webURLTimoutDuration) { (error) -> Void in
			XCTAssertNil(error, "Error")
		}

	}


	func testFailureFetchingAdvanceAfterInitialPageForResourceFetcher() {
		let pageLimit = PageLimit
		let customFetcher = TestResourceFetcher(pageLimit: pageLimit)
		customFetcher.successChance = 100

		let initialPageExpectation = expectationWithDescription("Completed Fetching Initial Page")
		let nextPageExpectation = expectationWithDescription("Completed Fetching Next Page")

		customFetcher.startFetchingProducts { (inner) -> Void in
			do {

				let result = try inner()
				let allObjectsCount = customFetcher.allObjects.count

				if result.hasMoreDataToLoad {
					XCTAssert(allObjectsCount == pageLimit)
				} else {
					XCTAssert(allObjectsCount < pageLimit)
				}

				initialPageExpectation.fulfill()
			} catch {
				print("Error : \(error)")
				print("ErrorDesc : \(error.resourceFetcherError.message)")
				XCTAssertNotNil(error)

				initialPageExpectation.fulfill()
			}
		}

		delay(3) { () -> () in
			customFetcher.successChance = 0
			customFetcher.fetchNextPage() { (inner) -> Void in
				do {

					let result = try inner()
					let allObjectsCount = customFetcher.allObjects.count

					if result.hasMoreDataToLoad {
						print("page \(customFetcher.currentPage)")
						XCTAssert(allObjectsCount <= pageLimit * customFetcher.currentPage)
					} else {
						XCTAssert(allObjectsCount < pageLimit * customFetcher.currentPage)
					}

					delay(3) {
						nextPageExpectation.fulfill()
					}
				} catch {
					print("Error : \(error)")
					print("ErrorDesc : \(error.resourceFetcherError.message)")
					XCTAssertNotNil(error)

					delay(3) {
						nextPageExpectation.fulfill()
					}
				}
			}
		}

		waitForExpectationsWithTimeout(ResourceFetcherTests.webURLTimoutDuration) { (error) -> Void in
			XCTAssertNil(error, "Error")
		}
		
	}

	func testFetchingInitialPageFailureForResourceFetcher() {
		let customFetcher = TestResourceFetcher(pageLimit: PageLimit)
		customFetcher.successChance = 0
		fetchingInitialPage(customFetcher)
	}

	func testFetchingLastPageForTestResourceFetcher() {
		let customFetcher = TestResourceFetcher(pageLimit: PageLimit)
		customFetcher.successChance = 100
		customFetcher.lastPageNumber = 2
		fetchingLastPage(customFetcher, lastPageNumber: customFetcher.lastPageNumber)
	}

	func testFetchingInAdvanceForTestResourceFetcher() {
		let lastPageNumber = 4

		let customFetcher = TestResourceFetcher(pageLimit: PageLimit)
		customFetcher.lastPageNumber = lastPageNumber
		customFetcher.delayTime = 1
		fetchingInAdvanceAfterCompletion(customFetcher, lastPageNumber: lastPageNumber)

		let anotherCustomFetcher = TestResourceFetcher(pageLimit: PageLimit)
		anotherCustomFetcher.lastPageNumber = lastPageNumber
		anotherCustomFetcher.delayTime = 2
		fetchingInAdvanceBeforeCompletion(anotherCustomFetcher, lastPageNumber: lastPageNumber)
	}

	func testFetchingPageErrorForTestResourceFetcher() {
		let customFetcher = TestResourceFetcher(pageLimit: PageLimit)
		customFetcher.successChance = 0
		fetchingPageError(customFetcher)
	}
}
	//MARK: Tests for CursorBased Resource Fetcher
class ResourceFetcherCursorBasedTests: ResourceFetcherTests {

	func testFetchingInitialPageForTestCursorResourceFetcher() {
		let customFetcher = TestCursorResourceFetcher(pageLimit: PageLimit)
		customFetcher.successChance = 100
		fetchingInitialPage(customFetcher)
	}

	func testFetcherFetchingLastPageForTestCursorResourceFetcher() {
		let customFetcher = TestCursorResourceFetcher(pageLimit: PageLimit)
		customFetcher.successChance = 100
		customFetcher.lastPageURL = "5"
		fetchingLastPage(customFetcher, lastPageNumber: 5)
	}

	func testFetchingInAdvanceForTestCursorResourceFetcher() {
		let customFetcher = TestCursorResourceFetcher(pageLimit: PageLimit)
		customFetcher.lastPageURL = "5"
		customFetcher.delayTime = 2
		fetchingInAdvanceBeforeCompletion(customFetcher, lastPageNumber: PageLimit)

		let anotherCustomFetcher = TestCursorResourceFetcher(pageLimit: PageLimit)
		anotherCustomFetcher.lastPageURL = "5"
		anotherCustomFetcher.delayTime = 1
		fetchingInAdvanceAfterCompletion(anotherCustomFetcher, lastPageNumber: 5)
	}

	func testFetchingPageErrorForTestCursorResourceFetcher() {
		let customFetcher = TestCursorResourceFetcher(pageLimit: PageLimit)
		customFetcher.successChance = 0
		fetchingPageError(customFetcher)
	}
	
}
