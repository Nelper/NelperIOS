//
//  AccountSettingsViewController.swift
//  Nelper
//
//  Created by Pierre-Luc Benoit on 2015-10-14.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation
import UIKit

class AccountSettingsViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
	
	var navBar: NavBar!
	var saveButton: UIButton!
	
	var backgroundView: UIView!
	var scrollView: UIScrollView!
	var contentView: UIView!
	
	var generalContainer: DefaultContainerView!
	var emailLabel: UILabel!
	var emailTextField: DefaultTextFieldView!
	var userEmail: String!
	var phoneLabel: UILabel!
	var phoneTextField: DefaultTextFieldView!
	var userPhone: String?
	
	var locationsContainer: DefaultContainerView!
	var addLocationButton: UIButton!
	var emptyLocationsLabel: UILabel!
	//var locations: Array<Dictionary<String,AnyObject>>!
	var hardcodedArray = [
		(name: "Home", address: "175 Rue Forbin-Janson\nMont-Saint-Hilaire, QC\nJ3H 4E4"),
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
	
	var willShowPassword = false
	var passwordContainer: DefaultContainerView!
	var currentLabel: UILabel!
	var currentTextField: DefaultTextFieldView!
	var newLabel: UILabel!
	var newTextField: DefaultTextFieldView!
	var confirmLabel: UILabel!
	var confirmTextField: DefaultTextFieldView!
	
	var deleteContainer: DefaultContainerView!
	var deletionNoticeLabel: UILabel!
	var deleteButton: SecondaryActionButton!
	
	var tap: UITapGestureRecognizer?
	var keyboardFrame: CGRect!
	var contentInsets: UIEdgeInsets!
	var activeField: UIView!
	var fieldEditing = false
	var popupShown = false
	
	var settingsWereEdited = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setLocations()
		
		createView()
		setTextFields()
		
		//KEYBOARD
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
		self.tap = tap
		self.view.addGestureRecognizer(tap)
		keyboardObserver()
		self.currentTextField.delegate = self
		self.newTextField.delegate = self
		self.confirmTextField.delegate = self
		self.emailTextField.delegate = self
		self.phoneTextField.delegate = self
	}
	
	///MARK: UI
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		self.scrollView.contentSize = self.contentView.frame.size
	}
	
	func setTextFields() {
		self.userEmail = "admin@nelper.ca"
		self.userPhone = "514-283-2746"
		self.currentTextField.text = ""
		self.newTextField.text = ""
		self.confirmTextField.text = ""
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
		let previousBtn = UIButton()
		previousBtn.addTarget(self, action: "backButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		self.navBar.closeButton = previousBtn
		let saveBtn = UIButton()
		saveBtn.addTarget(self, action: "saveButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		self.navBar.saveButton = saveBtn
		self.navBar.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.view.snp_top)
			make.right.equalTo(self.view.snp_right)
			make.left.equalTo(self.view.snp_left)
			make.height.equalTo(64)
		}
		
		let backgroundView = UIView()
		self.backgroundView = backgroundView
		self.view.addSubview(self.backgroundView)
		self.backgroundView.backgroundColor = whiteBackground
		self.backgroundView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.navBar.snp_bottom)
			make.left.equalTo(self.view.snp_left)
			make.right.equalTo(self.view.snp_right)
			make.bottom.equalTo(self.view.snp_bottom).offset(1)
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
		self.contentView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.scrollView.snp_top)
			make.left.equalTo(self.scrollView.snp_left)
			make.right.equalTo(self.scrollView.snp_right)
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
		self.emailTextField.text = userEmail
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
		self.phoneTextField.text = userPhone
		self.phoneTextField.keyboardType = UIKeyboardType.NamePhonePad
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
		
		let userAuthData: String? = PFUser.currentUser()?.objectForKey("authData") as? String
		print(userAuthData)
		
		if (userAuthData == nil) {
			
			self.willShowPassword = true
			
			///PASSWORD
			let passwordContainer = DefaultContainerView()
			self.passwordContainer = passwordContainer
			self.contentView.addSubview(self.passwordContainer)
			self.passwordContainer.containerTitle = "Password"
			self.passwordContainer.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(self.locationsContainer.snp_bottom).offset(self.kPadding)
				make.left.equalTo(self.contentView.snp_left)
				make.right.equalTo(self.contentView.snp_right)
			}
			
			//CURRENT
			let currentLabel = UILabel()
			self.currentLabel = currentLabel
			self.passwordContainer.contentView.addSubview(self.currentLabel)
			self.currentLabel.text = "Current password"
			self.currentLabel.font = UIFont(name: "Lato-Regular", size: kTitle17)
			self.currentLabel.textColor = darkGrayText
			self.currentLabel.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(self.passwordContainer.contentView.snp_top).offset(15)
				make.left.equalTo(self.passwordContainer.snp_left).offset(self.kPadding)
			}
			
			let currentTextField = DefaultTextFieldView()
			self.currentTextField = currentTextField
			self.passwordContainer.contentView.addSubview(self.currentTextField)
			
			self.currentTextField.attributedPlaceholder = NSAttributedString(string: "**********", attributes: [NSForegroundColorAttributeName: darkGrayDetails])
			self.currentTextField.font = UIFont(name: "Lato-Regular", size: kText15)
			self.currentTextField.keyboardType = UIKeyboardType.Default
			self.currentTextField.autocorrectionType = UITextAutocorrectionType.No
			self.currentTextField.autocapitalizationType = UITextAutocapitalizationType.None
			self.currentTextField.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(self.currentLabel.snp_bottom).offset(10)
				make.left.equalTo(self.currentLabel.snp_left)
				make.right.equalTo(self.passwordContainer.snp_right).offset(-self.kPadding)
			}
			
			//NEW
			let newLabel = UILabel()
			self.newLabel = newLabel
			self.passwordContainer.contentView.addSubview(self.newLabel)
			self.newLabel.text = "New password"
			self.newLabel.font = UIFont(name: "Lato-Regular", size: kTitle17)
			self.newLabel.textColor = darkGrayText
			self.newLabel.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(self.currentTextField.snp_bottom).offset(15)
				make.left.equalTo(self.passwordContainer.snp_left).offset(self.kPadding)
			}
			
			let newTextField = DefaultTextFieldView()
			self.newTextField = newTextField
			self.passwordContainer.contentView.addSubview(self.newTextField)
			self.newTextField.font = UIFont(name: "Lato-Regular", size: kText15)
			self.newTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
			self.newTextField.textColor = darkGrayDetails
			self.newTextField.backgroundColor = whitePrimary
			self.newTextField.layer.borderWidth = 0.5
			self.newTextField.layer.borderColor = grayDetails.CGColor
			self.newTextField.keyboardType = UIKeyboardType.Default
			self.newTextField.autocorrectionType = UITextAutocorrectionType.No
			self.newTextField.autocapitalizationType = UITextAutocapitalizationType.None
			self.newTextField.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(self.newLabel.snp_bottom).offset(10)
				make.left.equalTo(self.newLabel.snp_left)
				make.right.equalTo(self.passwordContainer.snp_right).offset(-self.kPadding)
			}
			
			//CONFIRM
			let confirmLabel = UILabel()
			self.confirmLabel = confirmLabel
			self.passwordContainer.contentView.addSubview(self.confirmLabel)
			self.confirmLabel.text = "Confirm new password"
			self.confirmLabel.font = UIFont(name: "Lato-Regular", size: kTitle17)
			self.confirmLabel.textColor = darkGrayText
			self.confirmLabel.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(self.newTextField.snp_bottom).offset(15)
				make.left.equalTo(self.passwordContainer.snp_left).offset(self.kPadding)
			}
			
			let confirmTextField = DefaultTextFieldView()
			self.confirmTextField = confirmTextField
			self.passwordContainer.contentView.addSubview(self.confirmTextField)
			self.confirmTextField.font = UIFont(name: "Lato-Regular", size: kText15)
			self.confirmTextField.keyboardType = UIKeyboardType.Default
			self.confirmTextField.autocorrectionType = UITextAutocorrectionType.No
			self.confirmTextField.autocapitalizationType = UITextAutocapitalizationType.None
			self.confirmTextField.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(self.confirmLabel.snp_bottom).offset(10)
				make.left.equalTo(self.newTextField.snp_left)
				make.right.equalTo(self.passwordContainer.snp_right).offset(-self.kPadding)
			}
			
			self.passwordContainer.snp_makeConstraints { (make) -> Void in
				make.bottom.equalTo(confirmTextField.snp_bottom).offset(20)
			}
		}
		
		///PASSWORD
		let deleteContainer = DefaultContainerView()
		self.deleteContainer = deleteContainer
		self.contentView.addSubview(self.deleteContainer)
		self.deleteContainer.containerTitle = "Delete Account"
		
		if self.willShowPassword {
			
			self.deleteContainer.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(self.passwordContainer.snp_bottom).offset(self.kPadding)
				make.left.equalTo(self.contentView.snp_left)
				make.right.equalTo(self.contentView.snp_right)
			}
			
		} else {
			
			self.deleteContainer.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(self.locationsContainer.snp_bottom).offset(self.kPadding)
				make.left.equalTo(self.contentView.snp_left)
				make.right.equalTo(self.contentView.snp_right)
			}
		}
		
		let deletionNoticeLabel = UILabel()
		self.deletionNoticeLabel = deletionNoticeLabel
		self.deleteContainer.contentView.addSubview(self.deletionNoticeLabel)
		self.deletionNoticeLabel.text = "Account deletion is permanent"
		self.deletionNoticeLabel.font = UIFont(name: "Lato-Light", size: kText15)
		self.deletionNoticeLabel.textColor = darkGrayText
		self.deletionNoticeLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.deleteContainer.contentView.snp_top).offset(15)
			make.left.equalTo(self.deleteContainer.snp_left).offset(self.kPadding)
		}
		
		let deleteButton = SecondaryActionButton()
		self.deleteButton = deleteButton
		self.deleteContainer.addSubview(deleteButton)
		self.deleteButton.backgroundColor = whitePrimary
		self.deleteButton.setTitle("Delete my account", forState: UIControlState.Normal)
		self.deleteButton.addTarget(self, action: "deleteButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		self.deleteButton.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.deletionNoticeLabel.snp_bottom).offset(15)
			make.left.equalTo(self.deleteContainer.snp_left).offset(self.kPadding)
		}
		
		self.deleteContainer.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(self.deleteButton.snp_bottom).offset(20)
		}
		
		self.contentView.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(self.deleteContainer.snp_bottom).offset(20)
		}
	}
	
	///MARK: KEYBOARD
	
	func DismissKeyboard() {
		view.endEditing(true)
	}
	
	func keyboardObserver() {
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardDidShow:"), name: UIKeyboardWillShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
	}
	
	override func viewDidDisappear(animated: Bool) {
		
		NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
	}
	
	func textFieldDidBeginEditing(textField: UITextField) {
		self.activeField = textField
		self.fieldEditing = true
	}
	
	func textFieldDidEndEditing(textField: UITextField) {
		self.activeField = nil
		self.fieldEditing = false
	}
	
	func keyboardDidShow(notification: NSNotification) {
		
		if !self.popupShown {
			let info = notification.userInfo!
			let value = info[UIKeyboardFrameEndUserInfoKey]!
			self.keyboardFrame = value.CGRectValue
			
			self.contentInsets = UIEdgeInsetsMake(0, 0, keyboardFrame.height, 0)
			
			self.scrollView.contentInset = contentInsets
			self.scrollView.scrollIndicatorInsets = contentInsets
			
			var aRect = self.view.frame
			aRect.size.height -= self.keyboardFrame.height
			
			if !(CGRectContainsPoint(aRect, self.activeField.frame.origin)) {
				self.scrollView.scrollRectToVisible(self.activeField.frame, animated: true)
			}
		}
	}
	
	func keyboardWillHide(notification: NSNotification) {
		self.contentInsets = UIEdgeInsetsZero
		self.scrollView.contentInset = contentInsets
		self.scrollView.scrollIndicatorInsets = contentInsets
	}

	///MARK: ACTIONS
	
	func backButtonTapped(sender: UIButton) {
		
		if (self.emailTextField.text != self.userEmail) || (self.phoneTextField.text != userPhone) || (self.currentTextField.text != "") || (self.newTextField.text != "") || (self.confirmTextField.text != "") {
			
			self.settingsWereEdited = true
		} else {
			self.settingsWereEdited = false
		}
		
		if self.settingsWereEdited {
			DismissKeyboard() // dismiss keyboard without delay
			
			let popup = UIAlertController(title: "Discard changes?", message: "Your changes will not be saved", preferredStyle: UIAlertControllerStyle.Alert)
			let popupSubview = popup.view.subviews.first! as UIView
			let popupContentView = popupSubview.subviews.first! as UIView
			popupContentView.layer.cornerRadius = 0
			
			popup.view.subviews.first!
			popup.addAction(UIAlertAction(title: "Confirm", style: .Default, handler: { (action) -> Void in
				self.dismissViewControllerAnimated(true, completion: nil)
			}))
			popup.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) -> Void in
			}))
			
			self.presentViewController(popup, animated: true, completion: nil)
			
		} else {
			
			DismissKeyboard() // dismiss keyboard without delay
			setTextFields()
			self.dismissViewControllerAnimated(true, completion: nil)
		}
	}
	
	func saveButtonTapped(sender: UIButton) {
		print("saved")
	}
	
	func locationContainerTapped(sender: UIButton) {
		
		if self.fieldEditing {
			
			DismissKeyboard()
			
		} else {
			
			//self.popupShown = true
		}
	}
	
	func addTapped(sender: UIButton) {
		if self.fieldEditing {
			
			DismissKeyboard()
			
		} else {
			
			//self.popupShown = true
		}
	}
	
	func deleteButtonTapped(sender: UIButton) {
		if self.fieldEditing {
			
			DismissKeyboard()
			
		} else {
			
			//self.popupShown = true
		}
	}
}