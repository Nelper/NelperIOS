//
//  LoginViewController.swift
//  Nelper
//
//  Created by Janic Duplessis on 2015-06-21.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol LoginViewControllerDelegate {
	func onLogin() -> Void
}

class LoginViewController: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate {
	
	let permissions = ["public_profile"]
	var delegate: LoginViewControllerDelegate?
	var tap: UITapGestureRecognizer?
	
	var backgroundView: UIView!
	var scrollView: UIScrollView!
	var contentView: UIView!
	var logo: UIImageView!
	
	var firstContainer: UIView!
	var fbButton: UIButton!
	var fbLogo: UIImageView!
	var fbLine: UIView!
	var twitterButton: UIButton!
	var twitterLogo: UIImageView!
	var twitterLine: UIView!
	var emailButton: UIButton!
	
	var secondContainer: UIView!
	var emailField: UITextField!
	var textfieldUnderline: UIView!
	var passwordField: UITextField!
	var loginButton: UIButton!
	var arrowSecond: UIButton!
	var registerButton: UIButton!
	var forgotPassButton: UIButton!
	
	var thirdContainer: UIView!
	var firstnameField: UITextField!
	var firstnameUnderlineRegister: UIView!
	var lastnameField: UITextField!
	var emailFieldRegister: UITextField!
	var passwordFieldRegister: UITextField!
	var passwordfieldUnderlineRegister: UIView!
	var passwordFieldConfirmRegister: UITextField!
	var registerAccountButton: UIButton!
	var arrowThird: UIButton!
	
	var emailActive = false
	var registerActive = false
	
	var contentInsets: UIEdgeInsets!
	var activeField: UITextField!
	var fieldEditing = false
	
	//MARK: Initialization
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = Color.redPrimary
		
		self.createView()
		self.adjustUI()
		
		// KEYBOARD DISMISS
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
		self.tap = tap
		self.view.addGestureRecognizer(tap)
		
		// KEYBOARD VIEW MOVER
		self.emailField.delegate = self
		self.passwordField.delegate = self
		self.firstnameField.delegate = self
		self.lastnameField.delegate = self
		self.emailFieldRegister.delegate = self
		self.passwordFieldRegister.delegate = self
		self.passwordFieldConfirmRegister.delegate = self
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(true)
		
		Helper.statusBarHidden(false, animation: .Slide)
		
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
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// KEYBOARD DISMISS
	func dismissKeyboard() {
		view.endEditing(true)
	}
	
	//MARK: UI
	
