//
//  ResourceFetcherError.swift
//  EthanolUtilities
//
//  Created by Ravindra Soni on 07/09/2015.
//  Copyright © 2015 Stephane Copin. All rights reserved.
//

import Foundation

@objc public class ResourceFetcherError: NSObject, ErrorType {
	static let UnknownErroCode = 500
	static let UnknownErrorDomain = "Error"
	static let UnknownErroMessage = "An unknown error occured."

	final public let code: Int
	final public let domain: String
	final public let message: String

	override init() {
		self.code = ResourceFetcherError.UnknownErroCode
		self.domain = ResourceFetcherError.UnknownErrorDomain
		self.message = ResourceFetcherError.UnknownErroMessage
		super.init()
	}

	public init(code: Int, domain: String, message: String){
		self.code = code
		self.domain = domain
		self.message = message
		super.init()
	}

	convenience init (error: NSError) {
		self.init(code: error.code, domain: error.domain, message: error.localizedDescription)
	}
}

extension ResourceFetcherError {
	class var alreadyLoadingError:ResourceFetcherError {
		return ResourceFetcherError(code: ResourceFetcherError.UnknownErroCode, domain: "Already Loading!", message: "ResourceFetcher is already loading this page")
	}
}

extension ErrorType {
	var resourceFetcherError: ResourceFetcherError {
		return self as? ResourceFetcherError ?? ResourceFetcherError(error: self as NSError)
	}
}
