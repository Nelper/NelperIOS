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
import FXBlurView
import GoogleMaps

protocol PostTaskFormViewControllerDelegate {
	func nelpTaskAdded(task: Task) -> Void
	func dismiss()
}

class PostTaskFormViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, AddAddressViewControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PicturesCollectionViewCellDelegate {
	
	let kGoogleAPIKey = "AIzaSyC4IkGUD1uY53E1aihYxDvav3SbdCDfzq8"
	let imagePicker = UIImagePickerController()
	var task: Task!
	var placesClient: GMSPlacesClient?
	var locationTextField: UITextField?
	var titleTextField: DefaultTextFieldView!
	var descriptionTextView: UITextView!
	var descriptionStatus: UIImageView!
	var priceOffered: DefaultTextFieldView!
	var autocompleteArray = [GMSAutocompletePrediction]()
	var tap: UITapGestureRecognizer?
	var contentView: UIView!
	var scrollView: UIScrollView!
	var navBar: NavBar!
	var autocompleteTableView: UITableView!
	var titleStatus: UIImageView!
	var priceStatus: UIImageView!
	var locationContainer: UIView!
	var deleteAddressButton: SecondaryActionButton!
	var addLocationButton: PrimaryBorderActionButton!
	var locations: [Location]?
	var locationsPickerView: UIPickerView?
	var streetAddressLabel: UILabel!
	var delegate: PostTaskFormViewControllerDelegate?
	var picturesCollectionView: UICollectionView!
	var arrayOfPictures = [UIImage]()
	
	var taskFormContainer: UIView!
	var backgroundView: UIView!
	var picturesButton: PrimaryBorderActionButton!
	var picturesContainer: UIView!
	var collectionViewHeight = Int()
	var createTaskButton: UIButton!
	
	var contentInsets: UIEdgeInsets!
	var activeField: UIView!
	var fieldEditing = false
	var popupShown = false
	
	var userPrivateData: UserPrivateData!
	
	var acceptedIcon = UIImage(named: "accepted")
	var exclamationIcon = UIImage(named: "exclamation")
	
	var textFieldError: Bool!
	var textFieldErrorMessages = [String]()
	
	var moneyLabel: UILabel!
	
	//MARK: Initialization
	
	init(task: Task) {
		super.init(nibName: nil, bundle: nil)
		self.task = task
		self.placesClient = GMSPlacesClient()
		
		self.userPrivateData = ApiHelper.getUserPrivateData()
		self.locations = userPrivateData.locations
		
		if !self.locations!.isEmpty {
			self.task.location = GeoPoint(latitude: self.locations![0].coords!["latitude"]!, longitude: self.locations![0].coords!["longitude"]!)
			self.task.city = self.locations![0].city
			self.task.exactLocation = self.locations![0]
		} else {
			self.locations = [Location]()
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		self.imagePicker.delegate = self
		self.createView()
		self.adjustUI()
		
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
		self.tap = tap
		contentView.addGestureRecognizer(tap)
		
		// KEYBOARD VIEW MOVER
		self.titleTextField.delegate = self
		self.priceOffered.delegate = self
		self.descriptionTextView.delegate = self
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(true)
		
		self.locationsPickerView?.selectRow(0, inComponent: 0, animated: false)
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardDidShow:"), name: UIKeyboardDidShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
	}
	
	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(true)
		
		NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
	}
	
	//MARK: View Creation
	
	func createView() {
		
		let contentInset: CGFloat = 12
		
		let navBar = NavBar()
		self.navBar = navBar
		self.view.addSubview(navBar)
		navBar.setTitle("Post a task")
		let previousBtn = UIButton()
		previousBtn.addTarget(self, action: "backButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		self.navBar.backButton = previousBtn
		navBar.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.view.snp_top)
			make.right.equalTo(self.view.snp_right)
			make.left.equalTo(self.view.snp_left)
			make.height.equalTo(64)
		}
		
		//ScrollView + ContentView
		
