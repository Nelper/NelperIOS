//
//  UIElements.swift
//  Nelper
//
//  Created by Pierre-Luc Benoit on 2015-10-14.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation
import UIKit

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
	
	required init(coder: NSCoder) {
		super.init(coder: coder)!
		
		createView()
	}
	
	func createView() {
		for subview in self.subviews {
			subview.removeFromSuperview()
		}
		
		let backgroundView = UIView()
		self.backgroundView = backgroundView
		self.addSubview(self.backgroundView)
		self.backgroundView.backgroundColor = darkGrayDetails.colorWithAlphaComponent(0.8)
		self.backgroundView.layer.borderColor = grayDetails.CGColor
		self.backgroundView.layer.borderWidth = 1
		self.backgroundView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self.snp_edges)
		}
		
		let titleView = UIView()
		self.titleView = titleView
		self.backgroundView.addSubview(self.titleView)
		self.titleView.backgroundColor = whitePrimary
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
		self.titleLabel.textColor = blackPrimary
		self.titleLabel.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(self.titleView.snp_centerY)
			make.left.equalTo(self.titleView.snp_left).offset(20)
		}
		
		let contentView = UIView()
		self.contentView = contentView
		self.backgroundView.addSubview(self.contentView)
		self.contentView.backgroundColor = whitePrimary
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
		self.contentView.backgroundColor = whitePrimary
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
		self.font = UIFont(name: "Lato-Regular", size: kText15)
		self.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
		self.textColor = textFieldTextColor
		self.backgroundColor = whitePrimary
		self.layer.borderWidth = 1
		self.layer.borderColor = grayDetails.CGColor
		self.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(50)
		}
	}
	
}