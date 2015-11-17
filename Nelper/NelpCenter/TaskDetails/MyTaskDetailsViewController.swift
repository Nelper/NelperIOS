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
import FXBlurView

protocol MyTaskDetailsViewControllerDelegate {
	func didEditTask(task:FindNelpTask)
}

class MyTaskDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ApplicantCellDelegate, ApplicantProfileViewControllerDelegate, UINavigationControllerDelegate {
	
	@IBOutlet weak var navBar: NavBar!
	@IBOutlet weak var container: UIView!
	@IBOutlet weak var scrollView: UIScrollView!
	
	var task: FindNelpTask!
	var applications: [TaskApplication]!
	var pendingApplications: [TaskApplication]!
	var deniedApplications: [TaskApplication]!
	
	var delegate:MyTaskDetailsViewControllerDelegate!
	var contentView: UIView!
	
	var taskInfoPagingView: TaskInfoPagingView!
	
	var applicantsTableView: UITableView!
	var activeApplicantsContainer: DefaultContainerView!
	var deniedApplicantsContainer: DefaultContainerView!
	var deniedApplicantsTableView: UITableView!
	var deniedApplicantIcon:UIImageView!
	var deniedApplicantsLabel:UILabel!
	
	var deleteTaskButton: UIButton!
	
	var saveChangesButton: UIButton!
	
	var noPendingContainer: UIView!
	
	var taskTitle: String!
	var taskDescription: String!
	
	convenience init(task:FindNelpTask) {
		self.init(nibName: "MyTaskDetailsViewController", bundle: nil)
		self.task = task
		self.applications = task.applications
		self.pendingApplications = self.applications.filter({ $0.state != .Denied })
		self.deniedApplications = self.applications.filter({ $0.state == .Denied })
	}
	
	//MARK: Initialization
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.automaticallyAdjustsScrollViewInsets = false
		
		self.createView()
		
