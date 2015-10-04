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
	var task: Task!
	var price: Int?
	
	init(parseApplication: PFObject) {
		super.init()
		objectId = parseApplication.objectId
		state = State(rawValue: parseApplication["state"] as! Int)!
		if(parseApplication.createdAt != nil){
			createdAt = parseApplication.createdAt!
		}
		if parseApplication["price"] != nil {
			price = parseApplication["price"] as? Int
		}
		isNew = parseApplication["isNew"] as! Bool
		user = User(parseUser: parseApplication["user"] as! PFUser)
		if parseApplication["task"] != nil{
			if parseApplication["task"]!.isDataAvailable() == true {
				task = Task(parseTask: parseApplication["task"] as! PFObject)
			}
		}
	}
}
