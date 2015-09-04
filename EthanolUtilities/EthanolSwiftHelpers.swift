//
//  EthanolSwiftHelpers.swift
//  EthanolUtilities
//
//  Created by Stephane Copin on 1/9/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation

public func delay(delay: Double, closure: () -> ()) {
	dispatch_after(
		dispatch_time(
			DISPATCH_TIME_NOW,
			Int64(delay * Double(NSEC_PER_SEC))
		),
		dispatch_get_main_queue(), closure)
}

public func compareWithDelta<T: SignedNumberType>(value: T, compareTo: T, delta: T) -> Bool {
	return abs(value - compareTo) < delta
}

infix operator ~= { precedence 60 }
infix operator +- { precedence 70 }

// This operator is not made to be used by itself. Please use it with ~= (Syntax is value ~= compare +- delta)
public func +-<T: SignedNumberType>(@autoclosure lhs: () -> T, @autoclosure rhs: () -> T)(left: Bool) -> T {
	return left ? lhs() : rhs()
}

public func ~=<T: SignedNumberType>(value: T, compareToDelta: (left: Bool) -> T) -> Bool {
	let compareTo = compareToDelta(left: true)
	let delta = compareToDelta(left: false)
	return compareWithDelta(value, compareTo: compareTo, delta: delta)
}
