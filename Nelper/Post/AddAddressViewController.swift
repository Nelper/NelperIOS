//
//  AddAddressViewController.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-09-24.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import FXBlurView
import GoogleMaps

protocol AddAddressViewControllerDelegate {
	func didClosePopup(vc: AddAddressViewController)
	func didAddLocation(vc: AddAddressViewController)
}

class AddAddressViewController: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
	
	let kGoogleAPIKey = "AIzaSyC4IkGUD1uY53E1aihYxDvav3SbdCDfzq8"
	var delegate:AddAddressViewControllerDelegate?
	var backgroundImage: UIImageView!
	var popupContainer: UIView!
	var tap: UITapGestureRecognizer!
	var blurContainer: FXBlurView!
	var scrollView: UIScrollView!
	var contentView: UIView!
	var titleLabel: UILabel!
	var addressTextField:UITextField!
	var autocompleteTableView:UITableView!
	var autocompleteArray = [GMSAutocompletePrediction]()
	var nameTextField:UITextField!
	var placesClient: GMSPlacesClient?
	var location: GeoPoint!
	var addLocationButton:UIButton!
	var address = Location()
	var addressOk:Bool!
	var nameOk:Bool!
	var blurImage: UIImage!
	
	var contentInsets: UIEdgeInsets!
	var activeField: UITextField!
	var fieldEditing = false
	
	//MARK: Initialization
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.placesClient = GMSPlacesClient()
		self.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
		addressOk = false
		nameOk = false
		
		createView()
		
		// KEYBOARD VIEW MOVER
		self.nameTextField.delegate = self
		self.addressTextField.delegate = self
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(true)
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardDidShow:"), name: UIKeyboardWillShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
	}
	
	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(true)
		
		NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		self.scrollView.contentSize = self.contentView.frame.size
	}
	
	//MARK: View Creation
	
	func createView() {
		
		let backgroundImage = UIImageView(frame: self.view.frame)
		self.backgroundImage = backgroundImage
		self.backgroundImage.image = self.blurImage
		self.view.addSubview(backgroundImage)
		
		let blurContainer = FXBlurView(frame: self.view.bounds)
		self.blurContainer = blurContainer
		self.blurContainer.tintColor = UIColor.clearColor()
		self.blurContainer.updateInterval = 100
		self.blurContainer.iterations = 2
		self.blurContainer.blurRadius = 4
		self.blurContainer.dynamic = false
		self.blurContainer.underlyingView = nil
		self.backgroundImage.addSubview(self.blurContainer)
		self.blurContainer.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self.view.snp_edges)
		}
		
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapDetected")
		self.tap = tap
		self.tap.delegate = self
		blurContainer.addGestureRecognizer(tap)
		
		self.view.backgroundColor = UIColor.clearColor()
		self.view.addSubview(blurContainer)
		
		let scrollView = UIScrollView()
		self.scrollView = scrollView
		self.scrollView.backgroundColor = Color.blackPrimary.colorWithAlphaComponent(0.4)
		self.blurContainer.addSubview(self.scrollView)
		self.scrollView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self.blurContainer.snp_edges)
		}
		
		let contentView = UIView()
		self.contentView = contentView
		self.scrollView.addSubview(self.contentView)
		self.contentView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(scrollView.snp_top)
			make.left.equalTo(scrollView.snp_left)
			make.right.equalTo(scrollView.snp_right)
			make.height.greaterThanOrEqualTo(blurContainer.snp_height)
			make.width.equalTo(blurContainer.snp_width)
		}
		
		let popupContainer = UIView()
		self.popupContainer = popupContainer
		self.contentView.addSubview(popupContainer)
		popupContainer.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(contentView.snp_left).offset(8)
			make.right.equalTo(contentView.snp_right).offset(-8)
			make.top.equalTo(contentView.snp_top).offset(200)
		}
		
		let titleLabel = UILabel()
		self.titleLabel = titleLabel
		popupContainer.addSubview(titleLabel)
		titleLabel.text	= "Add a location"
		titleLabel.textColor = Color.whitePrimary
		titleLabel.font = UIFont(name: "Lato-Regular", size: kNavTitle18)
		titleLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(popupContainer.snp_top)
			make.centerX.equalTo(popupContainer.snp_centerX)
		}
		
		let nameTextField = DefaultTextFieldView(isPriceTextField: false)
		self.nameTextField = nameTextField
		popupContainer.addSubview(nameTextField)
		nameTextField.attributedPlaceholder = NSAttributedString(string: "Name (home, office, etc.)", attributes: [NSForegroundColorAttributeName: Color.textFieldPlaceholderColor])
		nameTextField.autocorrectionType = UITextAutocorrectionType.No
		nameTextField.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(titleLabel.snp_bottom).offset(15)
			make.left.equalTo(popupContainer.snp_left).offset(8)
			make.right.equalTo(popupContainer.snp_right).offset(-8)
		}
		
		let addressTextField = DefaultTextFieldView(isPriceTextField: false)
		self.addressTextField = addressTextField
		addressTextField.delegate = self
		popupContainer.addSubview(addressTextField)
		addressTextField.attributedPlaceholder = NSAttributedString(string: "Address", attributes: [NSForegroundColorAttributeName: Color.textFieldPlaceholderColor])
		addressTextField.keyboardType = UIKeyboardType.NumbersAndPunctuation
		addressTextField.autocorrectionType = UITextAutocorrectionType.No
		addressTextField.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(nameTextField.snp_bottom).offset(10)
			make.left.equalTo(popupContainer.snp_left).offset(8)
			make.right.equalTo(popupContainer.snp_right).offset(-8)
		}
		
		let addLocationButton = PrimaryActionButton()
		self.addLocationButton = addLocationButton
		popupContainer.addSubview(addLocationButton)
		addLocationButton.addTarget(self, action: "didTapAddLocationButton:", forControlEvents: UIControlEvents.TouchUpInside)
		addLocationButton.setTitle("Add", forState: UIControlState.Normal)
		addLocationButton.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(popupContainer.snp_centerX)
			make.top.equalTo(addressTextField.snp_bottom).offset(20)
		}
		
		popupContainer.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(addLocationButton)
		}
		
		//Google Autocomplete Table View
		
		let autocompleteTableView = UITableView()
		self.view.addSubview(autocompleteTableView)
		self.autocompleteTableView = autocompleteTableView
		self.autocompleteTableView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
		self.autocompleteTableView.delegate = self
		self.autocompleteTableView.dataSource = self
		self.autocompleteTableView.registerClass(AutocompleteCell.classForCoder(), forCellReuseIdentifier: AutocompleteCell.reuseIdentifier)
		self.autocompleteTableView.hidden = true
		self.autocompleteTableView.layer.borderColor = Color.darkGrayDetails.CGColor
		self.autocompleteTableView.layer.borderWidth = 0.5
		self.autocompleteTableView.backgroundColor = Color.whitePrimary.colorWithAlphaComponent(0.6)
		self.autocompleteTableView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(addressTextField.snp_bottom)
			make.left.equalTo(addressTextField.snp_left)
			make.right.equalTo(addressTextField.snp_right)
			make.height.equalTo(240)
		}
	}
	
	//MARK: TableView Delegate and Datasource
	
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
		self.addressTextField!.text = prediction.attributedFullText.string
		
		let geocodeURL = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(prediction.placeID)&key=\(kGoogleAPIKey)"
		
		request(.GET, geocodeURL).responseJSON { response in
			let json = JSON(response.result.value!)
			let res = json["result"]
			
			let latitude = res["geometry"]["location"]["lat"].doubleValue
			let longitude =  res["geometry"]["location"]["lng"].doubleValue
			
			//print(latitude)
			//print(longitude)
			
			let comps = res["address_components"]
			self.address.streetNumber = self.getAddressComponent(comps, component: "street_number")["long_name"].string
			self.address.route = self.getAddressComponent(comps, component: "route")["long_name"].string
			self.address.city = self.getAddressComponent(comps, component: "locality")["long_name"].string
			self.address.province = self.getAddressComponent(comps, component: "administrative_area_level_1")["short_name"].string
			self.address.country = self.getAddressComponent(comps, component: "country")["long_name"].string
			self.address.postalCode = self.getAddressComponent(comps, component: "postal_code")["long_name"].string
			self.address.formattedAddress = res["formatted_address"].string
			
			self.address.coords = ["latitude":Double(latitude),"longitude":Double(longitude)]
			
			let point = GeoPoint(latitude: latitude, longitude:longitude)
			//print(point)
			self.addressOk = true
			self.location = point
		}
		self.autocompleteTableView.hidden = true
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 60
	}
	
	//MARK: DISMISS KEYBOARD
	
	func dismissKeyboard() {
		view.endEditing(true)
	}
	
	//MARK: TextField delegate method
	
	func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
		return true
	}
	
	func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
		if(textField == addressTextField) {
			
			let textFieldRange:NSRange = NSMakeRange(0, textField.text!.characters.count)
			
			if NSEqualRanges(textFieldRange, range)	&& string.characters.count == 0 {
				self.autocompleteTableView.hidden = true
			} else {
				self.autocompleteTableView.hidden = false
			}
			var substring = textField.text! as NSString
			substring = substring.stringByReplacingCharactersInRange(range, withString: string)
			self.placeAutocomplete(substring as String)
			return true
		}
		return true
	}
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		dismissKeyboard()
		textField.resignFirstResponder()
		
		switch (textField) {
		case self.nameTextField:
			self.addressTextField.becomeFirstResponder()
		default:
			return false
		}
		
		return false
	}
	
	//MARK: Google Places Autocomplete
	
	/**
	Google Autocomplete Method
	
	- parameter text: User text (constantly updated)
	*/
	func placeAutocomplete(text: String) {
		let filter = GMSAutocompleteFilter()
		filter.type = .Address
		
		var bounds: GMSCoordinateBounds?
		
		if LocationHelper.sharedInstance.currentCLLocation != nil{
			bounds = GMSCoordinateBounds(coordinate: LocationHelper.sharedInstance.currentCLLocation, coordinate: LocationHelper.sharedInstance.currentCLLocation)
		}
		
		self.placesClient?.autocompleteQuery(text, bounds: bounds, filter: filter, callback: { (results, error: NSError?) -> Void in
			if let error = error {
				print("Autocomplete error \(error)")
			}
			
			if (results != nil) {
				self.autocompleteArray = results as! [GMSAutocompletePrediction]
				//TODO: FILTER COUNTRY AND KEEP ONLY CANADA
				/*for result in self.autocompleteArray {
					let string = result.attributedFullText.string
					if string.lowercaseString.rangeOfString("canada") == nil {
						self.autocompleteArray.removeAtIndex(self.autocompleteArray.indexOf(result)!)
					}
				}*/
				self.autocompleteTableView.reloadData()
				self.autocompleteTableView.hidden = false
				/*for result in results! {
					if let result = result as? GMSAutocompletePrediction {
						print("Result \(result.attributedFullText) with placeID \(result.placeID)")
					}
				}*/
			}
		})
	}
	
	//MARK: Gesture recognizer delegate methods
	
	func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
		if touch.view!.isEqual(self.popupContainer) && !touch.view!.isEqual(self.autocompleteTableView){
			return false
		}
		return true
	}
	
	
	func tapDetected(){
		if self.addressTextField.editing == true || self.nameTextField.editing == true {
			self.view.endEditing(true)
			if self.autocompleteTableView.hidden == false {
				self.autocompleteTableView.hidden = true
			}
		} else {
			dismissKeyboard()
			self.dismissViewControllerAnimated(true, completion: nil)
			self.delegate?.didClosePopup(self)
		}
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
	
	func keyboardDidShow(notification: NSNotification) {
		
		let info = notification.userInfo!
		var keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
		keyboardFrame = self.view.convertRect(keyboardFrame, fromView: nil)
		
		self.contentInsets = UIEdgeInsetsMake(0, 0, keyboardFrame.height * 0.8, 0)
		
		self.scrollView.contentInset = contentInsets
		self.scrollView.scrollIndicatorInsets = contentInsets
		
		var aRect = self.view.frame
		aRect.size.height -= keyboardFrame.height
		
		self.scrollView.scrollRectToVisible(CGRectMake(scrollView.contentSize.width - 1, scrollView.contentSize.height * 0.895, 1, 1), animated: true)
	}
	
	func keyboardWillHide(notification: NSNotification) {
		self.contentInsets = UIEdgeInsetsZero
		self.scrollView.contentInset = contentInsets
		self.scrollView.scrollIndicatorInsets = contentInsets
	}
	
	//MARK: Actions
	
	/**
			Returns the JSON element of a component with the specified type
	
		- parameter addressComponents: Address Component from Google Autocomplete
		- parameter component: The type of component
	
		- returns: The JSON part of the component
	*/
	
	func getAddressComponent(addressComponents: JSON, component: String) -> JSON {
		for (_, comp):(String, JSON) in addressComponents {
			for (_, t):(String, JSON) in comp["types"] {
				if t.stringValue == component {
					return comp
				}
			}
		}
		return nil
	}
	
	func didTapAddLocationButton(sender:UIButton!) {
		dismissKeyboard()
		
		if self.addressOk == true && self.nameTextField.text?.characters.count > 0 {
			if self.address.country == nil || self.address.country! != "Canada" {
				let popup = UIAlertController(title: "Invalid address", message: "You must select a valid Canadian address", preferredStyle: UIAlertControllerStyle.Alert)
				popup.addAction(UIAlertAction(title: "Confirm", style: .Default, handler: { (action) -> Void in
				}))
				self.presentViewController(popup, animated: true, completion: nil)
				popup.view.tintColor = Color.redPrimary
			} else if self.address.postalCode == nil {
				let popup = UIAlertController(title: "Invalid address", message: "You must select an address with a valid Postal Code", preferredStyle: UIAlertControllerStyle.Alert)
				popup.addAction(UIAlertAction(title: "Confirm", style: .Default, handler: { (action) -> Void in
				}))
				self.presentViewController(popup, animated: true, completion: nil)
				popup.view.tintColor = Color.redPrimary
			} else {
				self.address.name = self.nameTextField.text!
				self.delegate?.didAddLocation(self)
				self.dismissViewControllerAnimated(true, completion: nil)
				self.delegate?.didClosePopup(self)
			}
		} else {
			let popup = UIAlertController(title: "Missing information", message: "You must enter a name and select a valid address", preferredStyle: UIAlertControllerStyle.Alert)
			popup.addAction(UIAlertAction(title: "Confirm", style: .Default, handler: { (action) -> Void in
			}))
			self.presentViewController(popup, animated: true, completion: nil)
			popup.view.tintColor = Color.redPrimary
		}
	}
	
}

