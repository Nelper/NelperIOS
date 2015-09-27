//
//  Button.swift
//  Nelper
//
//  Created by Pierre-Luc Benoit on 2015-09-27.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation
import UIKit

class PrimaryActionButton: UIButton {
	
	private var buttonColor = redPrimary
	private var buttonLabelColor = whitePrimary
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		createView()
	}
	
	required init(coder: NSCoder) {
		super.init(coder: coder)!
		createView()
	}
	
	func createView() {
		self.setTitleColor(whitePrimary, forState: UIControlState.Normal)
		self.backgroundColor = buttonColor
		self.titleLabel?.font = UIFont(name: "Lato-Regular", size: kTitle17)
		self.setTitleColor(buttonLabelColor, forState: UIControlState.Normal)
		self.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(40)
			make.width.equalTo(220)
		}
	}
}

class SecondaryActionButton: UIButton {
	
	private var buttonColor = whiteBackground
	private var buttonBorderColor = darkGrayDetails
	private var buttonBorderWidth: CGFloat = 0.5
	private var buttonLabelColor = darkGrayDetails
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		createView()
	}
	
	required init(coder: NSCoder) {
		super.init(coder: coder)!
		createView()
	}
	
	func createView() {
		self.setTitleColor(whitePrimary, forState: UIControlState.Normal)
		self.backgroundColor = buttonColor
		self.layer.borderColor = buttonBorderColor.CGColor
		self.layer.borderWidth = buttonBorderWidth
		self.titleLabel?.font = UIFont(name: "Lato-Regular", size: kTitle17)
		self.setTitleColor(buttonLabelColor, forState: UIControlState.Normal)
		self.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(40)
			make.width.equalTo(220)
		}
	}
}