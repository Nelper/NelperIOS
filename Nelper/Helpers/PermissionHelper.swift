//
//  PermissionHelper.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-11-15.
//  Copyright © 2015 Nelper. All rights reserved.
//

import UIKit

class PermissionHelper{
	
	static let sharedInstance = PermissionHelper()
	var localizationAllowed:Bool!

	//Singleton to check Location Permissions
	
	func checkLocationStatus(){
		if CLLocationManager.locationServicesEnabled() {
			switch (CLLocationManager.authorizationStatus()) {
			case .NotDetermined, .Restricted, .Denied:
				self.localizationAllowed = false
			case .AuthorizedAlways, .AuthorizedWhenInUse:
				self.localizationAllowed = true
			}
		} else {
			self.localizationAllowed = false
		}
	}
}
