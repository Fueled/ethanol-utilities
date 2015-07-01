//
//  EthanolArrayUtilities.swift
//  EthanolUtilities
//
//  Created by Stephane Copin on 1/5/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

extension SequenceType {
  public func find(predicate: Self.Generator.Element -> Bool) -> Int? {
    for (idx, element) in self.enumerate() {
      if predicate(element) {
        return idx
      }
    }
    return nil;
  }
}

extension Array {
  public func keepRange(range: Range<Int>) -> Array<T> {
    var array = self
    array.keepRangeInPlace(range)
    return array
  }
  
  public mutating func keepRangeInPlace(range: Range<Int>) {
    if(range.endIndex < self.endIndex) {
      self.removeRange(range.endIndex..<self.endIndex);
    }
    if(range.startIndex > self.startIndex) {
      self.removeRange(0..<range.startIndex);
    }
  }
}
