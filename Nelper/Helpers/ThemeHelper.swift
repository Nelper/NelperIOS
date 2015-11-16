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

struct Color{
	
static let whiteBackground = hexStringToUIColor("eaeaea")
static let blackPrimary = hexStringToUIColor("2c2c2c")
static let redPrimary = hexStringToUIColor("ed4b4e")

static let redPrimarySelected = hexStringToUIColor("f16f71")

static let whitePrimary = hexStringToUIColor("f7f7f7")
static let grayDetails = hexStringToUIColor("e1e1e1")
static let darkGrayDetails = hexStringToUIColor("979797")
static let darkGrayText = hexStringToUIColor("3d3d3d")

static let textFieldTextColor = Color.darkGrayText.colorWithAlphaComponent(0.8)
static let textFieldPlaceholderColor = Color.darkGrayText.colorWithAlphaComponent(0.5)

static let progressGreen = hexStringToUIColor("29B473")
static let pendingYellow = hexStringToUIColor("F7CC39")

static let greenProfile = hexStringToUIColor("29b48f")

static let blueFacebook = hexStringToUIColor("3b5998")
static let blueFacebookSelected = hexStringToUIColor("4f6aa2")
static let blueTwitter = hexStringToUIColor("55acee")
static let blueTwitterSelected = hexStringToUIColor("77bdf1")

static let greenPriceButton = hexStringToUIColor("80bf62")

static let grayBlue = hexStringToUIColor("5a6a7b")

static let navBarColor = Color.redPrimary
static let tabBarColor = Color.whitePrimary

static let mapKitBeigeBackground = hexStringToUIColor("f9f4ec")
	
//TEXT
	
static let blackTextColor = hexStringToUIColor("3d3d3d")
	
}

//IMAGES

let tabBarSearch:UIImage = UIImage(named: "search_dark.png")!
let tabBarNelp:UIImage = UIImage(named: "help_dark.png")!
let tabBarProfile:UIImage = UIImage(named: "profile_dark.png")!

let tabBarSearchSelected:UIImage = UIImage(named: "search_orange.png")!
let tabBarNelpSelected:UIImage = UIImage(named: "help_orange.png")!
let tabBarProfileSelected:UIImage = UIImage(named: "profile_orange.png")!




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