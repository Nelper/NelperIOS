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

protocol AddAddressViewControllerDelegate{
	func didClosePopup(vc:AddAddressViewController)
	func didAddLocation(vc:AddAddressViewController)
}

class AddAddressViewController:UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate{
	
	let kGoogleAPIKey = "AIzaSyC4IkGUD1uY53E1aihYxDvav3SbdCDfzq8"
	var delegate:AddAddressViewControllerDelegate?
	var popupContainer: UIView!
	var tap: UITapGestureRecognizer!
	var blurContainer:UIVisualEffectView!
	var titleLabel: UILabel!
	var addressTextField:UITextField!
	var autocompleteTableView:UITableView!
	var autocompleteArray = [GMSAutocompletePrediction]()
	var nameTextField:UITextField!
	var placesClient: GMSPlacesClient?
	var location: GeoPoint!
	var addLocationButton:UIButton!
	var address = Location()
	var keyboardIsShowing: Bool = false
	var addressOk:Bool!
	var nameOk:Bool!
	
	
	//MARK: Initialization
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.placesClient = GMSPlacesClient()
		self.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
		addressOk = false
		nameOk = false
		
		//keyboard move view
		NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
		
		
		self.createView()
	}
	
	//MARK: View Creation
	
	func createView(){
		
		let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
		let blurContainer = UIVisualEffectView(effect: blurEffect)
		self.blurContainer = blurContainer
		self.view.addSubview(blurContainer)
		blurContainer.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self.view.snp_edges)
		}
		
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapDetected")
		self.tap = tap
		self.tap.delegate = self
		blurContainer.addGestureRecognizer(tap)
		
		self.view.backgroundColor = UIColor.clearColor()
		self.view.backgroundColor = UIColor.clearColor()
		self.view.addSubview(blurContainer)
		
		let popupContainer = UIView()
		self.popupContainer = popupContainer
		blurContainer.addSubview(popupContainer)
		popupContainer.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(blurContainer.snp_left).offset(8)
			make.right.equalTo(blurContainer.snp_right).offset(-8)
			make.centerY.equalTo(self.view.snp_centerY)
		}
		
		let titleLabel = UILabel()
		self.titleLabel = titleLabel
		popupContainer.addSubview(titleLabel)
		titleLabel.text	= "Add a location"
		titleLabel.textColor = whitePrimary
		titleLabel.font = UIFont(name: "Lato-Regular", size: kNavTitle18)
		titleLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(popupContainer.snp_top)
			make.centerX.equalTo(popupContainer.snp_centerX)
		}
		
		let nameTextField = UITextField()
		self.nameTextField = nameTextField
		popupContainer.addSubview(nameTextField)
		nameTextField.backgroundColor = whitePrimary.colorWithAlphaComponent(0.75)
		nameTextField.attributedPlaceholder = NSAttributedString(string: "Name (home, office, etc.)", attributes: [NSForegroundColorAttributeName: blackPrimary.colorWithAlphaComponent(0.75)])
		nameTextField.font = UIFont(name: "Lato-Regular", size: kText15)
		nameTextField.textColor = blackPrimary
		nameTextField.textAlignment = NSTextAlignment.Left
		nameTextField.layer.cornerRadius = 3
		nameTextField.layer.borderColor = grayDetails.CGColor
		nameTextField.layer.borderWidth = 1
		let paddingViewLocationName = UIView(frame: CGRectMake(0, 0, 10, 0))
		nameTextField.leftView = paddingViewLocationName
		nameTextField.leftViewMode = UITextFieldViewMode.Always
		nameTextField.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(titleLabel.snp_bottom).offset(15)
			make.left.equalTo(popupContainer.snp_left).offset(8)
			make.right.equalTo(popupContainer.snp_right).offset(-8)
			make.height.equalTo(50)
		}
		
		let addressTextField = UITextField()
		self.addressTextField = addressTextField
		addressTextField.delegate = self
		popupContainer.addSubview(addressTextField)
		addressTextField.backgroundColor = whitePrimary.colorWithAlphaComponent(0.75)
		addressTextField.attributedPlaceholder = NSAttributedString(string: "Address", attributes: [NSForegroundColorAttributeName: blackPrimary.colorWithAlphaComponent(0.75)])
		addressTextField.font = UIFont(name: "Lato-Regular", size: kText15)
		addressTextField.keyboardType = UIKeyboardType.NumbersAndPunctuation
		addressTextField.autocorrectionType = UITextAutocorrectionType.No
		addressTextField.textColor = blackPrimary
		addressTextField.textAlignment = NSTextAlignment.Left
		addressTextField.layer.cornerRadius = 3
		addressTextField.layer.borderColor = grayDetails.CGColor
		addressTextField.layer.borderWidth = 1
		let paddingViewLocation = UIView(frame: CGRectMake(0, 0, 10, 0))
		addressTextField.leftView = paddingViewLocation
		addressTextField.leftViewMode = UITextFieldViewMode.Always
		
		addressTextField.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(nameTextField.snp_bottom).offset(10)
			make.left.equalTo(popupContainer.snp_left).offset(8)
			make.right.equalTo(popupContainer.snp_right).offset(-8)
			make.height.equalTo(50)
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
			//make.height.equalTo(300)
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
		self.autocompleteTableView.layer.borderColor = darkGrayDetails.CGColor
		self.autocompleteTableView.layer.borderWidth = 0.5
		self.autocompleteTableView.backgroundColor = blackPrimary
		
		self.autocompleteTableView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(addressTextField.snp_bottom)
			make.left.equalTo(addressTextField.snp_left)
			make.right.equalTo(addressTextField.snp_right)
			make.height.equalTo(220)
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
		
		request(.GET, geocodeURL).responseJSON { _, _, data in
			let json = JSON(data.value!)
			let res = json["result"]
			
			let latitude = res["geometry"]["location"]["lat"].doubleValue
			let longitude =  res["geometry"]["location"]["lng"].doubleValue
			
			print(latitude)
			print(longitude)
			
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
			print(point)
			self.addressOk = true
			self.location = point
		}
		self.autocompleteTableView.hidden = true
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 60
	}
	
	//MARK: TextField delegate method
	
	func textFieldDidBeginEditing(textField: UITextField){
		
	}
	
	func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
		return true
	}
	
	func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
		if(textField == addressTextField){
			
			let textFieldRange:NSRange = NSMakeRange(0, textField.text!.characters.count)
			
			if NSEqualRanges(textFieldRange, range)	&& string.characters.count == 0 {
				self.autocompleteTableView.hidden = true
			}else{
				self.autocompleteTableView.hidden = false
			}
			var substring = textField.text! as NSString
			substring = substring.stringByReplacingCharactersInRange(range, withString: string)
			self.placeAutocomplete(substring as String)
			return true
		}
		return true
	}
	
	//MARK: Google Places Autocomplete
	
	/**
	Google Autocomplete Method
	
	- parameter text: User text (constantly updated)
	*/
	func placeAutocomplete(text:String) {
		let filter = GMSAutocompleteFilter()
		filter.type = GMSPlacesAutocompleteTypeFilter.Address
		
		var bounds:GMSCoordinateBounds?
		
		if LocationHelper.sharedInstance.currentCLLocation != nil{
			bounds = GMSCoordinateBounds(coordinate: LocationHelper.sharedInstance.currentCLLocation, coordinate: LocationHelper.sharedInstance.currentCLLocation)
		}
		
		self.placesClient?.autocompleteQuery(text, bounds: bounds, filter: filter, callback: { (results, error: NSError?) -> Void in
			if let error = error {
				print("Autocomplete error \(error)")
			}
			
			if(results != nil){
				self.autocompleteArray = results as! [GMSAutocompletePrediction]
				self.autocompleteTableView.reloadData()
				self.autocompleteTableView.hidden = false
				for result in results! {
					if let result = result as? GMSAutocompletePrediction {
						print("Result \(result.attributedFullText) with placeID \(result.placeID)")
					}
				}
			}
		})
	}
	
	//MARK: View delegate methods
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}
	
	//MARK: Keyboard move view
	func keyboardWillShow(sender: NSNotification) {
		if keyboardIsShowing == false {
			self.view.frame.origin.y -= 150
			keyboardIsShowing = true
		}
	}
	
	func keyboardWillHide(sender: NSNotification) {
		if keyboardIsShowing == true{
		self.view.frame.origin.y += 150
		keyboardIsShowing = false
		}
	}
	
	//MARK: Gesture recognizer delegate methods
	
	func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
		if touch.view!.isEqual(self.popupContainer) && !touch.view!.isEqual(self.autocompleteTableView){
			return false
		}
		return true
	}
	
	
	func tapDetected(){
		if self.addressTextField.editing == true || self.nameTextField.editing == true{
			self.view.endEditing(true)
			if self.autocompleteTableView.hidden == false{
				self.autocompleteTableView.hidden == true
			}
		}else{
			self.dismissViewControllerAnimated(true, completion: nil)
		}
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
	
	func didTapAddLocationButton(sender:UIButton!){
		if self.addressOk == true && self.nameTextField.text?.characters.count > 0{
		self.address.name = self.nameTextField.text!
		self.delegate?.didAddLocation(self)
		self.dismissViewControllerAnimated(true, completion: nil)
		}else{
				let popup = UIAlertController(title: "Missing information", message: "You must name and select a valid address!", preferredStyle: UIAlertControllerStyle.Alert)
			popup.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
			}))
				self.presentViewController(popup, animated: true, completion: nil)
		}
	}
	
}

