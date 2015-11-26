//
//  UIElements.swift
//  Nelper
//
//  Created by Pierre-Luc Benoit on 2015-10-14.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation
import UIKit
import ParkedTextField

class DefaultContainerView: UIView {
	
	var backgroundView: UIView!
	var contentView: UIView!
	var titleView: UIView!
	var titleLabel: UILabel!
	var titleLine: UIView!
	
	var titleViewHeight = 50
	
	var containerTitle: String! {
		didSet {
			createView()
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		createView()
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	func createView() {
		for subview in self.subviews {
			subview.removeFromSuperview()
		}
		
		let backgroundView = UIView()
		self.backgroundView = backgroundView
		self.addSubview(self.backgroundView)
		self.backgroundView.backgroundColor = Color.grayDetails
		self.backgroundView.layer.borderColor = Color.grayDetails.CGColor
		self.backgroundView.layer.borderWidth = 1
		self.backgroundView.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(self.snp_left).offset(-1)
			make.right.equalTo(self.snp_right).offset(1)
			make.top.equalTo(self.snp_top)
			make.bottom.equalTo(self.snp_bottom)
		}
		
		let titleView = UIView()
		self.titleView = titleView
		self.backgroundView.addSubview(self.titleView)
		self.titleView.backgroundColor = Color.whitePrimary
		self.titleView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.backgroundView.snp_top)
			make.left.equalTo(self.backgroundView.snp_left)
			make.right.equalTo(self.backgroundView.snp_right)
			make.height.equalTo(titleViewHeight)
		}
		
		let titleLabel = UILabel()
		self.titleLabel = titleLabel
		self.titleView.addSubview(self.titleLabel)
		self.titleLabel.text = containerTitle
		self.titleLabel.font = UIFont(name: "Lato-Regular", size: kNavTitle18)
		self.titleLabel.textColor = Color.blackPrimary
		self.titleLabel.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(self.titleView.snp_centerY)
			make.left.equalTo(self.titleView.snp_left).offset(20)
		}
		
		let contentView = UIView()
		self.contentView = contentView
		self.backgroundView.addSubview(self.contentView)
		self.contentView.backgroundColor = Color.whitePrimary
		self.contentView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.titleView.snp_bottom).offset(0.5)
			make.left.equalTo(self.backgroundView.snp_left)
			make.right.equalTo(self.backgroundView.snp_right)
			make.bottom.equalTo(self.backgroundView.snp_bottom)
		}
		
		/*if no title...
		let contentView = UIView()
		self.contentView = contentView
		self.backgroundView.addSubview(self.contentView)
		self.contentView.backgroundColor = Color.whitePrimary
		self.contentView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.backgroundView.snp_top)
			make.left.equalTo(self.backgroundView.snp_left)
			make.right.equalTo(self.backgroundView.snp_right)
			make.bottom.equalTo(self.backgroundView.snp_bottom)
		}*/
	}
}

class DefaultTextFieldView: UITextField {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		createView()
	}
	
	required init(coder: NSCoder) {
		super.init(coder: coder)!
		
		createView()
	}
	
	func createView() {
		self.backgroundColor = Color.whitePrimary
		
		self.clearButtonMode = .WhileEditing
		
		self.textAlignment = .Left
		self.font = UIFont(name: "Lato-Regular", size: kText15)
		self.textColor = Color.textFieldTextColor
		self.autocorrectionType = .No
		
		self.layer.borderWidth = 1
		self.layer.borderColor = Color.grayDetails.CGColor
		
		
		self.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(50)
		}
		
		let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.size.height))
		leftView.backgroundColor = self.backgroundColor
		self.leftView = leftView
		self.leftViewMode = .Always
	}
}

extension ParkedTextField {
	func addLeftView(inset: CGFloat) {
		let leftView = UIView(frame: CGRect(x: 0, y: 0, width: inset, height: self.frame.size.height))
		leftView.backgroundColor = self.backgroundColor
		self.leftView = leftView
		self.leftViewMode = .Always
	}
}

class ShowPasswordButton: UIButton {
	
	var assignedTextField: UITextField?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		createView()
	}
	
	required init(coder: NSCoder) {
		super.init(coder: coder)!
		
		createView()
	}
	
	func createView() {
		self.setImage(UIImage(named: "show"), forState: .Normal)
		self.contentMode = .ScaleAspectFit
		self.snp_makeConstraints { (make) -> Void in
			make.width.equalTo(35)
			make.height.equalTo(35)
		}

	}
}