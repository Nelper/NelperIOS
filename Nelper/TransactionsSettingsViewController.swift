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
		self.view.addSubview(navBar)
		navBar.setTitle("Transaction History")
		let previousBtn = UIButton()
		previousBtn.addTarget(self, action: "backButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		navBar.backButton = previousBtn
		navBar.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.view.snp_top)
			make.right.equalTo(self.view.snp_right)
			make.left.equalTo(self.view.snp_left)
			make.height.equalTo(64)
		}
		
		let contentView = UIView()
		self.contentView = contentView
		self.view.addSubview(contentView)
		contentView.backgroundColor = Color.whiteBackground
		contentView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(navBar.snp_bottom)
			make.left.equalTo(self.view.snp_left)
			make.right.equalTo(self.view.snp_right)
			make.bottom.equalTo(self.view.snp_bottom)
		}
		
		let giveFeedbackView = GiveFeedbackView()
		self.addChildViewController(giveFeedbackView)
		giveFeedbackView.didMoveToParentViewController(self)
		contentView.addSubview(giveFeedbackView.view)
		giveFeedbackView.view.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(contentView.snp_edges)
		}
	}
	
	func adjustUI() {
	
	}
	
	//MARK: ACTIONS
	func backButtonTapped(sender: UIButton) {
		self.navigationController?.popViewControllerAnimated(true)
		view.endEditing(true)
	}
}