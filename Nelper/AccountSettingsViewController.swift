//
//  AccountSettingsViewController.swift
//  Nelper
//
//  Created by Pierre-Luc Benoit on 2015-10-14.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation
import UIKit

class AccountSettingsViewController: UIViewController {
	
	private var navBar: NavBar!
	
	private var backgroundView: UIView!
	private var scrollView: UIScrollView!
	private var contentView: UIView!
	
	var generalContainer: DefaultContainerView!
	//var emailLabel: UILabel!
	//var emailTextField: UITextField!
	//var phoneLabel: UILabel!
	//var phoneTextField: UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		createView()
		adjustUI()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		self.scrollView.contentSize = self.contentView.frame.size
	}
	
	func createView() {
		
		//NAVBAR
		let navBar = NavBar()
		self.navBar = navBar
		self.view.addSubview(self.navBar)
		self.navBar.setTitle("Account Settings")
		self.navBar.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.view.snp_top)
			make.right.equalTo(self.view.snp_right)
			make.left.equalTo(self.view.snp_left)
			make.height.equalTo(64)
		}
		
		let backgroundView = UIView()
		self.backgroundView = backgroundView
		self.view.addSubview(self.backgroundView)
		self.backgroundView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.navBar.snp_bottom)
			make.left.equalTo(self.view.snp_left)
			make.right.equalTo(self.view.snp_right)
			make.bottom.equalTo(self.view.snp_bottom)
		}
		
		let scrollView = UIScrollView()
		self.scrollView = scrollView
		self.backgroundView.addSubview(self.scrollView)
		self.scrollView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self.backgroundView.snp_edges)
		}
		
		let contentView = UIView()
		self.contentView = contentView
		self.scrollView.addSubview(self.contentView)
		self.contentView.backgroundColor = whiteBackground
		self.contentView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.scrollView.snp_top)
			make.left.equalTo(self.scrollView.snp_left)
			make.right.equalTo(self.scrollView.snp_right)
			make.height.greaterThanOrEqualTo(self.backgroundView.snp_height)
			make.width.equalTo(self.backgroundView.snp_width)
		}
		
		let generalContainer = DefaultContainerView()
		self.generalContainer = generalContainer
		self.contentView.addSubview(self.generalContainer)
		self.generalContainer.containerTitle = "General"
		self.generalContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.contentView.snp_top).offset(20)
			make.left.equalTo(self.contentView.snp_left)
			make.right.equalTo(self.contentView.snp_right)
			make.height.equalTo(200)
		}
		
	}
	
	func adjustUI() {
		
		//NAVBAR
		let previousBtn = UIButton()
		previousBtn.addTarget(self, action: "backButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		self.navBar.closeButton = previousBtn
	}
	
	//MARK: ACTIONS
	func backButtonTapped(sender: UIButton) {
		self.dismissViewControllerAnimated(true, completion: nil)
		view.endEditing(true) // dissmiss keyboard without delay
	}
}