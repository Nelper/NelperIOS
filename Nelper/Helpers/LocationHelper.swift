//
//  LocationHelper.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-08-05.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation

class LocationHelper {
	static let sharedInstance = LocationHelper()
	var currentLocation: PFGeoPoint!
	var currentCLLocation: CLLocationCoordinate2D!

 /**
	Calculates distance in kilometers between 2 CLLocations
	
	- parameter source:      1st Location
	- parameter destination: 2nd Location
	
	- returns: Returns Distance
	*/
	
	func calculateDistanceBetweenTwoLocations(source: CLLocation, destination: CLLocation) -> String {
		let distanceMeters = source.distanceFromLocation(destination)
		if (distanceMeters > 1000) {
			let distanceKM = distanceMeters / 1000
			return "\(Int(round(distanceKM))) km away from you"
		} else {
			return String(format:"%.0f m away from you", distanceMeters)
		}
	}
}
