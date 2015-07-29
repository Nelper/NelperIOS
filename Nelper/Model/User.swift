//
//  User.swift
//  Nelper
//
//  Created by Janic Duplessis on 2015-07-28.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation

class User : BaseModel {
  
  var username: String!
  var email: String?
  var name: String!
  var location: GeoPoint?
  var createdAt: NSDate!
  
  init(parseUser: PFUser) {
    super.init();
    
    username = parseUser.username!
    email = parseUser.email
    name = parseUser["name"] as! String
    location = parseUser["location"] as? GeoPoint
    createdAt = parseUser.createdAt!
  }
}