//
//  EthanolSwiftHelpers.swift
//  EthanolUtilities
//
//  Created by Stephane Copin on 1/9/15.
//  Copyright (c) 2015 Fueled Digital Media, LLC.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
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

public func compareWithDelta<T where T: SignedNumberType, T: FloatingPointType>(value: T, compareTo: T, delta: T) -> Bool {
	if(value.isInfinite && compareTo.isInfinite) {
		if((value.isSignMinus && !compareTo.isSignMinus) || (!value.isSignMinus && compareTo.isSignMinus)) {
			return false
		}
		return !delta.isInfinite
	}
	if(delta.isInfinite) {
		if(value.isInfinite) {
			return false
		}
		return true
	}
	return abs(value - compareTo) <= abs(delta)
}

infix operator ~= { precedence 60 }
infix operator +- { precedence 70 }

// This operator is not made to be used by itself. Please use it with ~= (Syntax is value ~= (compare +- delta))
public func +-<T: SignedNumberType>(@autoclosure lhs: () -> T, @autoclosure rhs: () -> T)(left: Bool) -> T {
	return left ? lhs() : rhs()
}

public func ~=<T: SignedNumberType>(value: T, compareToDelta: (left: Bool) -> T) -> Bool {
	let compareTo = compareToDelta(left: true)
	let delta = compareToDelta(left: false)
	return compareWithDelta(value, compareTo: compareTo, delta: delta)
}
