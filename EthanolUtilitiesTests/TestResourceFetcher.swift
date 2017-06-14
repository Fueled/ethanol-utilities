//
//  TestResourceFetcher.swift
//  EthanolUtilities
//
//  Created by hhs-fueled on 15/09/15.
//  Copyright © 2015 Stephane Copin. All rights reserved.
//

import UIKit
@testable import EthanolUtilities

class TestResourceFetcher: ResourceFetcher {

	var delayTime = 2.0
	var lastPageNumber = 5
	var successChance = 100 // percent success chance

	override func fetchPage(pageNumber: Int, pageLimit: Int, completion: ExternalAPICompletionHandler?) {
		guard let completion = completion else {
			return
		}

		let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(delayTime * Double(NSEC_PER_SEC)))
		dispatch_after(delay, dispatch_get_main_queue()) {
			completion() {
				let success = (random() % 100 <= self.successChance)
				if success {
					let objectsCount = (pageNumber == self.lastPageNumber) ? pageLimit-1 : pageLimit
					return self.randomResponseArrayFor(pageNumber, objectsCount: objectsCount)
				} else {
					throw self.randomResponseError()
				}
			}
		}
	}
}

class TestCursorResourceFetcher: CursorBasedResourceFetcher {

	var delayTime = 2.0
	var lastPageURL = 5.stringValue
	var successChance = 100 // percent success chance

	override func fetchPage(url: String?, pageLimit: Int, completion: CursorBasedAPICompletionHandler?) {

		guard let completion = completion else {
			return
		}

		let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(delayTime * Double(NSEC_PER_SEC)))
		dispatch_after(delay, dispatch_get_main_queue()) {

			completion(){
				let success = (random() % 100 <= self.successChance)
				if success {
					let pageNumber = url?.intValue ?? 0
					let objectsCount = (pageNumber == self.lastPageURL.intValue) ? pageLimit-1 : pageLimit
					return ( "1" , nil, self.randomResponseArrayFor(pageNumber, objectsCount: objectsCount))
				} else {
					throw self.randomResponseError()
				}
			}
		}
	}
}


extension ResourceFetcher {
	private func randomResponseArrayFor(pageNumber: Int, objectsCount:Int) -> [String] {
		var randomArray: [String] = []
		for index in 0..<objectsCount {
			randomArray.append("Page - \(pageNumber) - \(index)")
		}
		return randomArray
	}

	private func randomResponseError() -> NSError {
		let error = NSError(domain: "APIERROR", code: 400, userInfo: [NSLocalizedDescriptionKey : "NOTHING ERROR"])
		return error
	}
}

extension String {
	var intValue: Int {
		return Int(self) ?? 0
	}
}

extension Int {
	var stringValue: String {
		return String(self)
	}
}