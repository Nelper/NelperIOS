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
	
	var contentView: UIView!
	var categoryIcon: UIImageView!
	var task: FindNelpTask!
	var applicantsTableView: UITableView!
	var arrayOfApplicants: [User]!
	var activeApplicantsContainer: UIView!
	var deniedApplicantsContainer: UIView!
	var arrayOfDeniedApplicants: [User]!
	var deniedApplicantsTableView: UITableView!
	var arrayOfApplications: [TaskApplication]!
	var arrayOfAllApplicants: [User]!
	var taskSectionContainer: UIView!
	var deniedApplicantIcon:UIImageView!
	var deniedApplicantsLabel:UILabel!
	var taskInformationContainer:UIView!
	var titleTextField:UITextField!
	var descriptionTextView:UITextView!
	var deleteTaskButton:UIButton!
	var tap:UIGestureRecognizer!
	var pictures:Array<PFFile>?
	var picturesContainer:UIView!
	var images = Array<UIImage>()
	var imagePicker = UIImagePickerController()
	
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
		for application in arrayOfApplications {
			if application.state == .Pending {
				arrayOfApplicants.append(application.user)
				arrayOfAllApplicants.append(application.user)
			} else if application.state == .Denied {
				arrayOfDeniedApplicants.append(application.user)
				arrayOfAllApplicants.append(application.user)
			}
		}
		self.arrayOfApplicants = arrayOfApplicants
		self.arrayOfDeniedApplicants = arrayOfDeniedApplicants
		self.arrayOfAllApplicants = arrayOfAllApplicants
	}
	
	//MARK: View Creation
	
	func createView() {
		
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
		
		
		//Pending Applicants Container
		
		let activeApplicantsContainer = UIView()
		self.activeApplicantsContainer = activeApplicantsContainer
		self.contentView.addSubview(activeApplicantsContainer)
		activeApplicantsContainer.backgroundColor = whitePrimary
		activeApplicantsContainer.layer.borderWidth = 1
		activeApplicantsContainer.layer.borderColor = grayDetails.CGColor
		activeApplicantsContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(contentView.snp_top).offset(20)
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
		applicantsLabel.font = UIFont(name: "Lato-Regular", size: kNavTitle18)
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
		
		self.makeDeniedApplicantsContainer()
		//Task Edit
		
		let taskInformationContainer = UIView()
		self.taskInformationContainer = taskInformationContainer
		contentView.addSubview(taskInformationContainer)
		taskInformationContainer.layer.borderColor = darkGrayDetails.CGColor
		taskInformationContainer.layer.borderWidth = 0.5
		taskInformationContainer.backgroundColor = whitePrimary
		taskInformationContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(deniedApplicantsContainer.snp_bottom).offset(20)
			make.left.equalTo(contentView.snp_left).offset(-1)
			make.right.equalTo(contentView.snp_right).offset(1)
		}
		
		let categoryIcon = UIImageView()
		taskInformationContainer.addSubview(categoryIcon)
		let iconSize:CGFloat = 60
		categoryIcon.layer.cornerRadius = iconSize / 2
		categoryIcon.contentMode = UIViewContentMode.ScaleAspectFill
		categoryIcon.image = UIImage(named: self.task.category!)
		categoryIcon.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(taskInformationContainer.snp_top).offset(16)
			make.centerX.equalTo(taskInformationContainer.snp_centerX)
			make.width.equalTo(iconSize)
			make.height.equalTo(iconSize)
		}
		
		let titleTextField = UITextField()
		self.titleTextField = titleTextField
		taskInformationContainer.addSubview(titleTextField)
		titleTextField.text = self.task.title
		titleTextField.font = UIFont(name: "Lato-Regular", size: kText15)
		titleTextField.textAlignment = NSTextAlignment.Center
		titleTextField.layer.borderWidth = 1
		titleTextField.layer.borderColor = darkGrayDetails.CGColor
		titleTextField.backgroundColor = whiteBackground
		titleTextField.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(categoryIcon.snp_bottom).offset(20)
			make.left.equalTo(taskInformationContainer.snp_left).offset(12)
			make.right.equalTo(taskInformationContainer.snp_right).offset(-12)
			make.height.equalTo(40)
		}
		
		let titleUnderline = UIView()
		taskInformationContainer.addSubview(titleUnderline)
		titleUnderline.backgroundColor = darkGrayDetails
		titleUnderline.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(titleTextField.snp_bottom).offset(16)
			make.width.equalTo(taskInformationContainer.snp_width).dividedBy(1.4)
			make.height.equalTo(0.5)
			make.centerX.equalTo(taskInformationContainer.snp_centerX)
			
		}
		
		let descriptionTextView = UITextView()
		self.descriptionTextView = descriptionTextView
		taskInformationContainer.addSubview(descriptionTextView)
		descriptionTextView.text = self.task.desc
		descriptionTextView.font = UIFont(name: "Lato-Regular", size: kProgressBarTextFontSize)
		descriptionTextView.textAlignment = NSTextAlignment.Center
		descriptionTextView.layer.borderWidth = 1
		descriptionTextView.layer.borderColor = darkGrayDetails.CGColor
		descriptionTextView.backgroundColor = whiteBackground
		descriptionTextView.scrollEnabled = false
		descriptionTextView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(titleUnderline.snp_bottom).offset(16)
			make.width.equalTo(titleTextField.snp_width)
			make.centerX.equalTo(taskInformationContainer.snp_centerX)
		}
		
		let fixedWidth = descriptionTextView.frame.size.width
		descriptionTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
		let newSize = descriptionTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
		var newFrame = descriptionTextView.frame
		newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
		descriptionTextView.frame = newFrame;
		
		let descriptionUnderline = UIView()
		taskInformationContainer.addSubview(descriptionUnderline)
		descriptionUnderline.backgroundColor = darkGrayDetails
		descriptionUnderline.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(descriptionTextView.snp_bottom).offset(16)
			make.width.equalTo(taskInformationContainer.snp_width).dividedBy(1.4)
			make.height.equalTo(0.5)
			make.centerX.equalTo(taskInformationContainer.snp_centerX)
			
		}
		
		let locationContainer = UIView()
		taskInformationContainer.addSubview(locationContainer)
		locationContainer.backgroundColor = whitePrimary
		locationContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(descriptionUnderline.snp_bottom).offset(20)
			make.left.equalTo(descriptionTextView.snp_left).offset(16)
			make.width.equalTo(taskInformationContainer.snp_width).dividedBy(2)
		}
		
		let pinIcon = UIImageView()
		locationContainer.addSubview(pinIcon)
		pinIcon.image = UIImage(named: "pin")
		pinIcon.contentMode = UIViewContentMode.ScaleAspectFill
		pinIcon.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(45)
			make.width.equalTo(45)
			make.centerY.equalTo(locationContainer.snp_centerY)
			make.left.equalTo(locationContainer.snp_left).offset(4)
		}
		
		let locationVerticalLine = UIView()
		locationContainer.addSubview(locationVerticalLine)
		locationVerticalLine.backgroundColor = darkGrayDetails
		locationVerticalLine.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(locationContainer.snp_top)
			make.bottom.equalTo(locationContainer.snp_bottom)
			make.width.equalTo(1)
			make.left.equalTo(pinIcon.snp_right).offset(4)
		}
		
		let streetAddressLabel = UITextField()
		streetAddressLabel.backgroundColor = whitePrimary
		locationContainer.addSubview(streetAddressLabel)
		streetAddressLabel.text = "175 Forbin Janson"
		streetAddressLabel.textColor = blackPrimary
		streetAddressLabel.font = UIFont(name: "Lato-Regular", size: kText15)
		streetAddressLabel.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(locationContainer.snp_height).dividedBy(3)
			make.left.equalTo(locationVerticalLine.snp_left).offset(4)
			make.top.equalTo(locationContainer.snp_top)
		}
		
		let cityLabel = UITextField()
		cityLabel.backgroundColor = whitePrimary
		locationContainer.addSubview(cityLabel)
		cityLabel.text = "Mont Saint-Hilaire"
		cityLabel.textColor = blackPrimary
		cityLabel.font = UIFont(name: "Lato-Regular", size: kText15)
		cityLabel.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(locationContainer.snp_height).dividedBy(3)
			make.left.equalTo(locationVerticalLine.snp_left).offset(4)
			make.top.equalTo(streetAddressLabel.snp_bottom)
		}
		
		let zipcodeLabel = UITextField()
		zipcodeLabel.backgroundColor = whitePrimary
		locationContainer.addSubview(zipcodeLabel)
		zipcodeLabel.text = "J3H5E5"
		zipcodeLabel.textColor = blackPrimary
		zipcodeLabel.font = UIFont(name: "Lato-Regular", size: kText15)
		zipcodeLabel.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(locationContainer.snp_height).dividedBy(3)
			make.left.equalTo(locationVerticalLine.snp_left).offset(4)
			make.top.equalTo(cityLabel.snp_bottom)
		}
		
		let locationUnderline = UIView()
		taskInformationContainer.addSubview(locationUnderline)
		locationUnderline.backgroundColor = darkGrayDetails
		locationUnderline.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(locationContainer.snp_bottom).offset(20)
			make.width.equalTo(taskInformationContainer.snp_width).dividedBy(1.4)
			make.height.equalTo(0.5)
			make.centerX.equalTo(taskInformationContainer.snp_centerX)
		}
		
		let deleteTaskButton = UIButton()
		taskInformationContainer.addSubview(deleteTaskButton)
		self.deleteTaskButton = deleteTaskButton
		deleteTaskButton.setTitle("Delete Task", forState: UIControlState.Normal)
		deleteTaskButton.setTitle("Sure?", forState: UIControlState.Selected)
		deleteTaskButton.setTitleColor(redPrimary, forState: UIControlState.Normal)
		deleteTaskButton.setTitleColor(redPrimary, forState: UIControlState.Selected)
		self.deleteTaskButton.addTarget(self, action: "didTapDeleteButton:", forControlEvents: UIControlEvents.TouchUpInside)
		deleteTaskButton.layer.borderWidth = 1
		deleteTaskButton.layer.borderColor = redPrimary.CGColor
		deleteTaskButton.backgroundColor = whitePrimary
		deleteTaskButton.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(locationUnderline.snp_bottom).offset(20)
			make.centerX.equalTo(taskInformationContainer.snp_centerX)
			make.height.equalTo(45)
			make.width.equalTo(200)
			make.bottom.equalTo(taskInformationContainer.snp_bottom).offset(-20)
		}
		taskInformationContainer.sizeToFit()
		
		self.createPicturesContainer()
		
		
		let fakeView = UIView()
		self.contentView.addSubview(fakeView)
		fakeView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.picturesContainer.snp_bottom)
			make.bottom.equalTo(self.contentView.snp_bottom)
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
	
	func createPicturesContainer(){
		
		let picturesContainer = UIView()
		contentView.addSubview(picturesContainer)
		self.picturesContainer = picturesContainer
		picturesContainer.backgroundColor = whitePrimary
		picturesContainer.layer.borderColor = darkGrayDetails.CGColor
		picturesContainer.layer.borderWidth = 0.5
		picturesContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(taskInformationContainer.snp_bottom).offset(10)
			make.left.equalTo(contentView.snp_left).offset(-1)
			make.right.equalTo(contentView.snp_right)
		}
		
		let managePicturesLabel = UILabel()
		picturesContainer.addSubview(managePicturesLabel)
		managePicturesLabel.text = "Manage Pictures"
		managePicturesLabel.textColor = blackPrimary
		managePicturesLabel.font = UIFont(name: "Lato-Regular", size: kEditTaskSubtitleFontSize)
		managePicturesLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(picturesContainer.snp_top).offset(10)
			make.left.equalTo(picturesContainer.snp_left).offset(10)
		}
		
		if self.pictures != nil{
		}
		
		if self.pictures != nil {
	}
		
		picturesContainer.sizeToFit()
		
		//Save button
		
		let saveChangesButton = UIButton()
		contentView.addSubview(saveChangesButton)
		saveChangesButton.setTitle("Save", forState: UIControlState.Normal)
		saveChangesButton.setTitleColor(grayBlue, forState: UIControlState.Normal)
		saveChangesButton.addTarget(self, action: "didTapSaveButton:", forControlEvents: UIControlEvents.TouchUpInside)
		saveChangesButton.layer.borderWidth = 1
		saveChangesButton.layer.borderColor = grayBlue.CGColor
		saveChangesButton.backgroundColor = whitePrimary
		saveChangesButton.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(picturesContainer.snp_bottom).offset(10)
			make.centerX.equalTo(taskInformationContainer.snp_centerX)
			make.height.equalTo(45)
			make.width.equalTo(200)
			make.bottom.equalTo(contentView.snp_bottom).offset(-10)
		}
		
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
		self.tap = tap
		contentView.addGestureRecognizer(tap)
	}
	
	
	func makeDeniedApplicantsContainer(){
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
		}
		
		let deniedApplicantIcon = UIImageView()
		self.deniedApplicantIcon = deniedApplicantIcon
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
		self.deniedApplicantsLabel = deniedApplicantsLabel
		deniedApplicantsContainer.addSubview(deniedApplicantsLabel)
		deniedApplicantsLabel.textAlignment = NSTextAlignment.Left
		deniedApplicantsLabel.text = "Declined Nelpers"
		deniedApplicantsLabel.textColor = blackPrimary
		deniedApplicantsLabel.font = UIFont(name: "Lato-Regular", size: kNavTitle18)
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
	func setImages(task:FindNelpTask){
		self.categoryIcon.layer.cornerRadius = self.categoryIcon.frame.size.width / 2;
		self.categoryIcon.clipsToBounds = true
		self.categoryIcon.image = UIImage(named: task.category!)
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
			make.height.equalTo((self.arrayOfDeniedApplicants.count*100)+65)
		}
		
		activeApplicantsContainer.snp_updateConstraints { (make) -> Void in
			make.top.equalTo(self.contentView.snp_top).offset(20)
			make.left.equalTo(self.contentView.snp_left)
			make.right.equalTo(self.contentView.snp_right)
			make.height.equalTo((self.arrayOfApplicants.count*100)+65)
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
			let applicant = self.arrayOfApplications[indexPath.row]
			pendingApplicantCell.setApplication(applicant)
			return pendingApplicantCell
			
		} else if tableView == deniedApplicantsTableView {
			
			let deniedApplicantCell = tableView.dequeueReusableCellWithIdentifier(ApplicantCell.reuseIdentifier, forIndexPath: indexPath) as! ApplicantCell
			let deniedApplicant = self.arrayOfDeniedApplicants[indexPath.row]
			deniedApplicantCell.setApplicant(deniedApplicant)
			for application in self.arrayOfApplications{
				if application.user.objectId == deniedApplicant.objectId{
					deniedApplicantCell.setApplication(application)
				}
			}
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
		let contentsize = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height + 10)
		self.scrollView.contentSize = contentsize.size
		
		
		if self.arrayOfDeniedApplicants.isEmpty{
			
			self.deniedApplicantsContainer.removeFromSuperview()
			self.taskInformationContainer.snp_updateConstraints(closure: { (make) -> Void in
				make.top.equalTo(self.activeApplicantsContainer.snp_bottom).offset(10)
			})
		}
	}
	
	//MARK: UIGesture Recognizer
	
	func dismissKeyboard(){
		view.endEditing(true)
	}
	
	
	//MARK: Cell delegate methods
	
	func didTapRevertButton(applicant:User){
		var applicationToRevert:TaskApplication!
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
		let query = PFQuery(className: "TaskApplication")
		query.getObjectInBackgroundWithId(applicationToRevert.objectId, block: { (application, error) -> Void in
			if error != nil{
				print(error)
			} else if let application = application{
				application["state"] = applicationToRevert.state.rawValue
				application.saveInBackground()
			}
		})
		
		self.refreshTableView()
		if self.arrayOfDeniedApplicants.isEmpty{
			self.deniedApplicantsContainer.removeFromSuperview()
			self.taskInformationContainer.snp_updateConstraints(closure: { (make) -> Void in
				make.top.equalTo(self.activeApplicantsContainer.snp_bottom).offset(10)
			})
		}
	}
	
	
	
	//MARK: Applications Profile View Controller Delegate
	
	func didTapDenyButton(applicant:User){
		var applicationToDeny:TaskApplication?
		self.makeDeniedApplicantsContainer()
		self.deniedApplicantsContainer.layoutIfNeeded()
		self.taskInformationContainer.snp_remakeConstraints(closure: { (make) -> Void in
				make.top.equalTo(deniedApplicantsContainer.snp_bottom).offset(20)
				make.left.equalTo(contentView.snp_left).offset(-1)
				make.right.equalTo(contentView.snp_right).offset(1)
			})
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
	
	//MARK: Utilities
	
	/**
	Fetches the task images in order to edit them
	*/
	func getImagesFromParse(){
		if let pffiles = self.pictures{
			for picture in pffiles{
				ApiHelper.getPictures(picture.url!, block: { (image) -> Void in
					self.images.append(image)
				})
			}
		}
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
	
	func didTapAddImage(sender:UIButton){
		imagePicker.allowsEditing = false
		imagePicker.sourceType = .PhotoLibrary
		presentViewController(imagePicker, animated: true, completion: nil)
	}
	
	func didTapSaveButton(sender:UIButton){
		self.task.title = self.titleTextField.text
		print(self.task.title, terminator: "")
		if !self.images.isEmpty{
			self.task.pictures = ApiHelper.convertImagesToData(self.images)
		}
		self.task.desc = self.descriptionTextView.text
		
		ApiHelper.editTask(self.task)
		self.didEditTask(self.task)
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func didTapDeleteButton(sender:UIButton){
		if sender.selected == false {
			sender.selected = true
			
		}else if sender.selected == true{
			ApiHelper.deleteTask(self.task)
			self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
			self.dismissViewControllerAnimated(true, completion: nil)
		}
	}
	
}