//
//  ResourceFetcherError.swift
//  EthanolUtilities
//
//  Created by Ravindra Soni on 07/09/2015.
//  Copyright © 2015 Stephane Copin. All rights reserved.
//

import Foundation

public class ResourceFetcherError: NSObject {
	static let UnknownErroCode = 500
	static let UnknownErrorDomain = "Error"
	static let UnknownErroMessage = "An unknown error occured."

	final public var statusCode: Int = 0
	final public var domain: String?
	final public var message: String?

	public init(statusCode: Int = ResourceFetcherError.UnknownErroCode,
		domain: String = ResourceFetcherError.UnknownErrorDomain,
		message: String = ResourceFetcherError.UnknownErroMessage){
			self.statusCode = statusCode
			self.domain = domain
			self.message = message
			super.init()
	}
}

