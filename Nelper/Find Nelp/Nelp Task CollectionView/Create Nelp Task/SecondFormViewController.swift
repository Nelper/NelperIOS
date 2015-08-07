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

class SecondFormViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate{
	
	let kGoogleAPIKey = "AIzaSyC4IkGUD1uY53E1aihYxDvav3SbdCDfzq8"
	var task: FindNelpTask!
	var placesClient: GMSPlacesClient?
	var autocompleteArray = [GMSAutocompletePrediction]()
	
	var delegate: SecondFormViewControllerDelegate?
	
	@IBOutlet weak var navBar: UIView!
	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var logoImage: UIImageView!
	
	@IBOutlet weak var nelpyTextBubble: UIImageView!
	@IBOutlet weak var nelpyText: UILabel!
	
	@IBOutlet weak var locationTextField: UITextField!
	
	@IBOutlet weak var autocompleteTableView: UITableView!
	
	@IBOutlet weak var priceOfferedTextField: UITextField!
	
	@IBOutlet weak var formBackground: UIView!
	
	@IBOutlet weak var categoriesBackground: UIView!
	@IBOutlet weak var technologyFilter: UIButton!
	@IBOutlet weak var houseCleaningFilter: UIButton!
	@IBOutlet weak var gardeningFilter: UIButton!
	@IBOutlet weak var businessFilter: UIButton!
	@IBOutlet weak var handyMan: UIButton!
	@IBOutlet weak var multimediaFilter: UIButton!
	
	
	@IBOutlet weak var postButton: UIButton!
	
	
	convenience init(task: FindNelpTask){
		self.init(nibName: "SecondFormScreen", bundle: nil)
		self.task = task
		self.placesClient = GMSPlacesClient()
	}
	
	override func viewDidLoad() {
		self.autocompleteTableView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
		self.autocompleteTableView.delegate = self
		self.autocompleteTableView.dataSource = self
		self.autocompleteTableView.registerClass(AutocompleteCell.classForCoder(), forCellReuseIdentifier: AutocompleteCell.reuseIdentifier)
		self.autocompleteTableView.hidden = true
		self.nelpyText.alpha = 0
		self.nelpyTextBubble.alpha = 0
		self.priceOfferedTextField.alpha = 0
		self.nelpyText.textColor = blackNelpyColor
		self.nelpyText.font = UIFont(name: "Railway", size: kTextFontSize)
		self.nelpyText.textAlignment = NSTextAlignment.Center
		self.nelpyTextBubble.image = UIImage(named: "bubble.png")
		self.nelpyText.text = "Enter the address where the task needs to be done."
		self.adjustUI()
		
	}
	
	override func viewDidAppear(animated: Bool) {
		
		UIView.animateWithDuration(0.4, animations:{self.nelpyText.alpha = 1}, completion: nil)
		UIView.animateWithDuration(0.4, animations:{self.nelpyTextBubble.alpha = 1}, completion: nil)
		
	}
	
