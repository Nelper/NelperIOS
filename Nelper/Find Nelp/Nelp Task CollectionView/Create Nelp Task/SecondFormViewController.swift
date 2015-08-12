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
	


	@IBOutlet weak var navBar: NavBar!
	
	@IBOutlet weak var autocompleteTableView: UITableView!
	
	@IBOutlet weak var formBackground: UIView!
	
	
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

		self.adjustUI()
		
	}
	
	override func viewDidAppear(animated: Bool) {

		
	}
	
	func adjustUI(){
		let backBtn = UIButton()
		backBtn.addTarget(self, action: "backButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		self.navBar.backButton = backBtn
		self.formBackground.backgroundColor = whiteNelpyColor

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
		return 0
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
	
	
	//IBACTIONS

	func backButtonTapped(sender: UIButton) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	@IBAction func postButtonTapped(sender: AnyObject) {

		ApiHelper.addTask(self.task, block: { (task, error) -> Void in
			self.delegate?.nelpTaskAdded(self.task)
			self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
			self.dismissViewControllerAnimated(true, completion: nil)
		})
	}
}