	func createView() {
		
		let backgroundView = UIView()
		self.backgroundView = backgroundView
		self.view.addSubview(self.backgroundView)
		self.backgroundView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self.view.snp_edges)
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
		self.contentView.backgroundColor = Color.redPrimary
		self.contentView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(scrollView.snp_top)
			make.left.equalTo(scrollView.snp_left)
			make.right.equalTo(scrollView.snp_right)
			make.height.greaterThanOrEqualTo(backgroundView.snp_height)
			make.width.equalTo(backgroundView.snp_width)
		}
		
		let logo = UIImageView()
		self.logo = logo
		self.contentView.addSubview(logo)
		self.logo.image = UIImage(named: "login_logo")
		self.logo.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.contentView.snp_top).offset(70)
			make.centerX.equalTo(self.contentView.snp_centerX)
			make.width.equalTo(200)
			make.height.equalTo(200)
		}
		
		//MARK: FIRST: SIGN IN
		
		let firstContainer = UIView()
		self.firstContainer = firstContainer
		self.contentView.addSubview(self.firstContainer)
		self.firstContainer.alpha = 1
		self.firstContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.logo.snp_bottom).offset(60)
			make.left.equalTo(self.contentView.snp_left)
			make.width.equalTo(self.contentView.snp_width)
			make.bottom.equalTo(contentView.snp_bottom)
		}
		
		let fbButton = UIButton()
		self.fbButton = fbButton
		self.firstContainer.addSubview(self.fbButton)
		self.fbButton.clipsToBounds = true
		self.fbButton.setBackgroundColor(Color.blueFacebook, forState: UIControlState.Normal)
		self.fbButton.setBackgroundColor(Color.blueFacebookSelected, forState: UIControlState.Highlighted)
		self.fbButton.setTitle("Sign in with Facebook", forState: UIControlState.Normal)
		self.fbButton.setTitleColor(Color.whitePrimary, forState: UIControlState.Normal)
		self.fbButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 0)
		self.fbButton.titleLabel?.font = UIFont(name: "Lato-Regular", size: kTitle17)
		self.fbButton.addTarget(self, action: "facebookLogin:", forControlEvents: UIControlEvents.TouchUpInside)
		self.fbButton.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.firstContainer.snp_top).offset(20)
			make.left.equalTo(self.firstContainer.snp_left).offset(24)
			make.right.equalTo(self.firstContainer.snp_right).offset(-24)
			make.height.equalTo(50)
		}
		
		let fbLogo = UIImageView()
		self.fbLogo = fbLogo
		self.fbButton.addSubview(self.fbLogo)
		self.fbLogo.image = UIImage(named: "fb-black")
		self.fbLogo.alpha = 0.4
		self.fbLogo.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(self.fbButton.snp_left).offset(10)
			make.centerY.equalTo(self.fbButton.snp_centerY)
			make.width.equalTo(30)
			make.height.equalTo(30)
		}
		
		let fbLine = UIView()
		self.fbLine = fbLine
		self.fbButton.addSubview(fbLine)
		self.fbLine.backgroundColor = Color.blackPrimary
		self.fbLine.alpha = 0.2
		self.fbLine.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(self.fbLogo.snp_right).offset(10)
			make.width.equalTo(1)
			make.top.equalTo(fbButton.snp_top).offset(5)
			make.bottom.equalTo(fbButton.snp_bottom).offset(-5)
		}
		
		/*let twitterButton = UIButton()
		self.twitterButton = twitterButton
		self.firstContainer.addSubview(self.twitterButton)
		self.twitterButton.setBackgroundColor(Color.blueTwitter, forState: UIControlState.Normal)
		self.twitterButton.setBackgroundColor(blueTwitterSelected, forState: UIControlState.Highlighted)
		self.twitterButton.setTitle("Sign in with Twitter", forState: UIControlState.Normal)
		self.twitterButton.setTitleColor(Color.whitePrimary, forState: UIControlState.Normal)
		self.twitterButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
		self.twitterButton.titleLabel?.font = UIFont(name: "Lato-Regular", size: kTitle17)
		self.twitterButton.addTarget(self, action: "twitterLogin:", forControlEvents: UIControlEvents.TouchUpInside)
		self.twitterButton.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.fbButton.snp_bottom).offset(20)
			make.left.equalTo(self.fbButton.snp_left)
			make.right.equalTo(self.fbButton.snp_right)
			make.height.equalTo(50)
		}
		
		let twitterLogo = UIImageView()
		self.twitterLogo = twitterLogo
		self.twitterButton.addSubview(self.twitterLogo)
		self.twitterLogo.image = UIImage(named: "twitter-black")
		self.twitterLogo.alpha = 0.4
		self.twitterLogo.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(self.twitterButton.snp_left).offset(10)
			make.centerY.equalTo(self.twitterButton.snp_centerY)
			make.width.equalTo(30)
			make.height.equalTo(30)
		}
		
		let twitterLine = UIView()
		self.twitterLine = twitterLine
		self.twitterButton.addSubview(self.twitterLine)
		self.twitterLine.backgroundColor = Color.blackPrimary
		self.twitterLine.alpha = 0.2
		self.twitterLine.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(self.twitterLogo.snp_right).offset(10)
			make.width.equalTo(1)
			make.top.equalTo(self.twitterButton.snp_top).offset(5)
			make.bottom.equalTo(self.twitterButton.snp_bottom).offset(-5)
		}*/
		
		let emailButton = UIButton()
		self.emailButton = emailButton
		self.firstContainer.addSubview(self.emailButton)
		self.emailButton.layer.borderColor = Color.whitePrimary.CGColor
		self.emailButton.layer.borderWidth = 1
		self.emailButton.setBackgroundColor(Color.redPrimary, forState: UIControlState.Normal)
		self.emailButton.setBackgroundColor(Color.redPrimarySelected, forState: UIControlState.Highlighted)
		self.emailButton.setTitle("Email sign in", forState: UIControlState.Normal)
		self.emailButton.setTitleColor(Color.whitePrimary, forState: UIControlState.Normal)
		self.emailButton.titleLabel?.font = UIFont(name: "Lato-Regular", size: kTitle17)
		self.emailButton.addTarget(self, action: "didTapEmailButton:", forControlEvents: UIControlEvents.TouchUpInside)
		self.emailButton.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(self.firstContainer.snp_bottom).offset(-55)
			make.left.equalTo(self.firstContainer.snp_left).offset(24)
			make.right.equalTo(self.firstContainer.snp_right).offset(-24)
			make.height.equalTo(50)
		}
		
		//MARK: SECOND: EMAIL LOGIN
		
		let secondContainer = UIView()
		self.secondContainer = secondContainer
		self.contentView.addSubview(self.secondContainer)
		self.secondContainer.alpha = 0
		self.secondContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.logo.snp_bottom)
			make.left.equalTo(self.firstContainer.snp_right)
			make.width.equalTo(self.contentView.snp_width)
			make.bottom.equalTo(contentView.snp_bottom)
		}
		
		let emailField = DefaultTextFieldView()
		self.emailField = emailField
		self.secondContainer.addSubview(emailField)
		self.emailField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: Color.textFieldPlaceholderColor])
		self.emailField.keyboardType = UIKeyboardType.EmailAddress
		self.emailField.autocapitalizationType = UITextAutocapitalizationType.None
		self.emailField.returnKeyType = .Next
		self.emailField.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.firstContainer.snp_top)
			make.left.equalTo(self.secondContainer.snp_left).offset(24)
			make.right.equalTo(self.secondContainer.snp_right).offset(-24)
		}
		
		let textfieldUnderline = UIView()
		self.textfieldUnderline = textfieldUnderline
		self.secondContainer.addSubview(textfieldUnderline)
		self.textfieldUnderline.backgroundColor = Color.grayDetails
		self.textfieldUnderline.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.emailField.snp_bottom)
			make.centerX.equalTo(self.emailField.snp_centerX)
			make.width.equalTo(self.emailField.snp_width)
			make.height.equalTo(1)
		}
		
		let passwordField = DefaultTextFieldView()
		self.passwordField = passwordField
		self.secondContainer.addSubview(passwordField)
		self.passwordField.secureTextEntry = true
		self.passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: Color.textFieldPlaceholderColor])
		self.passwordField.autocapitalizationType = UITextAutocapitalizationType.None
		self.passwordField.returnKeyType = .Done
		self.passwordField.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.emailField.snp_bottom).offset(-1)
			make.left.equalTo(self.secondContainer.snp_left).offset(24)
			make.right.equalTo(self.secondContainer.snp_right).offset(-24)
		}
		
		let loginButton = UIButton()
		self.loginButton = loginButton
		self.secondContainer.addSubview(self.loginButton)
		self.loginButton.setTitle("Login", forState: UIControlState.Normal)
		self.loginButton.setTitleColor(Color.whitePrimary, forState: UIControlState.Normal)
		self.loginButton.setTitleColor(Color.redPrimarySelected, forState: UIControlState.Highlighted)
		self.loginButton.titleLabel?.font = UIFont(name: "Lato-Regular", size: kTitle17)
		self.loginButton.addTarget(self, action: "emailLogin:", forControlEvents: UIControlEvents.TouchUpInside)
		self.loginButton.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.passwordField.snp_bottom)
			make.left.equalTo(self.secondContainer.snp_left).offset(24)
			make.right.equalTo(self.secondContainer.snp_right).offset(-24)
			make.height.equalTo(50)
		}
		
		let arrowSecond = UIButton()
		self.arrowSecond = arrowSecond
		self.secondContainer.addSubview(self.arrowSecond)
		self.arrowSecond.setImage(UIImage(named: "left-white-arrow"), forState: UIControlState.Normal)
		self.arrowSecond.imageEdgeInsets = UIEdgeInsetsMake(10, 24, 40, 56)
		self.arrowSecond.addTarget(self, action: "didTapEmailButton:", forControlEvents: UIControlEvents.TouchUpInside)
		self.arrowSecond.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.secondContainer.snp_top).offset(10)
			make.left.equalTo(self.secondContainer.snp_left)
			make.height.equalTo(70)
			make.width.equalTo(100)
		}
		
		let registerButton = UIButton()
		self.registerButton = registerButton
		self.secondContainer.addSubview(self.registerButton)
		self.registerButton.layer.borderColor = Color.whitePrimary.CGColor
		self.registerButton.layer.borderWidth = 1
		self.registerButton.setBackgroundColor(Color.redPrimary, forState: UIControlState.Normal)
		self.registerButton.setBackgroundColor(Color.redPrimarySelected, forState: UIControlState.Highlighted)
		self.registerButton.setTitle("Register new account", forState: UIControlState.Normal)
		self.registerButton.setTitleColor(Color.whitePrimary, forState: UIControlState.Normal)
		self.registerButton.titleLabel?.font = UIFont(name: "Lato-Regular", size: kTitle17)
		self.registerButton.addTarget(self, action: "didTapRegisterButton:", forControlEvents: UIControlEvents.TouchUpInside)
		self.registerButton.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(self.secondContainer.snp_bottom).offset(-55)
			make.left.equalTo(self.secondContainer.snp_left).offset(24)
			make.right.equalTo(self.secondContainer.snp_right).offset(-24)
			make.height.equalTo(50)
		}
		
		let forgotPassButton = UIButton()
		self.forgotPassButton = forgotPassButton
		self.secondContainer.addSubview(self.forgotPassButton)
		self.forgotPassButton.setTitle("I forgot my password", forState: UIControlState.Normal)
		self.forgotPassButton.setTitleColor(Color.whitePrimary, forState: UIControlState.Normal)
		self.forgotPassButton.setTitleColor(Color.redPrimarySelected, forState: UIControlState.Highlighted)
		self.forgotPassButton.titleLabel?.font = UIFont(name: "Lato-Regular", size: kText15)
		self.forgotPassButton.addTarget(self, action: "forgotPassword:", forControlEvents: UIControlEvents.TouchUpInside)
		self.forgotPassButton.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.registerButton.snp_bottom).offset(5)
			make.left.equalTo(self.secondContainer.snp_left).offset(24)
			make.right.equalTo(self.secondContainer.snp_right).offset(-24)
			make.height.equalTo(40)
		}
		
		//MARK: THIRD: EMAIL REGISTER
		
		let thirdContainer = UIView()
		self.thirdContainer = thirdContainer
		self.contentView.addSubview(self.thirdContainer)
		self.thirdContainer.alpha = 0
		self.thirdContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.logo.snp_bottom)
			make.left.equalTo(self.secondContainer.snp_right)
			make.width.equalTo(self.contentView.snp_width)
			make.bottom.equalTo(self.contentView.snp_bottom)
		}
		
		let firstnameField = DefaultTextFieldView()
		self.firstnameField = firstnameField
		self.thirdContainer.addSubview(firstnameField)
		self.firstnameField.attributedPlaceholder = NSAttributedString(string: "First name", attributes: [NSForegroundColorAttributeName: Color.textFieldPlaceholderColor])
		self.firstnameField.autocorrectionType = UITextAutocorrectionType.No
		self.firstnameField.returnKeyType = .Next
		self.firstnameField.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.firstContainer.snp_top)
			make.left.equalTo(self.thirdContainer.snp_left).offset(24)
			make.right.equalTo(self.thirdContainer.snp_right).offset(-24)
		}
		
		let firstnameUnderlineRegister = UIView()
		self.firstnameUnderlineRegister = firstnameUnderlineRegister
		self.thirdContainer.addSubview(firstnameUnderlineRegister)
		self.firstnameUnderlineRegister.backgroundColor = Color.grayDetails
		self.firstnameUnderlineRegister.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.firstnameField.snp_bottom)
			make.centerX.equalTo(self.firstnameField.snp_centerX)
			make.width.equalTo(self.firstnameField.snp_width)
			make.height.equalTo(1)
		}
		
		let lastnameField = DefaultTextFieldView()
		self.lastnameField = lastnameField
		self.thirdContainer.addSubview(lastnameField)
		self.lastnameField.attributedPlaceholder = NSAttributedString(string: "Last name", attributes: [NSForegroundColorAttributeName: Color.textFieldPlaceholderColor])
		self.lastnameField.autocorrectionType = UITextAutocorrectionType.No
		self.lastnameField.returnKeyType = .Next
		self.lastnameField.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.firstnameField.snp_bottom).offset(-1)
			make.left.equalTo(self.thirdContainer.snp_left).offset(24)
			make.right.equalTo(self.thirdContainer.snp_right).offset(-24)
		}
		
		let emailFieldRegister = DefaultTextFieldView()
		self.emailFieldRegister = emailFieldRegister
		self.thirdContainer.addSubview(emailFieldRegister)
		self.emailFieldRegister.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: Color.textFieldPlaceholderColor])
		self.emailFieldRegister.keyboardType = UIKeyboardType.EmailAddress
		self.emailFieldRegister.autocorrectionType = UITextAutocorrectionType.No
		self.emailFieldRegister.autocapitalizationType = UITextAutocapitalizationType.None
		self.emailFieldRegister.returnKeyType = .Next
		self.emailFieldRegister.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.lastnameField.snp_bottom).offset(10)
			make.left.equalTo(self.thirdContainer.snp_left).offset(24)
			make.right.equalTo(self.thirdContainer.snp_right).offset(-24)
		}
		
		let passwordFieldRegister = DefaultTextFieldView()
		self.passwordFieldRegister = passwordFieldRegister
		self.thirdContainer.addSubview(passwordFieldRegister)
		self.passwordFieldRegister.secureTextEntry = true
		self.passwordFieldRegister.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: Color.textFieldPlaceholderColor])
		self.passwordFieldRegister.autocorrectionType = UITextAutocorrectionType.No
		self.passwordFieldRegister.autocapitalizationType = UITextAutocapitalizationType.None
		self.passwordFieldRegister.returnKeyType = .Next
		self.passwordFieldRegister.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.emailFieldRegister.snp_bottom).offset(10)
			make.left.equalTo(self.thirdContainer.snp_left).offset(24)
			make.right.equalTo(self.thirdContainer.snp_right).offset(-24)
		}
		
		let passwordfieldUnderlineRegister = UIView()
		self.passwordfieldUnderlineRegister = passwordfieldUnderlineRegister
		self.thirdContainer.addSubview(passwordfieldUnderlineRegister)
		self.passwordfieldUnderlineRegister.backgroundColor = Color.grayDetails
		self.passwordfieldUnderlineRegister.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.passwordFieldRegister.snp_bottom)
			make.centerX.equalTo(self.passwordFieldRegister.snp_centerX)
			make.width.equalTo(self.passwordFieldRegister.snp_width)
			make.height.equalTo(1)
		}
		
		let passwordFieldConfirmRegister = DefaultTextFieldView()
		self.passwordFieldConfirmRegister = passwordFieldConfirmRegister
		self.passwordFieldConfirmRegister.secureTextEntry = true
		self.thirdContainer.addSubview(passwordFieldConfirmRegister)
		self.passwordFieldConfirmRegister.attributedPlaceholder = NSAttributedString(string: "Confirm password", attributes: [NSForegroundColorAttributeName: Color.textFieldPlaceholderColor])
		self.passwordFieldConfirmRegister.autocorrectionType = UITextAutocorrectionType.No
		self.passwordFieldConfirmRegister.autocapitalizationType = UITextAutocapitalizationType.None
		self.passwordFieldConfirmRegister.returnKeyType = .Done
		self.passwordFieldConfirmRegister.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.passwordFieldRegister.snp_bottom).offset(-1)
			make.left.equalTo(self.thirdContainer.snp_left).offset(24)
			make.right.equalTo(self.thirdContainer.snp_right).offset(-24)
		}
		
		let registerAccountButton = UIButton()
		self.registerAccountButton = registerAccountButton
		self.thirdContainer.addSubview(self.registerAccountButton)
		self.registerAccountButton.setTitle("Sign up", forState: UIControlState.Normal)
		self.registerAccountButton.setTitleColor(Color.whitePrimary, forState: UIControlState.Normal)
		self.registerAccountButton.titleLabel?.font = UIFont(name: "Lato-Regular", size: kTitle17)
		self.registerAccountButton.setBackgroundColor(Color.redPrimary, forState: UIControlState.Normal)
		self.registerAccountButton.setBackgroundColor(Color.redPrimarySelected, forState: UIControlState.Highlighted)
		self.registerAccountButton.addTarget(self, action: "createAccount:", forControlEvents: UIControlEvents.TouchUpInside)
		self.registerAccountButton.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.passwordFieldConfirmRegister.snp_bottom)
			make.left.equalTo(self.thirdContainer.snp_left).offset(24)
			make.right.equalTo(self.thirdContainer.snp_right).offset(-24)
			make.height.equalTo(50)
		}
		
		let arrowThird = UIButton()
		self.arrowThird = arrowThird
		self.thirdContainer.addSubview(self.arrowThird)
		self.arrowThird.setImage(UIImage(named: "left-white-arrow"), forState: UIControlState.Normal)
		self.arrowThird.imageEdgeInsets = UIEdgeInsetsMake(10, 24, 40, 56)
		self.arrowThird.addTarget(self, action: "didTapRegisterButton:", forControlEvents: UIControlEvents.TouchUpInside)
		self.arrowThird.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.thirdContainer.snp_top).offset(10)
			make.left.equalTo(self.thirdContainer.snp_left)
			make.height.equalTo(70)
			make.width.equalTo(100)
		}
	}
	
	func adjustUI() {
		
	}
	
	//MARK: TextField delegates
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		
		dismissKeyboard()
		textField.resignFirstResponder()
		
		switch (textField) {
		case self.emailField:
			self.passwordField.becomeFirstResponder()
		case self.firstnameField:
			self.lastnameField.becomeFirstResponder()
		case self.lastnameField:
			self.emailFieldRegister.becomeFirstResponder()
		case self.emailFieldRegister:
			self.passwordFieldRegister.becomeFirstResponder()
		case self.passwordFieldRegister:
			self.passwordFieldConfirmRegister.becomeFirstResponder()
		default:
			return false
		}
		
		return false
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
	
	func keyboardWillHide(notification: NSNotification) {
		self.contentInsets = UIEdgeInsetsZero
		self.scrollView.contentInset = contentInsets
		self.scrollView.scrollIndicatorInsets = contentInsets
	}
	
	//MARK: Actions
	
	func facebookLogin(sender: UIButton) {
		
		SVProgressHUD.setBackgroundColor(UIColor.whiteColor())
		SVProgressHUD.setForegroundColor(Color.redPrimary)
		SVProgressHUD.show()
		
		ApiHelper.loginWithFacebook { (err) -> Void in
			self.loginCompleted()
		}
	}
	
	//removed 13-11-15
	/*func twitterLogin(sender: UIButton) {
		
		PFTwitterUtils.logInWithBlock { (user, error) -> Void in
			if error != nil{
				print("\(error)")
				
			}else{
				
				if user!.isNew   {
					print("User signed up and logged in through Twitta!")
					self.getTwitterUserInfo()
					
					PFUser.currentUser()!["loginProvider"] = "twitter"
					PFUser.currentUser()!.saveInBackground()
					
				} else {
					
					print("User logged in through Twitta")
					self.getTwitterUserInfo()
				}
			}
		}
	}*/
	
	func emailLogin(sender: UIButton) {
		dismissKeyboard()
		var errorMsg: String?
		var openAlert = false
		
		
		if self.emailField.text == "" || self.passwordField.text == "" {
			errorMsg = "Please enter your email address and password"
			openAlert = true
		} else if !(self.emailField.text!.isEmail()) {
			errorMsg = "Please enter a valid email address"
			openAlert = true
		}
		
		if openAlert {
			let popup = UIAlertController(title: errorMsg!, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
			popup.addAction(UIAlertAction(title: "Confirm", style: .Default, handler: { (action) -> Void in
			}))
			
			self.presentViewController(popup, animated: true, completion: nil)
			popup.view.tintColor = Color.redPrimary
			
			return
		}
		
		
		ApiHelper.loginWithEmail(self.emailField.text!, password: self.passwordField.text!, block: { (error) -> Void in
			if error != nil {
				print("\(error)")
				
				if error!.code == 100 {
					errorMsg = "No internet connection"
				} else if error!.code == 101 {
					errorMsg = "Invalid email address or password"
				} else {
					errorMsg = "Error code: \(error!.code)"
				}
				
				
				let popup = UIAlertController(title: errorMsg, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
				popup.addAction(UIAlertAction(title: "Confirm", style: .Default, handler: { (action) -> Void in
				}))
				
				self.presentViewController(popup, animated: true, completion: nil)
				popup.view.tintColor = Color.redPrimary
			} else {
				self.loginCompleted()
			}
		})
	}
	
	func forgotPassword(sender: UIButton) {
		
	}
	
	func createAccount(sender: UIButton) {
		dismissKeyboard()
		
		var errorMsg: String?
		var openAlert = false
		
		
		if self.emailFieldRegister.text == "" || self.passwordFieldRegister.text == "" || self.firstnameField.text == "" || self.lastnameField.text == "" || self.passwordFieldRegister.text == "" || self.passwordFieldConfirmRegister.text == "" {
			errorMsg = "Please fill in all the required fields"
			openAlert = true
		} else if !(self.emailFieldRegister.text!.isEmail()) {
			errorMsg = "Please enter a valid email address"
			openAlert = true
		} else if self.passwordFieldRegister.text != self.passwordFieldConfirmRegister.text {
			errorMsg = "Passwords don't match"
			openAlert = true
			
			self.passwordFieldRegister.text = ""
			self.passwordFieldConfirmRegister.text = ""
		}
		
		if openAlert {
			let popup = UIAlertController(title: errorMsg!, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
			popup.addAction(UIAlertAction(title: "Confirm", style: .Default, handler: { (action) -> Void in
			}))
			
			self.presentViewController(popup, animated: true, completion: nil)
			popup.view.tintColor = Color.redPrimary
			
			return
		}
		
		ApiHelper.registerWithEmail(self.emailFieldRegister.text!, password: self.passwordFieldRegister.text!, firstName: self.firstnameField.text!, lastName: self.lastnameField.text!) { (error) -> Void in
			
			if error != nil {
				if error!.code == 100 {
					errorMsg = "No internet connection"
				} else if error!.code == 202 || error!.code == 203 {
					errorMsg = "This email is already registered"
				} else {
					errorMsg = "Error code: \(error!.code)"
				}
				
				let popup = UIAlertController(title: errorMsg, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
				popup.addAction(UIAlertAction(title: "Confirm", style: .Default, handler: { (action) -> Void in
				}))
				
				self.presentViewController(popup, animated: true, completion: nil)
				popup.view.tintColor = Color.redPrimary
				
			} else {
				self.loginCompleted()
			}
		}
	}
	
	func skipLogin(sender: AnyObject) {
		dismissKeyboard()
		self.loginCompleted()
	}
	
	//Login
	
	func getTwitterUserInfo() {
	}
	
	func loginCompleted() {
		dismissKeyboard()
		ApiHelper.getCurrentUserPrivateInfo()
		self.delegate?.onLogin()
	}
	
	//MARK: ANIMATE FIRST <-> SECOND VIEW
	
	func didTapEmailButton(sender: UIButton) {
		
		if !self.emailActive {
			
			self.firstContainer.snp_updateConstraints { (make) -> Void in
				make.left.equalTo(self.contentView.snp_left).offset(-(self.contentView.frame.maxX))
			}
			
			UIView.animateWithDuration(0.3, delay: 0.0, options: [.CurveEaseOut], animations:  {
				self.firstContainer.layoutIfNeeded()
				self.secondContainer.layoutIfNeeded()
				self.thirdContainer.layoutIfNeeded()
				
				self.firstContainer.alpha = 0
				self.secondContainer.alpha = 1
				}, completion: nil)
			
			self.emailActive = true
			dismissKeyboard()
			
		} else if self.fieldEditing {
			
			dismissKeyboard()
			
		} else {
			
			self.firstContainer.snp_updateConstraints { (make) -> Void in
				make.left.equalTo(self.contentView.snp_left)
			}
			
			UIView.animateWithDuration(0.3, delay: 0.0, options: [.CurveEaseOut], animations:  {
				self.firstContainer.layoutIfNeeded()
				self.secondContainer.layoutIfNeeded()
				self.thirdContainer.layoutIfNeeded()
				
				self.firstContainer.alpha = 1
				self.secondContainer.alpha = 0
				}, completion: nil)
			
			self.emailActive = false
			dismissKeyboard()
		}
	}
	
	//MARK: ANIMATE SECOND <-> THIRD VIEW
	
	func didTapRegisterButton(sender: UIButton) {
		if !self.registerActive {
			
			self.firstContainer.snp_updateConstraints { (make) -> Void in
				make.left.equalTo(self.contentView.snp_left).offset(-2*(self.contentView.frame.maxX))
			}
			
			UIView.animateWithDuration(0.3, delay: 0.0, options: [.CurveEaseOut], animations:  {
				self.firstContainer.layoutIfNeeded()
				self.secondContainer.layoutIfNeeded()
				self.thirdContainer.layoutIfNeeded()
				
				self.secondContainer.alpha = 0
				self.thirdContainer.alpha = 1
				}, completion: nil)
			
			self.registerActive = true
			dismissKeyboard()
			
		} else if self.fieldEditing {
			
			dismissKeyboard()
			
		} else {
			
			self.firstContainer.snp_updateConstraints { (make) -> Void in
				make.left.equalTo(self.contentView.snp_left).offset(-(self.contentView.frame.maxX))
			}
			
			UIView.animateWithDuration(0.3, delay: 0.0, options: [.CurveEaseOut], animations:  {
				self.firstContainer.layoutIfNeeded()
				self.secondContainer.layoutIfNeeded()
				self.thirdContainer.layoutIfNeeded()
				
				self.secondContainer.alpha = 1
				self.thirdContainer.alpha = 0
				}, completion: nil)
			
			self.registerActive = false
			dismissKeyboard()
		}
	}
}

