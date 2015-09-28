//
//  ResourceFetcherError.swift
//  EthanolUtilities
//
//  Created by Ravindra Soni on 07/09/2015.
//  Copyright © 2015 Stephane Copin. All rights reserved.
//

import Foundation

@objc public class ResourceFetcherError: NSObject, ErrorType {
	static let UnknownErrorCode = 500
	static let UnknownErrorDomain = "Error"
	static let UnknownErrorMessage = "An unknown error occured."

	final public let code: Int
	final public let domain: String
	final public let message: String

	public init(code: Int = ResourceFetcherError.UnknownErrorCode, domain: String = ResourceFetcherError.UnknownErrorDomain, message: String = ResourceFetcherError.UnknownErrorMessage){
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
		return ResourceFetcherError(code: ResourceFetcherError.UnknownErrorCode, domain: "Already Loading!", message: "ResourceFetcher is already loading this page")
	}
}

extension ErrorType {
	var resourceFetcherError: ResourceFetcherError {
		return self as? ResourceFetcherError ?? ResourceFetcherError(error: self as NSError)
	}
}