	func adjustUI(){
		self.navBar.backgroundColor = orangeMainColor
		self.logoImage.image = UIImage(named: "logo_nobackground_v2")
		self.backButton.titleLabel?.font = UIFont(name: "Railway", size: kButtonFontSize)
		self.formBackground.backgroundColor = orangeSecondaryColor
		
		self.locationTextField.backgroundColor = whiteNelpyColor.colorWithAlphaComponent(0.2)
		self.locationTextField.delegate = self
		self.locationTextField.font = UIFont(name: "Railway", size: kTitleFontSize)
		self.locationTextField.textAlignment = NSTextAlignment.Center
		self.locationTextField.attributedPlaceholder = NSAttributedString(string:"Address",
			attributes:[NSForegroundColorAttributeName: whiteNelpyColor])
		self.locationTextField.becomeFirstResponder()
		self.locationTextField.tintColor = whiteNelpyColor
		self.locationTextField.textColor = blackNelpyColor
		
		self.autocompleteTableView.backgroundColor = orangeSecondaryColor
		
		self.priceOfferedTextField.backgroundColor = whiteNelpyColor.colorWithAlphaComponent(0.2)
		self.priceOfferedTextField.delegate = self
		self.priceOfferedTextField.font = UIFont(name: "Railway", size: kTitleFontSize)
		self.priceOfferedTextField.textAlignment = NSTextAlignment.Center
		self.priceOfferedTextField.attributedPlaceholder = NSAttributedString(string:"Price Offered",
			attributes:[NSForegroundColorAttributeName: whiteNelpyColor])
		self.priceOfferedTextField.becomeFirstResponder()
		self.priceOfferedTextField.tintColor = whiteNelpyColor
		self.priceOfferedTextField.textColor = blackNelpyColor
		
		self.categoriesBackground.backgroundColor = whiteNelpyColor.colorWithAlphaComponent(0.2)
		
		self.technologyFilter.backgroundColor = whiteNelpyColor.colorWithAlphaComponent(0.0)
		self.technologyFilter.setTitle("Technology", forState: UIControlState.Normal)
		self.technologyFilter.setTitleColor(whiteNelpyColor, forState: UIControlState.Normal)
		self.technologyFilter.setTitleColor(orangeMainColor, forState: UIControlState.Selected)
		self.technologyFilter.titleLabel?.font = UIFont(name: "Railway", size: kTextFontSize)
		
		self.houseCleaningFilter.backgroundColor = whiteNelpyColor.colorWithAlphaComponent(0.0)
		self.houseCleaningFilter.setTitle("House cleaning", forState: UIControlState.Normal)
		self.houseCleaningFilter.setTitleColor(whiteNelpyColor, forState: UIControlState.Normal)
		self.houseCleaningFilter.setTitleColor(orangeMainColor, forState: UIControlState.Selected)
		self.houseCleaningFilter.titleLabel?.font = UIFont(name: "Railway", size: kTextFontSize)
		
		self.handyMan.backgroundColor = whiteNelpyColor.colorWithAlphaComponent(0.0)
		self.handyMan.setTitle("Handyman", forState: UIControlState.Normal)
		self.handyMan.setTitleColor(whiteNelpyColor, forState: UIControlState.Normal)
		self.handyMan.setTitleColor(orangeMainColor, forState: UIControlState.Selected)
		self.handyMan.titleLabel?.font = UIFont(name: "Railway", size: kTextFontSize)
		
		self.gardeningFilter.backgroundColor = whiteNelpyColor.colorWithAlphaComponent(0.0)
		self.gardeningFilter.setTitle("Gardening", forState: UIControlState.Normal)
		self.gardeningFilter.setTitleColor(whiteNelpyColor, forState: UIControlState.Normal)
		self.gardeningFilter.setTitleColor(orangeMainColor, forState: UIControlState.Selected)
		self.gardeningFilter.titleLabel?.font = UIFont(name: "Railway", size: kTextFontSize)
		
		self.businessFilter.backgroundColor = whiteNelpyColor.colorWithAlphaComponent(0.0)
		self.businessFilter.setTitle("Business & Admin", forState: UIControlState.Normal)
		self.businessFilter.setTitleColor(whiteNelpyColor, forState: UIControlState.Normal)
		self.businessFilter.setTitleColor(orangeMainColor, forState: UIControlState.Selected)
		self.businessFilter.titleLabel?.font = UIFont(name: "Railway", size: kTextFontSize)
		
		self.multimediaFilter.backgroundColor = whiteNelpyColor.colorWithAlphaComponent(0.0)
		self.multimediaFilter.setTitle("Multimedia", forState: UIControlState.Normal)
		self.multimediaFilter.setTitleColor(whiteNelpyColor, forState: UIControlState.Normal)
		self.multimediaFilter.setTitleColor(orangeMainColor, forState: UIControlState.Selected)
		self.multimediaFilter.titleLabel?.font = UIFont(name: "Railway", size: kTextFontSize)
		
		self.categoriesBackground.alpha = 0
		
		self.postButton.backgroundColor = orangeSecondaryColor
		self.postButton.setTitle("Ask for nelp!", forState: UIControlState.Normal)
		self.postButton.setTitleColor(whiteNelpyColor, forState: UIControlState.Normal)
		self.postButton.titleLabel?.font = UIFont(name: "Railway", size: kTitleFontSize)
		self.postButton.layer.borderWidth = 2
		self.postButton.layer.cornerRadius = 6
		self.postButton.layer.borderColor = whiteNelpyColor.CGColor
		
		self.postButton.alpha = 0
	}
	
	//TextFieldDelegate
	
