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

class MyTaskDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ApplicantCellDelegate, ApplicantProfileViewControllerDelegate, EditTaskViewControllerDelegate{
	
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
	var arrayOfApplications:[NelpTaskApplication]!
	var arrayOfAllApplicants:[User]!
	var taskSectionContainer:UIView!
	
	//MARK: Initialization
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.automaticallyAdjustsScrollViewInsets = false
		self.createView()
		self.adjustUI()
	}
	
	override func viewDidAppear(animated: Bool) {
		//		self.drawTableViewsSize()
	}
	
	
	convenience init(findNelpTask:FindNelpTask) {
		self.init(nibName: "MyTaskDetailsViewController", bundle: nil)
		self.task = findNelpTask
		let arrayOfApplications = findNelpTask.applications
		self.arrayOfApplications = arrayOfApplications
		var arrayOfApplicants = [User]()
		var arrayOfAllApplicants = [User]()
		var arrayOfDeniedApplicants = [User]()
		for application in arrayOfApplications{
			if application.state == .Pending{
				arrayOfApplicants.append(application.user)
				arrayOfAllApplicants.append(application.user)
			}else if application.state == .Denied{
				arrayOfDeniedApplicants.append(application.user)
				arrayOfAllApplicants.append(application.user)
			}
		}
		self.arrayOfApplicants = arrayOfApplicants
		self.arrayOfDeniedApplicants = arrayOfDeniedApplicants
		self.arrayOfAllApplicants = arrayOfAllApplicants
	}
	
	//MARK: View Creation
	
	func createView(){
		
		//ContentView
		
		let contentView = UIView()
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
		
		let taskSectionContainer = UIView()
		self.taskSectionContainer = taskSectionContainer
		self.contentView.addSubview(taskSectionContainer)
		taskSectionContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.contentView.snp_top)
			make.left.equalTo(self.contentView.snp_left)
			make.right.equalTo(self.contentView.snp_right)
			make.height.equalTo(110)
		}
		taskSectionContainer.backgroundColor = redPrimary
		
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
		
		let title = UILabel()
		taskSectionContainer.addSubview(title)
		title.text = self.task.title
		title.textColor = whitePrimary
		title.font = UIFont(name: "Lato-Regular", size: kTitle17)
		title.textAlignment = NSTextAlignment.Center
		title.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(taskSectionContainer.snp_top).offset(12)
			make.centerX.equalTo(taskSectionContainer.snp_centerX)
		}
		
		let editButton = UIButton()
		taskSectionContainer.addSubview(editButton)
		editButton.addTarget(self, action: "editButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		editButton.setTitle("Edit Task", forState: UIControlState.Normal)
		editButton.titleLabel!.font = UIFont(name: "Lato-Regular", size: kText15)
		editButton.setTitleColor(whiteBackground, forState: UIControlState.Normal)
		editButton.backgroundColor = redPrimary
		editButton.layer.borderWidth = 2
		editButton.layer.borderColor = whitePrimary.CGColor
		editButton.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(title.snp_bottom).offset(14)
			make.centerX.equalTo(taskSectionContainer.snp_centerX)
			make.width.equalTo(140)
			make.height.equalTo(35)
		}
		
		//Pending Applicants Container
		
		let activeApplicantsContainer = UIView()
		self.activeApplicantsContainer = activeApplicantsContainer
		self.contentView.addSubview(activeApplicantsContainer)
		activeApplicantsContainer.backgroundColor = whitePrimary
		activeApplicantsContainer.layer.borderWidth = 1
		activeApplicantsContainer.layer.borderColor = grayDetails.CGColor
		activeApplicantsContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(taskSectionContainer.snp_bottom).offset(20)
			make.left.equalTo(self.contentView.snp_left)
			make.right.equalTo(self.contentView.snp_right)
			make.height.equalTo((self.arrayOfApplicants.count*100)+65)
		}
		
		
		let pendingApplicantIcon = UIImageView()
		activeApplicantsContainer.addSubview(pendingApplicantIcon)
		pendingApplicantIcon.image = UIImage(named: "pending.png")
		pendingApplicantIcon.contentMode = UIViewContentMode.ScaleAspectFill
		pendingApplicantIcon.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(activeApplicantsContainer.snp_top).offset(20)
			make.left.equalTo(activeApplicantsContainer.snp_left).offset(20)
			make.height.equalTo(30)
			make.width.equalTo(30)
		}
		
		let applicantsLabel = UILabel()
		activeApplicantsContainer.addSubview(applicantsLabel)
		applicantsLabel.textAlignment = NSTextAlignment.Left
		applicantsLabel.text = "Nelpers"
		applicantsLabel.textColor = blackPrimary
		applicantsLabel.font = UIFont(name: "Lato-Regular", size: kTitle17)
		applicantsLabel.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(pendingApplicantIcon.snp_centerY)
			make.left.equalTo(pendingApplicantIcon.snp_right).offset(12)
		}
		
		
		//Applicants Table View
		
		let applicantsTableView = UITableView()
		self.applicantsTableView = applicantsTableView
		self.applicantsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
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
		
		let pendingBottomLine = UIView()
		pendingBottomLine.backgroundColor = grayDetails
		activeApplicantsContainer.addSubview(pendingBottomLine)
		pendingBottomLine.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(applicantsTableView.snp_top).offset(-2)
			make.centerX.equalTo(activeApplicantsContainer.snp_centerX)
			make.height.equalTo(0.5)
			make.width.equalTo(activeApplicantsContainer.snp_width)
		}
		
		//Denied Applicants
		
		let deniedApplicantsContainer = UIView()
		self.deniedApplicantsContainer = deniedApplicantsContainer
		self.contentView.addSubview(deniedApplicantsContainer)
		deniedApplicantsContainer.backgroundColor = whitePrimary
		deniedApplicantsContainer.layer.borderWidth = 1
		deniedApplicantsContainer.layer.borderColor = grayDetails.CGColor
		deniedApplicantsContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(activeApplicantsContainer.snp_bottom).offset(20)
			make.left.equalTo(self.contentView.snp_left)
			make.right.equalTo(self.contentView.snp_right)
			make.height.equalTo((self.arrayOfDeniedApplicants.count*100)+65)
			make.bottom.equalTo(self.contentView.snp_bottom).offset(-20)
		}
		
		let deniedApplicantIcon = UIImageView()
		deniedApplicantsContainer.addSubview(deniedApplicantIcon)
		deniedApplicantIcon.image = UIImage(named: "denied.png")
		deniedApplicantIcon.contentMode = UIViewContentMode.ScaleAspectFill
		deniedApplicantIcon.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(deniedApplicantsContainer.snp_top).offset(20)
			make.left.equalTo(deniedApplicantsContainer.snp_left).offset(20)
			make.height.equalTo(30)
			make.width.equalTo(30)
		}
		
		let deniedApplicantsLabel = UILabel()
		deniedApplicantsContainer.addSubview(deniedApplicantsLabel)
		deniedApplicantsLabel.textAlignment = NSTextAlignment.Left
		deniedApplicantsLabel.text = "Denied Nelpers"
		deniedApplicantsLabel.textColor = blackPrimary
		deniedApplicantsLabel.font = UIFont(name: "Lato-Regular", size: kTitle17)
		deniedApplicantsLabel.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(deniedApplicantIcon.snp_centerY)
			make.left.equalTo(deniedApplicantIcon.snp_right).offset(12)
		}
		
		//Applicants Table View
		
		let deniedApplicantsTableView = UITableView()
		self.deniedApplicantsTableView = deniedApplicantsTableView
		self.deniedApplicantsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
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
		
		let deniedBottomLine = UIView()
		deniedBottomLine.backgroundColor = grayDetails
		deniedApplicantsContainer.addSubview(deniedBottomLine)
		deniedBottomLine.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(deniedApplicantsTableView.snp_top).offset(-2)
			make.centerX.equalTo(deniedApplicantsContainer.snp_centerX)
			make.height.equalTo(0.5)
			make.width.equalTo(deniedApplicantsContainer.snp_width)
		}
	}
	
	
	//MARK: Refresh Tableview
	func refreshTableView(){
		self.applicantsTableView.reloadData()
		self.deniedApplicantsTableView.reloadData()
		self.updateFrames()
	}
	
	func getPictures(imageURL: String, block: (UIImage) -> Void) -> Void {
		var image: UIImage!
		request(.GET,imageURL).response(){
			(_, _, data, error) in
			if(error != nil){
				print(error)
			}
			image = UIImage(data: data as NSData!)
			block(image)
		}
	}
	
	//MARK: UI

	func adjustUI(){
		self.container.backgroundColor = whiteBackground
		let previousBtn = UIButton()
		previousBtn.addTarget(self, action: "backButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		self.navBar.closeButton = previousBtn
		self.scrollView.backgroundColor = whiteBackground
		self.navBar.setTitle("My Task Details")
	}
	
	func setImages(nelpTask:FindNelpTask){
		self.categoryIcon.layer.cornerRadius = self.categoryIcon.frame.size.width / 2;
		self.categoryIcon.clipsToBounds = true
		self.categoryIcon.image = UIImage(named: nelpTask.category!)
	}
	
	func drawTableViewsSize(){
		self.activeApplicantsContainer.snp_updateConstraints { (make) -> Void in
			make.height.equalTo((self.arrayOfApplicants.count * 100)+70)
		}
		self.deniedApplicantsContainer.snp_updateConstraints { (make) -> Void in
			make.height.equalTo((self.arrayOfDeniedApplicants.count * 100)+70)
		}
		
		let numbersToMultiplyBy = self.arrayOfApplicants.count + self.arrayOfDeniedApplicants.count
		let numbersToAdd:CGFloat = CGFloat(numbersToMultiplyBy * 100)
		self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: self.scrollView.contentSize.height + numbersToAdd)
		self.contentView.snp_updateConstraints { (make) -> Void in
			make.height.equalTo(self.scrollView.contentSize.height)
		}
	}
	
	func updateFrames(){
		
		deniedApplicantsContainer.snp_updateConstraints { (make) -> Void in
			make.top.equalTo(activeApplicantsContainer.snp_bottom).offset(10)
			make.left.equalTo(self.contentView.snp_left)
			make.right.equalTo(self.contentView.snp_right)
			make.height.equalTo((self.arrayOfDeniedApplicants.count*100)+70)
		}
		
		activeApplicantsContainer.snp_updateConstraints { (make) -> Void in
			make.top.equalTo(taskSectionContainer.snp_bottom).offset(10)
			make.left.equalTo(self.contentView.snp_left)
			make.right.equalTo(self.contentView.snp_right)
			make.height.equalTo((self.arrayOfApplicants.count*100)+70)
		}
	}
	

	
	//MARK: Tableview Delegate and Datasource
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if tableView == self.applicantsTableView {
			return self.arrayOfApplicants.count
		} else if tableView == self.deniedApplicantsTableView {
			return self.arrayOfDeniedApplicants.count
		}
		return 0
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if tableView == applicantsTableView {
			
			let pendingApplicantCell = tableView.dequeueReusableCellWithIdentifier(ApplicantCell.reuseIdentifier, forIndexPath: indexPath) as! ApplicantCell
			let application = self.arrayOfApplicants[indexPath.row]
			pendingApplicantCell.setApplicant(application)
			
			return pendingApplicantCell
			
		} else if tableView == deniedApplicantsTableView {
			
			let deniedApplicantCell = tableView.dequeueReusableCellWithIdentifier(ApplicantCell.reuseIdentifier, forIndexPath: indexPath) as! ApplicantCell
			let deniedApplicant = self.arrayOfDeniedApplicants[indexPath.row]
			deniedApplicantCell.setApplicant(deniedApplicant)
			deniedApplicantCell.replaceArrowImage()
			deniedApplicantCell.delegate = self
			
			return deniedApplicantCell
			
		}
		
		return UITableViewCell()
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if tableView == self.applicantsTableView{
			let applicant = self.arrayOfAllApplicants[indexPath.row]
			let application = self.arrayOfApplications[indexPath.row]
			let nextVC = ApplicantProfileViewController(applicant: applicant, application: application)
			nextVC.delegate = self
			nextVC.previousVC = self
			dispatch_async(dispatch_get_main_queue()){
				self.presentViewController(nextVC, animated: true, completion: nil)
			}
		}
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 100
	}
	
	//MARK: View delegate Methods
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		self.scrollView.contentSize = self.contentView.frame.size
	}
	
	//MARK: Cell delegate methods
	
	func didTapRevertButton(applicant:User){
		var applicationToRevert:NelpTaskApplication!
		for application in self.arrayOfApplications{
			print(application.user.objectId)
			print(applicant.objectId)
			if application.user.objectId == applicant.objectId{
				applicationToRevert = application
				for (var i = 0 ; i < self.arrayOfDeniedApplicants.count ; i++) {
					let applicantToChange = self.arrayOfDeniedApplicants[i]
					if applicantToChange.objectId == applicant.objectId{
						self.arrayOfDeniedApplicants.removeAtIndex(i)
						self.arrayOfApplicants.append(applicantToChange)
					}
				}
			}
		}
		applicationToRevert.state = .Pending
		let query = PFQuery(className: "NelpTaskApplication")
		query.getObjectInBackgroundWithId(applicationToRevert.objectId, block: { (application, error) -> Void in
			if error != nil{
				print(error)
			} else if let application = application{
				application["state"] = applicationToRevert.state.rawValue
				application.saveInBackground()
			}
		})
		
		self.refreshTableView()
	}
	

	
