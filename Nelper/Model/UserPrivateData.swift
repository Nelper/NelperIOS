//
//  UserPrivateData.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-09-25.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation

class UserPrivateData:BaseModel {
	
	var email:String!
	var language:String?
	var locations:Location!
	var phoneNumber:String!

	
	
	init(currentParseUser: PFUser) {
		super.init();
		
		currentParseUser

	
	
	}
}