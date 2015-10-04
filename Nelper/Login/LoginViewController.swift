//
//  LoginViewController.swift
//  Nelper
//
//  Created by Janic Duplessis on 2015-06-21.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import UIKit

protocol LoginViewControllerDelegate {
	func onLogin() -> Void
}

class LoginViewController: UIViewController, UIGestureRecognizerDelegate {

	let permissions = ["public_profile"]
	var delegate: LoginViewControllerDelegate?
	var tap: UITapGestureRecognizer?
	
	var contentView: UIView!
	var logo: UIImageView!
	
	var firstContainer: UIView!
	var fbButton: UIButton!
	var fbLogo: UIImageView!
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
	var emailFieldRegister: UITextField!
	var passwordFieldRegister: UITextField!
	var passwordfieldUnderlineRegister: UIView!
	var passwordFieldConfirmRegister: UITextField!
	var registerAccountButton: UIButton!
	var arrowThird: UIButton!
	
	var emailActive = false
	var registerActive = false
	
	var keyboardIsShowing = false
	
	//MARK: Initialization
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.createView()
		self.adjustUI()
		
		// KEYBOARD DISMISS
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
		self.tap = tap
		self.contentView.addGestureRecognizer(tap)
		
		// KEYBOARD VIEW MOVER
		NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// KEYBOARD DISMISS
	func DismissKeyboard() {
		view.endEditing(true)
	}
	
	//MARK: UI
	
