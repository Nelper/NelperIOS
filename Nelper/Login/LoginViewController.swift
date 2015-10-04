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
	var arrow: UIButton!
	var registerButton: UIButton!
	var forgotPassButton: UIButton!
	
	var emailActive = false
	
	var keyboardIsShowing: Bool = false
	
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
		/*
		NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
		*/
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
		
		//MARK: FIRST: BUTTONS
		
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
		
		//MARK: SECOND: TEXTFIELDS
		
		let secondContainer = UIView()
		self.secondContainer = secondContainer
		self.contentView.addSubview(self.secondContainer)
		self.secondContainer.alpha = 0
		self.secondContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.logo.snp_bottom)
			make.left.equalTo(self.contentView.snp_right)
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
			make.top.equalTo(emailField.snp_bottom)
			make.centerX.equalTo(emailField.snp_centerX)
			make.width.equalTo(emailField.snp_width)
			make.height.equalTo(1)
		}
		
		let passwordField = UITextField()
		self.passwordField = passwordField
		self.secondContainer.addSubview(passwordField)
		self.passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: blackPrimary.colorWithAlphaComponent(0.50)])
		self.passwordField.font = UIFont(name: "Lato-Regular", size: kText15)
		self.passwordField.autocorrectionType = UITextAutocorrectionType.No
		self.emailField.autocapitalizationType = UITextAutocapitalizationType.None
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
		
		let arrow = UIButton()
		self.arrow = arrow
		self.secondContainer.addSubview(self.arrow)
		self.arrow.setImage(UIImage(named: "left-white-arrow"), forState: UIControlState.Normal)
		self.arrow.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 45, 50)
		self.arrow.addTarget(self, action: "didTapEmailButton:", forControlEvents: UIControlEvents.TouchUpInside)
		self.arrow.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.secondContainer.snp_top)
			make.left.equalTo(self.emailField.snp_left)
			make.height.equalTo(70)
			make.width.equalTo(70)
		}
		
		let registerButton = UIButton()
		self.registerButton = registerButton
		self.secondContainer.addSubview(self.registerButton)
		self.registerButton.layer.borderColor = whitePrimary.CGColor
		self.registerButton.layer.borderWidth = 1
		self.registerButton.setTitle("Register", forState: UIControlState.Normal)
		self.registerButton.setTitleColor(whitePrimary, forState: UIControlState.Normal)
		self.registerButton.titleLabel?.font = UIFont(name: "Lato-Regular", size: kTitle17)
		self.registerButton.addTarget(self, action: "registerAccount:", forControlEvents: UIControlEvents.TouchUpInside)
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
	}
	
	func adjustUI(){
		
	}
	
	// Elements animation (fade in)
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
	}
	
	//MARK: KEYBOARD VIEW MOVER
	/*
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
	*/
	
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
	
	func registerAccount(sender: UIButton) {
		
	}
		
	func forgotPassword(sender: UIButton) {
		
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
	
	func didTapEmailButton(sender: UIButton) {
		
		if self.emailActive == false {
			
			self.firstContainer.snp_updateConstraints { (make) -> Void in
				make.left.equalTo(self.contentView.snp_left).offset(-(self.contentView.frame.maxX))
			}
			self.secondContainer.snp_updateConstraints { (make) -> Void in
				make.left.equalTo(self.contentView.snp_right).offset(-(self.contentView.frame.maxX))
			}
			
			
			UIView.animateWithDuration(0.5, delay: 0.0, options: [.CurveEaseOut], animations:  {
				self.firstContainer.layoutIfNeeded()
				self.secondContainer.layoutIfNeeded()
				
				self.firstContainer.alpha = 0
				self.secondContainer.alpha = 1
			}, completion: nil)
			
			self.emailActive = true
			DismissKeyboard()
			
		} else {
			
			self.firstContainer.snp_updateConstraints { (make) -> Void in
				make.left.equalTo(self.contentView.snp_left)
			}
			self.secondContainer.snp_updateConstraints { (make) -> Void in
				make.left.equalTo(self.contentView.snp_right)
			}
			
			
			UIView.animateWithDuration(0.5, delay: 0.0, options: [.CurveEaseOut], animations:  {
				self.firstContainer.layoutIfNeeded()
				self.secondContainer.layoutIfNeeded()
				
				self.firstContainer.alpha = 1
				self.secondContainer.alpha = 0
			}, completion: nil)
			
			self.emailActive = false
			DismissKeyboard()
		}
		
	}

}

