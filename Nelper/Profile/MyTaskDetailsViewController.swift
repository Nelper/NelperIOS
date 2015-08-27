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

class MyTaskDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
	
	@IBOutlet weak var navBar: NavBar!
	@IBOutlet weak var container: UIView!
	@IBOutlet weak var scrollView: UIScrollView!
	
	var contentView:UIView!
	var categoryIcon:UIImageView!
	var task: FindNelpTask!
	var applicantsTableView: UITableView!
	var arrayOfApplicants:[User]!
	var activeApplicantsContainer:UIView!
	var deniedApplicantsContainer:UIView!
	var arrayOfDeniedApplicants:[User]!
	var deniedApplicantsTableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.automaticallyAdjustsScrollViewInsets = false
		self.createView()
		self.adjustUI()
	}
	
	override func viewDidAppear(animated: Bool) {
//		self.drawTableViewsSize()
	}
	
	//Initialization
	
	convenience init(findNelpTask:FindNelpTask) {
		self.init(nibName: "MyTaskDetailsViewController", bundle: nil)
		self.task = findNelpTask
		var arrayOfApplications = findNelpTask.applications
		var arrayOfApplicants = [User]()
		for application in arrayOfApplications{
			arrayOfApplicants.append(application.user)
		}
		self.arrayOfApplicants = arrayOfApplicants
		self.arrayOfDeniedApplicants = [User]()
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
			make.top.equalTo(self.contentView.snp_top)
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
		
	//Pending Applicants Container
		
		var activeApplicantsContainer = UIView()
		self.activeApplicantsContainer = activeApplicantsContainer
		self.contentView.addSubview(activeApplicantsContainer)
		activeApplicantsContainer.backgroundColor = navBarColor
		activeApplicantsContainer.layer.borderWidth = 1
		activeApplicantsContainer.layer.borderColor = darkGrayDetails.CGColor
		activeApplicantsContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(taskSectionContainer.snp_bottom).offset(10)
			make.left.equalTo(self.contentView.snp_left)
			make.right.equalTo(self.contentView.snp_right)
			make.height.equalTo((self.arrayOfApplicants.count*120)+70)
		}
		
		var pendingApplicantIcon = UIImageView()
		activeApplicantsContainer.addSubview(pendingApplicantIcon)
		pendingApplicantIcon.image = UIImage(named: "pending.png")
		pendingApplicantIcon.contentMode = UIViewContentMode.ScaleAspectFill
		pendingApplicantIcon.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(activeApplicantsContainer.snp_top).offset(20)
			make.left.equalTo(activeApplicantsContainer.snp_left).offset(10)
			make.height.equalTo(30)
			make.width.equalTo(30)
		}
		
		var applicantsLabel = UILabel()
		activeApplicantsContainer.addSubview(applicantsLabel)
		applicantsLabel.textAlignment = NSTextAlignment.Left
		applicantsLabel.text = "Applicants"
		applicantsLabel.textColor = blackNelpyColor
		applicantsLabel.font = UIFont(name: "ABeeZee-Regular", size: kSubtitleFontSize)
		applicantsLabel.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(pendingApplicantIcon.snp_centerY)
			make.left.equalTo(pendingApplicantIcon.snp_right).offset(6)
		}

		//Applicants Table View
		
		var applicantsTableView = UITableView()
		self.applicantsTableView = applicantsTableView
		applicantsTableView.registerClass(ApplicantCell.classForCoder(), forCellReuseIdentifier: ApplicantCell.reuseIdentifier)
		self.applicantsTableView.scrollEnabled = false
		self.applicantsTableView.dataSource = self
		self.applicantsTableView.delegate = self
		activeApplicantsContainer.addSubview(applicantsTableView)
		applicantsTableView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(applicantsLabel.snp_bottom).offset(20)
			make.left.equalTo(activeApplicantsContainer.snp_left)
			make.right.equalTo(activeApplicantsContainer.snp_right)
			make.bottom.equalTo(activeApplicantsContainer.snp_bottom)
			}
		
		//Denied Applicants
		
		var deniedApplicantsContainer = UIView()
		self.deniedApplicantsContainer = deniedApplicantsContainer
		self.contentView.addSubview(deniedApplicantsContainer)
		deniedApplicantsContainer.backgroundColor = navBarColor
		deniedApplicantsContainer.layer.borderWidth = 1
		deniedApplicantsContainer.layer.borderColor = darkGrayDetails.CGColor
		deniedApplicantsContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(activeApplicantsContainer.snp_bottom).offset(10)
			make.left.equalTo(self.contentView.snp_left)
			make.right.equalTo(self.contentView.snp_right)
			make.height.equalTo((self.arrayOfDeniedApplicants.count*120)+70)
		}
		
		var deniedApplicantIcon = UIImageView()
		deniedApplicantsContainer.addSubview(deniedApplicantIcon)
		deniedApplicantIcon.image = UIImage(named: "denied.png")
		deniedApplicantIcon.contentMode = UIViewContentMode.ScaleAspectFill
		deniedApplicantIcon.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(deniedApplicantsContainer.snp_top).offset(20)
			make.left.equalTo(deniedApplicantsContainer.snp_left).offset(10)
			make.height.equalTo(30)
			make.width.equalTo(30)
		}
		
		var deniedApplicantsLabel = UILabel()
		deniedApplicantsContainer.addSubview(deniedApplicantsLabel)
		deniedApplicantsLabel.textAlignment = NSTextAlignment.Left
		deniedApplicantsLabel.text = "Denied Applicants"
		deniedApplicantsLabel.textColor = blackNelpyColor
		deniedApplicantsLabel.font = UIFont(name: "ABeeZee-Regular", size: kSubtitleFontSize)
		deniedApplicantsLabel.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(deniedApplicantIcon.snp_centerY)
			make.left.equalTo(deniedApplicantIcon.snp_right).offset(6)
		}
		
		//Applicants Table View
		
		var deniedApplicantsTableView = UITableView()
		self.deniedApplicantsTableView = deniedApplicantsTableView
		deniedApplicantsTableView.registerClass(ApplicantCell.classForCoder(), forCellReuseIdentifier: ApplicantCell.reuseIdentifier)
		self.deniedApplicantsTableView.scrollEnabled = false
		self.deniedApplicantsTableView.dataSource = self
		self.deniedApplicantsTableView.delegate = self
		deniedApplicantsContainer.addSubview(deniedApplicantsTableView)
		deniedApplicantsTableView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(deniedApplicantsLabel.snp_bottom).offset(20)
			make.left.equalTo(deniedApplicantsContainer.snp_left)
			make.right.equalTo(deniedApplicantsContainer.snp_right)
			make.bottom.equalTo(deniedApplicantsContainer.snp_bottom)
		}
		
		//MockView for Scoll
		var mockView = UIView(frame: CGRectMake(0, 0, 1, 1))
		self.contentView.addSubview(mockView)
		mockView.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(contentView.snp_bottom)
			make.centerX.equalTo(contentView.snp_centerX)
		}

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
	
	func drawTableViewsSize(){
		self.activeApplicantsContainer.snp_updateConstraints { (make) -> Void in
			make.height.equalTo((self.arrayOfApplicants.count * 120)+70)
		}
		self.deniedApplicantsContainer.snp_updateConstraints { (make) -> Void in
			make.height.equalTo((self.arrayOfDeniedApplicants.count * 120)+70)
		}
		
		var numbersToMultiplyBy = self.arrayOfApplicants.count + self.arrayOfDeniedApplicants.count
		var numbersToAdd:CGFloat = CGFloat(numbersToMultiplyBy * 120)
		self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: self.scrollView.contentSize.height + numbersToAdd)
		self.contentView.snp_updateConstraints { (make) -> Void in
			make.height.equalTo(self.scrollView.contentSize.height)
		}
	}
	
	//Table View Delegate Methods
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.arrayOfApplicants.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let pendingApplicantCell = tableView.dequeueReusableCellWithIdentifier(ApplicantCell.reuseIdentifier, forIndexPath: indexPath) as! ApplicantCell
		let applicant = self.arrayOfApplicants[indexPath.row]
		pendingApplicantCell.setApplicant(applicant)
		return pendingApplicantCell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 120
	}
	
	//View Delegate Methods
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		self.scrollView.contentSize = self.contentView.frame.size
		println("\(self.scrollView.contentSize)")
	}
	
	//Actions
	
	func editButtonTapped(sender:UIButton){
		
	}
	
	func backButtonTapped(sender:UIButton){
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
}