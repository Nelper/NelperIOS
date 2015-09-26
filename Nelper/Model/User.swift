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
	var rating: Double!
	var name: String!
	var location: GeoPoint?
	var createdAt: NSDate!
	var profilePictureURL:String?
	var skills:[Dictionary<String,String>]!
	var education:[Dictionary<String,String>]!
	var experience:[Dictionary<String,String>]!
	var about:String!
	var privateDate:UserPrivateData?
	
	
	init(parseUser: PFUser) {
		super.init();
		
		username = parseUser.username!
		email = parseUser.email
		rating = parseUser["rating"] as! Double!
		objectId = parseUser.objectId!
		name = parseUser["name"] as! String
		location = parseUser["location"] as? GeoPoint
		createdAt = parseUser.createdAt!
		if parseUser["skills"] != nil{
			skills = parseUser["skills"] as! [Dictionary<String,String>]
		}
		if parseUser["education"] != nil{
			education = parseUser["education"] as! [Dictionary<String,String>]
		}
		if parseUser["experience"] != nil{
			experience = parseUser["experience"] as! [Dictionary<String,String>]
		}
		if parseUser["about"] != nil{
			about = parseUser["about"] as! String
		}
		if let pic = parseUser["customPicture"] as? PFFile {
			profilePictureURL = pic.url
		} else if let picURL = parseUser["pictureURL"] as? String {
			profilePictureURL = picURL
		}
	}
}
