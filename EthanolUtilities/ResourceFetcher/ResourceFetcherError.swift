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

	final public var code: Int = ResourceFetcherError.UnknownErroCode
	final public var domain: String = ResourceFetcherError.UnknownErrorDomain
	final public var message: String = ResourceFetcherError.UnknownErroMessage

	public init(code: Int, domain: String, message: String){
		self.code = code
		self.domain = domain
		self.message = message
		super.init()
	}

	override init() {
		super.init()
	}
}
