//
//  EthanolSwiftHelpers.swift
//  EthanolUtilities
//
//  Created by Stephane Copin on 1/9/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation

public func delay(delay:Double, closure:()->()) {
  dispatch_after(
    dispatch_time(
      DISPATCH_TIME_NOW,
      Int64(delay * Double(NSEC_PER_SEC))
    ),
    dispatch_get_main_queue(), closure)
}
