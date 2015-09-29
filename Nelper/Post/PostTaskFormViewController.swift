//
//  PostTaskFormViewController.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-07-25.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

protocol PostTaskFormViewControllerDelegate {
	func nelpTaskAdded(nelpTask: FindNelpTask) -> Void
	func dismiss()
}

class PostTaskFormViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate,AddAddressViewControllerDelegate {
	
	let kGoogleAPIKey = "AIzaSyC4IkGUD1uY53E1aihYxDvav3SbdCDfzq8"
	let imagePicker = UIImagePickerController()
	var task: FindNelpTask!
	var placesClient: GMSPlacesClient?
	var locationTextField: UITextField?
	var titleTextField:UITextField?
	var descriptionTextView:UITextView?
	var priceOffered:UITextField?
	var autocompleteArray = [GMSAutocompletePrediction]()
	var imagesArray = NSMutableArray()
	var tap: UITapGestureRecognizer?
	var contentView:UIView!
	var scrollView:UIScrollView!
	var navBar:NavBar!
	var autocompleteTableView:UITableView!
	var titleStatus:UIImageView!
	var priceStatus:UIImageView!
	var deleteAddressButton:UIButton!
	var addLocationButton:UIButton!
	
	var delegate: PostTaskFormViewControllerDelegate?
	
	//MARK: Initialization
	
	init(task: FindNelpTask){
		super.init(nibName: nil, bundle: nil)
		self.task = task
		self.placesClient = GMSPlacesClient()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		self.imagePicker.delegate = self
		self.createView()
		self.adjustUI()
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
		self.tap = tap
		contentView.addGestureRecognizer(tap)
		}
	
	override func viewDidAppear(animated: Bool) {
	}
	
	//MARK: View Creation
	
