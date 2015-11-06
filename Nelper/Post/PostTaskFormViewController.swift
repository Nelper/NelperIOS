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
	func nelpTaskAdded(task: FindNelpTask) -> Void
	func dismiss()
}

class PostTaskFormViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, AddAddressViewControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PicturesCollectionViewCellDelegate {
	
	let kGoogleAPIKey = "AIzaSyC4IkGUD1uY53E1aihYxDvav3SbdCDfzq8"
	let imagePicker = UIImagePickerController()
	var task: FindNelpTask!
	var placesClient: GMSPlacesClient?
	var locationTextField: UITextField?
	var titleTextField: UITextField!
	var descriptionTextView: UITextView!
	var descriptionStatus: UIImageView!
	var priceOffered: UITextField!
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
	
	//MARK: Initialization
	
	init(task: FindNelpTask) {
		super.init(nibName: nil, bundle: nil)
		self.task = task
		self.placesClient = GMSPlacesClient()
		
		self.userPrivateData = ApiHelper.getUserPrivateData()
		self.locations = userPrivateData.locations
		
		if !self.locations!.isEmpty {
			self.task.location = GeoPoint(latitude:self.locations![0].coords!["latitude"]!,longitude: self.locations![0].coords!["longitude"]!)
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
		
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
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
		headerPicture.image = UIImage(named: "\(self.task.category!)-nc-bg")
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
		taskFormContainer.layer.borderColor = grayDetails.CGColor
		self.contentView.addSubview(taskFormContainer)
		taskFormContainer.backgroundColor = whitePrimary
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
		taskTitleTextField.backgroundColor = whitePrimary
		taskTitleTextField.attributedPlaceholder = NSAttributedString(string: "Title", attributes: [NSForegroundColorAttributeName: textFieldPlaceholderColor])
		taskTitleTextField.font = UIFont(name: "Lato-Regular", size: kText15)
		taskTitleTextField.textColor = blackPrimary
		taskTitleTextField.textAlignment = NSTextAlignment.Left
		taskTitleTextField.autocorrectionType = UITextAutocorrectionType.No
		taskTitleTextField.layer.borderColor = grayDetails.CGColor
		taskTitleTextField.layer.borderWidth = 1
		taskTitleTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
		
		taskTitleTextField.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(taskTitleLabel.snp_left)
			make.top.equalTo(taskTitleLabel.snp_bottom).offset(10)
			make.right.equalTo(contentView.snp_right).offset(-15)
			make.height.equalTo(50)
		}
		
		let titleStatus = UIImageView()
		self.titleStatus = titleStatus
		taskFormContainer.addSubview(titleStatus)
		titleStatus.image = UIImage(named: "exclamation")
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
		descriptionTextView.backgroundColor = whitePrimary
		descriptionTextView.font = UIFont(name: "Lato-Regular", size: kText15)
		descriptionTextView.textColor = textFieldPlaceholderColor
		descriptionTextView.textAlignment = NSTextAlignment.Left
		descriptionTextView.layer.borderColor = grayDetails.CGColor
		descriptionTextView.layer.borderWidth = 1
		descriptionTextView.layer.sublayerTransform = CATransform3DMakeTranslation(6, 0, 0)
		descriptionTextView.text = "Description   "
		descriptionTextView.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(taskTitleLabel.snp_left)
			make.top.equalTo(descriptionLabel.snp_bottom).offset(10)
			make.right.equalTo(titleTextField.snp_right)
			make.height.equalTo(150)
		}
		
		let descriptionStatus = UIImageView()
		self.descriptionStatus = descriptionStatus
		taskFormContainer.addSubview(descriptionStatus)
		descriptionStatus.image = UIImage(named: "exclamation")
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
		priceOfferedTextField.backgroundColor = whitePrimary
		priceOfferedTextField.attributedPlaceholder = NSAttributedString(string: "$", attributes: [NSForegroundColorAttributeName: textFieldPlaceholderColor])
		priceOfferedTextField.font = UIFont(name: "Lato-Regular", size: kText15)
		priceOfferedTextField.textColor = textFieldTextColor
		priceOfferedTextField.textAlignment = NSTextAlignment.Left
		priceOfferedTextField.layer.borderColor = grayDetails.CGColor
		priceOfferedTextField.layer.borderWidth = 1
		priceOfferedTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
		priceOfferedTextField.keyboardType = UIKeyboardType.NumberPad
		
