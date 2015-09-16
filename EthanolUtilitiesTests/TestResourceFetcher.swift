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
	var lastPageNumer = 5
	var successChance = 90 // percent success chance

	override func fetchPage(pageNumber: Int, pageLimit: Int, completion: ExternalAPICompletionHandler?) {

		let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(delayTime * Double(NSEC_PER_SEC)))
		dispatch_after(delay, dispatch_get_main_queue()) {
			var randomArray: [String] = []

			if (pageNumber == self.lastPageNumer) { // Last Page
				for index in 0..<pageLimit-1 {
					randomArray.append("Page - \(pageNumber) - \(index)")
				}
			} else {
				for index in 0..<pageLimit {
					randomArray.append("Page - \(pageNumber) - \(index)")
				}
			}

			let error = NSError(domain: "APIERROR", code: 400, userInfo: [NSLocalizedDescriptionKey : "NOTHING ERROR"])

			let success = (random() % 100 <= self.successChance)
			if success {
				completion?(){ return randomArray }
			} else {
				completion?(){ throw error }
			}
		}
	}
}

class TestCursorResourceFetcher: CurserBasedResourceFetcher {

	var delayTime = 2.0
	var lastPageURL = 5.stringValue
	var successChance = 90 // percent success chance

	override func fetchPage(url: String?, pageLimit: Int, completion: CursorBasedAPICompletionHandler?){


		let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(delayTime * Double(NSEC_PER_SEC)))
		dispatch_after(delay, dispatch_get_main_queue()) {

			var randomArray: [String] = []

			let pageNumber = url?.intValue ?? 0

			if (pageNumber == self.lastPageURL.intValue) { // Last Page
				for index in 0..<pageLimit-1 {
					randomArray.append("Page - \(pageNumber) - \(index)")
				}
			} else {
				for index in 0..<pageLimit {
					randomArray.append("Page - \(pageNumber) - \(index)")
				}
			}

			let error = NSError(domain: "APIERROR", code: 400, userInfo: [NSLocalizedDescriptionKey : "NOTHING ERROR"])

			let success = (random() % 100 <= self.successChance)
			if success {
				completion?(){ return ( "1" , nil, randomArray) }
			} else {
				completion?(){ throw error }
			}
		}

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