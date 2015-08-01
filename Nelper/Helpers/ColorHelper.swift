//
//  File.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-07-12.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation


let orangeMainColor = hexStringToUIColor("de1f1f")
let orangeSecondaryColor = hexStringToUIColor("d98b30")

let orangeMainGradientColor = hexStringToUIColor("de1f1f")
let orangeSecondaryGradientColor = hexStringToUIColor("d95330")

let whiteNelpyColor = hexStringToUIColor ("eaeaea")
let blackNelpyColor = hexStringToUIColor ("2c2c2c")
let grayNelpyColor = hexStringToUIColor("525252")

let facebookBlueColor = hexStringToUIColor ("3b5998")
let greenPriceButton = hexStringToUIColor ("7fae79")
let yellowTechnology = hexStringToUIColor ("f7cc39")




func hexStringToUIColor (hex:String) -> UIColor {
	var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
	
	if (cString.hasPrefix("#")) {
		cString = cString.substringFromIndex(advance(cString.startIndex, 1))
	}
	
	if (count(cString) != 6) {
		return UIColor.grayColor()
	}
	
	var rgbValue:UInt32 = 0
	NSScanner(string: cString).scanHexInt(&rgbValue)
	
	return UIColor(
		red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
		green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
		blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
		alpha: CGFloat(1.0)
	)
}