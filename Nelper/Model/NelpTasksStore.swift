//
//  OffersStore.swift
//  Nelper
//
//  Created by Janic Duplessis on 2015-07-03.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation

class NelpTasksStore {
  
	func createWithTitle(title: String, description: String, priceOffered:String) -> NelpTask {
    let user = PFUser.currentUser()!
    
    let task = NelpTask()
    task.title = title
    task.desc = description
    task.user = user
		task.priceOffered = priceOffered
    
    let acl = PFACL(user: user)
    acl.setPublicReadAccess(true)
    acl.setPublicWriteAccess(false)
    task.ACL = acl
    
    task.saveEventually()
    
    return task
  }
  
  func listMyOffers(block: ([NelpTask]?, NSError?) -> Void) {
    let query = NelpTask.query()!
    query.whereKey("user", equalTo: PFUser.currentUser()!)
    query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
      if error != nil {
        block(nil, error)
      } else {
        let tasks = objects as! [NelpTask]
        block(tasks, nil)
      }
    }
  }
}