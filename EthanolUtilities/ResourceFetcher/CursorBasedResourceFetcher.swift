//
//  CursorBasedResourceFetcher.swift
//  EthanolUtilities
//
//  Created by Ravindra Soni on 15/09/2015.
//  Copyright © 2015 Stephane Copin. All rights reserved.
//

import Foundation

public struct CursorBasedPageInfo {
	var previousPageUrl: String?
	var nextPageUrl: String?
	var objects: [AnyObject]
}

@objc public class CursorBasedResourceFetcher: ResourceFetcher {


	public typealias CursorBasedAPICompletionInnerHandler =
		() throws -> (previousPageUrl: String?, nextPageUrl: String?, objects: [AnyObject])

	public typealias CursorBasedAPICompletionHandler = (inner: CursorBasedAPICompletionInnerHandler) -> Void

	var loadedPagesInfo = [Int: CursorBasedPageInfo]()


	final internal override func resetAllInfo() {
		loadedPagesInfo.removeAll()
		super.resetAllInfo()
	}

	final public override func fetchPage(pageNumber: Int = ResourceFetcher.initialPage,
		pageLimit: Int = ResourceFetcher.defaultPageLimit, completion: ExternalAPICompletionHandler?) {
			let pageInfo = loadedPagesInfo[pageNumber - 1]

			fetchPage(pageInfo?.nextPageUrl, pageLimit: pageLimit) { (inner) -> Void in
				do {
					let (prevUrl, nextUrl, objects) = try inner()
					self.loadedPagesInfo[pageNumber] =
						CursorBasedPageInfo(previousPageUrl: prevUrl, nextPageUrl: nextUrl, objects: objects)

					completion?(){ return objects }
				}
				catch {
					completion?() { throw ResourceFetcherError.OtherError }
				}
			}
	}

	/**
	Fetches objects from the specified URL.

	* Must be overridden By subclass

	:param: `url`								the url from where to load objects. url = nil indicates loading the very first page

	:param: `pageLimit`							number of objects per page

	:param: `completion`						Completion Handler on success/failure

	*/

	public func fetchPage(url: String?, pageLimit: Int, completion: CursorBasedAPICompletionHandler?){
		assertionFailure("This should be implemented in subclass");
	}
}

