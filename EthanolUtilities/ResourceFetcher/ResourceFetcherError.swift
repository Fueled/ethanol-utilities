//
//  ResourceFetcherError.swift
//  EthanolUtilities
//
//  Created by Ravindra Soni on 07/09/2015.
//  Copyright © 2015 Stephane Copin. All rights reserved.
//

import Foundation

@objc public enum ResourceFetcherError: Int, ErrorType {
	public static var _NSErrorDomain: String {
		return "com.Fueled.ResourceFetcherError"
	}

	case AlreadyLoadingError, UnknownError, OtherError
}

extension ErrorType {
	var errorMessage: String {
		if let error = self as? ResourceFetcherError {
			switch error {
			case .AlreadyLoadingError:
				return "ResourceFetcher is already loading this page"
			case .UnknownError:
				return "An unknown error occured."
			default:
				return (self as NSError).localizedDescription
			}
		} else {
			return (self as NSError).localizedDescription
		}
	}
}
