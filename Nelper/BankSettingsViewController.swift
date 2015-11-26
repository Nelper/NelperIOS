//
//  BankSettingsViewController.swift
//  Nelper
//
//  Created by Pierre-Luc Benoit on 2015-10-14.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation
import UIKit

class BankSettingsViewController: UIViewController {
	
	private var contentView: UIView!
	private var navBar: NavBar!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		createView()
		adjustUI()
	}
	
	func createView() {
		
		//NAVBAR
		let navBar = NavBar()
		self.navBar = navBar
		self.view.addSubview(self.navBar)
		self.navBar.setTitle("Bank Account")
		let previousBtn = UIButton()
		previousBtn.addTarget(self, action: "backButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		self.navBar.backButton = previousBtn
		self.navBar.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.view.snp_top)
			make.right.equalTo(self.view.snp_right)
			make.left.equalTo(self.view.snp_left)
			make.height.equalTo(64)
		}
		
		let contentView = UIView()
		self.contentView = contentView
		self.view.addSubview(contentView)
		self.contentView.backgroundColor = Color.whiteBackground
		self.contentView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.navBar.snp_bottom)
			make.left.equalTo(self.view.snp_left)
			make.right.equalTo(self.view.snp_right)
			make.bottom.equalTo(self.view.snp_bottom)
		}
		
		//Empty Applications/Tasks warning label
		
		let noAccountNotice = UILabel()
		noAccountNotice.textAlignment = NSTextAlignment.Center
		contentView.addSubview(noAccountNotice)
		noAccountNotice.text = "You have not linked a bank account yet"
		noAccountNotice.numberOfLines = 0
		noAccountNotice.font =  UIFont(name: "Lato-Regular", size: kTitle17)
		noAccountNotice.textColor = Color.darkGrayDetails
		noAccountNotice.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(contentView.snp_top).offset(60)
			make.left.equalTo(contentView).offset(30)
			make.right.equalTo(contentView).offset(-30)
		}
		
		
		
		//Go to button
		
		let linkAccountButton = PrimaryActionButton()
		contentView.addSubview(linkAccountButton)
		linkAccountButton.setBackgroundColor(Color.redPrimary, forState: UIControlState.Normal)
		linkAccountButton.setTitleColor(Color.whitePrimary, forState: .Normal)
		linkAccountButton.setTitle("Link a bank account", forState: .Normal)
		linkAccountButton.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(noAccountNotice.snp_bottom).offset(20)
			make.centerX.equalTo(contentView)
		}
	}
	
	func adjustUI() {
		
	}
	
	//MARK: ACTIONS
	func backButtonTapped(sender: UIButton) {
		self.navigationController?.popViewControllerAnimated(true)
		view.endEditing(true) // dismiss keyboard without delay
	}
}