//
//  TransactionsSettingsViewController.swift
//  Nelper
//
//  Created by Pierre-Luc Benoit on 2015-10-14.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation
import UIKit

class TransactionsSettingsViewController: UIViewController {
	
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
		self.navBar.setTitle("Transaction History")
		self.navBar.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.view.snp_top)
			make.right.equalTo(self.view.snp_right)
			make.left.equalTo(self.view.snp_left)
			make.height.equalTo(64)
		}
		
		let contentView = UIView()
		self.contentView = contentView
		self.view.addSubview(contentView)
		self.contentView.backgroundColor = whiteBackground
		self.contentView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.navBar.snp_bottom)
			make.left.equalTo(self.view.snp_left)
			make.right.equalTo(self.view.snp_right)
			make.bottom.equalTo(self.view.snp_bottom)
		}
	}
	
	func adjustUI() {
		
		//NAVBAR
		let previousBtn = UIButton()
		previousBtn.addTarget(self, action: "backButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		self.navBar.closeButton = previousBtn
		self.contentView.backgroundColor = whiteBackground
	}
	
	//MARK: ACTIONS
	func backButtonTapped(sender: UIButton) {
		self.dismissViewControllerAnimated(true, completion: nil)
		view.endEditing(true) // dissmiss keyboard without delay
	}
}