//MARK: Applications Profile View Controller Delegate
	
	func didTapDenyButton(applicant:User){
		var applicationToDeny:NelpTaskApplication?
		for application in self.arrayOfApplications{
			print(application.user.objectId)
			print(applicant.objectId)
			if application.user.objectId == applicant.objectId{
				applicationToDeny = application
				for (var i = 0 ; i < self.arrayOfApplicants.count ; i++) {
					let applicantToChange = self.arrayOfApplicants[i]
					if applicantToChange.objectId == applicant.objectId{
						self.arrayOfApplicants.removeAtIndex(i)
						self.arrayOfDeniedApplicants.append(applicantToChange)
					}
				}
			}
		}
		self.refreshTableView()
	}
	
	func dismissVC(){
		self.dismissViewControllerAnimated(true, completion: {})
	}
	
	//MARK: Edit Task Delegate
	
	func didEditTask(task: FindNelpTask) {
		self.task = task
		self.createView()
	}
	
	//MARK: Actions
	
	func editButtonTapped(sender:UIButton){
		let nextVC = EditTaskViewController()
		nextVC.task = self.task
		nextVC.delegate = self
		dispatch_async(dispatch_get_main_queue()) {
			self.presentViewController(nextVC, animated: true, completion: nil)
		}
	}
	
	func backButtonTapped(sender:UIButton){
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
}