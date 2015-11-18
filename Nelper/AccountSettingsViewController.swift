//
//  AccountSettingsViewController.swift
//  Nelper
//
//  Created by Pierre-Luc Benoit on 2015-10-14.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation
import UIKit
import FXBlurView
import SnapKit

class AccountSettingsViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate, AddAddressViewControllerDelegate {
	
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
	var locationContainer: AccountSettingsLocationButton!
	var locationContainerLine: UIView!
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
	
	var saveConfirmationBackground: UIView!
	var saveConfirmationBlurView: FXBlurView!
	var saveConfirmationContainer: UIView!
	var saveConfirmationLabel: UILabel!
	
	var textFieldError = false
	var textFieldErrorMessages = [String]()
	
	var loginProvider: String!
	
	var userPrivateData: UserPrivateData!
	
	var deleteLocationViewIsOpened = false
	var locationBlurView: FXBlurView!
	var locations: [Location]?
	var locationsModified = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.userPrivateData = ApiHelper.getUserPrivateData()
		setLocations()
		
		//GET LOGIN PROVIDER
		self.loginProvider = PFUser.currentUser()?.objectForKey("loginProvider") as? String
		
		//GET LOCATIONS
		self.locations = self.userPrivateData.locations
		
		//GET USER INFO
		self.userEmail = self.userPrivateData.email
		self.userPhone = self.userPrivateData.phone
		
		//CALL
		createView()
		setTextFields()
		
		//KEYBOARD
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
		self.tap = tap
		self.view.addGestureRecognizer(tap)
		self.emailTextField.delegate = self
		self.phoneTextField.delegate = self
		self.currentTextField?.delegate = self
		self.newTextField?.delegate = self
		self.confirmTextField?.delegate = self
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
	
	//MARK: SET LOCATIONS
	
	func setLocations() {
		self.locations = self.userPrivateData.locations
	}
	
	//MARK: UI
	
	func setTextFields() {
		self.emailTextField.text = self.userEmail
		self.phoneTextField.text = self.userPhone
		
		self.currentTextField?.text = ""
		self.newTextField?.text = ""
		self.confirmTextField?.text = ""
	}
	
	func createView() {
		
		//NAVBAR
		let navBar = NavBar()
		self.navBar = navBar
		self.view.addSubview(self.navBar)
		self.navBar.setTitle("Account Settings")
		let previousBtn = UIButton()
		previousBtn.addTarget(self, action: "backButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		self.navBar.backButton = previousBtn
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
		self.backgroundView.backgroundColor = Color.whiteBackground
		self.backgroundView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.navBar.snp_bottom)
			make.left.equalTo(self.view.snp_left)
			make.right.equalTo(self.view.snp_right)
			make.bottom.equalTo(self.view.snp_bottom).offset(1)
		}
		
		let scrollView = UIScrollView()
		self.scrollView = scrollView
		self.scrollView.alwaysBounceVertical = true
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
		
