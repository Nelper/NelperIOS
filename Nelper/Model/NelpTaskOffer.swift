//
//  NelpTaskOffer.swift
//  Nelper
//
//  Created by Janic Duplessis on 2015-07-06.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation

class NelpTaskOffer : PFObject, PFSubclassing {
  
  override class func initialize() {
    struct Static {
      static var onceToken : dispatch_once_t = 0;
    }
    dispatch_once(&Static.onceToken) {
      self.registerSubclass()
    }
  }
  
  static func parseClassName() -> String {
    return "NelpTaskOffer"
  }
  
  @NSManaged var nelpTask: NelpTask!
  @NSManaged var user: PFUser!
  
}