	func createView(){
		
		let contentInset: CGFloat = 12
		
		let navBar = NavBar()
		self.navBar = navBar
		self.view.addSubview(navBar)
		navBar.setTitle("Post a task")
		navBar.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.view.snp_top)
			make.right.equalTo(self.view.snp_right)
			make.left.equalTo(self.view.snp_left)
			make.height.equalTo(64)
		}
		
		//ScrollView + ContentView
		
		let backgroundView = UIView()
		backgroundView.backgroundColor = whiteBackground
		self.view.addSubview(backgroundView)
		backgroundView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(navBar.snp_bottom)
			make.left.equalTo(self.view.snp_left)
			make.right.equalTo(self.view.snp_right)
			make.bottom.equalTo(self.view.snp_bottom)
		}
		
		let scrollView = UIScrollView()
		self.scrollView = scrollView
		backgroundView.addSubview(scrollView)
		scrollView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(backgroundView.snp_edges)
		}
		
		let contentView = UIView()
		self.contentView = contentView
		scrollView.addSubview(contentView)
		contentView.backgroundColor = whiteBackground
		contentView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(scrollView.snp_top)
			make.left.equalTo(scrollView.snp_left)
			make.right.equalTo(scrollView.snp_right)
			make.width.equalTo(backgroundView.snp_width)
			make.height.greaterThanOrEqualTo(backgroundView.snp_height)
		}
		
		//Header Picture
		
		let headerPicture = UIImageView()
		contentView.addSubview(headerPicture)
		headerPicture.image = UIImage(named: "square_\(self.task.category!)")
		headerPicture.contentMode = UIViewContentMode.ScaleAspectFill
		headerPicture.clipsToBounds = true
		headerPicture.layer.borderWidth = 1
		headerPicture.layer.borderColor = grayDetails.CGColor
		headerPicture.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(contentView.snp_top).offset(-1)
			make.left.equalTo(contentView.snp_left).offset(-1)
			make.right.equalTo(contentView.snp_right).offset(1)
			make.height.equalTo(100)
		}
		
		let blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
		let blurView = UIVisualEffectView(effect: blur)
		headerPicture.addSubview(blurView)
		blurView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(headerPicture.snp_edges)
		}
		
		let topContainerDarkBox = UIView()
		headerPicture.addSubview(topContainerDarkBox)
		topContainerDarkBox.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(headerPicture.snp_edges)
		}
		topContainerDarkBox.backgroundColor = blackPrimary
		topContainerDarkBox.alpha = 0.15
		
		let headerPictureLogo = UIImageView()
		headerPicture.addSubview(headerPictureLogo)
		headerPictureLogo.image = UIImage(named: self.task.category!)
		headerPictureLogo.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(60)
			make.width.equalTo(60)
			make.center.equalTo(headerPicture.snp_center)
		}
		
		let taskFormContainer = UIView()
		taskFormContainer.layer.borderWidth = 1
		taskFormContainer.layer.borderColor = grayDetails.CGColor
		self.contentView.addSubview(taskFormContainer)
		taskFormContainer.backgroundColor = whitePrimary
		taskFormContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(headerPicture.snp_bottom).offset(20)
			make.left.equalTo(contentView.snp_left).offset(-1)
			make.right.equalTo(contentView.snp_right).offset(1)
		}
		
		
		//Task Title Label + TextField
		
		let taskTitleLabel = UILabel()
		taskFormContainer.addSubview(taskTitleLabel)
		taskTitleLabel.text = "Enter your Task Title"
		taskTitleLabel.textColor = blackPrimary
		taskTitleLabel.font = UIFont(name: "Lato-Regular", size: kTitle17)
		
		taskTitleLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(taskFormContainer.snp_top).offset(15)
			make.left.equalTo(contentView.snp_left).offset(contentInset)
		}
		let taskTitleTextField = UITextField()
		taskTitleTextField.delegate = self
		self.titleTextField = taskTitleTextField
		taskFormContainer.addSubview(taskTitleTextField)
		taskTitleTextField.backgroundColor = whitePrimary.colorWithAlphaComponent(0.75)
		taskTitleTextField.attributedPlaceholder = NSAttributedString(string: "Title", attributes: [NSForegroundColorAttributeName: blackPrimary.colorWithAlphaComponent(0.75)])
		taskTitleTextField.font = UIFont(name: "Lato-Regular", size: kText15)
		taskTitleTextField.textColor = blackPrimary
		taskTitleTextField.textAlignment = NSTextAlignment.Left
		taskTitleTextField.layer.borderColor = grayDetails.CGColor
		taskTitleTextField.layer.borderWidth = 1
		let paddingViewTitle = UIView(frame: CGRectMake(0, 0, 10, 0))
		taskTitleTextField.leftView = paddingViewTitle
		taskTitleTextField.leftViewMode = UITextFieldViewMode.Always
		
		taskTitleTextField.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(taskTitleLabel.snp_left)
			make.top.equalTo(taskTitleLabel.snp_bottom).offset(10)
			make.right.equalTo(contentView.snp_right).offset(-50)
			make.height.equalTo(50)
		}
		
		let titleStatus = UIImageView()
		self.titleStatus = titleStatus
		taskFormContainer.addSubview(titleStatus)
		titleStatus.image = UIImage(named: "denied")
		titleStatus.contentMode = UIViewContentMode.ScaleAspectFit
		titleStatus.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(taskTitleTextField.snp_right).offset(2)
			make.right.equalTo(contentView.snp_right).offset(-2)
			make.centerY.equalTo(taskTitleTextField.snp_centerY)
			make.height.equalTo(30)
		}
		
		//Description Label + Textfield
		
		let descriptionLabel = UILabel()
		taskFormContainer.addSubview(descriptionLabel)
		descriptionLabel.text = "Briefly describe the task"
		descriptionLabel.textColor = blackPrimary
		descriptionLabel.font = UIFont(name: "Lato-Regular", size: kTitle17)
		
		descriptionLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(taskTitleTextField.snp_bottom).offset(20)
			make.left.equalTo(taskTitleTextField.snp_left)
		}
		let descriptionTextView = UITextView()
		self.descriptionTextView = descriptionTextView
		descriptionTextView.delegate = self
		taskFormContainer.addSubview(descriptionTextView)
		descriptionTextView.backgroundColor = whitePrimary.colorWithAlphaComponent(0.75)
		descriptionTextView.font = UIFont(name: "Lato-Regular", size: kText15)
		descriptionTextView.textColor = blackPrimary
		descriptionTextView.textAlignment = NSTextAlignment.Left
		descriptionTextView.layer.cornerRadius = 3
		descriptionTextView.layer.borderColor = grayDetails.CGColor
		descriptionTextView.layer.borderWidth = 1
		
		
		descriptionTextView.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(taskTitleLabel.snp_left)
			make.top.equalTo(descriptionLabel.snp_bottom).offset(10)
			make.right.equalTo(contentView.snp_right).offset(-50)
			make.height.equalTo(150)
		}

		
		//Price Offered Label + TextField
		
		let priceOfferedLabel = UILabel()
		taskFormContainer.addSubview(priceOfferedLabel)
		priceOfferedLabel.text = "How much are you offering?"
		priceOfferedLabel.textColor = blackPrimary
		priceOfferedLabel.font = UIFont(name: "Lato-Regular", size: kTitle17)
		
		priceOfferedLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(descriptionTextView.snp_bottom).offset(20)
			make.left.equalTo(taskTitleTextField.snp_left)
		}
		let priceOfferedTextField = UITextField()
		priceOfferedTextField.delegate = self
		self.priceOffered = priceOfferedTextField
		taskFormContainer.addSubview(priceOfferedTextField)
		priceOfferedTextField.backgroundColor = whitePrimary.colorWithAlphaComponent(0.75)
		priceOfferedTextField.attributedPlaceholder = NSAttributedString(string: "$", attributes: [NSForegroundColorAttributeName: blackPrimary.colorWithAlphaComponent(0.75)])
		priceOfferedTextField.font = UIFont(name: "Lato-Regular", size: kText15)
		priceOfferedTextField.textColor = blackPrimary
		priceOfferedTextField.textAlignment = NSTextAlignment.Left
		priceOfferedTextField.layer.cornerRadius = 3
		priceOfferedTextField.layer.borderColor = grayDetails.CGColor
		priceOfferedTextField.layer.borderWidth = 1
		let paddingViewPrice = UIView(frame: CGRectMake(0, 0, 10, 0))
		priceOfferedTextField.leftView = paddingViewPrice
		priceOfferedTextField.leftViewMode = UITextFieldViewMode.Always
		priceOfferedTextField.keyboardType = UIKeyboardType.NumberPad
		
		priceOfferedTextField.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(taskTitleLabel.snp_left)
			make.top.equalTo(priceOfferedLabel.snp_bottom).offset(10)
			make.right.equalTo(contentView.snp_right).offset(-50)
			make.height.equalTo(50)
		}
		
		let priceStatus = UIImageView()
		self.priceStatus = priceStatus
		taskFormContainer.addSubview(priceStatus)
		priceStatus.image = UIImage(named: "denied")
		priceStatus.contentMode = UIViewContentMode.ScaleAspectFit
		priceStatus.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(priceOfferedTextField.snp_right).offset(2)
			make.right.equalTo(contentView.snp_right).offset(-2)
			make.centerY.equalTo(priceOfferedTextField.snp_centerY)
			make.height.equalTo(30)
		}
		
		//Location Label + TextField
		let locationLabel = UILabel()
		taskFormContainer.addSubview(locationLabel)
		locationLabel.text = "Select your task's location"
		locationLabel.textColor = blackPrimary
		locationLabel.font = UIFont(name: "Lato-Regular", size: kTitle17)
		
		locationLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(priceOfferedTextField.snp_bottom).offset(20)
			make.left.equalTo(taskTitleTextField.snp_left)
		}
		let locationTextField = UITextField()
		taskFormContainer.addSubview(locationTextField)
		self.locationTextField = locationTextField
		self.locationTextField!.delegate = self
		locationTextField.backgroundColor = whitePrimary.colorWithAlphaComponent(0.75)
		locationTextField.attributedPlaceholder = NSAttributedString(string: "Address", attributes: [NSForegroundColorAttributeName: blackPrimary.colorWithAlphaComponent(0.75)])
		locationTextField.font = UIFont(name: "Lato-Regular", size: kText15)
		locationTextField.textColor = blackPrimary
		locationTextField.textAlignment = NSTextAlignment.Left
		locationTextField.layer.cornerRadius = 3
		locationTextField.layer.borderColor = grayDetails.CGColor
		locationTextField.layer.borderWidth = 1
		let paddingViewLocation = UIView(frame: CGRectMake(0, 0, 10, 0))
		locationTextField.leftView = paddingViewLocation
		locationTextField.leftViewMode = UITextFieldViewMode.Always
		
		locationTextField.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(taskTitleLabel.snp_left)
			make.top.equalTo(locationLabel.snp_bottom).offset(10)
			make.width.equalTo(self.contentView.snp_width).multipliedBy(0.66)
			make.height.equalTo(50)
		}
		
		let addLocationButton = UIButton()
		taskFormContainer.addSubview(addLocationButton)
		self.addLocationButton = addLocationButton
		addLocationButton.addTarget(self, action: "didTapAddLocation:", forControlEvents: UIControlEvents.TouchUpInside)
		addLocationButton.backgroundColor = whitePrimary
		addLocationButton.setTitle("Add", forState: UIControlState.Normal)
		addLocationButton.setTitleColor(redPrimary, forState: UIControlState.Normal)
		addLocationButton.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(locationTextField.snp_height)
			make.left.equalTo(locationTextField.snp_right).offset(4)
			make.bottom.equalTo(locationTextField.snp_bottom)
		}
		
		let streetAddressLabel = UILabel()
		streetAddressLabel.text = "123 Temporaire"
		taskFormContainer.addSubview(streetAddressLabel)
		streetAddressLabel.textColor = blackPrimary
		streetAddressLabel.font = UIFont(name: "Lato-Light", size: kText15)
		streetAddressLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(locationTextField.snp_bottom).offset(16)
			make.left.equalTo(locationTextField.snp_left)
		}
		
		let cityAddressLabel = UILabel()
		cityAddressLabel.text = "Montreal"
		taskFormContainer.addSubview(cityAddressLabel)
		cityAddressLabel.textColor = blackPrimary
		cityAddressLabel.font = UIFont(name: "Lato-Light", size: kText15)
		cityAddressLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(streetAddressLabel.snp_bottom)
			make.left.equalTo(streetAddressLabel.snp_left)
		}
		
		let deleteAddressButton = UIButton()
		taskFormContainer.addSubview(deleteAddressButton)
		self.deleteAddressButton = deleteAddressButton
		deleteAddressButton.setTitle("Delete Address", forState: UIControlState.Normal)
		deleteAddressButton.setTitle("Sure?", forState: UIControlState.Selected)
		deleteAddressButton.setTitleColor(blackPrimary, forState: UIControlState.Normal)
		deleteAddressButton.setTitleColor(redPrimary, forState: UIControlState.Selected)
		self.deleteAddressButton.addTarget(self, action: "didTapDeleteAddress:", forControlEvents: UIControlEvents.TouchUpInside)
		deleteAddressButton.layer.borderWidth = 0.5
		deleteAddressButton.layer.borderColor = darkGrayDetails.CGColor
		deleteAddressButton.backgroundColor = whitePrimary
		deleteAddressButton.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(cityAddressLabel.snp_bottom).offset(16)
			make.left.equalTo(cityAddressLabel.snp_left)
			make.height.equalTo(35)
			make.width.equalTo(200)
			make.bottom.equalTo(taskFormContainer.snp_bottom).offset(-16)
		}
		
		//Pictures Container
		
		let picturesContainer = UIView()
		picturesContainer.backgroundColor = whitePrimary
		contentView.addSubview(picturesContainer)
		picturesContainer.layer.borderColor = grayDetails.CGColor
		picturesContainer.layer.borderWidth = 1
		picturesContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(taskFormContainer.snp_bottom).offset(20)
			make.left.equalTo(contentView.snp_left).offset(-1)
			make.right.equalTo(contentView.snp_right).offset(1)
			make.height.equalTo(160)
		}
		
		
		//Attach Pictures Button
		
		let picturesButton = UIButton()
		picturesContainer.addSubview(picturesButton)
		picturesButton.backgroundColor = redPrimary
		picturesButton.setTitleColor(whitePrimary, forState: UIControlState.Normal)
		picturesButton.titleLabel?.font = UIFont(name: "Lato-Regular", size: kTitle17)
		picturesButton.setTitle("Add Pictures", forState: UIControlState.Normal)
		
		picturesButton.addTarget(self, action: "attachPicturesButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		picturesButton.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(deleteAddressButton.snp_left)
			make.bottom.equalTo(picturesContainer.snp_bottom).offset(-16)
			make.height.equalTo(35)
			make.width.equalTo(200)
		}
		
		//Create task button
		
		let createTaskButton = UIButton()
		self.contentView.addSubview(createTaskButton)
		createTaskButton.setTitle("Post Task!", forState: UIControlState.Normal)
		createTaskButton.setTitleColor(whitePrimary, forState: UIControlState.Normal)
		createTaskButton.backgroundColor = redPrimary
		createTaskButton.titleLabel?.font = UIFont(name: "Lato-Regular", size: kTitle17)
		createTaskButton.addTarget(self, action: "postButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		
		createTaskButton.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(self.view.snp_left).offset(20)
			make.right.equalTo(self.view.snp_right).offset(-20)
			make.height.equalTo(40)
			make.top.equalTo(picturesContainer.snp_bottom).offset(20)
			make.centerX.equalTo(self.contentView.snp_centerX)
			make.bottom.equalTo(self.contentView.snp_bottom).offset(-20)
		}
	}
	
	func adjustUI(){
		let previousBtn = UIButton()
		previousBtn.addTarget(self, action: "backButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		self.navBar.closeButton = previousBtn
		self.contentView.backgroundColor = whiteBackground
		self.navBar.setTitle("Create your task")
	}
	
	/**
	Converts the attached task pictures to Data in order to save them in parse.
	*/
	func convertImagesToData(){
		self.task.pictures = Array()
		for image in self.imagesArray{
			let imageData = UIImageJPEGRepresentation(image as! UIImage, 0.50)
			let imageFile = PFFile(name:"image.png", data:imageData!)
			self.task.pictures!.append(imageFile)
		}
	}
	
	//MARK: Image Picker Delegate
	
	/**
	Allows the user to pick pictures in his library
	
	- parameter picker: ImagePicker instance
	- parameter info:   .
	*/
	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
		if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
			self.imagesArray.addObject(pickedImage)
//			if(self.imagesArray.count == 1){
//				self.imageOne!.image = pickedImage
//			}else if(self.imagesArray.count == 2){
//				self.imageTwo!.image = pickedImage
//			}else if(self.imagesArray.count == 3){
//				self.imageThree!.image = pickedImage
//			}else if(self.imagesArray.count == 4){
//				self.imageFour!.image = pickedImage
//			}
		}
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	//MARK: TextView Delegate method
	
	func textViewDidBeginEditing(textView: UITextView) {
		self.tap!.enabled = true
	}
	
	//MARK: View Delegate Method
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		self.scrollView.contentSize = self.contentView.frame.size
	}
	
	
	//MARK: Add Address Location Delegate
	
	func didClosePopup(vc: AddAddressViewController) {
	}
	
	func didAddLocation(vc:AddAddressViewController){
		
	}
	
	//MARK: Actions
	
	/**
	Allow the user to attach pictures
	
	- parameter sender: Add pictures button
	*/
	func attachPicturesButtonTapped(sender: UIButton){
		imagePicker.allowsEditing = false
		imagePicker.sourceType = .PhotoLibrary
		presentViewController(imagePicker, animated: true, completion: nil)
	}
	
	/**
	Dismiss Keyboard
	*/
	func DismissKeyboard() {
		view.endEditing(true)
	}
	
	func backButtonTapped(sender: UIButton) {
		self.dismissViewControllerAnimated(true, completion: nil)
		view.endEditing(true) // dissmiss keyboard without delay
	}
	
	/**
	Shows the add address view controller
	
	- parameter sender: Add Address Button
	*/
	func didTapAddLocation(sender:UIButton) {
		let nextVC = AddAddressViewController()
		nextVC.delegate = self
		nextVC.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
		self.providesPresentationContextTransitionStyle = true
		nextVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
		self.presentViewController(nextVC, animated: true, completion: nil)
	}
	
	func didTapDeleteAddress(sender:UIButton){
		
	}
	
	/**
	Post a task on Nelper
	
	- parameter sender: Post Button
	*/
	func postButtonTapped(sender: UIButton) {
		if(self.imagesArray.count != 0){
			self.convertImagesToData()
		}
		self.task.title = self.titleTextField!.text
		self.task.desc = self.descriptionTextView!.text
		self.task.priceOffered = Double(self.priceOffered!.text!)
				ApiHelper.addTask(self.task, block: { (task, error) -> Void in
					self.delegate?.nelpTaskAdded(self.task)
					self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
					self.dismissViewControllerAnimated(true, completion: nil)
				})
	}
}