		//GENERAL
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
		self.emailLabel.textColor = Color.darkGrayText
		self.emailLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.generalContainer.contentView.snp_top).offset(15)
			make.left.equalTo(self.generalContainer.snp_left).offset(self.kPadding)
		}
		
		let emailTextField = DefaultTextFieldView()
		self.emailTextField = emailTextField
		self.generalContainer.contentView.addSubview(self.emailTextField)
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
		self.phoneLabel.textColor = Color.darkGrayText
		self.phoneLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.emailTextField.snp_bottom).offset(15)
			make.left.equalTo(self.emailLabel.snp_left)
		}
		
		let phoneTextField = DefaultTextFieldView()
		self.phoneTextField = phoneTextField
		self.generalContainer.contentView.addSubview(self.phoneTextField)
		self.phoneTextField.attributedPlaceholder = NSAttributedString(string: "None", attributes: [NSForegroundColorAttributeName: Color.textFieldPlaceholderColor])
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
		
		//LOCATIONS
		
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
		self.addLocationButton.backgroundColor = Color.redPrimary.colorWithAlphaComponent(0)
		self.addLocationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
		self.addLocationButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
		self.addLocationButton.setTitleColor(Color.redPrimary, forState: UIControlState.Normal)
		self.addLocationButton.setTitleColor(Color.darkGrayDetails, forState: UIControlState.Highlighted)
		self.addLocationButton.titleLabel!.font = UIFont(name: "Lato-Regular", size: kTitle17)
		self.addLocationButton.addTarget(self, action: "addTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		self.addLocationButton.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(self.locationsContainer.titleLabel.snp_centerY)
			make.right.equalTo(self.locationsContainer.snp_right)
			make.height.equalTo(self.locationsContainer.titleView.snp_height)
			make.width.equalTo(80)
		}
		
		setLocationView(false)
		
		//PASSWORD
		
		if (self.loginProvider == "email") {
			
			self.willShowPassword = true
			
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
			self.currentLabel.textColor = Color.darkGrayText
			self.currentLabel.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(self.passwordContainer.contentView.snp_top).offset(15)
				make.left.equalTo(self.passwordContainer.snp_left).offset(self.kPadding)
			}
			
			let currentTextField = DefaultTextFieldView()
			self.currentTextField = currentTextField
			self.passwordContainer.contentView.addSubview(self.currentTextField)
			
			self.currentTextField.attributedPlaceholder = NSAttributedString(string: "**********", attributes: [NSForegroundColorAttributeName: Color.darkGrayDetails])
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
			self.newLabel.textColor = Color.darkGrayText
			self.newLabel.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(self.currentTextField.snp_bottom).offset(15)
				make.left.equalTo(self.passwordContainer.snp_left).offset(self.kPadding)
			}
			
			let newTextField = DefaultTextFieldView()
			self.newTextField = newTextField
			self.passwordContainer.contentView.addSubview(self.newTextField)
			self.newTextField.font = UIFont(name: "Lato-Regular", size: kText15)
			self.newTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
			self.newTextField.textColor = Color.darkGrayDetails
			self.newTextField.backgroundColor = Color.whitePrimary
			self.newTextField.layer.borderWidth = 0.5
			self.newTextField.layer.borderColor = Color.grayDetails.CGColor
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
			self.confirmLabel.textColor = Color.darkGrayText
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
		
		//DELETE
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
		self.deletionNoticeLabel.textColor = Color.redPrimary
		self.deletionNoticeLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.deleteContainer.contentView.snp_top).offset(15)
			make.left.equalTo(self.deleteContainer.snp_left).offset(self.kPadding)
		}
		
		let deleteButton = SecondaryActionButton()
		self.deleteButton = deleteButton
		self.deleteContainer.addSubview(deleteButton)
		self.deleteButton.backgroundColor = Color.whitePrimary
		self.deleteButton.setTitle("Delete my account", forState: UIControlState.Normal)
		self.deleteButton.setTitleColor(Color.darkGrayText, forState: UIControlState.Normal)
		self.deleteButton.addTarget(self, action: "deleteAccountButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		self.deleteButton.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.deletionNoticeLabel.snp_bottom).offset(15)
			make.left.equalTo(self.deleteContainer.snp_left).offset(self.kPadding)
		}
		
		self.deleteContainer.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(self.deleteButton.snp_bottom).offset(20)
		}
		
		self.contentView.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(self.deleteContainer.snp_bottom).offset(self.kPadding)
		}
	}
	
	/**
	creates/update the view for locations list
	
	- parameter isUpdate: false only if we are creating the view for the first time
	*/
	func setLocationView(isUpdate: Bool) {
		
		if isUpdate {
			for subview in self.locationsContainer.contentView.subviews {
				subview.removeFromSuperview()
			}
			
			//for locationCont in self.locationContainerArray {
			//	locationCont.removeFromSuperview()
			//}
			
			self.locationContainerArray.removeAll()
		}
		
		if self.locations!.isEmpty {
			
			let emptyLocationsLabel = UILabel()
			self.emptyLocationsLabel = emptyLocationsLabel
			self.locationsContainer.contentView.addSubview(self.emptyLocationsLabel)
			self.emptyLocationsLabel.text = "No locations yet"
			self.emptyLocationsLabel.font = UIFont(name: "Lato-Light", size: kText15)
			self.emptyLocationsLabel.textColor = Color.darkGrayDetails
			self.emptyLocationsLabel.sizeToFit()
			self.emptyLocationsLabel.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(self.locationsContainer.contentView.snp_top).offset(15)
				make.left.equalTo(self.generalContainer.snp_left).offset(self.kPadding)
			}
			
			self.locationsContainer.snp_remakeConstraints { (make) -> Void in
				make.top.equalTo(self.generalContainer.snp_bottom).offset(self.kPadding)
				make.left.equalTo(self.contentView.snp_left)
				make.right.equalTo(self.contentView.snp_right)
				make.bottom.equalTo(self.emptyLocationsLabel.snp_bottom).offset(20)
			}
			
			self.contentView.layoutIfNeeded()
			
		} else {
			
			let locationNameLabel = UILabel()
			self.locationNameLabel = locationNameLabel
			self.locationsContainer.contentView.addSubview(self.locationNameLabel)
			self.locationNameLabel.text = "Name"
			self.locationNameLabel.font = UIFont(name: "Lato-Regular", size: kTitle17)
			self.locationNameLabel.textColor = Color.darkGrayText
			self.locationNameLabel.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(self.locationsContainer.contentView.snp_top).offset(15)
				make.left.equalTo(self.locationsContainer.snp_left).offset(self.kPadding)
			}
			
			let locationAddressLabel = UILabel()
			self.locationAddressLabel = locationAddressLabel
			self.locationsContainer.contentView.addSubview(self.locationAddressLabel)
			self.locationAddressLabel.text = "Address"
			self.locationAddressLabel.font = UIFont(name: "Lato-Regular", size: kTitle17)
			self.locationAddressLabel.textColor = Color.darkGrayText
			self.locationAddressLabel.snp_makeConstraints { (make) -> Void in
				make.centerY.equalTo(self.locationNameLabel.snp_centerY)
				make.left.equalTo(self.locationNameLabel.snp_right).offset(50)
			}
			
			self.locationContainerHeight = 0
			
			for i in 0...(self.locations!.count - 1) {
				
				let locationContainer = AccountSettingsLocationButton()
				self.locationContainer = locationContainer
				self.locationsContainer.contentView.addSubview(self.locationContainer)
				self.locationContainer.backgroundColor = Color.whitePrimary
				self.locationContainer.assignedLocationIndex = i
				self.locationContainer.setBackgroundColor(Color.grayDetails, forState: UIControlState.Highlighted)
				self.locationContainer.addTarget(self, action: "locationContainerTapped:", forControlEvents: UIControlEvents.TouchUpInside)
				
				self.locationContainer.snp_makeConstraints { (make) -> Void in
					make.top.equalTo(self.locationNameLabel.snp_bottom).offset(20 + (i * (Int(locationContainerHeight) + 20)))
					make.left.equalTo(self.locationsContainer.snp_left)
					make.right.equalTo(self.locationsContainer.snp_right)
				}
				
				let locationName = UILabel()
				self.locationName = locationName
				self.locationContainer.addSubview(self.locationName)
				self.locationName.text = self.locations![i].name
				self.locationName.font = UIFont(name: "Lato-Light", size: kText15)
				self.locationName.textColor = Color.darkGrayText
				self.locationName.snp_makeConstraints { (make) -> Void in
					make.top.equalTo(self.locationContainer.snp_top)
					make.left.equalTo(self.locationNameLabel.snp_left)
				}
				
				let locationAddress = UILabel()
				self.locationAddress = locationAddress
				self.locationContainer.addSubview(self.locationAddress)
				self.locationAddress.text = self.locations![i].formattedTextLabel
				self.locationAddress.numberOfLines = 0
				self.locationAddress.font = UIFont(name: "Lato-Light", size: kText15)
				self.locationAddress.textColor = Color.darkGrayText
				self.locationAddress.snp_makeConstraints { (make) -> Void in
					make.top.equalTo(self.locationContainer.snp_top)
					make.left.equalTo(self.locationAddressLabel.snp_left)
					make.right.equalTo(self.locationContainer.snp_right)
				}
				
				/*let locationContainerLine = UIView()
				self.locationContainerLine = locationContainerLine
				self.locationContainer.addSubview(locationContainerLine)
				self.locationContainerLine.backgroundColor = Color.darkGrayDetails.colorWithAlphaComponent(0.5)
				self.locationContainerLine.snp_makeConstraints { (make) -> Void in
					make.top.equalTo(self.locationName.snp_top)
					make.right.equalTo(self.locationName.snp_left).offset(-6)
					make.width.equalTo(0.5)
					make.bottom.equalTo(self.locationAddress.snp_bottom)
				}*/
				
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
			
			self.locationsContainer.snp_remakeConstraints { (make) -> Void in
				make.top.equalTo(self.generalContainer.snp_bottom).offset(self.kPadding)
				make.left.equalTo(self.contentView.snp_left)
				make.right.equalTo(self.contentView.snp_right)
				make.bottom.equalTo(self.locationContainerArray[self.locations!.count - 1].snp_bottom).offset(30)
			}
			
			self.locationsContainer.layoutIfNeeded()
			self.contentView.layoutIfNeeded()
		}
		
		self.scrollView.contentSize = self.contentView.frame.size
	}
	
	func showLocationDelete(button: AccountSettingsLocationButton) {
		
		dismissKeyboard()
		
		if self.deleteLocationViewIsOpened {
			self.locationBlurView.removeFromSuperview()
		}
		
		self.deleteLocationViewIsOpened = true
		
		let locationBlurView = FXBlurView(frame: button.frame)
		self.locationBlurView = locationBlurView
		locationBlurView.tintColor = UIColor.clearColor()
		locationBlurView.alpha = 0
		locationBlurView.updateInterval = 100
		locationBlurView.iterations = 2
		locationBlurView.blurRadius = 4
		locationBlurView.dynamic = false
		locationBlurView.underlyingView = nil
		self.locationsContainer.contentView.addSubview(locationBlurView)
		locationBlurView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(button.snp_top).offset(-8)
			make.left.equalTo(button.snp_left)
			make.right.equalTo(button.snp_right)
			make.bottom.equalTo(button.snp_bottom).offset(8)
		}
		
		let darken = UIView()
		locationBlurView.addSubview(darken)
		darken.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.4)
		darken.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(locationBlurView.snp_edges)
		}
		
		let deleteButton = AccountSettingsLocationButton()
		locationBlurView.addSubview(deleteButton)
		deleteButton.addTarget(self, action: "deleteLocationTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		deleteButton.setTitle("Delete", forState: .Normal)
		deleteButton.layer.borderColor = Color.redPrimary.CGColor
		deleteButton.layer.borderWidth = 1
		deleteButton.setTitleColor(Color.redPrimary, forState: .Normal)
		deleteButton.setTitleColor(Color.darkGrayDetails.colorWithAlphaComponent(0.6), forState: .Highlighted)
		deleteButton.assignedLocationIndex = button.assignedLocationIndex
		deleteButton.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(locationBlurView.snp_centerY)
			make.right.equalTo(locationBlurView.snp_centerX).offset(-30)
			make.height.equalTo(40)
			make.width.equalTo(100)
		}
		
		let cancelButton = UIButton()
		locationBlurView.addSubview(cancelButton)
		cancelButton.addTarget(self, action: "cancelLocationDeletionTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		cancelButton.setTitle("Cancel", forState: .Normal)
		cancelButton.layer.borderColor = Color.darkGrayDetails.CGColor
		cancelButton.layer.borderWidth = 1
		cancelButton.setTitleColor(Color.darkGrayDetails, forState: .Normal)
		cancelButton.setTitleColor(Color.darkGrayDetails.colorWithAlphaComponent(0.6), forState: .Highlighted)
		cancelButton.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(locationBlurView.snp_centerY)
			make.left.equalTo(locationBlurView.snp_centerX).offset(30)
			make.height.equalTo(40)
			make.width.equalTo(100)
		}
		
		UIView.animateWithDuration(0.3, delay: 0.0, options: [.CurveEaseOut], animations:  {
			locationBlurView.alpha = 1
			}, completion: nil)
		
	}
	
	//MARK: KEYBOARD, WITH viewDidDis/Appear AND textfielddelegate
	
	func dismissKeyboard() {
		view.endEditing(true)
		
		if self.deleteLocationViewIsOpened {
			cancelLocationDeletionTapped(nil)
		}
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
		
		if !popupShown {
			let info = notification.userInfo!
			var keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
			keyboardFrame = self.view.convertRect(keyboardFrame, fromView: nil)
			
			self.contentInsets = UIEdgeInsetsMake(0, 0, keyboardFrame.height, 0)
			
			self.scrollView.contentInset = contentInsets
			self.scrollView.scrollIndicatorInsets = contentInsets
			
			var aRect = self.view.frame
			aRect.size.height -= keyboardFrame.height
			
			if self.activeField != nil {
				let frame = CGRectMake(self.activeField.frame.minX, self.activeField.frame.minY, self.activeField.frame.width, self.activeField.frame.height + (self.view.frame.height * 0.2))
				
				if !(CGRectContainsPoint(aRect, self.activeField.frame.origin)) {
					self.scrollView.scrollRectToVisible(frame, animated: true)
				}
			}
		}
	}
	
	func keyboardWillHide(notification: NSNotification) {
		self.contentInsets = UIEdgeInsetsZero
		self.scrollView.contentInset = contentInsets
		self.scrollView.scrollIndicatorInsets = contentInsets
	}

	//ADDADDRESS LOCATION DELEGATE
	
	func didClosePopup(vc: AddAddressViewController) {
		self.popupShown = false
	}
	
	func didAddLocation(vc:AddAddressViewController) {
		self.locationsModified = true
		
		self.locations!.append(vc.address)
		
		setLocationView(true)
	}
	
	//MARK: ACTIONS
	
	func cancelLocationDeletionTapped(sender: UIButton?) {
		self.locationBlurView.removeFromSuperview()
		self.deleteLocationViewIsOpened = false
	}
	
	func deleteLocationTapped(sender: AccountSettingsLocationButton) {
		self.locationsModified = true
		
		let index = sender.assignedLocationIndex
		
		self.locations!.removeAtIndex(index)
		
		setLocationView(true)
	}
	
	func backButtonTapped(sender: UIButton) {
		
		if (self.loginProvider == "email") {
			if (self.emailTextField.text != self.userEmail) || (self.phoneTextField.text != self.userPhone) || (self.currentTextField?.text != "") || (self.newTextField?.text != "") || (self.confirmTextField?.text != "") || self.locationsModified {
			
				self.settingsWereEdited = true
			
			} else {
			
				self.settingsWereEdited = false
			}
		} else {
			
			if (self.emailTextField.text != self.userEmail) || (self.phoneTextField.text != self.userPhone) || self.locationsModified {
				
				self.settingsWereEdited = true
				
			} else {
				
				self.settingsWereEdited = false
			}
		}
		
		if self.settingsWereEdited {
			dismissKeyboard()
			
			let popup = UIAlertController(title: "Discard changes?", message: "Your changes will not be saved", preferredStyle: UIAlertControllerStyle.Alert)
			popup.addAction(UIAlertAction(title: "Confirm", style: .Default, handler: { (action) -> Void in
				//Change the view and resets fields and locations
				self.navigationController?.popViewControllerAnimated(true)
				self.setTextFields()
				self.setLocations()
				self.locationsModified = false
				self.setLocationView(true)
			}))
			popup.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
			}))
			
			self.presentViewController(popup, animated: true, completion: nil)
			popup.view.tintColor = Color.redPrimary
			
		} else {
			
			dismissKeyboard()
			self.navigationController?.popViewControllerAnimated(true)
		}
	}
	
	func saveButtonTapped(sender: UIButton) {
		
		self.textFieldError = false
		self.textFieldErrorMessages.removeAll()
		
		//TODO: LINK PARSE AND PASSWORDS
		if self.newTextField?.text != self.confirmTextField?.text {
			print("passwords dont match")
			self.textFieldError = true
			self.textFieldErrorMessages.append("New passwords don't match")
		}
		
		if !self.emailTextField.text!.isEmail() {
			print("not a valid email address")
			self.textFieldError = true
			self.textFieldErrorMessages.append("Please enter a valid email address")
		}
		
		//TODO: REVIEW FORMAT? Helper -> extension.swift
		if !self.phoneTextField.text!.isPhoneNumber() && self.phoneTextField.text != "" {
			print("not a valid 10 digits phone number")
			self.textFieldError = true
			self.textFieldErrorMessages.append("Please enter a valid 10 digits phone number")
		}
		
		if self.textFieldError {
			//There is an incorrect field
			
			var popupMessage = ""
			
			for i in 0...(self.textFieldErrorMessages.count - 1) {
				if i == 0 {
					popupMessage = self.textFieldErrorMessages[i]
				} else {
					popupMessage += "\n\(self.textFieldErrorMessages[i])"
				}
			}
			
			dismissKeyboard()
			
			let popup = UIAlertController(title: "Incorrect fields", message: popupMessage, preferredStyle: UIAlertControllerStyle.Alert)
			popup.addAction(UIAlertAction(title: "Confirm", style: .Default, handler: { (action) -> Void in
			}))
			self.presentViewController(popup, animated: true, completion: nil)
			
		} else {
			//Textfields are correct: save settings
			
			dismissKeyboard()
			
			let saveConfirmationBlurView = FXBlurView(frame: self.view.bounds)
			self.saveConfirmationBlurView = saveConfirmationBlurView
			self.saveConfirmationBlurView.alpha = 0
			self.saveConfirmationBlurView.tintColor = UIColor.clearColor()
			self.saveConfirmationBlurView.updateInterval = 100
			self.saveConfirmationBlurView.iterations = 2
			self.saveConfirmationBlurView.blurRadius = 4
			self.saveConfirmationBlurView.dynamic = false
			self.saveConfirmationBlurView.underlyingView = self.view
			self.view.addSubview(self.saveConfirmationBlurView)
			
			let saveConfirmationBackground = UIView()
			self.saveConfirmationBackground = saveConfirmationBackground
			self.saveConfirmationBlurView.addSubview(self.saveConfirmationBackground)
			self.saveConfirmationBackground.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
			self.saveConfirmationBackground.snp_makeConstraints { (make) -> Void in
				make.edges.equalTo(self.saveConfirmationBlurView.snp_edges)
			}
			
			let saveConfirmationContainer = UIView()
			self.saveConfirmationContainer = saveConfirmationContainer
			self.saveConfirmationBlurView.addSubview(self.saveConfirmationContainer)
			self.saveConfirmationContainer.backgroundColor = Color.whitePrimary
			self.saveConfirmationContainer.snp_makeConstraints { (make) -> Void in
				make.centerX.equalTo(self.view.snp_centerX)
				make.centerY.equalTo(self.view.snp_centerY)
				make.width.equalTo(self.view.snp_width).multipliedBy(0.7)
				make.height.equalTo(0)
			}
			
			let saveConfirmationLabel = UILabel()
			self.saveConfirmationLabel = saveConfirmationLabel
			self.saveConfirmationContainer.addSubview(saveConfirmationLabel)
			self.saveConfirmationLabel.text = "Settings saved!"
			self.saveConfirmationLabel.alpha = 0
			self.saveConfirmationLabel.font = UIFont(name: "Lato-Regular", size: kTitle17)
			self.saveConfirmationLabel.textColor = Color.darkGrayText
			self.saveConfirmationLabel.snp_makeConstraints { (make) -> Void in
				make.centerX.equalTo(self.saveConfirmationContainer.snp_centerX)
				make.centerY.equalTo(self.saveConfirmationContainer.snp_centerY)
			}
			
			self.saveConfirmationContainer.layoutIfNeeded()
			
			self.saveConfirmationContainer.snp_updateConstraints { (make) -> Void in
				make.height.equalTo(100)
			}
			
			UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations:  {
				self.saveConfirmationBlurView.alpha = 1
				self.saveConfirmationContainer.layoutIfNeeded()
				}, completion: nil)
			
			UIView.animateWithDuration(0.4, delay: 0.2, options: UIViewAnimationOptions.CurveEaseOut, animations:  {
				self.saveConfirmationLabel.alpha = 1
				}, completion: nil)
			
			self.saveConfirmationContainer.snp_updateConstraints { (make) -> Void in
				make.height.equalTo(0)
			}
			
			UIView.animateWithDuration(0.2, delay: 2.5, options: UIViewAnimationOptions.CurveEaseOut, animations:  {
				self.saveConfirmationLabel.alpha = 0
				}, completion: nil)
			
			UIView.animateWithDuration(0.2, delay: 2.7, options: UIViewAnimationOptions.CurveEaseOut, animations:  {
				self.saveConfirmationBlurView.alpha = 0
				self.saveConfirmationContainer.layoutIfNeeded()
				}, completion: nil)
			
			_ = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "dismissVC", userInfo: nil, repeats: false)
			
			self.locationsModified = false
			self.userEmail = self.emailTextField.text
			self.userPhone = phoneTextField.text
			
			//Update Parse
			ApiHelper.updateUserAccountSettings(self.emailTextField.text!, phone: self.phoneTextField.text)
			ApiHelper.updateUserLocations(self.locations!)
	 }
	}
	
	override func viewWillDisappear(animated: Bool) {
		
		self.saveConfirmationBlurView?.removeFromSuperview()
	}
	
	func dismissVC() {
		self.navigationController?.popViewControllerAnimated(true)
	}
	
	func locationContainerTapped(sender: AccountSettingsLocationButton) {
		
		if self.fieldEditing {
			
			dismissKeyboard()
			
		} else {
			
			self.popupShown = true
			
			showLocationDelete(sender)
		}
	}
	
	func addTapped(sender: UIButton) {
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
	
	func deleteAccountButtonTapped(sender: UIButton) {
		if self.fieldEditing {
			
			dismissKeyboard()
			
		} else {
			
			self.popupShown = true
		}
	}
}