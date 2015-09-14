//
//  File.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-07-12.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation

//COLORS

let whiteNelpyColor = hexStringToUIColor ("eaeaea")
let blackNelpyColor = hexStringToUIColor ("2c2c2c")
let nelperRedColor = hexStringToUIColor("ed4b4e")
let whiteGrayColor = hexStringToUIColor("f7f7f7")
let orangeTextColor = hexStringToUIColor("f32a18")
let grayDetails = hexStringToUIColor("e1e1e1")
let darkGrayDetails = hexStringToUIColor("979797")

let progressGreen = hexStringToUIColor("29B473")
let pendingYellow = hexStringToUIColor("F7CC39")

let profileGreenColor = hexStringToUIColor("29b48f")

let facebookBlueColor = hexStringToUIColor ("3b5998")
let greenPriceButton = hexStringToUIColor ("80bf62")


let grayBlueColor = hexStringToUIColor ("5a6a7b")

let navBarColor = whiteGrayColor
let tabBarColor = whiteGrayColor

//IMAGES

let tabBarSearch:UIImage = UIImage(named: "search_dark.png")!
let tabBarNelp:UIImage = UIImage(named:"help_dark.png")!
let tabBarProfile:UIImage = UIImage(named:"profile_dark.png")!

let tabBarSearchSelected:UIImage = UIImage(named: "search_orange.png")!
let tabBarNelpSelected:UIImage = UIImage(named:"help_orange.png")!
let tabBarProfileSelected:UIImage = UIImage(named:"profile_orange.png")!



/**
Transforms hex number in a UIColor

- parameter hex: Hex Code

- returns: UIColor
*/
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