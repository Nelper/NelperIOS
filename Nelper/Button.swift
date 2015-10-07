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
	
	private var buttonColor = redPrimary
	private var buttonColorSelected = redPrimarySelected
	private var buttonLabelColor = whitePrimary
	
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
		self.setTitleColor(whitePrimary, forState: UIControlState.Normal)
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

class SecondaryActionButton: UIButton {
	
	private var buttonColor = whiteBackground
	private var buttonBorderColor = darkGrayDetails
	private var buttonBorderWidth: CGFloat = 0.5
	private var buttonLabelColor = darkGrayDetails
	private var buttonLabelColorSelected = blackPrimary
	
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
		self.setTitleColor(whitePrimary, forState: UIControlState.Normal)
		self.backgroundColor = buttonColor
		self.layer.borderColor = buttonBorderColor.CGColor
		self.layer.borderWidth = buttonBorderWidth
		self.titleLabel?.font = UIFont(name: "Lato-Regular", size: kTitle17)
		self.setTitleColor(buttonLabelColor, forState: UIControlState.Normal)
		self.setTitleColor(buttonLabelColorSelected, forState: UIControlState.Highlighted)
		self.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(height)
			make.width.equalTo(width)
		}
	}
}