//
//  Nelp.swift
//  Nelper
//
//  Created by Janic Duplessis on 2015-07-03.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation

class NelpTask : PFObject, PFSubclassing {
  
  override class func initialize() {
    struct Static {
      static var onceToken : dispatch_once_t = 0;
    }
    dispatch_once(&Static.onceToken) {
      self.registerSubclass()
    }
  }
  
  static func parseClassName() -> String {
    return "Offer"
  }
  
  @NSManaged var title: String!
  @NSManaged var desc: String!
  @NSManaged var user: PFUser!
}