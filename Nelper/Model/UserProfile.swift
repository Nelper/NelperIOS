//
//  UserProfile.swift
//  Nelper
//
//  Created by Janic Duplessis on 2015-07-06.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation

class UserProfile : PFObject, PFSubclassing {
  
  override class func initialize() {
    struct Static {
      static var onceToken : dispatch_once_t = 0;
    }
    dispatch_once(&Static.onceToken) {
      self.registerSubclass()
    }
  }
  
  static func parseClassName() -> String {
    return "UserProfile"
  }
  
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var feedback:Int
  
  
}