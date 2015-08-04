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
	var category : String?
  var pictures : Array<UIImage>?
  var state: State = .Active
  
  override init() {
    super.init()
  }
  
  convenience init(parseTask: PFObject) {
    self.init()
    
    objectId = parseTask.objectId!
    title = parseTask["title"] as! String
    desc = parseTask["desc"] as! String
		category = parseTask["category"] as? String
    user = User(parseUser: parseTask["user"] as! PFUser)
    let pfLoc = parseTask["location"] as? PFGeoPoint
    if let pfLoc = pfLoc {
      location = GeoPoint(
        latitude: pfLoc.latitude,
        longitude: pfLoc.longitude
      )
    }
    priceOffered = parseTask["priceOffered"] as? String
    pictures = nil //TODO: pictures
    state = State(rawValue: parseTask["state"] as! Int)!
  }
}