	func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
		if(textField == locationTextField){
			var substring = textField.text as NSString
   substring = substring.stringByReplacingCharactersInRange(range, withString: string)
			self.placeAutocomplete(substring as String)
			return true
		}
		return true
	}
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		
		if(textField == locationTextField){
			self.priceOfferedTextField.alpha = 1
			self.priceOfferedTextField.becomeFirstResponder()
			
			UIView.animateWithDuration(0.4, animations:{self.nelpyText.alpha = 0}, completion: nil)
			UIView.animateWithDuration(0.4, animations:{self.nelpyTextBubble.alpha = 0}, completion: nil)
			
			self.nelpyText.text = "Now that I know where you are, tell me how much you are willing to pay :D ."
			
			UIView.animateWithDuration(0.4, animations:{self.nelpyText.alpha = 1}, completion: nil)
			UIView.animateWithDuration(0.4, animations:{self.nelpyTextBubble.alpha = 1}, completion: nil)
		}else if(textField == priceOfferedTextField){
			
			UIView.animateWithDuration(0.4, animations:{self.nelpyText.alpha = 0}, completion: nil)
			UIView.animateWithDuration(0.4, animations:{self.nelpyTextBubble.alpha = 0}, completion: nil)
			
			self.nelpyText.text = "Amazing!\n Last step. Select a category for your task and we're done!"
			
			UIView.animateWithDuration(0.4, animations:{self.nelpyText.alpha = 1}, completion: nil)
			UIView.animateWithDuration(0.4, animations:{self.nelpyTextBubble.alpha = 1}, completion: nil)
			
			self.categoriesBackground.alpha = 1
			self.postButton.alpha = 1
			
			self.priceOfferedTextField.endEditing(true)
			return false
			
		}
		return false
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
		self.locationTextField.text = prediction.attributedFullText.string
		var geocodeURL = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(prediction.placeID)&key=\(kGoogleAPIKey)"
		
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
		self.priceOfferedTextField.alpha = 1
		self.priceOfferedTextField.becomeFirstResponder()
		
		UIView.animateWithDuration(0.4, animations:{self.nelpyText.alpha = 0}, completion: nil)
		UIView.animateWithDuration(0.4, animations:{self.nelpyTextBubble.alpha = 0}, completion: nil)
		
		self.nelpyText.text = "Now that I know where you are, tell me how much you are willing to pay 8==D ."
		
		UIView.animateWithDuration(0.4, animations:{self.nelpyText.alpha = 1}, completion: nil)
		UIView.animateWithDuration(0.4, animations:{self.nelpyTextBubble.alpha = 1}, completion: nil)
		self.autocompleteTableView.hidden = true
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 70
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
	
	func deselectAllButton(){
		self.multimediaFilter.selected = false
		self.handyMan.selected = false
		self.businessFilter.selected = false
		self.technologyFilter.selected = false
		self.gardeningFilter.selected = false
		self.houseCleaningFilter.selected = false
	}
	
	func getCity(addressComponents: JSON) -> String? {
		for (_, comp: JSON) in addressComponents {
			let locale = comp["types"].arrayValue.filter({ $0.stringValue == "locality" })
			for (_, t: JSON) in comp["types"] {
				if t.stringValue == "locality" {
					return comp["long_name"].string
				}
			}
		}
		
		return nil
	}
	
	
	//IBACTIONS
	
	@IBAction func technologyFilterTapped(sender: AnyObject) {
		deselectAllButton()
		self.task.category = "technology"
	}
	
	@IBAction func gardeningFilterTapped(sender: AnyObject) {
		deselectAllButton()
		self.task.category = "gardening"
	}
	
	@IBAction func cleaningFilterTapped(sender: AnyObject) {
		deselectAllButton()
		self.task.category = "housecleaning"
	}
	
	@IBAction func businessFilterTapped(sender: AnyObject) {
		deselectAllButton()
		self.task.category = "business"
	}
	
	@IBAction func handyManFilterTapped(sender: AnyObject) {
		deselectAllButton()
		self.task.category = "handywork"
	}
	
	@IBAction func multimediaFilterTapped(sender: AnyObject) {
		deselectAllButton()
		self.task.category = "multimedia"
	}
	
	
	
	@IBAction func backButtonTapped(sender: AnyObject) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	@IBAction func postButtonTapped(sender: AnyObject) {
		self.task.priceOffered = priceOfferedTextField.text
		//TODO: set location using GeoPoint
		//self.task.location = locationTextField.text
		
		ApiHelper.addTask(self.task, block: { (task, error) -> Void in
			self.delegate?.nelpTaskAdded(self.task)
			self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
			self.dismissViewControllerAnimated(true, completion: nil)
		})
	}
}
