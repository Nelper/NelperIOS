//
//  NavBar.swift
//  Nelper
//
//  Created by Janic Duplessis on 2015-08-06.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation

class NavBar: UINavigationBar {
	
	private var container: UIView!
	private var logoutButton: UIButton!
	private var logoView: UIImageView!
	private var titleView: UILabel!
	private var backButtonView: UIButton?
	private var closeButtonView: UIButton?
	private var saveButtonView: UIButton?
	private var filtersButtonView: UIButton?
	private var deleteButtonView: UIButton?
	private var backArrow:UIImageView!
	private var closeX:UIImageView!
	
	var backButton: UIButton? {
		didSet {
			if let value = backButton {
				self.backButtonView?.removeFromSuperview()
				self.backButtonView = value
				self.backButtonView?.setImage(UIImage(named: "left-white-arrow"), forState: UIControlState.Normal)
				self.backButtonView?.backgroundColor = UIColor.clearColor()
				self.backButtonView?.imageEdgeInsets = UIEdgeInsetsMake(28, 22, 22, 58)
				self.container.addSubview(self.backButtonView!)
				self.backButtonView?.snp_makeConstraints(closure: { (make) -> Void in
					make.left.equalTo(self.container.snp_left)
					make.centerY.equalTo(self.container.snp_centerY).offset(8)
					make.height.equalTo(70)
					make.width.equalTo(100)
				})
			}
		}
	}
	
	var closeButton: UIButton? {
		didSet {
			if let value = closeButton {
				self.closeButtonView?.removeFromSuperview()
				self.closeButtonView = value
				self.closeButtonView?.setImage(UIImage(named: "white-x"), forState: UIControlState.Normal)
				self.closeButtonView?.imageEdgeInsets = UIEdgeInsetsMake(27, 20, 27, 34)
				self.container.addSubview(self.closeButtonView!)
				self.closeButtonView?.snp_makeConstraints(closure: { (make) -> Void in
					make.left.equalTo(self.container.snp_left)
					make.centerY.equalTo(self.container.snp_centerY).offset(9)
					make.height.equalTo(70)
					make.width.equalTo(70)
				})
			}
		}
	}
	
	var saveButton: UIButton? {
		didSet {
			if let value = saveButton {
				self.saveButtonView?.removeFromSuperview()
				self.saveButtonView = value
				self.saveButtonView?.backgroundColor = whitePrimary.colorWithAlphaComponent(0)
				self.saveButtonView?.setTitle("Save", forState: UIControlState.Normal)
				self.saveButtonView?.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
				self.saveButtonView?.setTitleColor(whitePrimary, forState: UIControlState.Normal)
				self.saveButtonView?.setTitleColor(darkGrayDetails, forState: UIControlState.Highlighted)
				self.saveButtonView?.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
				self.saveButtonView?.titleLabel?.font = UIFont(name: "Lato-Regular", size: kTitle17)
				self.container.addSubview(self.saveButtonView!)
				self.saveButtonView?.snp_makeConstraints { (make) -> Void in
					make.centerY.equalTo(self.container.snp_centerY).offset(9)
					make.right.equalTo(self.self.container.snp_right)
					make.height.equalTo(70)
					make.width.equalTo(100)
				}
			}
		}
	}
	
	var filtersButton: UIButton? {
		didSet {
			if let value = filtersButton {
				self.filtersButtonView?.removeFromSuperview()
				self.filtersButtonView = value
				self.filtersButtonView?.backgroundColor = whitePrimary.colorWithAlphaComponent(0)
				self.filtersButtonView?.setTitle("Filters", forState: UIControlState.Normal)
				self.filtersButtonView?.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
				self.filtersButtonView?.setTitleColor(whitePrimary, forState: UIControlState.Normal)
				self.filtersButtonView?.setTitleColor(darkGrayDetails, forState: UIControlState.Highlighted)
				self.filtersButtonView?.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
				self.filtersButtonView?.titleLabel?.font = UIFont(name: "Lato-Regular", size: kTitle17)
				self.container.addSubview(self.filtersButtonView!)
				self.filtersButtonView?.snp_makeConstraints { (make) -> Void in
					make.centerY.equalTo(self.container.snp_centerY).offset(9)
					make.right.equalTo(self.self.container.snp_right)
					make.height.equalTo(70)
					make.width.equalTo(100)
				}
			}
		}
	}
	
	var deleteButton: UIButton? {
		didSet {
			if let value = deleteButton {
				self.deleteButtonView?.removeFromSuperview()
				self.deleteButtonView = value
				self.deleteButtonView?.setImage(UIImage(named: "remove-navbar"), forState: UIControlState.Normal)
				self.deleteButtonView?.imageEdgeInsets = UIEdgeInsetsMake(26, 54, 24, 26)
				self.container.addSubview(self.deleteButtonView!)
				self.deleteButtonView?.snp_makeConstraints(closure: { (make) -> Void in
					make.right.equalTo(self.container.snp_right)
					make.centerY.equalTo(self.container.snp_centerY).offset(9)
					make.height.equalTo(70)
					make.width.equalTo(100)
				})
			}
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.adjustUI()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.adjustUI()
	}
	
	func adjustUI() {
		
		self.container = UIView()
		self.container.backgroundColor = navBarColor
		self.addSubview(self.container)
		self.container.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self)
		}
		
		self.titleView = UILabel()
		self.titleView.font = UIFont(name: "Lato-Regular", size: 17)
		self.titleView.textColor = whitePrimary
		self.titleView.sizeToFit()
		
		self.container.addSubview(self.titleView)
		self.titleView.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(self.container.snp_centerX)
			make.centerY.equalTo(self.container.snp_centerY).offset(9)
		}
	}
	
	func setTitle(title:String) {
		self.titleView.text = title
	}
}