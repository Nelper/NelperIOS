//
//  Button.swift
//  Nelper
//
//  Created by Pierre-Luc Benoit on 2015-09-27.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
	func setBackgroundColor(color: UIColor, forState: UIControlState) {
		UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
		CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), color.CGColor)
		CGContextFillRect(UIGraphicsGetCurrentContext(), CGRect(x: 0, y: 0, width: 1, height: 1))
		let colorImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		self.setBackgroundImage(colorImage, forState: forState)
	}
}

class PrimaryActionButton: UIButton {
	
	private var buttonColor = Color.redPrimary
	private var buttonColorSelected = Color.redPrimarySelected
	private var buttonLabelColor = Color.whitePrimary
	
	var height = 40 {
		didSet {
			setSize()
		}
	}
	
	var width = 220 {
		didSet {
			setSize()
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		createView()
	}
	
	required init(coder: NSCoder) {
		super.init(coder: coder)!
		createView()
	}
	
	func setSize() {
		self.snp_updateConstraints { (make) -> Void in
			make.height.equalTo(height)
			make.width.equalTo(width)
		}
	}
	
	func createView() {
		self.setTitleColor(Color.whitePrimary, forState: UIControlState.Normal)
		self.setBackgroundColor(buttonColor, forState: UIControlState.Normal)
		self.setBackgroundColor(buttonColorSelected, forState: UIControlState.Highlighted)
		self.titleLabel?.font = UIFont(name: "Lato-Regular", size: kTitle17)
		self.setTitleColor(buttonLabelColor, forState: UIControlState.Normal)
		self.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(height)
			make.width.equalTo(width)
		}
	}
}

class PrimaryBorderActionButton: UIButton {
	
	private var buttonColor = UIColor.clearColor()
	private var buttonColorSelected = Color.redPrimary
	private var buttonLabelColor = Color.redPrimary
	private var buttonLabelSelectedColor = Color.whitePrimary
	private var buttonBorderWidth: CGFloat = 1
	private var buttonBorderColor = Color.redPrimary
	
	var height = 40 {
		didSet {
			setSize()
		}
	}
	
	var width = 220 {
		didSet {
			setSize()
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		createView()
	}
	
	required init(coder: NSCoder) {
		super.init(coder: coder)!
		createView()
	}
	
	func setSize() {
		self.snp_updateConstraints { (make) -> Void in
			make.height.equalTo(height)
			make.width.equalTo(width)
		}
	}
	
	func createView() {
		self.setTitleColor(Color.whitePrimary, forState: UIControlState.Normal)
		self.setBackgroundColor(buttonColor, forState: UIControlState.Normal)
		self.setBackgroundColor(buttonColorSelected, forState: UIControlState.Highlighted)
		self.titleLabel?.font = UIFont(name: "Lato-Regular", size: kTitle17)
		self.setTitleColor(buttonLabelColor, forState: UIControlState.Normal)
		self.setTitleColor(buttonLabelSelectedColor, forState: UIControlState.Highlighted)
		self.layer.borderWidth = buttonBorderWidth
		self.layer.borderColor = buttonBorderColor.CGColor
		self.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(height)
			make.width.equalTo(width)
		}
	}
}

class SecondaryActionButton: UIButton {
	
	private var buttonColor = Color.whiteBackground
	private var buttonBorderColor = Color.darkGrayDetails
	private var buttonBorderWidth: CGFloat = 0.5
	private var buttonLabelColor = Color.darkGrayDetails
	private var buttonLabelColorSelected = Color.blackPrimary
	
	var height = 40 {
		didSet {
			setSize()
		}
	}
	
	var width = 220 {
		didSet {
			setSize()
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		createView()
	}
	
	required init(coder: NSCoder) {
		super.init(coder: coder)!
		createView()
	}
	
	func setSize() {
		self.snp_updateConstraints { (make) -> Void in
			make.height.equalTo(height)
			make.width.equalTo(width)
		}
	}
	
	func createView() {
		self.setTitleColor(Color.whitePrimary, forState: UIControlState.Normal)
		self.backgroundColor = buttonColor
		self.layer.borderColor = buttonBorderColor.CGColor
		self.layer.borderWidth = buttonBorderWidth
		self.titleLabel?.font = UIFont(name: "Lato-Light", size: kTitle17)
		self.setTitleColor(buttonLabelColor, forState: UIControlState.Normal)
		self.setTitleColor(buttonLabelColorSelected, forState: UIControlState.Highlighted)
		self.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(height)
			make.width.equalTo(width)
		}
	}
}

class AccountSettingsLocationButton: UIButton {
	var assignedLocationIndex: Int!
}