	func createView() {
		
		let contentView = UIView()
		self.contentView = contentView
		self.view.addSubview(contentView)
		self.contentView.backgroundColor = redPrimary
		self.contentView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self.view.snp_edges)
		}
		
		let logo = UIImageView()
		self.logo = logo
		self.contentView.addSubview(logo)
		self.logo.image = UIImage(named: "logo_beige_nobackground_v2")
		self.logo.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.contentView.snp_top).offset(75)
			make.centerX.equalTo(self.contentView.snp_centerX)
			make.width.equalTo(220)
			make.height.equalTo(220)
		}
		
		//MARK: FIRST: FB SIGN IN
		
		let firstContainer = UIView()
		self.firstContainer = firstContainer
		self.contentView.addSubview(self.firstContainer)
		self.firstContainer.alpha = 1
		self.firstContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.logo.snp_bottom).offset(50)
			make.left.equalTo(self.contentView.snp_left)
			make.width.equalTo(self.contentView.snp_width)
			make.bottom.equalTo(contentView.snp_bottom)
		}
		
		let fbButton = UIButton()
		self.fbButton = fbButton
		self.firstContainer.addSubview(self.fbButton)
		self.fbButton.backgroundColor = blueFacebook
		self.fbButton.setTitle("Sign in with Facebook", forState: UIControlState.Normal)
		self.fbButton.setTitleColor(whitePrimary, forState: UIControlState.Normal)
		self.fbButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
		self.fbButton.titleLabel?.font = UIFont(name: "Lato-Regular", size: kTitle17)
		self.fbButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
		self.fbButton.addTarget(self, action: "facebookLogin:", forControlEvents: UIControlEvents.TouchUpInside)
		self.fbButton.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.firstContainer.snp_top)
			make.left.equalTo(self.firstContainer.snp_left).offset(24)
			make.right.equalTo(self.firstContainer.snp_right).offset(-24)
			make.height.equalTo(50)
		}
		
		let fbLogo = UIImageView()
		self.fbLogo = fbLogo
		self.fbButton.addSubview(self.fbLogo)
		self.fbLogo.image = UIImage(named: "facebook_512_white")
		self.fbLogo.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(self.fbButton.snp_bottom).offset(11)
			make.left.equalTo(self.fbButton.snp_left).offset(5)
			make.width.equalTo(60)
			make.height.equalTo(60)
		}
		
		let emailButton = UIButton()
		self.emailButton = emailButton
		self.firstContainer.addSubview(self.emailButton)
		self.emailButton.layer.borderColor = whitePrimary.CGColor
		self.emailButton.layer.borderWidth = 1
		self.emailButton.setTitle("Email sign in", forState: UIControlState.Normal)
		self.emailButton.setTitleColor(whitePrimary, forState: UIControlState.Normal)
		self.emailButton.titleLabel?.font = UIFont(name: "Lato-Regular", size: kTitle17)
		self.emailButton.addTarget(self, action: "didTapEmailButton:", forControlEvents: UIControlEvents.TouchUpInside)
		self.emailButton.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.fbButton.snp_bottom).offset(20)
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
		
		let emailField = UITextField()
		self.emailField = emailField
		self.secondContainer.addSubview(emailField)
		self.emailField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: blackPrimary.colorWithAlphaComponent(0.50)])
		self.emailField.font = UIFont(name: "Lato-Regular", size: kText15)
		self.emailField.keyboardType = UIKeyboardType.EmailAddress
		self.emailField.autocorrectionType = UITextAutocorrectionType.No
		self.emailField.autocapitalizationType = UITextAutocapitalizationType.None
		self.emailField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
		self.emailField.backgroundColor = whitePrimary
		self.emailField.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.firstContainer.snp_top)
			make.left.equalTo(self.secondContainer.snp_left).offset(24)
			make.right.equalTo(self.secondContainer.snp_right).offset(-24)
			make.height.equalTo(50)
		}
		
		let textfieldUnderline = UIView()
		self.textfieldUnderline = textfieldUnderline
		self.secondContainer.addSubview(textfieldUnderline)
		self.textfieldUnderline.backgroundColor = grayDetails
		self.textfieldUnderline.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.emailField.snp_bottom)
			make.centerX.equalTo(self.emailField.snp_centerX)
			make.width.equalTo(self.emailField.snp_width)
			make.height.equalTo(1)
		}
		
		let passwordField = UITextField()
		self.passwordField = passwordField
		self.secondContainer.addSubview(passwordField)
		self.passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: blackPrimary.colorWithAlphaComponent(0.50)])
		self.passwordField.font = UIFont(name: "Lato-Regular", size: kText15)
		self.passwordField.autocorrectionType = UITextAutocorrectionType.No
		self.passwordField.autocapitalizationType = UITextAutocapitalizationType.None
		self.passwordField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
		self.passwordField.backgroundColor = whitePrimary
		self.passwordField.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.emailField.snp_bottom).offset(1)
			make.left.equalTo(self.secondContainer.snp_left).offset(24)
			make.right.equalTo(self.secondContainer.snp_right).offset(-24)
			make.height.equalTo(50)
		}
		
		let loginButton = UIButton()
		self.loginButton = loginButton
		self.secondContainer.addSubview(self.loginButton)
		self.loginButton.setTitle("Login", forState: UIControlState.Normal)
		self.loginButton.setTitleColor(whitePrimary, forState: UIControlState.Normal)
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
		self.arrowSecond.imageEdgeInsets = UIEdgeInsetsMake(5, 24, 45, 56)
		self.arrowSecond.addTarget(self, action: "didTapEmailButton:", forControlEvents: UIControlEvents.TouchUpInside)
		self.arrowSecond.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.secondContainer.snp_top)
			make.left.equalTo(self.emailField.snp_left)
			make.height.equalTo(70)
			make.width.equalTo(100)
		}
		
		let registerButton = UIButton()
		self.registerButton = registerButton
		self.secondContainer.addSubview(self.registerButton)
		self.registerButton.layer.borderColor = whitePrimary.CGColor
		self.registerButton.layer.borderWidth = 1
		self.registerButton.setTitle("Register new account", forState: UIControlState.Normal)
		self.registerButton.setTitleColor(whitePrimary, forState: UIControlState.Normal)
		self.registerButton.titleLabel?.font = UIFont(name: "Lato-Regular", size: kTitle17)
		self.registerButton.addTarget(self, action: "didTapRegisterButton:", forControlEvents: UIControlEvents.TouchUpInside)
		self.registerButton.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(self.secondContainer.snp_bottom).offset(-50)
			make.left.equalTo(self.secondContainer.snp_left).offset(24)
			make.right.equalTo(self.secondContainer.snp_right).offset(-24)
			make.height.equalTo(50)
		}
		
		let forgotPassButton = UIButton()
		self.forgotPassButton = forgotPassButton
		self.secondContainer.addSubview(self.forgotPassButton)
		self.forgotPassButton.setTitle("I forgot my password", forState: UIControlState.Normal)
		self.forgotPassButton.setTitleColor(whitePrimary, forState: UIControlState.Normal)
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
		
		let emailFieldRegister = UITextField()
		self.emailFieldRegister = emailFieldRegister
		self.thirdContainer.addSubview(emailFieldRegister)
		self.emailFieldRegister.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: blackPrimary.colorWithAlphaComponent(0.50)])
		self.emailFieldRegister.font = UIFont(name: "Lato-Regular", size: kText15)
		self.emailFieldRegister.keyboardType = UIKeyboardType.EmailAddress
		self.emailFieldRegister.autocorrectionType = UITextAutocorrectionType.No
		self.emailFieldRegister.autocapitalizationType = UITextAutocapitalizationType.None
		self.emailFieldRegister.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
		self.emailFieldRegister.backgroundColor = whitePrimary
		self.emailFieldRegister.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.firstContainer.snp_top)
			make.left.equalTo(self.thirdContainer.snp_left).offset(24)
			make.right.equalTo(self.thirdContainer.snp_right).offset(-24)
			make.height.equalTo(50)
		}
		
		let passwordFieldRegister = UITextField()
		self.passwordFieldRegister = passwordFieldRegister
		self.thirdContainer.addSubview(passwordFieldRegister)
		self.passwordFieldRegister.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: blackPrimary.colorWithAlphaComponent(0.50)])
		self.passwordFieldRegister.font = UIFont(name: "Lato-Regular", size: kText15)
		self.passwordFieldRegister.autocorrectionType = UITextAutocorrectionType.No
		self.passwordFieldRegister.autocapitalizationType = UITextAutocapitalizationType.None
		self.passwordFieldRegister.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
		self.passwordFieldRegister.backgroundColor = whitePrimary
		self.passwordFieldRegister.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.emailFieldRegister.snp_bottom).offset(10)
			make.left.equalTo(self.thirdContainer.snp_left).offset(24)
			make.right.equalTo(self.thirdContainer.snp_right).offset(-24)
			make.height.equalTo(50)
		}
		
		let passwordfieldUnderlineRegister = UIView()
		self.passwordfieldUnderlineRegister = passwordfieldUnderlineRegister
		self.thirdContainer.addSubview(passwordfieldUnderlineRegister)
		self.passwordfieldUnderlineRegister.backgroundColor = grayDetails
		self.passwordfieldUnderlineRegister.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.passwordFieldRegister.snp_bottom)
			make.centerX.equalTo(self.passwordFieldRegister.snp_centerX)
			make.width.equalTo(self.passwordFieldRegister.snp_width)
			make.height.equalTo(1)
		}
		
		let passwordFieldConfirmRegister = UITextField()
		self.passwordFieldConfirmRegister = passwordFieldConfirmRegister
		self.thirdContainer.addSubview(passwordFieldConfirmRegister)
		self.passwordFieldConfirmRegister.attributedPlaceholder = NSAttributedString(string: "Confirm password", attributes: [NSForegroundColorAttributeName: blackPrimary.colorWithAlphaComponent(0.50)])
		self.passwordFieldConfirmRegister.font = UIFont(name: "Lato-Regular", size: kText15)
		self.passwordFieldConfirmRegister.autocorrectionType = UITextAutocorrectionType.No
		self.passwordFieldConfirmRegister.autocapitalizationType = UITextAutocapitalizationType.None
		self.passwordFieldConfirmRegister.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
		self.passwordFieldConfirmRegister.backgroundColor = whitePrimary
		self.passwordFieldConfirmRegister.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.passwordFieldRegister.snp_bottom).offset(1)
			make.left.equalTo(self.thirdContainer.snp_left).offset(24)
			make.right.equalTo(self.thirdContainer.snp_right).offset(-24)
			make.height.equalTo(50)
		}
		
		let registerAccountButton = UIButton()
		self.registerAccountButton = registerAccountButton
		self.thirdContainer.addSubview(self.registerAccountButton)
		self.registerAccountButton.setTitle("Sign up", forState: UIControlState.Normal)
		self.registerAccountButton.setTitleColor(whitePrimary, forState: UIControlState.Normal)
		self.registerAccountButton.titleLabel?.font = UIFont(name: "Lato-Regular", size: kTitle17)
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
		self.arrowThird.imageEdgeInsets = UIEdgeInsetsMake(5, 24, 45, 56)
		self.arrowThird.addTarget(self, action: "didTapRegisterButton:", forControlEvents: UIControlEvents.TouchUpInside)
		self.arrowThird.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.thirdContainer.snp_top)
			make.left.equalTo(self.thirdContainer.snp_left)
			make.height.equalTo(70)
			make.width.equalTo(100)
		}
	}
	
	func adjustUI(){
		
	}
	
	// Elements animation (fade in)
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
	}
	
	//MARK: KEYBOARD VIEW MOVER
	
	func keyboardWillShow(sender: NSNotification) {
		if keyboardIsShowing == false {
			self.view.frame.origin.y -= 100
			keyboardIsShowing = true
		}
	}
	
	func keyboardWillHide(sender: NSNotification) {
		if keyboardIsShowing == true{
			self.view.frame.origin.y += 100
			keyboardIsShowing = false
		}
	}
	
	//MARK: Actions
	
	func facebookLogin(sender: UIButton) {
		PFFacebookUtils.logInInBackgroundWithReadPermissions(self.permissions) { (user: PFUser?, error: NSError?) -> Void in
			if error != nil {
				//TODO: handle login errors.
				NSLog("Login error")
				return
			}
			
			if user!.isNew {
				NSLog("User signed up and logged in through Facebook!")
				self.getFBUserInfo()
			} else {
				NSLog("User logged in through Facebook! \(user!.username)")
				self.getFBUserInfo()
			}
		}
	}
	
	func emailLogin(sender: UIButton) {
		
	}
		
	func forgotPassword(sender: UIButton) {
		
	}
	
	func createAccount(sender: UIButton) {
		
	}
	
	func skipLogin(sender: AnyObject) {
		self.loginCompleted()
	}
	
	//Login
	
	func getFBUserInfo() {
		let request = FBSDKGraphRequest(graphPath: "me", parameters: nil)
		request.startWithCompletionHandler { (conn:FBSDKGraphRequestConnection!, user:AnyObject!, error:NSError!) -> Void in
			if error != nil {
				self.loginCompleted()
			} else {
				var results = user as! Dictionary<String, AnyObject>
				
				let currentUser = PFUser.currentUser()!
				let fbID = results["id"] as AnyObject? as! String
				let profilePictureURL : String = "https://graph.facebook.com/\(fbID)/picture?type=large&return_ssl_resources=1"
				
				currentUser.setValue(profilePictureURL, forKey: "pictureURL")
				currentUser.setValue(user.valueForKey("name"), forKey: "name")
				
				PFUser.currentUser()!.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
					self.loginCompleted()
				})
			}
		}
	}
	
	func loginCompleted() {
		ApiHelper.getCurrentUserPrivateInfo()
		delegate?.onLogin()
	}
	
	//MARK: ANIMATE FIRST <-> SECOND VIEW
	
	func didTapEmailButton(sender: UIButton) {
		
		if self.emailActive == false {
			
			self.firstContainer.snp_updateConstraints { (make) -> Void in
				make.left.equalTo(self.contentView.snp_left).offset(-(self.contentView.frame.maxX))
			}
			
			UIView.animateWithDuration(0.5, delay: 0.0, options: [.CurveEaseOut], animations:  {
				self.firstContainer.layoutIfNeeded()
				self.secondContainer.layoutIfNeeded()
				self.thirdContainer.layoutIfNeeded()
				
				self.firstContainer.alpha = 0
				self.secondContainer.alpha = 1
			}, completion: nil)
			
			self.emailActive = true
			DismissKeyboard()
			
		} else {
			
			self.firstContainer.snp_updateConstraints { (make) -> Void in
				make.left.equalTo(self.contentView.snp_left)
			}
			
			UIView.animateWithDuration(0.5, delay: 0.0, options: [.CurveEaseOut], animations:  {
				self.firstContainer.layoutIfNeeded()
				self.secondContainer.layoutIfNeeded()
				self.thirdContainer.layoutIfNeeded()
				
				self.firstContainer.alpha = 1
				self.secondContainer.alpha = 0
			}, completion: nil)
			
			self.emailActive = false
			DismissKeyboard()
		}
	}
	
	//MARK: ANIMATE SECOND <-> THIRD VIEW
	
	func didTapRegisterButton(sender: UIButton) {
		if self.registerActive == false {
			
			self.firstContainer.snp_updateConstraints { (make) -> Void in
				make.left.equalTo(self.contentView.snp_left).offset(-2*(self.contentView.frame.maxX))
			}
			
			UIView.animateWithDuration(0.5, delay: 0.0, options: [.CurveEaseOut], animations:  {
				self.firstContainer.layoutIfNeeded()
				self.secondContainer.layoutIfNeeded()
				self.thirdContainer.layoutIfNeeded()
				
				self.secondContainer.alpha = 0
				self.thirdContainer.alpha = 1
			}, completion: nil)
			
			self.registerActive = true
			DismissKeyboard()
			
		} else {
			
			self.firstContainer.snp_updateConstraints { (make) -> Void in
				make.left.equalTo(self.contentView.snp_left).offset(-(self.contentView.frame.maxX))
			}
			
			UIView.animateWithDuration(0.5, delay: 0.0, options: [.CurveEaseOut], animations:  {
				self.firstContainer.layoutIfNeeded()
				self.secondContainer.layoutIfNeeded()
				self.thirdContainer.layoutIfNeeded()
				
				self.secondContainer.alpha = 1
				self.thirdContainer.alpha = 0
				}, completion: nil)
		
			self.registerActive = false
			DismissKeyboard()
		}
	}

}

