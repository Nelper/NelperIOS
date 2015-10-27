//
//  Location.swift
//  Nelper
//
//  Created by Janic Duplessis on 2015-09-25.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation


class Location {
	var name: String?
	var formattedAddress: String?
	var streetNumber: String?
	var route: String?
	var city: String?
	var province: String?
	var country: String?
	var postalCode: String?
	var coords: Dictionary<String, Double>?
	var formattedTextLabel: String {
		get {
			if self.streetNumber != nil {
				return "\(self.streetNumber!) \(self.route!)\n\(self.city!), \(self.province!)\n\(self.postalCode!)"
			} else {
				return "\(self.route!)\n\(self.city!), \(self.province!)\n\(self.postalCode!)"
			}
		}
	}
	
	init(parseLocation: AnyObject) {
		let dict = parseLocation as! Dictionary<String, AnyObject>
		
		self.formattedAddress = dict["formattedAddress"] as? String
		self.name = dict["name"] as? String
		self.city = dict["city"] as? String
		self.province = dict["province"] as? String
		self.route = dict["route"] as? String
		self.streetNumber = dict["streetNumber"] as? String
		self.postalCode = dict["postalCode"] as? String
		self.country = dict["country"] as? String
		self.coords = dict["coords"] as? Dictionary<String, Double>
	}
	
	init() {
		
	}
		
	func createDictionary() -> Dictionary<String, AnyObject> {
		var dictionary = Dictionary<String, AnyObject>()
		
		if self.name != nil {
			dictionary["name"] = self.name
		}
		if self.formattedAddress != nil {
			dictionary["formattedAddress"] = self.formattedAddress
		}
		if self.streetNumber != nil {
			dictionary["streetNumber"] = self.streetNumber
		}
		if self.route != nil {
			dictionary["route"] = self.route
		}
		if self.city != nil {
			dictionary["city"] = self.city
		}
		if self.province != nil {
			dictionary["province"] = self.province
		}
		if self.country != nil {
			dictionary["country"] = self.country
		}
		if self.postalCode != nil {
			dictionary["postalCode"] = self.postalCode
		}
		if self.coords != nil {
			dictionary["coords"] = self.coords
		}
		return dictionary
	}
}