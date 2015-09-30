//
//  ResourceFetcher.swift
//  SwiftTests
//
//  Created by Ravindra Soni on 31/08/2015.
//  Copyright © 2015 Fueled Inc. All rights reserved.
//

import Foundation

@objc public class ResourceFetcher: NSObject {

	/**
	ResourceFetcherCompletionInnerHandler
	
	:see ResourceFetcherCompletionHandler:

	- Throws: An error of ResourceFetcherError type

	*/
	public typealias ResourceFetcherCompletionInnerHandler = () throws -> (hasMoreDataToLoad: Bool, objects: [AnyObject], resourceFetcher: ResourceFetcher?)

	/**
	ExternalAPICompletionInnerHandler
 
	:see ExternalAPICompletionHandler:
	
	- Throws: An error of ResourceFetcherError type
	
	*/
	public typealias ExternalAPICompletionInnerHandler = () throws -> [AnyObject]

	/**
	ResourceFetcherCompletionHandler

	Primary Completion Block with an inner closure to handle errors

	:param: `inner`	which will throw an error on Failure and return a tuple on success
	
	*/
	public typealias ResourceFetcherCompletionHandler = (inner: ResourceFetcherCompletionInnerHandler) -> Void

	/**
	ExternalAPICompletionHandler

	External API Completion Block for the overridden method with an inner closure to handle errors

	:param: `inner`	which will throw an error on Failure and return the array of objects on successful completion

	*/
	public typealias ExternalAPICompletionHandler = (inner: ExternalAPICompletionInnerHandler) -> Void


	static let defaultPageLimit = 20
	static let initialPage = 1

	final private (set) public var allObjects = [AnyObject]()

	final internal var isLoading = false

	final internal var currentPage: Int

	final internal var pageLimit: Int

	final internal var advanceLoadedObjects: [AnyObject]?

	final private var nextLoadBlock: ResourceFetcherCompletionHandler?

	// MARK: Initializer

	public init(pageLimit: Int = ResourceFetcher.defaultPageLimit) {
		self.pageLimit = pageLimit
		self.currentPage = ResourceFetcher.initialPage
		super.init()
	}

	// MARK: Public Methods

	/**
	Start Fetching Products

	Calls `fetchPage(:pageLimit:completion)` with the first page and the page-limit specified during initialization.

	On successful completion clears the current set of Objects, if any and replaces them with the newly fetched results.

	Then performs the fetch for the next page silently

	:param: `completionHandler`	called when the fetch is completed

	*/


	final public func startFetchingProducts(completion: ResourceFetcherCompletionHandler? = nil) {
		if(isLoading) {
			if let completion = completion {
				completion() { throw ResourceFetcherError.alreadyLoadingError }
			}
			return
		}

		resetAllInfo()

		loadNextPages { (inner) -> Void in
			do {
				let (hasMoreDataToLoad, objects, resourceFetcher) = try inner()
				self.allObjects.removeAll()
				self.allObjects += objects

				if hasMoreDataToLoad {
					self.fetchNextPage(false, completion: nil)
				}

				completion?() { return (hasMoreDataToLoad, objects, resourceFetcher) }
			}
			catch {
				completion?() { throw error.resourceFetcherError }
			}
		}
	}
	/**
	Fetch Next Page

	Calls `fetchPage(:pageLimit:completion)` with the next page to be fetched and cached and the page-limit specified during initialization.

	On successful completion clears the current set of Objects, if any and replaces them with the newly fetched results.

	Then performs the fetch for the next page silently

	:param: `completionHandler`	called when the fetch is completed

	*/
	final public func fetchNextPage(completion: ResourceFetcherCompletionHandler? = nil) {
		fetchNextPage(true, completion: completion)
	}

	/**
	Fetches the Next Page from the specified URL.

	* Must be overridden By subclass

	:param: `pageNumber`								the page number of the fetching page

	:param: `pageLimit`									number of objects per page

	:param: `completionHandler`					Completion Handler on success/failure

	*/

	public func fetchPage(pageNumber:Int = 1, pageLimit: Int = ResourceFetcher.defaultPageLimit, completion: ExternalAPICompletionHandler? = nil) {
		assertionFailure("This method needs to be implemented in a subclass")
	}


	// MARK: Private Methods
	internal func resetAllInfo() {
		currentPage = ResourceFetcher.initialPage
		advanceLoadedObjects = nil
	}

	final private func fetchNextPage(userInitiated: Bool = false, completion: ResourceFetcherCompletionHandler? = nil) {
		print("xxxx - \(NSDate()) - ResourceFetcher: Fetching Next Page, UserInitiated? \(userInitiated)")
		if userInitiated {
			/* If user initiated, check if there are advance loaded objects.
			If exists then send loaded objects back, and load next batch.
			*/
			if let advanceLoadedObjects = advanceLoadedObjects {
				allObjects += advanceLoadedObjects
				self.advanceLoadedObjects = nil
				print("xxxx - \(NSDate()) - ResourceFetcher: Returning Advanced Loaded Objects")
				completion?() { return ((advanceLoadedObjects.count >= self.pageLimit), advanceLoadedObjects, self) }

			}
			else {
				//Setting Next Block
				nextLoadBlock = completion

				//Already Loading. So return. you'll get data in nextLoadBlock
				if isLoading {
					print("xxxx - \(NSDate()) - ResourceFetcher: Already Loading With Completion")
					return
				} else {
					print("xxxx - \(NSDate()) - ResourceFetcher: Loading Objects in Advance")
				}
			}
		}

		loadNextPages { (inner) -> Void in
			do {
				let (hasMoreDataToLoad,objects,resourceFetcher) = try inner()

				if let nextLoadBlock = self.nextLoadBlock {
					self.allObjects += objects
					nextLoadBlock() { return (hasMoreDataToLoad, objects, resourceFetcher) }
					self.nextLoadBlock = nil

					if hasMoreDataToLoad {
						self.fetchNextPage(false, completion: nil)
					}

				} else {
					self.advanceLoadedObjects = objects
				}
			}
			catch {
				if let nextLoadBlock = self.nextLoadBlock {
					print("xxxx - \(NSDate()) - ResourceFetcher: Handling Error While Fetching Objects")
					nextLoadBlock() { throw error.resourceFetcherError }
					self.nextLoadBlock = nil
				} else {
					print("xxxx - \(NSDate()) - ResourceFetcher: Unhandled Error while Fetching additional Objects")
				}
			}
		}
	}

	final private func loadNextPages(completion:ResourceFetcherCompletionHandler? = nil) {
		isLoading = true

		print("xxxx - \(NSDate()) - ResourceFetcher:  Fetching Page \(self.currentPage)")

		fetchPage(currentPage, pageLimit: pageLimit) { (inner) -> Void in

			do {
				let objects = try inner()
				//incremented currentPage
				self.currentPage++
				completion?() { return ((objects.count >= self.pageLimit), objects, self) }
			}
			catch {
				completion?() { throw error.resourceFetcherError }
			}
		}
	}
}
