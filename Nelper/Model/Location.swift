//
//  Location.swift
//  Nelper
//
//  Created by Janic Duplessis on 2015-09-25.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation

struct Location {
	var name: String?
	var formattedAddress: String?
	var streetNumber: String?
	var route: String?
	var city: String?
	var province: String?
	var country: String?
	var postalCode: String?
	var coords: GeoPoint?
}