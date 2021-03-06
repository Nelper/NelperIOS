//
//  FaqViewController.swift
//  Nelper
//
//  Created by Pierre-Luc Benoit on 2015-10-30.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class FaqViewController: UIViewController {
	
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
		self.navBar.setTitle("Frequently Asked Questions")
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
		
		let webView = WKWebView()
		self.contentView.addSubview(webView)
		webView.loadRequest(NSURLRequest(URL: NSURL(string: "https://www.nelper.ca/faq")!))
		webView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self.contentView.snp_edges)
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
