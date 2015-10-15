//
//  AccountSettingsViewController.swift
//  Nelper
//
//  Created by Pierre-Luc Benoit on 2015-10-14.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation
import UIKit

class AccountSettingsViewController: UIViewController {
	
	private var navBar: NavBar!
	
	var backgroundView: UIView!
	var scrollView: UIScrollView!
	var contentView: UIView!
	
	var generalContainer: DefaultContainerView!
	var emailLabel: UILabel!
	var emailTextField: DefaultTextFieldView!
	var phoneLabel: UILabel!
	var phoneTextField: DefaultTextFieldView!
	
	var locationsContainer: DefaultContainerView!
	var addLocationButton: UIButton!
	var emptyLocationsLabel: UILabel!
	//var locations: Array<Dictionary<String,AnyObject>>!
	var hardcodedArray = [
		(name: "Home", address: "175 Rue Forbin-Janson\nMont-Saint-Hilaire,QC\nJ3H 4E4"),
		(name: "Office", address: "1 Rue Notre Dame Ouest\nMontréal-Des-Longues-Villes, QC\nH2Y 3N2")
	]
	var locationContainer: UIButton!
	var locationContainerArray = [UIButton]()
	var locationNameLabel: UILabel!
	var locationName: UILabel!
	var locationAddressLabel: UILabel!
	var locationAddress: UILabel!
	
	let kPadding = 20
	var locationContainerHeight = CGFloat()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setLocations()
		