		let backgroundView = UIView()
		self.backgroundView = backgroundView
		backgroundView.backgroundColor = Color.whiteBackground
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
		contentView.backgroundColor = Color.whiteBackground
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
		headerPicture.image = UIImage(named: "\(self.task.category!)-nc-bg")
		headerPicture.contentMode = UIViewContentMode.ScaleAspectFill
		headerPicture.clipsToBounds = true
		headerPicture.layer.borderWidth = 1
		headerPicture.layer.borderColor = Color.grayDetails.CGColor
		headerPicture.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(contentView.snp_top).offset(-1)
			make.left.equalTo(contentView.snp_left).offset(-2)
			make.right.equalTo(contentView.snp_right).offset(1)
			make.height.equalTo(100)
		}
		
		let darkenView = UIView()
		headerPicture.addSubview(darkenView)
		darkenView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.05)
		darkenView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(headerPicture.snp_edges)
		}
		
		let headerPictureLogo = UIImageView()
		headerPicture.addSubview(headerPictureLogo)
		headerPictureLogo.image = UIImage(named: self.task.category!)
		headerPictureLogo.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(60)
			make.width.equalTo(60)
			make.center.equalTo(headerPicture.snp_center)
		}
		
		let taskFormContainer = UIView()
		self.taskFormContainer = taskFormContainer
		taskFormContainer.layer.borderWidth = 1
		taskFormContainer.layer.borderColor = Color.grayDetails.CGColor
		self.contentView.addSubview(taskFormContainer)
		taskFormContainer.backgroundColor = Color.whitePrimary
		taskFormContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(headerPicture.snp_bottom).offset(20)
			make.left.equalTo(contentView.snp_left).offset(-1)
			make.right.equalTo(contentView.snp_right).offset(1)
		}
		
		//Task Title Label + TextField
		
		let statusIconHeight = 20
		
		let taskTitleLabel = UILabel()
		taskFormContainer.addSubview(taskTitleLabel)
		taskTitleLabel.text = "Enter your task title"
		taskTitleLabel.textColor = Color.blackPrimary
		taskTitleLabel.font = UIFont(name: "Lato-Regular", size: kTitle17)
		
		taskTitleLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(taskFormContainer.snp_top).offset(15)
			make.left.equalTo(contentView.snp_left).offset(contentInset)
		}
		
		let taskTitleTextField = DefaultTextFieldView(isPriceTextField: false)
		taskTitleTextField.delegate = self
		self.titleTextField = taskTitleTextField
		taskFormContainer.addSubview(taskTitleTextField)
		taskTitleTextField.attributedPlaceholder = NSAttributedString(string: " Title", attributes: [NSForegroundColorAttributeName: Color.textFieldPlaceholderColor])
		taskTitleTextField.returnKeyType = .Next
		taskTitleTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: .EditingChanged)
		taskTitleTextField.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(taskTitleLabel.snp_left)
			make.top.equalTo(taskTitleLabel.snp_bottom).offset(10)
			make.right.equalTo(contentView.snp_right).offset(-15)
		}
		
		let titleStatus = UIImageView()
		self.titleStatus = titleStatus
		taskFormContainer.addSubview(titleStatus)
		titleStatus.image = nil
		titleStatus.contentMode = UIViewContentMode.ScaleAspectFit
		titleStatus.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(taskTitleTextField.snp_right)
			make.centerY.equalTo(taskTitleLabel.snp_centerY)
			make.height.equalTo(statusIconHeight)
			make.width.equalTo(statusIconHeight)
		}
		
		//Description Label + Textfield
		
		let descriptionLabel = UILabel()
		taskFormContainer.addSubview(descriptionLabel)
		descriptionLabel.text = "Briefly describe the task"
		descriptionLabel.textColor = Color.blackPrimary
		descriptionLabel.font = UIFont(name: "Lato-Regular", size: kTitle17)
		
		descriptionLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(taskTitleTextField.snp_bottom).offset(20)
			make.left.equalTo(taskTitleTextField.snp_left)
		}
		let descriptionTextView = UITextView()
		self.descriptionTextView = descriptionTextView
		descriptionTextView.delegate = self
		taskFormContainer.addSubview(descriptionTextView)
		descriptionTextView.backgroundColor = Color.whitePrimary
		descriptionTextView.font = UIFont(name: "Lato-Regular", size: kText15)
		descriptionTextView.textColor = Color.textFieldPlaceholderColor
		descriptionTextView.textAlignment = NSTextAlignment.Justified
		descriptionTextView.layer.borderColor = Color.grayDetails.CGColor
		descriptionTextView.layer.borderWidth = 1
		descriptionTextView.textContainerInset = UIEdgeInsetsMake(9, 7, 0, 0)
		descriptionTextView.text = " Description   "
		descriptionTextView.returnKeyType = .Next
		descriptionTextView.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(taskTitleLabel.snp_left)
			make.top.equalTo(descriptionLabel.snp_bottom).offset(10)
			make.right.equalTo(titleTextField.snp_right)
			make.height.equalTo(150)
		}
		
		let descriptionStatus = UIImageView()
		self.descriptionStatus = descriptionStatus
		taskFormContainer.addSubview(descriptionStatus)
		descriptionStatus.image = nil
		descriptionStatus.contentMode = UIViewContentMode.ScaleAspectFit
		descriptionStatus.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(descriptionTextView.snp_right)
			make.centerY.equalTo(descriptionLabel.snp_centerY)
			make.height.equalTo(statusIconHeight)
			make.width.equalTo(statusIconHeight)
		}
		
		//Price Offered Label + TextField
		
		let priceOfferedLabel = UILabel()
		taskFormContainer.addSubview(priceOfferedLabel)
		priceOfferedLabel.text = "How much are you offering?"
		priceOfferedLabel.textColor = Color.blackPrimary
		priceOfferedLabel.font = UIFont(name: "Lato-Regular", size: kTitle17)
		priceOfferedLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(descriptionTextView.snp_bottom).offset(20)
			make.left.equalTo(taskTitleTextField.snp_left)
		}
		
		let priceOfferedTextField = DefaultTextFieldView(isPriceTextField: true)
		priceOfferedTextField.delegate = self
		self.priceOffered = priceOfferedTextField
		taskFormContainer.addSubview(priceOfferedTextField)
		priceOfferedTextField.backgroundColor = Color.whitePrimary
		priceOfferedTextField.font = UIFont(name: "Lato-Regular", size: kText15)
		priceOfferedTextField.textColor = Color.textFieldTextColor
		priceOfferedTextField.clearButtonMode = .WhileEditing
		priceOfferedTextField.textAlignment = NSTextAlignment.Left
		priceOfferedTextField.layer.borderColor = Color.grayDetails.CGColor
		priceOfferedTextField.layer.borderWidth = 1
		priceOfferedTextField.keyboardType = .NumberPad
		priceOfferedTextField.returnKeyType = .Done
		priceOfferedTextField.autocorrectionType = .No
		priceOfferedTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: .EditingChanged)
		priceOfferedTextField.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(taskTitleLabel.snp_left)
			make.top.equalTo(priceOfferedLabel.snp_bottom).offset(10)
			make.right.equalTo(titleTextField.snp_right)
			make.height.equalTo(40)
		}
		
		let moneyLabel = UILabel()
		self.moneyLabel = moneyLabel
		priceOfferedTextField.addSubview(moneyLabel)
		moneyLabel.text = "$"
		moneyLabel.font = UIFont(name: "Lato-Regular", size: kText15)
		moneyLabel.textColor = Color.textFieldPlaceholderColor
		moneyLabel.snp_makeConstraints(closure: { (make) -> Void in
			make.left.equalTo(priceOfferedTextField.snp_left).offset(10)
			make.centerY.equalTo(priceOfferedTextField.snp_centerY)
		})
		
		let toolBar = UIToolbar()
		toolBar.barStyle = .Default
		toolBar.translucent = true
		toolBar.tintColor = Color.redPrimary
		toolBar.sizeToFit()
		
		let doneButton = UIBarButtonItem(title: "Done", style: .Done, target: self, action: "doneToolbar:")
		let spacingButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
		
		toolBar.setItems([spacingButton, doneButton], animated: false)
		toolBar.userInteractionEnabled = true
		
		priceOfferedTextField.inputAccessoryView = toolBar
		
		let priceStatus = UIImageView()
		self.priceStatus = priceStatus
		taskFormContainer.addSubview(priceStatus)
		priceStatus.image = nil
		priceStatus.contentMode = UIViewContentMode.ScaleAspectFit
		priceStatus.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(priceOfferedTextField.snp_right)
			make.centerY.equalTo(priceOfferedLabel.snp_centerY)
			make.height.equalTo(statusIconHeight)
			make.width.equalTo(statusIconHeight)
		}
		
		//Task Location
		
		setLocations(false)
		
		//Pictures Container
		
		let picturesContainer = UIView()
		self.picturesContainer = picturesContainer
		picturesContainer.backgroundColor = Color.whitePrimary
		contentView.addSubview(picturesContainer)
		picturesContainer.layer.borderColor = Color.grayDetails.CGColor
		picturesContainer.layer.borderWidth = 1
		picturesContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(taskFormContainer.snp_bottom).offset(20)
			make.left.equalTo(contentView.snp_left).offset(-1)
			make.right.equalTo(contentView.snp_right).offset(1)
		}
		
		//Attach Pictures Button
		
		self.collectionViewHeight = 150
		
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
		
		let picturesCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: flowLayout)
		picturesContainer.addSubview(picturesCollectionView)
		self.picturesCollectionView = picturesCollectionView
		self.picturesCollectionView.delegate = self
		self.picturesCollectionView.dataSource = self
		picturesCollectionView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(picturesContainer.snp_top).offset(10)
			make.height.equalTo(collectionViewHeight)
			make.left.equalTo(picturesContainer.snp_left).offset(5)
			make.right.equalTo(picturesContainer.snp_right).offset(-5)
		}
		
		let picturesButton = PrimaryBorderActionButton()
		self.picturesButton = picturesButton
		picturesContainer.addSubview(picturesButton)
		picturesButton.setTitle("Add pictures", forState: UIControlState.Normal)
		picturesButton.addTarget(self, action: "attachPicturesButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		picturesButton.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(picturesContainer.snp_centerX)
			make.top.equalTo(picturesContainer.snp_top).offset(20)
		}
		
		picturesContainer.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(picturesButton.snp_bottom).offset(20)
		}
		
		picturesCollectionView.registerClass(PicturesCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: PicturesCollectionViewCell.reuseIdentifier)
		picturesCollectionView.backgroundColor = UIColor.clearColor()
		
		//Create task button
		
		let createTaskButton = UIButton()
		self.createTaskButton = createTaskButton
		self.contentView.addSubview(createTaskButton)
		createTaskButton.setTitle("Post task!", forState: UIControlState.Normal)
		createTaskButton.setTitleColor(Color.whitePrimary, forState: UIControlState.Normal)
		createTaskButton.backgroundColor = Color.redPrimary
		createTaskButton.titleLabel?.font = UIFont(name: "Lato-Regular", size: kTitle17)
		createTaskButton.addTarget(self, action: "postButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		createTaskButton.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(self.contentView.snp_left).offset(contentInset * 2)
			make.right.equalTo(self.contentView.snp_right).offset(-contentInset * 2)
			make.top.equalTo(picturesContainer.snp_bottom).offset(20)
			make.height.equalTo(50)
			make.centerX.equalTo(self.contentView.snp_centerX)
			make.bottom.equalTo(self.contentView.snp_bottom).offset(-20)
		}
	}
	
	func adjustUI() {
		
	}
	
	func setLocations(isUpdate: Bool) {
		
		if isUpdate {
			self.locationContainer.removeFromSuperview()
		}
		
		let locationContainer = UIView()
		self.locationContainer = locationContainer
		self.taskFormContainer.addSubview(locationContainer)
		locationContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.priceOffered.snp_bottom).offset(20)
			make.left.equalTo(self.titleTextField.snp_left)
			make.right.equalTo(self.taskFormContainer.snp_right)
		}
		
		if self.locations!.isEmpty {
			
			let locationLabel = UILabel()
			locationContainer.addSubview(locationLabel)
			locationLabel.text = "Select a location for your task"
			locationLabel.textColor = Color.blackPrimary
			locationLabel.font = UIFont(name: "Lato-Regular", size: kTitle17)
			locationLabel.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(locationContainer.snp_top)
				make.left.equalTo(locationContainer.snp_left)
			}
			
			let addLocationButton = PrimaryBorderActionButton()
			locationContainer.addSubview(addLocationButton)
			self.addLocationButton = addLocationButton
			addLocationButton.addTarget(self, action: "didTapAddLocation:", forControlEvents: UIControlEvents.TouchUpInside)
			addLocationButton.setTitle("Add new location", forState: UIControlState.Normal)
			addLocationButton.snp_makeConstraints { (make) -> Void in
				make.centerX.equalTo(self.taskFormContainer.snp_centerX)
				make.top.equalTo(locationLabel.snp_bottom).offset(15)
			}
			
			locationContainer.snp_makeConstraints { (make) -> Void in
				make.bottom.equalTo(addLocationButton.snp_bottom)
			}
			
		} else {
			
			//Location Label + TextField
			let locationLabel = UILabel()
			locationContainer.addSubview(locationLabel)
			locationLabel.text = "Select a location for your task"
			locationLabel.textColor = Color.blackPrimary
			locationLabel.font = UIFont(name: "Lato-Regular", size: kTitle17)
			locationLabel.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(locationContainer.snp_top)
				make.left.equalTo(locationContainer.snp_left)
			}
			
			let locationTextField = UITextField()
			self.locationTextField = locationTextField
			locationTextField.delegate = self
			locationContainer.addSubview(locationTextField)
			locationTextField.backgroundColor = Color.whitePrimary
			locationTextField.tintColor = locationTextField.backgroundColor
			locationTextField.text = self.locations!.first!.name!
			locationTextField.attributedPlaceholder = NSAttributedString(string: "Address", attributes: [NSForegroundColorAttributeName: Color.blackPrimary.colorWithAlphaComponent(0.75)])
			locationTextField.font = UIFont(name: "Lato-Regular", size: kText15)
			locationTextField.textColor = Color.textFieldTextColor
			locationTextField.textAlignment = NSTextAlignment.Center
			locationTextField.delegate = self
			
			//Picker view
			
			let locationsPickerView = UIPickerView()
			self.locationsPickerView = locationsPickerView
			locationsPickerView.delegate = self
			locationTextField.inputView = locationsPickerView
			locationTextField.layer.borderColor = Color.grayDetails.CGColor
			locationTextField.layer.borderWidth = 1
			locationTextField.snp_makeConstraints { (make) -> Void in
				make.left.equalTo(locationLabel.snp_left)
				make.top.equalTo(locationLabel.snp_bottom).offset(10)
				make.right.equalTo(self.contentView.snp_right).offset(-100)
				make.height.equalTo(40)
			}
			
			let toolBar = UIToolbar()
			toolBar.barStyle = .Default
			toolBar.translucent = true
			toolBar.tintColor = Color.redPrimary
			toolBar.sizeToFit()
			
			let doneButton = UIBarButtonItem(title: "Done", style: .Done, target: self, action: "doneToolbar:")
			let spacingButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
			
			toolBar.setItems([spacingButton, doneButton], animated: false)
			toolBar.userInteractionEnabled = true
			
			locationTextField.inputAccessoryView = toolBar
			
			let addLocationButton = PrimaryBorderActionButton()
			locationContainer.addSubview(addLocationButton)
			self.addLocationButton = addLocationButton
			addLocationButton.addTarget(self, action: "didTapAddLocation:", forControlEvents: UIControlEvents.TouchUpInside)
			addLocationButton.setTitle("Add", forState: UIControlState.Normal)
			addLocationButton.width = 80
			addLocationButton.snp_makeConstraints { (make) -> Void in
				make.left.equalTo(locationTextField.snp_right).offset(10)
				make.centerY.equalTo(locationTextField.snp_centerY)
			}
			
			let streetAddressLabel = UILabel()
			self.streetAddressLabel = streetAddressLabel
			streetAddressLabel.text = self.locations?.first?.formattedTextLabelNoPostal
			locationContainer.addSubview(streetAddressLabel)
			streetAddressLabel.numberOfLines = 0
			streetAddressLabel.textColor = Color.darkGrayDetails
			streetAddressLabel.font = UIFont(name: "Lato-Light", size: kText15)
			streetAddressLabel.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(locationTextField.snp_bottom).offset(16)
				make.centerX.equalTo(locationTextField.snp_centerX)
			}
			
			let deleteAddressButton = SecondaryActionButton()
			locationContainer.addSubview(deleteAddressButton)
			self.deleteAddressButton = deleteAddressButton
			deleteAddressButton.setTitle("Delete this location", forState: UIControlState.Normal)
			self.deleteAddressButton.addTarget(self, action: "didTapDeleteAddress:", forControlEvents: UIControlEvents.TouchUpInside)
			deleteAddressButton.backgroundColor = Color.whitePrimary
			deleteAddressButton.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(streetAddressLabel.snp_bottom).offset(15)
				make.centerX.equalTo(locationTextField.snp_centerX)
			}
			
			locationContainer.snp_makeConstraints { (make) -> Void in
				make.bottom.equalTo(deleteAddressButton.snp_bottom)
			}
			
		}
		
		self.locationContainer.layoutIfNeeded()
		
		self.taskFormContainer.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(locationContainer.snp_bottom).offset(20)
		}
		
		if isUpdate {
			self.scrollView.contentSize = self.contentView.frame.size
		}
	}
	
	/**
	Converts the attached task pictures to Data in order to save them in parse.
	*/
	func convertImagesToData() {
		self.task.pictures = Array()
		for image in self.arrayOfPictures{
			let imageData = UIImageJPEGRepresentation(image, 0.50)
			let imageFile = PFFile(name:"image.png", data: imageData!)
			self.task.pictures!.append(imageFile)
		}
	}
	
	//MARK: UICollectionView Datasource and Delegate
	
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.arrayOfPictures.count
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PicturesCollectionViewCell.reuseIdentifier, forIndexPath: indexPath) as! PicturesCollectionViewCell
		cell.delegate = self
		cell.tag = indexPath.row
		let image = self.arrayOfPictures[indexPath.row]
		cell.imageView.image = image
		return cell
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		return CGSizeMake(self.picturesCollectionView.frame.height, self.picturesCollectionView.frame.height)
	}
	
	//MARK: UIPicker Delegate and Datasource
	
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
		return 1
	}
	
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return (self.locations?.count)!
	}
	
	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return self.locations![row].name
	}
	
	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		self.locationTextField!.text = self.locations?[row].name
		
		self.streetAddressLabel.text = self.locations?[row].formattedTextLabelNoPostal
		
		self.task.location = GeoPoint(latitude: Double(self.locations![row].coords!["latitude"]!), longitude: Double(self.locations![row].coords!["longitude"]!))
		self.task.city = self.locations![row].city
		self.task.exactLocation = self.locations![row]
	}
	
	//MARK: Picture Cell Delegate
	
	func didRemovePicture(vc: PicturesCollectionViewCell) {
		self.arrayOfPictures.removeAtIndex(vc.tag)
		self.picturesCollectionView.reloadData()
		
		if self.arrayOfPictures.isEmpty {
			picturesButton.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(picturesContainer.snp_top).offset(20)
			}
			
			UIView.animateWithDuration(0.3, delay: 0.0, options: [.CurveEaseOut], animations:  {
				self.picturesButton.layoutIfNeeded()
				self.picturesContainer.layoutIfNeeded()
				self.createTaskButton.layoutIfNeeded()
				self.backgroundView.layoutIfNeeded()
				
				self.scrollView.contentSize = self.contentView.frame.size
				}, completion: nil)
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
			self.arrayOfPictures.append(pickedImage)
			self.picturesCollectionView.reloadData()
		}
		dismissViewControllerAnimated(true, completion: nil)
		
		self.picturesButton.snp_updateConstraints { (make) -> Void in
			make.top.equalTo(picturesContainer.snp_top).offset(10 + self.collectionViewHeight + 20)
		}
		
		UIView.animateWithDuration(0.3, delay: 0.0, options: [.CurveEaseOut], animations:  {
			self.picturesButton.layoutIfNeeded()
			self.picturesContainer.layoutIfNeeded()
			self.createTaskButton.layoutIfNeeded()
			self.backgroundView.layoutIfNeeded()
			}, completion: nil)
	}
	
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	//MARK: Textfield and Textview Delegate
	
	func textFieldDidChange(textField: UITextField) {
		if textField == self.titleTextField {
			if textField.text!.characters.count >= 4 {
				self.titleStatus.image = self.acceptedIcon
			} else {
				self.titleStatus.image = self.exclamationIcon
			}
			
			if self.titleStatus.image == self.acceptedIcon {
				textField.layer.borderColor = Color.grayDetails.CGColor
			}
		} else if textField == self.priceOffered {
			if textField.text == "" || textField.text == nil {
				moneyLabel.textColor = Color.textFieldPlaceholderColor
			} else {
				moneyLabel.textColor = Color.textFieldTextColor
			}
			
			var value: Int? = Int(textField.text!)
			
			if value == nil {
				value = 0
			}
			
			if value! >= 10 && value! <= 200 {
				self.priceStatus.image = self.acceptedIcon
			} else {
				self.priceStatus.image = self.exclamationIcon
			}
			
			if self.priceStatus.image == self.acceptedIcon {
				textField.layer.borderColor = Color.grayDetails.CGColor
			}
		}
	}
	
	func textViewDidChange(textView: UITextView) {
		if textView.text!.characters.count >= 4 {
			self.descriptionStatus.image = self.acceptedIcon
		} else {
			self.descriptionStatus.image = self.exclamationIcon
		}
		
		if self.descriptionStatus.image == self.acceptedIcon {
			textView.layer.borderColor = Color.grayDetails.CGColor
		}
	}
	
	func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
		
		//Restrict to numbers
		if textField == self.priceOffered {
			let nonDigits = NSCharacterSet(charactersInString: "0123456789").invertedSet
			let compSepByCharInSet = string.componentsSeparatedByCharactersInSet(nonDigits)
			let numberFiltered = compSepByCharInSet.joinWithSeparator("")
			
			return string == numberFiltered
			
		} else if textField == self.titleTextField {
			return textField.text!.characters.count + (string.characters.count - range.length) <= 80
		}
		
		return true
	}
	
	func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
		
		//textViewShouldReturn hack
		let resultRange = text.rangeOfCharacterFromSet(NSCharacterSet.newlineCharacterSet(), options: .BackwardsSearch)
		if resultRange != nil {
			self.descriptionTextView.resignFirstResponder()
			self.priceOffered.becomeFirstResponder()
			
			return false
		}
		
		return textView.text.characters.count + (text.characters.count - range.length) <= 600
	}
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		dismissKeyboard()
		textField.resignFirstResponder()
		
		if textField == self.titleTextField {
			self.descriptionTextView.becomeFirstResponder()
		}
		
		return false
	}
	
	//MARK: View Delegate Method
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		self.scrollView.contentSize = self.contentView.frame.size
	}
	
	//MARK: Add Address Location Delegate
	
	func didClosePopup(vc: AddAddressViewController) {
		self.popupShown = false
	}
	
	func didAddLocation(vc: AddAddressViewController) {
		self.task.location = vc.location
		self.task.city = vc.address.city!
		self.task.exactLocation = vc.address
		self.locations?.append(vc.address)
		
		setLocations(true)
		
		self.locationsPickerView?.reloadAllComponents()
		self.locationTextField?.text = vc.address.name
		
		self.streetAddressLabel.text = vc.address.formattedTextLabelNoPostal
		
		self.userPrivateData.locations.append(vc.address)
		ApiHelper.updateUserLocations(self.userPrivateData.locations)
		
		self.contentView.layoutIfNeeded()
		self.scrollView.contentSize = self.contentView.frame.size
	}
	
	//MARK: KEYBOARD VIEW MOVER, WITH viewDidDis/Appear AND textfielddelegate
	
	func textFieldDidBeginEditing(textField: UITextField) {
		self.activeField = textField
		self.fieldEditing = true
	}
	
	func textFieldDidEndEditing(textField: UITextField) {
		self.activeField = nil
		self.fieldEditing = false
		
		switch textField {
		case self.titleTextField:
			if self.titleStatus.image == self.exclamationIcon {
				textField.layer.borderColor = Color.redPrimarySelected.colorWithAlphaComponent(0.7).CGColor
			}
		case self.priceOffered:
			if self.priceStatus.image == self.exclamationIcon {
				textField.layer.borderColor = Color.redPrimarySelected.colorWithAlphaComponent(0.7).CGColor
			}
		default:
			break
		}
	}
	
	func textViewDidBeginEditing(textView: UITextView) {
		self.activeField = textView
		self.fieldEditing = true
		
		if textView.text == " Description   " {
			textView.text = ""
			textView.textColor = Color.textFieldTextColor
		}
	}
	
	func textViewDidEndEditing(textView: UITextView) {
		self.activeField = nil
		self.fieldEditing = false
		
		if textView.text == "" {
			textView.text = " Description   "
			textView.textColor = Color.textFieldPlaceholderColor
		}
		
		if self.descriptionStatus.image == self.exclamationIcon {
			textView.layer.borderColor = Color.redPrimarySelected.colorWithAlphaComponent(0.7).CGColor
		}
	}
	
	func keyboardDidShow(notification: NSNotification) {
		
		if !popupShown {
			let info = notification.userInfo!
			var keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
			keyboardFrame = self.view.convertRect(keyboardFrame, fromView: nil)
			
			self.contentInsets = UIEdgeInsetsMake(0, 0, keyboardFrame.height, 0)
			
			self.scrollView.contentInset = contentInsets
			self.scrollView.scrollIndicatorInsets = contentInsets
			
			var aRect = self.view.frame
			aRect.size.height -= keyboardFrame.height
			
			if activeField != nil {
				let frame = CGRectMake(self.activeField.frame.minX, self.activeField.frame.minY, self.activeField.frame.width, self.activeField.frame.height + (self.view.frame.height * 0.2))
				
				if self.activeField != nil {
					if !(CGRectContainsPoint(aRect, self.activeField.frame.origin)) {
						self.scrollView.scrollRectToVisible(frame, animated: true)
					}
				}
			}
		}
	}
	
	func keyboardWillHide(notification: NSNotification) {
		self.contentInsets = UIEdgeInsetsZero
		self.scrollView.contentInset = contentInsets
		self.scrollView.scrollIndicatorInsets = contentInsets
	}
	
	//MARK: Utilities
	
	func dismissKeyboard() {
		view.endEditing(true)
	}
	
	//MARK: Actions
	
	/**
	Resigns first responder of the toolbar's textField
	*/
	func doneToolbar(sender: UIBarButtonItem) {
		if self.locationTextField!.isFirstResponder() {
			self.locationTextField?.resignFirstResponder()
		} else if self.priceOffered.isFirstResponder() {
			self.priceOffered.resignFirstResponder()
		}
	}
	
	/**
	Allow the user to attach pictures
	
	- parameter sender: Add pictures button
	*/
	func attachPicturesButtonTapped(sender: UIButton) {
		dismissKeyboard()
		self.imagePicker.allowsEditing = false
		self.imagePicker.sourceType = .PhotoLibrary
		
		//let tabBarViewController = UIApplication.sharedApplication().delegate!.window!?.rootViewController as! TabBarViewController
		self.navigationController!.viewControllers.last!.presentViewController(self.imagePicker, animated: true, completion: nil)
	}
	
	func backButtonTapped(sender: UIButton) {
		dismissKeyboard()
		self.navigationController?.popViewControllerAnimated(true)
	}
	
	/**
	Shows the add address view controller
	
	- parameter sender: Add Address Button
	*/
	func didTapAddLocation(sender: UIButton) {
		dismissKeyboard()
		
		UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, false, UIScreen.mainScreen().scale)
		self.view.drawViewHierarchyInRect(self.view.bounds, afterScreenUpdates: true)
		let blurImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		let nextVC = AddAddressViewController()
		nextVC.blurImage = blurImage
		nextVC.delegate = self
		nextVC.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
		self.providesPresentationContextTransitionStyle = true
		nextVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
		self.presentViewController(nextVC, animated: true, completion: nil)
		
		self.popupShown = true
	}
	
	func didTapDeleteAddress(sender: UIButton) {
		dismissKeyboard()
		
		let popup = UIAlertController(title: "Delete '\(self.locationTextField!.text!)'?", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
		popup.addAction(UIAlertAction(title: "Delete", style: .Default, handler: { (action) -> Void in
			
			if self.locations!.isEmpty == false {
				self.locations?.removeAtIndex(self.locationsPickerView!.selectedRowInComponent(0))
			}
			self.locationsPickerView!.reloadAllComponents()
			if !self.locations!.isEmpty {
				self.locationsPickerView!.selectRow(0, inComponent: 0, animated: true)
				self.task.location = GeoPoint(latitude:Double(self.locations![0].coords!["latitude"]!),longitude: Double(self.locations![0].coords!["longitude"]!))
				self.task.city = self.locations![0].city
				self.updateLocationInfoToFirstComponent()
			} else {
				self.locationTextField!.text = ""
				self.streetAddressLabel.text = "You haven't saved any addresses yet!"
				self.task.city = nil
				self.task.location = nil
				self.task.exactLocation = nil
			}
			
			ApiHelper.updateUserLocations(self.locations!)
			PFUser.currentUser()!.saveInBackground()
			
			self.setLocations(true)
		}))
		popup.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
		}))
		
		self.presentViewController(popup, animated: true, completion: nil)
		popup.view.tintColor = Color.redPrimary
	}
	
	func updateLocationInfoToFirstComponent() {
		self.locationTextField!.text = self.locations?[0].name
		
		self.streetAddressLabel.text = self.locations?[0].formattedTextLabelNoPostal
		
		self.locations?[0].formattedAddress
		self.task.location = GeoPoint(latitude:Double(self.locations![0].coords!["latitude"]!),longitude: Double(self.locations![0].coords!["longitude"]!))
		self.task.exactLocation = self.locations?[0]
	}
	
	/**
	Allows the creation of an Array of Dictionaries to Save in Parse
	
	- parameter locations: The array of locations
	
	- returns: The Array of Dictionaries
	*/
	func createDictionaries(locations:Array<Location>) ->Array<Dictionary<String,AnyObject>>{
		var arrayOfLocations = Array<Dictionary<String,AnyObject>>()
		for location in locations{
			let oneLocation = location.createDictionary()
			arrayOfLocations.append(oneLocation)
		}
		return arrayOfLocations
	}
	
	
	/**
	Post a task on Nelper
	
	- parameter sender: Post Button
	*/
	func postButtonTapped(sender: UIButton) {
		dismissKeyboard()
		
		self.textFieldError = false
		self.textFieldErrorMessages.removeAll()
		
		if self.titleStatus.image != self.acceptedIcon {
			self.textFieldError = true
			self.textFieldErrorMessages.append("Please enter a title of at least 4 characters")
		}
		
		if self.descriptionStatus.image != self.acceptedIcon {
			self.textFieldError = true
			self.textFieldErrorMessages.append("Please enter a description of at least 4 characters")
		}
		
		if self.priceStatus.image != self.acceptedIcon {
			self.textFieldError = true
			self.textFieldErrorMessages.append("The amount you are offering must be between 10$ and 200$")
		}
		
		if self.locations!.isEmpty {
			self.textFieldError = true
			self.textFieldErrorMessages.append("Please add a location for your task")
		}
		
		if self.textFieldError == true {
			
			var popupMessage = ""
			
			for i in 0...(self.textFieldErrorMessages.count - 1) {
				if i == 0 {
					popupMessage = self.textFieldErrorMessages[i]
				} else {
					popupMessage += "\n\(self.textFieldErrorMessages[i])"
				}
			}
			
			let popup = UIAlertController(title: "Incorrect fields", message: popupMessage, preferredStyle: UIAlertControllerStyle.Alert)
			popup.addAction(UIAlertAction(title: "Confirm", style: .Default, handler: { (action) -> Void in
			}))
			
			self.presentViewController(popup, animated: true, completion: nil)
			popup.view.tintColor = Color.redPrimary
			
		} else {
			
			if self.arrayOfPictures.count != 0 {
				self.convertImagesToData()
			}
			
			self.task.state = .Pending
			self.task.title = self.titleTextField!.text
			
			if self.descriptionTextView!.text != nil {
				self.task.desc = self.descriptionTextView!.text
			} else {
				self.task.desc = ""
			}
			
			self.task.priceOffered = Double(self.priceOffered.text!)
			
			ApiHelper.addTask(self.task, block: { (task, error) -> Void in
				self.delegate?.nelpTaskAdded(self.task)
				
				let saveConfirmationBlurView = FXBlurView(frame: self.view.bounds)
				saveConfirmationBlurView.alpha = 0
				saveConfirmationBlurView.tintColor = UIColor.clearColor()
				saveConfirmationBlurView.updateInterval = 100
				saveConfirmationBlurView.iterations = 2
				saveConfirmationBlurView.blurRadius = 4
				saveConfirmationBlurView.dynamic = false
				saveConfirmationBlurView.underlyingView = self.view
				self.view.addSubview(saveConfirmationBlurView)
				
				let saveConfirmationBackground = UIView()
				saveConfirmationBlurView.addSubview(saveConfirmationBackground)
				saveConfirmationBackground.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
				saveConfirmationBackground.snp_makeConstraints { (make) -> Void in
					make.edges.equalTo(saveConfirmationBlurView.snp_edges)
				}
				
				let saveConfirmationContainer = UIView()
				saveConfirmationBlurView.addSubview(saveConfirmationContainer)
				saveConfirmationContainer.backgroundColor = Color.whitePrimary
				saveConfirmationContainer.snp_makeConstraints { (make) -> Void in
					make.centerX.equalTo(self.view.snp_centerX)
					make.centerY.equalTo(self.view.snp_centerY)
					make.width.equalTo(self.view.snp_width).multipliedBy(0.7)
					make.height.equalTo(0)
				}
				
				let saveConfirmationLabel = UILabel()
				saveConfirmationContainer.addSubview(saveConfirmationLabel)
				saveConfirmationLabel.text = "Your task has been posted!"
				saveConfirmationLabel.alpha = 0
				saveConfirmationLabel.font = UIFont(name: "Lato-Regular", size: kTitle17)
				saveConfirmationLabel.textColor = Color.darkGrayText
				saveConfirmationLabel.textAlignment = .Center
				saveConfirmationLabel.snp_makeConstraints { (make) -> Void in
					make.centerX.equalTo(saveConfirmationContainer.snp_centerX)
					make.centerY.equalTo(saveConfirmationContainer.snp_centerY)
				}
				
				saveConfirmationContainer.layoutIfNeeded()
				
				saveConfirmationContainer.snp_updateConstraints { (make) -> Void in
					make.height.equalTo(100)
				}
				
				UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations:  {
					saveConfirmationBlurView.alpha = 1
					saveConfirmationContainer.layoutIfNeeded()
					}, completion: nil)
				
				UIView.animateWithDuration(0.4, delay: 0.2, options: UIViewAnimationOptions.CurveEaseOut, animations:  {
					saveConfirmationLabel.alpha = 1
					}, completion: nil)
				
				saveConfirmationContainer.snp_updateConstraints { (make) -> Void in
					make.height.equalTo(0)
				}
				
				UIView.animateWithDuration(0.2, delay: 2.5, options: UIViewAnimationOptions.CurveEaseOut, animations:  {
					saveConfirmationLabel.alpha = 0
					}, completion: nil)
				
				UIView.animateWithDuration(0.2, delay: 2.7, options: UIViewAnimationOptions.CurveEaseOut, animations:  {
					saveConfirmationBlurView.alpha = 0
					saveConfirmationContainer.layoutIfNeeded()
					}, completion: nil)
				
				_ = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "dismissVC", userInfo: nil, repeats: false)
			})
		}
	}
	
	//TODO: FIX NEXT VIEW NELP CENTER MY TASKS
	func dismissVC() {
		self.navigationController!.setViewControllers([NelpCenterViewController()], animated: true)
		self.navigationController?.popViewControllerAnimated(false)
		
		let tabBarViewController = UIApplication.sharedApplication().delegate!.window!?.rootViewController as! TabBarViewController
		tabBarViewController.tabBar.didSelectIndex(1, loadView: true)
	}
}
