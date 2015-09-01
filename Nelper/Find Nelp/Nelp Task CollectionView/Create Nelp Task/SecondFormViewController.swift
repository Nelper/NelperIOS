//
//  SecondFormViewController.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-07-25.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

protocol SecondFormViewControllerDelegate {
	func nelpTaskAdded(nelpTask: FindNelpTask) -> Void
	func dismiss()
}

class SecondFormViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
	
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
	var imageOne: UIImageView?
	var imageTwo: UIImageView?
	var imageThree: UIImageView?
	var imageFour: UIImageView?
	var tap: UITapGestureRecognizer?
	
	var delegate: SecondFormViewControllerDelegate?
	
	
	@IBOutlet weak var navBar: NavBar!
	
	@IBOutlet weak var contentView: UIView!
	
	@IBOutlet weak var formBackground: UIView!
	
	@IBOutlet weak var autocompleteTableView: UITableView!
	
	@IBOutlet weak var postButton: UIButton!
	
	
	convenience init(task: FindNelpTask){
		self.init(nibName: "SecondFormScreen", bundle: nil)
		self.task = task
		self.placesClient = GMSPlacesClient()
	}
	
	override func viewDidLoad() {
		//		self.autocompleteTableView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
		//		self.autocompleteTableView.delegate = self
		//		self.autocompleteTableView.dataSource = self
		//		self.autocompleteTableView.registerClass(AutocompleteCell.classForCoder(), forCellReuseIdentifier: AutocompleteCell.reuseIdentifier)
		//		self.autocompleteTableView.hidden = true
		self.imagePicker.delegate = self
		self.createView()
		self.adjustUI()
		
		// looks for tap (keyboard dismiss)
		var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
		self.tap = tap
		contentView.addGestureRecognizer(tap)
		
	}
	
	//keyboard dismiss on screen touch
	func DismissKeyboard() {

		view.endEditing(true)
		if(self.autocompleteTableView.hidden == false){
			self.autocompleteTableView.hidden = true
		}
	}
	
	override func viewDidAppear(animated: Bool) {
		
	}
	
	func createView(){
		
		//To avoid width calculation for each textField, insets
		
		var frameWidth = self.view.frame.size.width
		
		let contentInset: CGFloat = 12
		
		//Task Title Label + TextField
		
		var taskTitleLabel = UILabel()
		self.contentView.addSubview(taskTitleLabel)
		taskTitleLabel.text = "Enter your Task Title"
		taskTitleLabel.textColor = blackNelpyColor
		taskTitleLabel.font = UIFont(name: "HelveticaNeue", size: kFormViewLabelFontSize)
		
		taskTitleLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(contentView.snp_top).offset(20)
			make.left.equalTo(contentView.snp_left).offset(contentInset)
		}
		var taskTitleTextField = UITextField()
		taskTitleTextField.delegate = self
		self.titleTextField = taskTitleTextField
		self.contentView.addSubview(taskTitleTextField)
		taskTitleTextField.backgroundColor = navBarColor.colorWithAlphaComponent(0.75)
		taskTitleTextField.attributedPlaceholder = NSAttributedString(string: "Title", attributes: [NSForegroundColorAttributeName: blackNelpyColor.colorWithAlphaComponent(0.75)])
		taskTitleTextField.font = UIFont(name: "HelveticaNeue", size: kTextFontSize)
		taskTitleTextField.textColor = blackNelpyColor
		taskTitleTextField.textAlignment = NSTextAlignment.Left
		taskTitleTextField.layer.cornerRadius = 3
		taskTitleTextField.layer.borderColor = grayDetails.CGColor
		taskTitleTextField.layer.borderWidth = 1
		var paddingViewTitle = UIView(frame: CGRectMake(0, 0, 10, 0))
		taskTitleTextField.leftView = paddingViewTitle
		taskTitleTextField.leftViewMode = UITextFieldViewMode.Always
		
		taskTitleTextField.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(taskTitleLabel.snp_left)
			make.top.equalTo(taskTitleLabel.snp_bottom).offset(10)
			make.width.equalTo(frameWidth - contentInset * 2)
			make.height.equalTo(50)
		}
		
		//Price Offered Label + TextField
		
		var priceOfferedLabel = UILabel()
		self.contentView.addSubview(priceOfferedLabel)
		priceOfferedLabel.text = "How much are you offering?"
		priceOfferedLabel.textColor = blackNelpyColor
		priceOfferedLabel.font = UIFont(name: "HelveticaNeue", size: kFormViewLabelFontSize)
		
		priceOfferedLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(taskTitleTextField.snp_bottom).offset(20)
			make.left.equalTo(taskTitleTextField.snp_left)
		}
		var priceOfferedTextField = UITextField()
		priceOfferedTextField.delegate = self
		self.priceOffered = priceOfferedTextField
		self.contentView.addSubview(priceOfferedTextField)
		priceOfferedTextField.backgroundColor = navBarColor.colorWithAlphaComponent(0.75)
		priceOfferedTextField.attributedPlaceholder = NSAttributedString(string: "$", attributes: [NSForegroundColorAttributeName: blackNelpyColor.colorWithAlphaComponent(0.75)])
		priceOfferedTextField.font = UIFont(name: "HelveticaNeue", size: kTextFontSize)
		priceOfferedTextField.textColor = blackNelpyColor
		priceOfferedTextField.textAlignment = NSTextAlignment.Left
		priceOfferedTextField.layer.cornerRadius = 3
		priceOfferedTextField.layer.borderColor = grayDetails.CGColor
		priceOfferedTextField.layer.borderWidth = 1
		var paddingViewPrice = UIView(frame: CGRectMake(0, 0, 10, 0))
		priceOfferedTextField.leftView = paddingViewPrice
		priceOfferedTextField.leftViewMode = UITextFieldViewMode.Always
		priceOfferedTextField.keyboardType = UIKeyboardType.NumberPad
		
		priceOfferedTextField.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(taskTitleLabel.snp_left)
			make.top.equalTo(priceOfferedLabel.snp_bottom).offset(10)
			make.width.equalTo((frameWidth - 24)/2)
			make.height.equalTo(50)
		}
		
		//Location Label + TextField
		var locationLabel = UILabel()
		self.contentView.addSubview(locationLabel)
		locationLabel.text = "Enter a location for the task"
		locationLabel.textColor = blackNelpyColor
		locationLabel.font = UIFont(name: "HelveticaNeue", size: kFormViewLabelFontSize)
		
		locationLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(priceOfferedTextField.snp_bottom).offset(20)
			make.left.equalTo(taskTitleTextField.snp_left)
		}
		var locationTextField = UITextField()
		self.contentView.addSubview(locationTextField)
		self.locationTextField = locationTextField
		self.locationTextField!.delegate = self
		locationTextField.backgroundColor = navBarColor.colorWithAlphaComponent(0.75)
		locationTextField.attributedPlaceholder = NSAttributedString(string: "Address", attributes: [NSForegroundColorAttributeName: blackNelpyColor.colorWithAlphaComponent(0.75)])
		locationTextField.font = UIFont(name: "HelveticaNeue", size: kTextFontSize)
		locationTextField.textColor = blackNelpyColor
		locationTextField.textAlignment = NSTextAlignment.Left
		locationTextField.layer.cornerRadius = 3
		locationTextField.layer.borderColor = grayDetails.CGColor
		locationTextField.layer.borderWidth = 1
		var paddingViewLocation = UIView(frame: CGRectMake(0, 0, 10, 0))
		locationTextField.leftView = paddingViewLocation
		locationTextField.leftViewMode = UITextFieldViewMode.Always
		
		locationTextField.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(taskTitleLabel.snp_left)
			make.top.equalTo(locationLabel.snp_bottom).offset(10)
			make.width.equalTo(frameWidth - contentInset * 2)
			make.height.equalTo(50)
		}
		
		
		//Description Label + Textfield
		
		var descriptionLabel = UILabel()
		self.contentView.addSubview(descriptionLabel)
		descriptionLabel.text = "Briefly describe the task"
		descriptionLabel.textColor = blackNelpyColor
		descriptionLabel.font = UIFont(name: "HelveticaNeue", size: kFormViewLabelFontSize)
		
		descriptionLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(locationTextField.snp_bottom).offset(20)
			make.left.equalTo(taskTitleTextField.snp_left)
		}
		var descriptionTextView = UITextView()
		self.descriptionTextView = descriptionTextView
		descriptionTextView.delegate = self
		self.contentView.addSubview(descriptionTextView)
		descriptionTextView.backgroundColor = navBarColor.colorWithAlphaComponent(0.75)
		descriptionTextView.font = UIFont(name: "HelveticaNeue", size: kTextFontSize)
		descriptionTextView.textColor = blackNelpyColor
		descriptionTextView.textAlignment = NSTextAlignment.Left
		descriptionTextView.layer.cornerRadius = 3
		descriptionTextView.layer.borderColor = grayDetails.CGColor
		descriptionTextView.layer.borderWidth = 1
		
		
		descriptionTextView.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(taskTitleLabel.snp_left)
			make.top.equalTo(descriptionLabel.snp_bottom).offset(10)
			make.width.equalTo(frameWidth - contentInset * 2)
			make.height.equalTo(150)
		}

		
		//Attach Pictures label + Button
		
		var picturesLabel = UILabel()
		self.contentView.addSubview(picturesLabel)
		picturesLabel.text = "Attach pictures (optional)"
		picturesLabel.textColor = blackNelpyColor
		picturesLabel.font = UIFont(name: "HelveticaNeue", size: kFormViewLabelFontSize)
		
		picturesLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(descriptionTextView.snp_bottom).offset(20)
			make.left.equalTo(descriptionLabel.snp_left)
		}
		
		var picturesButton = UIButton()
		self.contentView.addSubview(picturesButton)
		picturesButton.setBackgroundImage(UIImage(named: "plus"), forState: UIControlState.Normal)
		picturesButton.addTarget(self, action: "attachPicturesButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		
		picturesButton.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(picturesLabel.snp_bottom).offset(10)
			make.left.equalTo(picturesLabel.snp_left).offset(12)
			make.height.equalTo(80)
			make.width.equalTo(80)
		}
		
		//Image preview for attached images
		var imageOne = UIImageView()
		self.imageOne = imageOne
		self.contentView.addSubview(imageOne)
		imageOne.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(picturesButton.snp_right).offset(20)
			make.centerY.equalTo(picturesButton.snp_centerY)
			make.width.equalTo(50)
			make.height.equalTo(50)
		}
		
		var imageTwo = UIImageView()
		self.imageTwo = imageTwo
		self.contentView.addSubview(imageTwo)
		imageTwo.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(imageOne.snp_right).offset(10)
			make.centerY.equalTo(picturesButton.snp_centerY)
			make.width.equalTo(50)
			make.height.equalTo(50)
		}
		
		var imageThree = UIImageView()
		self.imageThree = imageThree
		self.contentView.addSubview(imageThree)
		imageThree.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(imageTwo.snp_right).offset(10)
			make.centerY.equalTo(picturesButton.snp_centerY)
			make.width.equalTo(50)
			make.height.equalTo(50)
		}
		
		var imageFour = UIImageView()
		self.imageFour = imageFour
		self.contentView.addSubview(imageFour)
		imageFour.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(imageThree.snp_right).offset(10)
			make.centerY.equalTo(picturesButton.snp_centerY)
			make.width.equalTo(50)
			make.height.equalTo(50)
		}
		
		//Google Autocomplete Table View
		
		var autocompleteTableView = UITableView()
		self.contentView.addSubview(autocompleteTableView)
		self.autocompleteTableView = autocompleteTableView
		self.autocompleteTableView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
		self.autocompleteTableView.delegate = self
		self.autocompleteTableView.dataSource = self
		self.autocompleteTableView.registerClass(AutocompleteCell.classForCoder(), forCellReuseIdentifier: AutocompleteCell.reuseIdentifier)
		self.autocompleteTableView.hidden = true
		self.autocompleteTableView.layer.borderColor = grayDetails.CGColor
		self.autocompleteTableView.layer.borderWidth = 1
		self.autocompleteTableView.backgroundColor = whiteNelpyColor
		
		self.autocompleteTableView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(locationTextField.snp_bottom)
			make.left.equalTo(locationTextField.snp_left)
			make.width.equalTo(locationTextField.snp_width)
			make.height.equalTo(self.contentView.snp_height).dividedBy(3)
		}
		
		//Create task button
		
		var createTaskButton = UIButton()
		self.contentView.addSubview(createTaskButton)
		createTaskButton.setTitle("Create Task", forState: UIControlState.Normal)
		createTaskButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
		createTaskButton.backgroundColor = greenPriceButton
		createTaskButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: kFormButtonFontSize)
		createTaskButton.addTarget(self, action: "postButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		
		createTaskButton.snp_makeConstraints { (make) -> Void in
			make.width.equalTo(250)
			make.height.equalTo(50)
			make.top.equalTo(picturesButton.snp_bottom).offset(45)
			make.centerX.equalTo(self.contentView.snp_centerX)
		}
		
	}
	
	func adjustUI(){
		let backBtn = UIButton()
		backBtn.addTarget(self, action: "backButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		self.navBar.backButton = backBtn
		self.formBackground.backgroundColor = whiteNelpyColor
		self.contentView.backgroundColor = whiteNelpyColor
		self.navBar.setTitle("Create your task")

		
	}
	
	func convertImagesToData(){
		self.task.pictures = Array()
		for image in self.imagesArray{
			var imageData = UIImageJPEGRepresentation(image as! UIImage, 0.50)
			var imageFile = PFFile(name:"image.png", data:imageData)
			self.task.pictures!.append(imageFile)
		}
	}
	
	//Image Picker delegate methods
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
		if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
			self.imagesArray.addObject(pickedImage)
			if(self.imagesArray.count == 1){
				self.imageOne!.image = pickedImage
			}else if(self.imagesArray.count == 2){
				self.imageTwo!.image = pickedImage
			}else if(self.imagesArray.count == 3){
				self.imageThree!.image = pickedImage
			}else if(self.imagesArray.count == 4){
				self.imageFour!.image = pickedImage
			}
		}
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	
	//TableView delegate methods
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return autocompleteArray.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCellWithIdentifier(AutocompleteCell.reuseIdentifier, forIndexPath: indexPath) as! AutocompleteCell
		
		let prediction: GMSAutocompletePrediction = self.autocompleteArray[indexPath.item]
		
		cell.setAddress(prediction)
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let prediction = self.autocompleteArray[indexPath.row]
		self.locationTextField!.text = prediction.attributedFullText.string

		let geocodeURL = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(prediction.placeID)&key=\(kGoogleAPIKey)"
		
		request(.GET, geocodeURL).responseJSON { _, _, response, _ in
			let json = JSON(response!)
			let res = json["result"]
			
			let latitude = res["geometry"]["location"]["lat"].doubleValue
			let longitude = res["geometry"]["location"]["lng"].doubleValue
			
			let city = self.getCity(res["address_components"])
			
			let point = GeoPoint(latitude:latitude, longitude:longitude)
			self.task.location = point
			self.task.city = city
		}
		self.autocompleteTableView.hidden = true
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 80
	}
	
	//TextField Delegate methods
	
	func textFieldDidBeginEditing(textField: UITextField) {
		if (textField == self.locationTextField){
			self.autocompleteTableView.hidden = false
			self.tap!.enabled = false
		}else{
		self.tap!.enabled = true
		}
	}
	
	func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
		if(textField == self.locationTextField){
			self.tap!.enabled = false
			return true
		}
		self.tap!.enabled = true
		return true
	}
	
	func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
		if(textField == locationTextField){
			var substring = textField.text as NSString
   substring = substring.stringByReplacingCharactersInRange(range, withString: string)
			self.placeAutocomplete(substring as String)
			return true
		}
		return true
	}
	
	//TextView delegate
	
	func textViewDidBeginEditing(textView: UITextView) {
		self.tap!.enabled = true
	}
	
	//Google Places auto complete
	
	func placeAutocomplete(text:String) {
		let filter = GMSAutocompleteFilter()
		filter.type = GMSPlacesAutocompleteTypeFilter.Address
		self.placesClient?.autocompleteQuery(text, bounds: nil, filter: filter, callback: { (results, error: NSError?) -> Void in
			if let error = error {
				println("Autocomplete error \(error)")
			}
			
			if(results != nil){
				self.autocompleteArray = results as! [GMSAutocompletePrediction]
				self.autocompleteTableView.reloadData()
				self.autocompleteTableView.hidden = false
				for result in results! {
					if let result = result as? GMSAutocompletePrediction {
						println("Result \(result.attributedFullText) with placeID \(result.placeID)")
					}
				}
			}
		})
	}
	
	
	func getCity(addressComponents: JSON) -> String? {
		for (_, comp: JSON) in addressComponents {
			for (_, t: JSON) in comp["types"] {
				if t.stringValue == "locality" {
					return comp["long_name"].string
				}
			}
		}
		
		return nil
	}
	
	
	//ACTIONS
	
	func attachPicturesButtonTapped(sender: UIButton){
		imagePicker.allowsEditing = false
		imagePicker.sourceType = .PhotoLibrary
		presentViewController(imagePicker, animated: true, completion: nil)
	}
	
	func backButtonTapped(sender: UIButton) {
		self.dismissViewControllerAnimated(true, completion: nil)
		view.endEditing(true) // dissmiss keyboard without delay
	}
	
	func postButtonTapped(sender: UIButton) {
		if(self.imagesArray.count != 0){
			self.convertImagesToData()
		}
		self.task.title = self.titleTextField!.text
		self.task.desc = self.descriptionTextView!.text
		self.task.priceOffered = (self.priceOffered!.text as NSString).doubleValue
				ApiHelper.addTask(self.task, block: { (task, error) -> Void in
					self.delegate?.nelpTaskAdded(self.task)
					self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
					self.dismissViewControllerAnimated(true, completion: nil)
				})
	}
}
