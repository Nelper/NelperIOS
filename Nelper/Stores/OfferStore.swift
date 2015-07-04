//
//  OffersStore.swift
//  Nelper
//
//  Created by Janic Duplessis on 2015-07-03.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation

class OfferStore {
  
  func createWithTitle(title: String, description: String) {
    let user = PFUser.currentUser()!
    
    let offer = Offer()
    offer.title = title
    offer.desc = description
    offer.user = user
    
    let acl = PFACL(user: user)
    acl.setPublicReadAccess(true)
    acl.setPublicWriteAccess(false)
    offer.ACL = acl
    
    offer.saveEventually()
  }
  
  func listMyOffers(block: ([Offer]?, NSError?) -> Void) {
    let query = Offer.query()!
    query.whereKey("user", equalTo: PFUser.currentUser()!)
    query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
      if error != nil {
        block(nil, error)
      } else {
        let offers = objects as! [Offer]
        block(offers, nil)
      }
    }
  }
}