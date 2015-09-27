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
	private var backArrow:UIImageView!
	private var closeX:UIImageView!
	
	var backButton: UIButton? {
		didSet {
			if let value = backButton {
				self.backButtonView?.removeFromSuperview()
				self.backButtonView = value
				self.backButtonView?.setImage(UIImage(named: "left-white-arrow"), forState: UIControlState.Normal)
				self.backButtonView?.imageEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20)
				self.container.addSubview(self.backButtonView!)
				
				self.backButtonView?.snp_makeConstraints(closure: { (make) -> Void in
					make.left.equalTo(self.container.snp_left)
					make.centerY.equalTo(self.container.snp_centerY).offset(8)
					make.height.equalTo(60)
					make.width.equalTo(60)
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
				self.closeButtonView?.imageEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20)
				self.container.addSubview(self.closeButtonView!)
				
				self.closeButtonView?.snp_makeConstraints(closure: { (make) -> Void in
					make.left.equalTo(self.container.snp_left)
					make.centerY.equalTo(self.container.snp_centerY).offset(8)
					make.height.equalTo(60)
					make.width.equalTo(60)
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
		self.translucent = false
		self.shadowImage = UIImage()
		self.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
		self.layer.shadowColor = UIColor.blackColor().CGColor
		self.layer.shadowOffset = CGSizeMake(0.0, 3)
		self.layer.shadowOpacity = 0.25
		self.layer.masksToBounds = false
		self.layer.shouldRasterize = true
		
		self.container = UIView()
		self.container.backgroundColor = navBarColor
		self.addSubview(self.container)
		self.container.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self)
		}
		
		self.titleView = UILabel()
		self.titleView.font = UIFont(name: "Lato-Regular", size: kNavTitle18)
		self.titleView.textColor = whitePrimary
		self.titleView.sizeToFit()
		
		self.container.addSubview(self.titleView)
		self.titleView.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(self.container.snp_centerX).offset(0)
			make.centerY.equalTo(self.container.snp_centerY).offset(8)
		}
		
		//Logout Button (temporary)
		self.logoutButton = UIButton()
		self.logoutButton.setTitle("logout", forState: UIControlState.Normal)
		self.logoutButton.titleLabel?.font = UIFont(name: "Lato-Regular", size: 12)
		self.logoutButton.titleLabel?.textColor = whitePrimary
		self.logoutButton.alpha = 0.3
		self.addSubview(logoutButton)
		
		self.logoutButton.addTarget(self, action: "logoutButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		
		logoutButton.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(container.snp_bottom)
			make.centerX.equalTo(container.snp_centerX)
			make.height.equalTo(20)
			make.width.equalTo(50)
		}
	}
	
	func setTitle(title:String){
		self.titleView.text = title
	}
	
	func logoutButtonTapped(sender: AnyObject) {
		ApiHelper.logout()
		
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		appDelegate.showLogin(true)
	}
}