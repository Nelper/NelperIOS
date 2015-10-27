//
//  File.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-07-12.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation
import UIKit


//COLORS

let whiteBackground = hexStringToUIColor("eaeaea")
let blackPrimary = hexStringToUIColor("2c2c2c")
let redPrimary = hexStringToUIColor("ed4b4e")

let redPrimarySelected = hexStringToUIColor("f16f71")

let whitePrimary = hexStringToUIColor("f7f7f7")
let grayDetails = hexStringToUIColor("e1e1e1")
let darkGrayDetails = hexStringToUIColor("979797")
let darkGrayText = hexStringToUIColor("3d3d3d")

let textFieldTextColor = darkGrayText.colorWithAlphaComponent(0.8)
let textFieldPlaceholderColor = darkGrayText.colorWithAlphaComponent(0.5)

let progressGreen = hexStringToUIColor("29B473")
let pendingYellow = hexStringToUIColor("F7CC39")

let greenProfile = hexStringToUIColor("29b48f")

let blueFacebook = hexStringToUIColor("3b5998")
let blueFacebookSelected = hexStringToUIColor("4f6aa2")
let blueTwitter = hexStringToUIColor("55acee")
let blueTwitterSelected = hexStringToUIColor("77bdf1")

let greenPriceButton = hexStringToUIColor("80bf62")

let grayBlue = hexStringToUIColor("5a6a7b")

let navBarColor = redPrimary
let tabBarColor = whitePrimary

let mapKitBeigeBackground = hexStringToUIColor("f9f4ec")

//IMAGES

let tabBarSearch:UIImage = UIImage(named: "search_dark.png")!
let tabBarNelp:UIImage = UIImage(named: "help_dark.png")!
let tabBarProfile:UIImage = UIImage(named: "profile_dark.png")!

let tabBarSearchSelected:UIImage = UIImage(named: "search_orange.png")!
let tabBarNelpSelected:UIImage = UIImage(named: "help_orange.png")!
let tabBarProfileSelected:UIImage = UIImage(named: "profile_orange.png")!

//TEXT

let blackTextColor = hexStringToUIColor("3d3d3d")


/**
Transforms hex number in a UIColor

- parameter hex: Hex Code

- returns: UIColor
*/

func hexStringToUIColor (hex:String) -> UIColor {
	var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
	
	if (cString.hasPrefix("#")) {
		cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
	}
	
	if (cString.characters.count != 6) {
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