		priceOfferedTextField.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(taskTitleLabel.snp_left)
			make.top.equalTo(priceOfferedLabel.snp_bottom).offset(10)
			make.right.equalTo(titleTextField.snp_right)
			make.height.equalTo(50)
		}
		
		let priceStatus = UIImageView()
		self.priceStatus = priceStatus
		taskFormContainer.addSubview(priceStatus)
		priceStatus.image = UIImage(named: "exclamation")
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
		picturesContainer.backgroundColor = whitePrimary
		contentView.addSubview(picturesContainer)
		picturesContainer.layer.borderColor = grayDetails.CGColor
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
		createTaskButton.setTitleColor(whitePrimary, forState: UIControlState.Normal)
		createTaskButton.backgroundColor = redPrimary
		createTaskButton.titleLabel?.font = UIFont(name: "Lato-Regular", size: kTitle17)
		createTaskButton.addTarget(self, action: "postButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		
		createTaskButton.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(self.contentView.snp_left).offset(contentInset * 2)
			make.right.equalTo(self.contentView.snp_right).offset(-contentInset * 2)
			make.top.equalTo(picturesContainer.snp_bottom).offset(20)
			make.height.equalTo(40)
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
			locationLabel.text = "Select your task location"
			locationLabel.textColor = blackPrimary
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
			locationLabel.text = "Select your task location"
			locationLabel.textColor = blackPrimary
			locationLabel.font = UIFont(name: "Lato-Regular", size: kTitle17)
			locationLabel.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(locationContainer.snp_top)
				make.left.equalTo(locationContainer.snp_left)
			}
			
			let locationTextField = UITextField()
			self.locationTextField = locationTextField
			locationTextField.delegate = self
			locationContainer.addSubview(locationTextField)
			locationTextField.backgroundColor = whitePrimary
			locationTextField.text = self.locations!.first!.name!
			locationTextField.attributedPlaceholder = NSAttributedString(string: "Address", attributes: [NSForegroundColorAttributeName: blackPrimary.colorWithAlphaComponent(0.75)])
			locationTextField.font = UIFont(name: "Lato-Regular", size: kText15)
			locationTextField.textColor = textFieldTextColor
			locationTextField.textAlignment = NSTextAlignment.Center
			locationTextField.delegate = self
			
			//Picker view
			
			let locationsPickerView = UIPickerView()
			self.locationsPickerView = locationsPickerView
			locationsPickerView.delegate = self
			locationTextField.inputView = locationsPickerView
			locationTextField.layer.borderColor = grayDetails.CGColor
			locationTextField.layer.borderWidth = 1
			locationTextField.snp_makeConstraints { (make) -> Void in
				make.left.equalTo(locationLabel.snp_left)
				make.top.equalTo(locationLabel.snp_bottom).offset(10)
				make.right.equalTo(self.contentView.snp_right).offset(-100)
				make.height.equalTo(50)
			}
			
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
			streetAddressLabel.text = self.locations?.first?.formattedTextLabel
			
			locationContainer.addSubview(streetAddressLabel)
			streetAddressLabel.numberOfLines = 0
			streetAddressLabel.textColor = darkGrayDetails
			streetAddressLabel.font = UIFont(name: "Lato-Light", size: kText15)
			streetAddressLabel.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(locationTextField.snp_bottom).offset(16)
				make.left.equalTo(locationTextField.snp_left).offset(5)
				make.right.equalTo(taskFormContainer.snp_right).offset(-25)
			}
			
			let deleteAddressButton = SecondaryActionButton()
			locationContainer.addSubview(deleteAddressButton)
			self.deleteAddressButton = deleteAddressButton
			deleteAddressButton.setTitle("Delete this location", forState: UIControlState.Normal)
			self.deleteAddressButton.addTarget(self, action: "didTapDeleteAddress:", forControlEvents: UIControlEvents.TouchUpInside)
			deleteAddressButton.backgroundColor = whitePrimary
			deleteAddressButton.width = 200
			deleteAddressButton.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(streetAddressLabel.snp_bottom).offset(15)
				make.left.equalTo(streetAddressLabel.snp_left)
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
			let imageData = UIImageJPEGRepresentation(image , 0.50)
			let imageFile = PFFile(name:"image.png", data:imageData!)
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
	
	// returns the # of rows in each component..
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
		return (self.locations?.count)!
	}
	
	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return self.locations![row].name
	}
	
	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
	{
		self.locationTextField!.text = self.locations?[row].name
		
		self.streetAddressLabel.text = self.locations?[row].formattedTextLabel
		
		
		self.task.location = GeoPoint(latitude:Double(self.locations![row].coords!["latitude"]!),longitude: Double(self.locations![row].coords!["longitude"]!))
		self.task.city = self.locations![row].city
		self.task.exactLocation = self.locations![row]
		//view.endEditing(true)
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
	
	//MARK: Textfield and Textview Delegate
	//TODO: FIX THIS SHIT I CAN'T :D
	
	func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
		
		if textField == self.locationTextField {
			return textField != self.locationTextField
		} else if textField == self.titleTextField {
			
			let textFieldRange: NSRange = NSMakeRange(0, textField.text!.characters.count)
			
			if NSEqualRanges(textFieldRange, range) && string.characters.count >= 6 {
				self.titleStatus.image = UIImage(named: "accepted")
			} else if NSEqualRanges(textFieldRange, range)	&& string.characters.count == 0 {
				self.titleStatus.image = nil
			} else {
				self.titleStatus.image = UIImage(named: "exclamation")
			}
		} else if textField == self.priceOffered {
			let textFieldRange:NSRange = NSMakeRange(0, textField.text!.characters.count)
			
			if NSEqualRanges(textFieldRange, range) && string.characters.count >= 6 {
				self.priceStatus.image = UIImage(named: "accepted")
			} else if (NSEqualRanges(textFieldRange, range) && string.characters.count == 0) {
				self.priceStatus.image = nil
			} else {
				self.priceStatus.image = UIImage(named: "exclamation")
			}
		}
		return true
	}
	
	func textView(textView: UITextView, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
		
		if textView == self.descriptionTextView {
			let textViewRange: NSRange = NSMakeRange(0, textView.text!.characters.count)
			
			if NSEqualRanges(textViewRange, range) && string.characters.count >= 6 {
				self.descriptionStatus.image = UIImage(named: "accepted")
			} else if NSEqualRanges(textViewRange, range)	&& string.characters.count == 0 {
				self.descriptionStatus.image = nil
			} else {
				self.descriptionStatus.image = UIImage(named: "exclamation")
			}
		}
		
		return true
	}

	
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		dismissViewControllerAnimated(true, completion: nil)
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
	
	func didAddLocation(vc:AddAddressViewController) {
		self.task.location = vc.location
		self.task.city = vc.address.city!
		self.task.exactLocation = vc.address
		self.locations?.append(vc.address)
		
		setLocations(true)
		
		self.locationsPickerView?.reloadAllComponents()
		self.locationTextField?.text = vc.address.name
		
		self.streetAddressLabel.text = vc.address.formattedTextLabel
		
		self.userPrivateData.locations.append(vc.address)
		ApiHelper.updateUserLocations(self.userPrivateData.locations)
		
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
	}
	
	func textViewDidBeginEditing(textView: UITextView) {
		self.activeField = textView
		self.fieldEditing = true
		
		if textView.text == "Description   " {
			textView.text = ""
			textView.textColor = textFieldTextColor
		}
	}
	
	func textViewDidEndEditing(textView: UITextView) {
		self.activeField = nil
		self.fieldEditing = false
		
		if textView.text == "" {
			textView.text = "Description   "
			textView.textColor = textFieldPlaceholderColor
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
	
	//MARK: Actions
	
	/**
	Allow the user to attach pictures
	
	- parameter sender: Add pictures button
	*/
	func attachPicturesButtonTapped(sender: UIButton){
		DismissKeyboard()
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
		self.navigationController?.popViewControllerAnimated(true)
		view.endEditing(true) // dissmiss keyboard without delay
	}
	
	/**
	Shows the add address view controller
	
	- parameter sender: Add Address Button
	*/
	func didTapAddLocation(sender:UIButton) {
		DismissKeyboard()
		
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
	
	func didTapDeleteAddress(sender:UIButton){
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
			locationTextField!.text = ""
			streetAddressLabel.text = "You haven't saved any address yet!"
			self.task.city = nil
			self.task.location = nil
			self.task.exactLocation = nil
		}
		
		ApiHelper.updateUserLocations(self.locations!)
		PFUser.currentUser()!.saveInBackground()
		
		setLocations(true)
	}
	
	
	func updateLocationInfoToFirstComponent(){
		self.locationTextField!.text = self.locations?[0].name
		
		self.streetAddressLabel.text = self.locations?[0].formattedTextLabel
		
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
		DismissKeyboard()
		
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
		
		self.task.priceOffered = Double(self.priceOffered!.text!)
		
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
			saveConfirmationContainer.backgroundColor = whitePrimary
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
			saveConfirmationLabel.textColor = darkGrayText
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
	
	//TODO: MADE NEXT VIEW NELP CENTER MY TASKS
	func dismissVC() {
		//self.navigationController?.setViewControllers([NelpCenterViewController()], animated: true)
		self.navigationController?.popViewControllerAnimated(false)
		self.tabBarController?.selectedIndex = 1
	}
}
