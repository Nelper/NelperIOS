//
//  NelpTaskApplication.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-07-12.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation

class NelpTaskApplication: BaseModel {
  enum State: Int {
    case Pending = 0
    case Canceled
    case Accepted
    case Denied
  }
  
  var state: State = .Pending
  var createdAt: NSDate!
  var isNew: Bool = true
  var user: User!
  var task: NelpTask!
  
  init(parseApplication: PFObject) {
    super.init()
		objectId = parseApplication.objectId
    state = State(rawValue: parseApplication["state"] as! Int)!
		if(parseApplication.createdAt != nil){
			createdAt = parseApplication.createdAt!
		}
    isNew = parseApplication["isNew"] as! Bool
    user = User(parseUser: parseApplication["user"] as! PFUser)
  }
}
