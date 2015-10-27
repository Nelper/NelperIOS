//
//  UserPrivateData.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-09-25.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation

class UserPrivateData: BaseModel {
	
	var email: String!
	var phone: String?
	var language: String?
	var locations = [Location]()
	var notifications = NotificationSettings()

	init(parsePrivateData: PFObject) {
		super.init()
		
		//NOTIFICATIONS
		let parseNotifications = parsePrivateData["notifications"] as! Dictionary<String, Dictionary<String, Bool>>
		self.notifications.posterApplication = SettingOption(email: parseNotifications["posterApplication"]!["email"]!)
		self.notifications.posterRequestPayment = SettingOption(email: parseNotifications["posterRequestPayment"]!["email"]!)
		self.notifications.nelperApplicationStatus = SettingOption(email: parseNotifications["nelperApplicationStatus"]!["email"]!)
		self.notifications.nelperReceivedPayment = SettingOption(email: parseNotifications["nelperReceivedPayment"]!["email"]!)
		self.notifications.newsletter = SettingOption(email: parseNotifications["newsletter"]!["email"]!)
		
		//LOCATIONS
		let locations = parsePrivateData["locations"]! as! Array<Dictionary<String,AnyObject>>
		for location in locations {
			let oneLocation = Location(parseLocation: location)
			oneLocation.formattedAddress = location["formattedAddress"] as? String
			oneLocation.name = location["name"] as? String
			oneLocation.city = location["city"] as? String
			oneLocation.province = location["province"] as? String
			oneLocation.route = location["route"] as? String
			oneLocation.streetNumber = location["streetNumber"] as? String
			oneLocation.postalCode = location["postalCode"] as? String
			oneLocation.country = location["country"] as? String
			oneLocation.coords = location["coords"] as? Dictionary<String,Double>
			self.locations.append(oneLocation)
		}
		
		//INFORMATIONS
		self.email = parsePrivateData["email"] as! String
		self.phone = parsePrivateData["phone"] as? String
	}
}


struct SettingOption {
	var email: Bool
}

class NotificationSettings {
	
	var posterApplication: SettingOption!
	var posterRequestPayment: SettingOption!
	var nelperApplicationStatus: SettingOption!
	var nelperReceivedPayment: SettingOption!
	var newsletter: SettingOption!
	
	
}
