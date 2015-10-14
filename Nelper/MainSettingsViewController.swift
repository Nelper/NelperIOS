//
//  File.swift
//  Nelper
//
//  Created by Pierre-Luc Benoit on 2015-10-13.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation
import UIKit

class MainSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	private var contentView: UIView!
	var navBar: NavBar!
	
	private var tableView: UITableView!
	var sections = [String]()
	
	private var cellHeight = CGFloat()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		cellHeight = 60
		
		self.sections = [
			"Account",
			"Notifications",
			"Bank Deposits",
			"Transaction History"
		]
		
		createView()
		createTableView()
		adjustUI()
	}

	func createView() {
		
		//NAVBAR
		let navBar = NavBar()
		self.navBar = navBar
		self.view.addSubview(self.navBar)
		self.navBar.setTitle("Settings")
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
	
	func createTableView() {
		let tableView = UITableView()
		self.tableView = tableView
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.tableView.registerClass(MainSettingsViewCell.classForCoder(), forCellReuseIdentifier: MainSettingsViewCell.reuseIdentifier)
		self.tableView.backgroundColor = whiteBackground
		self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
		self.contentView.addSubview(tableView)
		self.tableView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.contentView.snp_top)
			make.right.equalTo(self.contentView.snp_right)
			make.left.equalTo(self.contentView.snp_left)
			make.bottom.equalTo(self.contentView.snp_bottom)
		}
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.sections.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = self.tableView.dequeueReusableCellWithIdentifier(MainSettingsViewCell.reuseIdentifier, forIndexPath: indexPath) as! MainSettingsViewCell
		
		let sectionTitle = self.sections[indexPath.row]
		cell.setSectionTitle(sectionTitle)
		
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		/*let selectedTask = self.nelpTasks[indexPath.row]
		let vc = BrowseDetailsViewController()
		vc.task = selectedTask
		self.presentViewController(vc, animated: false, completion: nil)*/
	}
	
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return cellHeight
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