		self.adjustUI()
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
	
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
	}
	
	//MARK: View Creation
	
	func createView() {
		
		//NavBar
		
		let previousBtn = UIButton()
		let deleteBtn = UIButton()
		previousBtn.addTarget(self, action: "backButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		deleteBtn.addTarget(self, action: "deleteTaskButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		self.navBar.backButton = previousBtn
		self.navBar.deleteButton = deleteBtn
		self.navBar.setTitle("My Task")
		
		//Scroll View
		
		self.scrollView.alwaysBounceVertical = true
		
		//ContentView
		
		let contentView = UIView()
		self.contentView = contentView
		self.scrollView.addSubview(contentView)
		contentView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.scrollView.snp_top)
			make.left.equalTo(self.scrollView.snp_left)
			make.right.equalTo(self.scrollView.snp_right)
			make.width.equalTo(self.container.snp_width)
		}
		
		//Task info
		
		let taskInfoPagingView = TaskInfoPagingView(task: self.task,width: contentView.frame.width)
		self.taskInfoPagingView = taskInfoPagingView
		//taskInfoPagingView.view.frame = CGRect(x: 0, y: 0, width: contentView.bounds.width * 3, height: taskInfoPagingView.containerHeight)
		self.addChildViewController(taskInfoPagingView)
		taskInfoPagingView.didMoveToParentViewController(self)
		contentView.addSubview(taskInfoPagingView.view)
		taskInfoPagingView.view.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(contentView.snp_top).offset(20)
			make.left.equalTo(contentView.snp_left)
			make.width.equalTo(contentView.bounds.width * 3)
			make.centerX.equalTo(contentView)
		}
		
		//Active Applicants
		
		self.makeActiveApplicantsContainer(false)
		
		//Denied Applicants
		
		self.makeDeniedApplicantsContainer(false)
	}
	
	func getPictures(imageURL: String, block: (UIImage) -> Void) -> Void {
		var image: UIImage!
		request(.GET,imageURL).response() {
			(_, _, data, error) in
			if(error != nil){
				print(error)
			}
			image = UIImage(data: data as NSData!)
			block(image)
		}
	}
	
	//MARK: UI
	
	func adjustUI() {
		self.container.backgroundColor = Color.whiteBackground
		self.scrollView.backgroundColor = Color.whiteBackground
	}
	
	/**
	Make the active Applicants (Pending Nelpers) and set its content accordingly
	
	- parameter isUpdate: true if the container has already been created and we only want it to update
	*/
	func makeActiveApplicantsContainer(isUpdate: Bool) {
		
		if isUpdate {
			self.activeApplicantsContainer.removeFromSuperview()
		}
		
		//Container
		
		let activeApplicantsContainer = DefaultContainerView()
		self.activeApplicantsContainer = activeApplicantsContainer
		self.contentView.addSubview(activeApplicantsContainer)
		activeApplicantsContainer.containerTitle = "Nelpers"
		activeApplicantsContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.taskInfoPagingView.view.snp_bottom).offset(20)
			make.left.equalTo(self.contentView.snp_left)
			make.right.equalTo(self.contentView.snp_right)
		}
		
		let pendingApplicantIcon = UIImageView()
		activeApplicantsContainer.titleView.addSubview(pendingApplicantIcon)
		pendingApplicantIcon.image = UIImage(named: "pending.png")
		pendingApplicantIcon.contentMode = UIViewContentMode.ScaleAspectFill
		pendingApplicantIcon.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(activeApplicantsContainer.titleView.snp_centerY)
			make.left.equalTo(activeApplicantsContainer.titleView.snp_left).offset(20)
			make.height.equalTo(30)
			make.width.equalTo(30)
		}
		
		self.activeApplicantsContainer.titleLabel.snp_remakeConstraints { (make) -> Void in
			make.centerY.equalTo(pendingApplicantIcon.snp_centerY)
			make.left.equalTo(pendingApplicantIcon.snp_right).offset(12)
		}
		
		//Content
		
		let applicantsTableView = UITableView()
		self.applicantsTableView = applicantsTableView
		self.applicantsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
		self.applicantsTableView.registerClass(ApplicantCell.classForCoder(), forCellReuseIdentifier: ApplicantCell.reuseIdentifier)
		self.applicantsTableView.scrollEnabled = false
		self.applicantsTableView.dataSource = self
		self.applicantsTableView.delegate = self
		self.applicantsTableView.backgroundColor = UIColor.clearColor()
		self.activeApplicantsContainer.contentView.addSubview(applicantsTableView)
		self.applicantsTableView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(activeApplicantsContainer.contentView.snp_top)
			make.left.equalTo(activeApplicantsContainer.contentView.snp_left)
			make.right.equalTo(activeApplicantsContainer.contentView.snp_right)
			make.height.equalTo(self.pendingApplications.count * 100)
		}
		
		if self.pendingApplications.isEmpty {
			
			self.applicantsTableView.hidden = true
			
			let noPendingLabel = UILabel()
			activeApplicantsContainer.contentView.addSubview(noPendingLabel)
			noPendingLabel.text = "No pending applications"
			noPendingLabel.textColor = Color.darkGrayDetails
			noPendingLabel.font = UIFont(name: "Lato-Regular", size: kText15)
			noPendingLabel.snp_makeConstraints { (make) -> Void in
				make.centerX.equalTo(activeApplicantsContainer.contentView.snp_centerX)
				make.top.equalTo(activeApplicantsContainer.contentView.snp_top).offset(20)
			}
			
			self.activeApplicantsContainer.snp_makeConstraints { (make) -> Void in
				make.bottom.equalTo(noPendingLabel.snp_bottom).offset(20)
			}
			
			self.activeApplicantsContainer.layoutIfNeeded()
			
		} else {
			
			self.activeApplicantsContainer.snp_makeConstraints { (make) -> Void in
				make.bottom.equalTo(applicantsTableView.snp_bottom)
			}
			
			self.activeApplicantsContainer.layoutIfNeeded()
		}
	}
	
	/**
	Make the Denied Applicants Container if needed.
	*/
	func makeDeniedApplicantsContainer(isUpdate: Bool) {
		
		if isUpdate {
			self.deniedApplicantsContainer.removeFromSuperview()
		}
		
		//Container
		
		let deniedApplicantsContainer = DefaultContainerView()
		self.deniedApplicantsContainer = deniedApplicantsContainer
		self.contentView.addSubview(deniedApplicantsContainer)
		deniedApplicantsContainer.containerTitle = "Declined Nelpers"
		deniedApplicantsContainer.snp_remakeConstraints { (make) -> Void in
			make.top.equalTo(self.activeApplicantsContainer.snp_bottom).offset(20)
			make.left.equalTo(self.contentView.snp_left)
			make.right.equalTo(self.contentView.snp_right)
		}
		
		let deniedApplicantIcon = UIImageView()
		self.deniedApplicantIcon = deniedApplicantIcon
		deniedApplicantsContainer.titleView.addSubview(deniedApplicantIcon)
		deniedApplicantIcon.image = UIImage(named: "denied.png")
		deniedApplicantIcon.contentMode = UIViewContentMode.ScaleAspectFill
		deniedApplicantIcon.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(deniedApplicantsContainer.titleView.snp_centerY)
			make.left.equalTo(deniedApplicantsContainer.titleView.snp_left).offset(20)
			make.height.equalTo(30)
			make.width.equalTo(30)
		}
		
		deniedApplicantsContainer.titleLabel.snp_remakeConstraints { (make) -> Void in
			make.centerY.equalTo(deniedApplicantIcon.snp_centerY)
			make.left.equalTo(deniedApplicantIcon.snp_right).offset(12)
		}
		
		deniedApplicantsContainer.layoutIfNeeded()
		
		//Applicants Table View
		
		let deniedApplicantsTableView = UITableView()
		self.deniedApplicantsTableView = deniedApplicantsTableView
		self.deniedApplicantsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
		deniedApplicantsTableView.registerClass(ApplicantCell.classForCoder(), forCellReuseIdentifier: ApplicantCell.reuseIdentifier)
		self.deniedApplicantsTableView.scrollEnabled = false
		self.deniedApplicantsTableView.dataSource = self
		self.deniedApplicantsTableView.delegate = self
		self.contentView.addSubview(deniedApplicantsTableView)
		deniedApplicantsTableView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(deniedApplicantsContainer.contentView.snp_top)
			make.left.equalTo(deniedApplicantsContainer.snp_left)
			make.right.equalTo(deniedApplicantsContainer.snp_right)
			make.height.equalTo(deniedApplications.count * 100)
		}
		
		self.deniedApplicantsContainer.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(self.deniedApplicantsTableView.snp_bottom)
		}
		
		if !isUpdate {
			if self.deniedApplications.isEmpty {
				self.deniedApplicantsContainer.hidden = true
				self.contentView.snp_makeConstraints { (make) -> Void in
					make.top.equalTo(self.scrollView.snp_top)
					make.left.equalTo(self.scrollView.snp_left)
					make.right.equalTo(self.scrollView.snp_right)
					make.width.equalTo(self.container.snp_width)
					make.bottom.equalTo(self.activeApplicantsContainer.snp_bottom).offset(20)
				}
			} else {
				self.contentView.snp_makeConstraints { (make) -> Void in
					make.top.equalTo(self.scrollView.snp_top)
					make.left.equalTo(self.scrollView.snp_left)
					make.right.equalTo(self.scrollView.snp_right)
					make.width.equalTo(self.container.snp_width)
					make.bottom.equalTo(self.deniedApplicantsContainer.snp_bottom).offset(20)
				}
			}
		}
	}
	
	
	
	/**
	Update the frames to new tableViews
	*/
	func updateFrames() {
		
		//TODO: Animate?
		
		self.activeApplicantsContainer.layoutIfNeeded()
		self.deniedApplicantsContainer.layoutIfNeeded()
		
		if self.deniedApplications.isEmpty {
			self.deniedApplicantsContainer.hidden = true
			self.contentView.snp_remakeConstraints { (make) -> Void in
				make.top.equalTo(self.scrollView.snp_top)
				make.left.equalTo(self.scrollView.snp_left)
				make.right.equalTo(self.scrollView.snp_right)
				make.width.equalTo(self.container.snp_width)
				make.bottom.equalTo(self.activeApplicantsContainer.snp_bottom).offset(20)
			}
		} else {
			self.contentView.snp_remakeConstraints { (make) -> Void in
				make.top.equalTo(self.scrollView.snp_top)
				make.left.equalTo(self.scrollView.snp_left)
				make.right.equalTo(self.scrollView.snp_right)
				make.width.equalTo(self.container.snp_width)
				make.bottom.equalTo(self.deniedApplicantsContainer.snp_bottom).offset(20)
			}
		}
		
		self.scrollView.contentSize = self.contentView.frame.size
	}
	
	//MARK: Tableview Delegate and Datasource
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if tableView == self.applicantsTableView {
			return self.pendingApplications.count
		} else if tableView == self.deniedApplicantsTableView {
			return self.deniedApplications.count
		}
		return 0
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		if tableView == applicantsTableView {
			
			let pendingApplicantCell = tableView.dequeueReusableCellWithIdentifier(ApplicantCell.reuseIdentifier, forIndexPath: indexPath) as! ApplicantCell
			
			let application = self.pendingApplications[indexPath.row]
			pendingApplicantCell.setApplication(application)
			return pendingApplicantCell
			
		} else if tableView == deniedApplicantsTableView {
			
			let deniedApplicantCell = tableView.dequeueReusableCellWithIdentifier(ApplicantCell.reuseIdentifier, forIndexPath: indexPath) as! ApplicantCell
			let deniedApplication = self.deniedApplications[indexPath.row]
			deniedApplicantCell.setApplication(deniedApplication)
			deniedApplicantCell.replaceArrowImage()
			deniedApplicantCell.delegate = self
			
			return deniedApplicantCell
			
		}
		
		return UITableViewCell()
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if tableView == self.applicantsTableView {
			let application = self.pendingApplications[indexPath.row]
			let nextVC = ApplicantProfileViewController(applicant: application.user, application: application)
			nextVC.delegate = self
			dispatch_async(dispatch_get_main_queue()) {
				self.navigationController?.pushViewController(nextVC, animated: true)
			}
		}
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 100
	}
	
	
	
	
	
	
	//MARK: View delegate Methods
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		if taskInfoPagingView.descriptionIsEditing {
			self.scrollView.contentSize.height = UIScreen.mainScreen().bounds.height + 100
		}else{
			self.scrollView.contentSize = self.contentView.frame.size
		}
		
	}
	
	//MARK: Cell delegate methods
	
	func didTapRevertButton(application: TaskApplication) {

		self.deniedApplications.removeAtIndex(self.deniedApplications.indexOf({$0 === application})!)
		self.pendingApplications.append(application)
		
		application.state = .Pending
		ApiHelper.restoreApplication(application, block: nil)
		
		self.makeActiveApplicantsContainer(true)
		self.makeDeniedApplicantsContainer(true)
		self.updateFrames()
		_ = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: "scrollToBottom", userInfo: nil, repeats: false)
	}
	
	//MARK: Applications Profile View Controller Delegate
	
	func didTapDenyButton(application: TaskApplication) {
		self.pendingApplications.removeAtIndex(self.pendingApplications.indexOf({$0 === application})!)
		self.deniedApplications.append(application)

		self.makeActiveApplicantsContainer(true)
		self.makeDeniedApplicantsContainer(true)
		self.updateFrames()
		_ = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: "scrollToBottom", userInfo: nil, repeats: false)
	}
	
	func dismissVC() {
		self.navigationController?.popViewControllerAnimated(true)
	}
	
	//MARK: Utilities
	
	func scrollToBottom() {
		
		self.scrollView.scrollRectToVisible(CGRectMake(self.scrollView.contentSize.width - 1, self.scrollView.contentSize.height - 1, 1, 1), animated: true)
	}
	
	
	
	
	//MARK: Actions
	
	func dismissKeyboard() {
		view.endEditing(true)
	}
	
	
	
	func backButtonTapped(sender: UIButton) {
		
		dismissKeyboard()
		
		if (taskInfoPagingView.titleTextView.text != taskInfoPagingView.taskTitle) || (taskInfoPagingView.descriptionTextView.text != taskInfoPagingView.taskDescription) || (taskInfoPagingView.picturesChanged) {
			
			let popup = UIAlertController(title: "Your task was edited", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
			let popupSubview = popup.view.subviews.first! as UIView
			let popupContentView = popupSubview.subviews.first! as UIView
			popupContentView.layer.cornerRadius = 0
			popup.addAction(UIAlertAction(title: "Save changes", style: .Default, handler: { (action) -> Void in
				//Saves info and changes the view
				self.task.title = self.taskInfoPagingView.titleTextView.text
				if !self.taskInfoPagingView.images.isEmpty {
					self.convertImagesToData()
				}
				self.task.desc = self.taskInfoPagingView.descriptionTextView.text
				
				
				print(self.task.desc)
				
				ApiHelper.editTask(self.task)
				self.delegate.didEditTask(self.task)
				self.navigationController?.popViewControllerAnimated(true)
			}))
			popup.addAction(UIAlertAction(title: "Discard changes", style: .Default, handler: { (action) -> Void in
				//Resets info and changes the view
				if self.task.pictures != nil {
					self.taskInfoPagingView.pictures = self.task.pictures!
					self.taskInfoPagingView.getImagesFromParse()
				} else {
					self.taskInfoPagingView.pictures.removeAll()
				}
				self.taskTitle = self.task.title
				self.taskDescription = self.task.desc
				self.navigationController?.popViewControllerAnimated(true)
			}))
			self.presentViewController(popup, animated: true, completion: nil)
			popup.view.tintColor = Color.redPrimary
		} else {
			self.navigationController?.popViewControllerAnimated(true)
		}
	}
	
	/**
	Converts the attached task pictures to Data in order to save them in parse.
	*/
	func convertImagesToData() {
		self.task.pictures = Array()
		for image in self.taskInfoPagingView.images {
			let imageData = UIImageJPEGRepresentation(image , 0.50)
			let imageFile = PFFile(name:"image.png", data:imageData!)
			self.task.pictures!.append(imageFile)
		}
	}
	
	
	
	func deleteTaskButtonTapped(sender: UIButton) {
		dismissKeyboard()
		
		let popup = UIAlertController(title: "Delete this task?", message: "This action is permanent.", preferredStyle: UIAlertControllerStyle.Alert)
		popup.addAction(UIAlertAction(title: "Delete", style: .Destructive, handler: { (action) -> Void in
			//Changes the view and delete the task
			self.navigationController?.popViewControllerAnimated(true)
			ApiHelper.deleteTask(self.task)
		}))
		popup.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) -> Void in
		}))
		
		self.presentViewController(popup, animated: true, completion: nil)
		popup.view.tintColor = Color.redPrimary
	}
		
	func didTapSaveButton(sender:UIButton){
		self.task.title = self.taskInfoPagingView.titleTextView.text
		if !self.taskInfoPagingView.images.isEmpty{
			self.task.pictures = ApiHelper.convertImagesToData(self.taskInfoPagingView.images)
		}
		self.task.desc = self.taskInfoPagingView.descriptionTextView.text
		
		ApiHelper.editTask(self.task)
		self.navigationController?.popViewControllerAnimated(true)
	}
	
	func didTapDeleteButton(sender: UIButton) {
		
	}
	
}