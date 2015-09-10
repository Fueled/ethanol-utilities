//
//  ResourceFetcher.swift
//  SwiftTests
//
//  Created by Ravindra Soni on 31/08/2015.
//  Copyright © 2015 Fueled Inc. All rights reserved.
//

import Foundation


@objc public class ResourceFetcher: NSObject {

	public typealias ResourceFetcherCompletionHandler =
		(success: Bool, hasMoreDataToLoad: Bool, objects: [AnyObject]?,
		resourceFetcher: ResourceFetcher?, error: ResourceFetcherError?) -> Void

	public typealias ExternalAPICompletionHandler =
		(success: Bool, objects: [AnyObject]?, error: ResourceFetcherError?) -> Void

	static let defaultPageLimit = 20
	static let initialPage = 1

	final private (set) public var allObjects = [AnyObject]()

	final private (set) public var isLoading = false

	final private var currentPage: Int

	final private var pageLimit: Int

	final private var advanceLoadedObjects: [AnyObject]?

	final private var nextLoadBlock: ResourceFetcherCompletionHandler?

	// MARK: Initializer

	public init(pageLimit: Int = ResourceFetcher.defaultPageLimit) {
		print("things")
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

	public func test() throws -> (resourceFetcher: ResourceFetcher, objects: [AnyObject]?) {
		let error = ResourceFetcherError()
		let x = rand() % 2
		if x == 1 {
			throw error
		}
		return (self, nil)
	}

	final public func startFetchingProducts(completionHandler:ResourceFetcherCompletionHandler? = nil) {
		if(isLoading) {
			if let completionHandler = completionHandler {
				completionHandler(success:false, hasMoreDataToLoad:true, objects:nil, resourceFetcher:nil, error:nil)
			}
			return
		}

		resetAllInfo()

		loadNextPages() {
			(success, hasMoreDataToLoad, objects, resourceFetcher, error) in
			let loadedObjects = objects!
			var moreDataToLoad = hasMoreDataToLoad
			if success {
				self.allObjects.removeAll()
				self.allObjects.append(loadedObjects)

				if hasMoreDataToLoad {
					self.fetchNextPage(false, completionHandler: nil)
				}
			}
			else {
				moreDataToLoad = false
			}

			if let completion = completionHandler {
				completion(success: success, hasMoreDataToLoad: moreDataToLoad, objects: objects,
					resourceFetcher: self, error: error)
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
	final public func fetchNextPage(completionHandler:ResourceFetcherCompletionHandler? = nil) {
		fetchNextPage(true, completionHandler: completionHandler)
	}

	/**
	Fetches the Next Page from the specified URL.

	* Must be overridden By subclass

	:param: `pageNumber`								the page number of the fetching page

	:param: `pageLimit`									number of objects per page

	:param: `completionHandler`					Completion Handler on success/failure

	*/
	public func fetchPage(pageNumber:Int = 1, pageLimit: Int = ResourceFetcher.defaultPageLimit,
		completionHandler:ExternalAPICompletionHandler?) {
		assertionFailure("This method needs to be implemented in the subclass")
	}


	// MARK: Private Methods
	final private func resetAllInfo() {
		currentPage = ResourceFetcher.initialPage
		advanceLoadedObjects = nil
	}

	final private func fetchNextPage(userInitiated:Bool = false,
		completionHandler:ResourceFetcherCompletionHandler? = nil) {
		if userInitiated {
			/* If user initiated, check if there are advance loaded objects.
			If exists then send loaded objects back, and load next batch.
			*/
			if let advanceLoadedObjects = advanceLoadedObjects {
				allObjects.append(advanceLoadedObjects)

				if let completionHandler = completionHandler {
					let hasMoreDataToLoad = advanceLoadedObjects.count >= self.pageLimit
					completionHandler(success: true, hasMoreDataToLoad: hasMoreDataToLoad,
						objects: advanceLoadedObjects, resourceFetcher: self, error: nil)
				}

				self.advanceLoadedObjects = nil
			}
			else {
				//Setting Next Block
				nextLoadBlock = completionHandler

				//Already Loading. So return. you'll get data in nextLoadBlock
				if isLoading {
					return
				}
			}
		}

		self.loadNextPages() { (success, hasMoreDataToLoad, objects, resourceFetcher, error) in
			if success {
				//Load complete. Checking Next Block
				if let nextLoadBlock = self.nextLoadBlock {
					if let objects = objects {
						self.allObjects.append(objects)
					}
					//Passing Next Block
					nextLoadBlock(success: success, hasMoreDataToLoad: hasMoreDataToLoad,
						objects: objects, resourceFetcher: self, error: error)
					self.nextLoadBlock = nil

					if hasMoreDataToLoad {
						self.fetchNextPage(false, completionHandler: nil)
					}

				}
				else {
					//no Next Block. Save to advance
					self.advanceLoadedObjects = objects
				}
			}
			else {
				if let nextLoadBlock = self.nextLoadBlock {
					//Call Failed. Passing saved nextLoadBlock");
					nextLoadBlock(success: success, hasMoreDataToLoad: hasMoreDataToLoad,
						objects: objects, resourceFetcher: self, error: error)
					self.nextLoadBlock = nil
				}
			}
		}
	}

	final private func loadNextPages(completionHandler:ResourceFetcherCompletionHandler? = nil) {
		isLoading = true

		print("xxxx Fetching Page \(self.currentPage)")

		self.fetchPage(self.currentPage, pageLimit: self.pageLimit) {
			(success, objects, error) in
			var moreDataToLoad = true
			if success {
				if objects?.count >= self.pageLimit { /** excellent use of optional :) :thumbsup: */
					moreDataToLoad = true
				} /** Indentation? -> Refer Style guide please :P */
				else {
					moreDataToLoad = false
				}
				//incremented currentPage
				self.currentPage++
			}

			//Loading Finished
			self.isLoading = false

			if let completionHandler = completionHandler {
				completionHandler(success: success, hasMoreDataToLoad: moreDataToLoad,
					objects: objects, resourceFetcher: self, error: error)
			}

		}
	}

}