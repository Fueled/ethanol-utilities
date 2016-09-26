//
//  EthanolArrayUtilities.swift
//  EthanolUtilities
//
//  Created by Stephane Copin on 1/5/15.
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

extension Sequence {
	public func find(_ predicate: (Self.Iterator.Element) -> Bool) -> Int? {
		for (idx, element) in self.enumerated() {
			if predicate(element) {
				return idx
			}
		}
		return nil;
	}
}

extension Array {
	public func keepRange(_ range: Range<Int>) -> Array<Element> {
		var array = self
		array.keepRangeInPlace(range)
		return array
	}
	
	public mutating func keepRangeInPlace(_ range: Range<Int>) {
		if(range.upperBound < self.endIndex) {
			self.removeSubrange(self.indices.suffix(from: range.upperBound));
		}
		if(range.lowerBound > self.startIndex) {
			self.removeSubrange(0..<range.lowerBound);
		}
	}
}
