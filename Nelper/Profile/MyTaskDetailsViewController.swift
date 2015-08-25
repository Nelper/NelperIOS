//
//  MyTaskDetailsViewController.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-08-17.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import iCarousel

class MyTaskDetailsViewController: UIViewController{
	
	@IBOutlet weak var navBar: NavBar!
	@IBOutlet weak var container: UIView!
	@IBOutlet weak var scrollView: UIScrollView!
	
	var contentView:UIView!
	var categoryIcon:UIImageView!
	var task: FindNelpTask!
	var applicantsTableView: UITableView!
	var arrayOfApplicants = [User]()
	
	override func viewDidLoad() {
		self.createView()
		self.adjustUI()
	}
	
	//Initialization
	
	convenience init(findNelpTask:FindNelpTask) {
		self.init(nibName: "MyTaskDetailsViewController", bundle: nil)
		self.task = findNelpTask
	}
	
	func createView(){
		
		//ContentView
		
		var contentView = UIView()
		self.contentView = contentView
		self.scrollView.addSubview(contentView)
		contentView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.scrollView.snp_top)
			make.left.equalTo(self.scrollView.snp_left)
			make.right.equalTo(self.scrollView.snp_right)
			make.height.greaterThanOrEqualTo(self.container.snp_height)
			make.width.equalTo(self.container.snp_width)
		}
		
		//Task Section
		
		var taskSectionContainer = UIView()
		self.contentView.addSubview(taskSectionContainer)
		taskSectionContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(navBar.snp_bottom)
			make.left.equalTo(self.contentView.snp_left)
			make.right.equalTo(self.contentView.snp_right)
			make.height.equalTo(110)
		}
		taskSectionContainer.backgroundColor = blueGrayColor
//		taskSectionContainer.layer.borderColor = darkGrayDetails.CGColor
//		taskSectionContainer.layer.borderWidth = 1
		

//		var categoryIcon = UIImageView()
//		self.categoryIcon = categoryIcon
//		contentView.addSubview(categoryIcon)
//		self.categoryIcon.contentMode = UIViewContentMode.ScaleAspectFill
//		self.categoryIcon.snp_makeConstraints { (make) -> Void in
//			make.height.equalTo(60)
//			make.width.equalTo(60)
//			make.centerX.equalTo(taskSectionContainer.snp_centerX)
//			make.centerY.equalTo(taskSectionContainer.snp_top)
//		}
//		self.setImages(self.task)
		
		var title = UILabel()
		taskSectionContainer.addSubview(title)
		title.text = self.task.title
		title.textColor = navBarColor
		title.font = UIFont(name: "ABeeZee-Regular", size: kTitleFontSize)
		title.textAlignment = NSTextAlignment.Center
		title.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(taskSectionContainer.snp_top).offset(8)
			make.centerX.equalTo(taskSectionContainer.snp_centerX)
		}
		
		var editButton = UIButton()
		taskSectionContainer.addSubview(editButton)
		editButton.addTarget(self, action: "editButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		editButton.setTitle("Edit Task", forState: UIControlState.Normal)
		editButton.titleLabel!.font = UIFont(name: "ABeeZee-Regular", size: kTextFontSize)
		editButton.setTitleColor(whiteNelpyColor, forState: UIControlState.Normal)
		editButton.backgroundColor = blueGrayColor
		editButton.layer.borderWidth = 2
		editButton.layer.borderColor = navBarColor.CGColor
		editButton.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(title.snp_bottom).offset(16)
			make.centerX.equalTo(taskSectionContainer.snp_centerX)
			make.width.equalTo(140)
			make.height.equalTo(35)
		}

		

		//Applicants Table View
//		var applicantsTableView = UITableView()
//		self.applicantsTableView = applicantsTableView
//		self.applicantsTableView.dataSource = self
//		self.applicantsTableView.delegate = self
//		contentView.addSubview(applicantsTableView)
		}
	
	
	//UI
	func adjustUI(){
		self.container.backgroundColor = whiteNelpyColor
		let backBtn = UIButton()
		backBtn.addTarget(self, action: "backButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		self.navBar.backButton = backBtn
		self.scrollView.backgroundColor = whiteNelpyColor
	}
	
	func setImages(nelpTask:FindNelpTask){
		self.categoryIcon.layer.cornerRadius = self.categoryIcon.frame.size.width / 2;
		self.categoryIcon.clipsToBounds = true
		self.categoryIcon.image = UIImage(named: nelpTask.category!)
	}
	
	//Table View Delegate Methods
//	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		return self.arrayOfApplicants.count
//	}
//	
//	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//	
//	}
//	
//	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//		
//	}
//	
//	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//		return 100
//	}
	
	//Actions
	
	func editButtonTapped(sender:UIButton){
		
	}
	
	func backButtonTapped(sender:UIButton){
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
}