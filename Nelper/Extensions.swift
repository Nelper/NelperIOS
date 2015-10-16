//
//  Extensions.swift
//  Nelper
//
//  Created by Pierre-Luc Benoit on 2015-10-16.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation

extension String {
	func isEmail() -> Bool {
		let regex = try! NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$",
			options: [.CaseInsensitive])
		
		return regex.firstMatchInString(self, options:[],
			range: NSMakeRange(0, utf16.count)) != nil
	}
}

extension String {
	func isPhoneNumber() -> Bool {
		let regex = try! NSRegularExpression(pattern: "^\\d{3}-\\d{3}-\\d{4}$",
			options: [.CaseInsensitive])
		
		return regex.firstMatchInString(self, options:[],
			range: NSMakeRange(0, utf16.count)) != nil
	}
}