		createView()
		adjustUI()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		self.scrollView.contentSize = self.contentView.frame.size
	}
	
	func setLocations() {
		
		//let locations = PFUser.currentUser()!["privateData"]!["locations"]! as! Array<Dictionary<String,AnyObject>>
		//self.locations = locations
		
		//print(locations)
	}
	
	func createView() {
		
		///NAVBAR
		let navBar = NavBar()
		self.navBar = navBar
		self.view.addSubview(self.navBar)
		self.navBar.setTitle("Account Settings")
		self.navBar.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.view.snp_top)
			make.right.equalTo(self.view.snp_right)
			make.left.equalTo(self.view.snp_left)
			make.height.equalTo(64)
		}
		
		let backgroundView = UIView()
		self.backgroundView = backgroundView
		self.view.addSubview(self.backgroundView)
		self.backgroundView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.navBar.snp_bottom)
			make.left.equalTo(self.view.snp_left)
			make.right.equalTo(self.view.snp_right)
			make.bottom.equalTo(self.view.snp_bottom)
		}
		
		let scrollView = UIScrollView()
		self.scrollView = scrollView
		self.backgroundView.addSubview(self.scrollView)
		self.scrollView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self.backgroundView.snp_edges)
		}
		
		let contentView = UIView()
		self.contentView = contentView
		self.scrollView.addSubview(self.contentView)
		self.contentView.backgroundColor = whiteBackground
		self.contentView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.scrollView.snp_top)
			make.left.equalTo(self.scrollView.snp_left)
			make.right.equalTo(self.scrollView.snp_right)
			make.height.greaterThanOrEqualTo(self.backgroundView.snp_height)
			make.width.equalTo(self.backgroundView.snp_width)
		}
		
		///GENERAL
		let generalContainer = DefaultContainerView()
		self.generalContainer = generalContainer
		self.contentView.addSubview(self.generalContainer)
		self.generalContainer.containerTitle = "General"
		self.generalContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.contentView.snp_top).offset(self.kPadding)
			make.left.equalTo(self.contentView.snp_left)
			make.right.equalTo(self.contentView.snp_right)
		}
		
		//EMAIL
		let emailLabel = UILabel()
		self.emailLabel = emailLabel
		self.generalContainer.contentView.addSubview(self.emailLabel)
		self.emailLabel.text = "Email"
		self.emailLabel.font = UIFont(name: "Lato-Regular", size: kTitle17)
		self.emailLabel.textColor = darkGrayText
		self.emailLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.generalContainer.contentView.snp_top).offset(15)
			make.left.equalTo(self.generalContainer.snp_left).offset(self.kPadding)
		}
		
		let emailTextField = DefaultTextFieldView()
		self.emailTextField = emailTextField
		self.generalContainer.contentView.addSubview(self.emailTextField)
		self.emailTextField.text = "admin@nelper.ca"
		self.emailTextField.font = UIFont(name: "Lato-Regular", size: kText15)
		self.emailTextField.keyboardType = UIKeyboardType.EmailAddress
		self.emailTextField.autocorrectionType = UITextAutocorrectionType.No
		self.emailTextField.autocapitalizationType = UITextAutocapitalizationType.None
		self.emailTextField.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.emailLabel.snp_bottom).offset(10)
			make.left.equalTo(self.emailLabel.snp_left)
			make.right.equalTo(self.generalContainer.snp_right).offset(-self.kPadding)
		}
		
		//PHONE
		let phoneLabel = UILabel()
		self.phoneLabel = phoneLabel
		self.generalContainer.contentView.addSubview(self.phoneLabel)
		self.phoneLabel.text = "Phone"
		self.phoneLabel.font = UIFont(name: "Lato-Regular", size: kTitle17)
		self.phoneLabel.textColor = darkGrayText
		self.phoneLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.emailTextField.snp_bottom).offset(15)
			make.left.equalTo(self.emailLabel.snp_left)
		}
		
		let phoneTextField = DefaultTextFieldView()
		self.phoneTextField = phoneTextField
		self.generalContainer.contentView.addSubview(self.phoneTextField)
		self.phoneTextField.text = "450.453.2345"
		self.phoneTextField.keyboardType = UIKeyboardType.EmailAddress
		self.phoneTextField.autocorrectionType = UITextAutocorrectionType.No
		self.phoneTextField.autocapitalizationType = UITextAutocapitalizationType.None
		self.phoneTextField.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.phoneLabel.snp_bottom).offset(10)
			make.left.equalTo(self.phoneLabel.snp_left)
			make.right.equalTo(self.emailTextField.snp_right)
		}
		
		self.generalContainer.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(self.phoneTextField.snp_bottom).offset(kPadding)
		}
		
		///LOCATIONS
		let locationsContainer = DefaultContainerView()
		self.locationsContainer = locationsContainer
		self.contentView.addSubview(self.locationsContainer)
		self.locationsContainer.containerTitle = "Locations"
		self.locationsContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.generalContainer.snp_bottom).offset(self.kPadding)
			make.left.equalTo(self.contentView.snp_left)
			make.right.equalTo(self.contentView.snp_right)
		}
		
		let addLocationButton = UIButton()
		self.addLocationButton = addLocationButton
		self.locationsContainer.titleView.addSubview(self.addLocationButton)
		self.addLocationButton.setTitle("Add", forState: UIControlState.Normal)
		self.addLocationButton.backgroundColor = redPrimary.colorWithAlphaComponent(0)
		self.addLocationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
		self.addLocationButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
		self.addLocationButton.setTitleColor(redPrimary, forState: UIControlState.Normal)
		self.addLocationButton.setTitleColor(darkGrayDetails, forState: UIControlState.Highlighted)
		self.addLocationButton.titleLabel!.font = UIFont(name: "Lato-Regular", size: kTitle17)
		self.addLocationButton.addTarget(self, action: "addTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		self.addLocationButton.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(self.locationsContainer.titleLabel.snp_centerY)
			make.right.equalTo(self.locationsContainer.snp_right)
			make.height.equalTo(self.locationsContainer.titleView.snp_height)
			make.width.equalTo(80)
		}
		
		if hardcodedArray.isEmpty {
			
			let emptyLocationsLabel = UILabel()
			self.emptyLocationsLabel = emptyLocationsLabel
			self.locationsContainer.contentView.addSubview(self.emptyLocationsLabel)
			self.emptyLocationsLabel.text = "No locations yet"
			self.emptyLocationsLabel.font = UIFont(name: "Lato-Light", size: kText15)
			self.emptyLocationsLabel.textColor = darkGrayDetails
			self.emptyLocationsLabel.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(self.generalContainer.contentView.snp_top).offset(15)
				make.left.equalTo(self.generalContainer.snp_left).offset(self.kPadding)
			}
			
		} else {
			
			let locationNameLabel = UILabel()
			self.locationNameLabel = locationNameLabel
			self.locationsContainer.addSubview(self.locationNameLabel)
			self.locationNameLabel.text = "Name"
			self.locationNameLabel.font = UIFont(name: "Lato-Regular", size: kTitle17)
			self.locationNameLabel.textColor = darkGrayText
			self.locationNameLabel.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(self.locationsContainer.contentView.snp_top).offset(15)
				make.left.equalTo(self.locationsContainer.snp_left).offset(self.kPadding)
			}
			
			let locationAddressLabel = UILabel()
			self.locationAddressLabel = locationAddressLabel
			self.locationsContainer.addSubview(self.locationAddressLabel)
			self.locationAddressLabel.text = "Address"
			self.locationAddressLabel.font = UIFont(name: "Lato-Regular", size: kTitle17)
			self.locationAddressLabel.textColor = darkGrayText
			self.locationAddressLabel.snp_makeConstraints { (make) -> Void in
				make.centerY.equalTo(self.locationNameLabel.snp_centerY)
				make.left.equalTo(self.locationNameLabel.snp_right).offset(45)
			}
			
			self.locationContainerHeight = 0
			
			for i in 0...(hardcodedArray.count - 1) {
				
				let locationContainer = UIButton()
				self.locationContainer = locationContainer
				self.locationsContainer.addSubview(self.locationContainer)
				self.locationContainer.backgroundColor = whitePrimary
				self.locationContainer.setBackgroundColor(grayDetails, forState: UIControlState.Highlighted)
				self.locationContainer.addTarget(self, action: "locationContainerTapped:", forControlEvents: UIControlEvents.TouchUpInside)
				self.locationContainer.snp_makeConstraints { (make) -> Void in
					make.top.equalTo(self.locationNameLabel.snp_bottom).offset(20 + (i * (Int(locationContainerHeight) + 20)))
					make.left.equalTo(self.locationsContainer.snp_left)
					make.right.equalTo(self.locationsContainer.snp_right)
				}
				
				let locationName = UILabel()
				self.locationName = locationName
				self.locationContainer.addSubview(self.locationName)
				self.locationName.text = hardcodedArray[i].name
				self.locationName.font = UIFont(name: "Lato-Regular", size: kText15)
				self.locationName.textColor = darkGrayDetails
				self.locationName.snp_makeConstraints { (make) -> Void in
					make.top.equalTo(self.locationContainer.snp_top)
					make.left.equalTo(self.locationNameLabel.snp_left)
				}
				
				let locationAddress = UILabel()
				self.locationAddress = locationAddress
				self.locationContainer.addSubview(self.locationAddress)
				self.locationAddress.text = hardcodedArray[i].address
				self.locationAddress.numberOfLines = 0
				self.locationAddress.font = UIFont(name: "Lato-Regular", size: kText15)
				self.locationAddress.textColor = darkGrayDetails
				self.locationAddress.snp_makeConstraints { (make) -> Void in
					make.top.equalTo(self.locationContainer.snp_top)
					make.left.equalTo(self.locationAddressLabel.snp_left)
					make.right.equalTo(self.locationContainer.snp_right)
				}
				
				self.locationName.snp_makeConstraints { (make) -> Void in
					make.right.equalTo(self.locationAddress.snp_left)
				}
				
				self.locationContainer.layoutIfNeeded()
				
				if self.locationContainerHeight == 0 {
					self.locationContainerHeight = self.locationAddress.frame.maxY
				}
					
				self.locationContainer.snp_updateConstraints { (make) -> Void in
					make.height.equalTo(self.locationContainerHeight)
				}
				
				self.locationContainerArray.append(self.locationContainer)
			}
		}
		
		self.locationsContainer.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(self.locationContainerArray[hardcodedArray.count - 1].snp_bottom).offset(20)
		}
	}
	
	func adjustUI() {
		
		//NAVBAR
		let previousBtn = UIButton()
		previousBtn.addTarget(self, action: "backButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		self.navBar.closeButton = previousBtn
	}
	
	//MARK: ACTIONS
	func backButtonTapped(sender: UIButton) {
		self.dismissViewControllerAnimated(true, completion: nil)
		view.endEditing(true) // dissmiss keyboard without delay
	}
	
	func locationContainerTapped(sender: UIButton) {
	
	}
	
	func addTapped(sender: UIButton) {
		
	}
}