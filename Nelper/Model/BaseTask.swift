//
//  BaseTask.swift
//  Nelper
//
//  Created by Janic Duplessis on 2015-07-28.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation

class BaseTask: BaseModel {
  
  enum State: Int {
    case Active = 0
    case Accepted
    case Deleted
  }
  
  var title: String!
  var desc: String!
  var user: User!
  var location : GeoPoint?
  var priceOffered : String?
  var pictures : Array<UIImage>?
  var state: Int = 0
  
  init(parseTask: PFObject) {
    super.init()
    
    objectId = parseTask.objectId!
    title = parseTask["title"] as! String
    desc = parseTask["desc"] as! String
    user = User(parseUser: PFUser.currentUser()!)
    let pfLoc = parseTask["location"] as? PFGeoPoint
    if let pfLoc = pfLoc {
      location = GeoPoint(
        latitude: pfLoc.latitude,
        longitude: pfLoc.longitude
      )
    }
    priceOffered = parseTask["priceOffered"] as? String
    pictures = nil //TODO: pictures
    state = parseTask["state"] as! Int
  }
}