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
	
	var buttonsContainer: UIView!
	
	var fbButton: UIButton!
	var fbLogo: UIImageView!
	var emailButton: UIButton!
	
	//var emailField: UITextField!
	//var passwordField: UITextField!
	
	//MARK: Initialization
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.createView()
		self.adjustUI()
		
		// KEYBOARD DISMISS
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
		self.tap = tap
		self.contentView.addGestureRecognizer(tap)
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
			make.top.equalTo(self.contentView.snp_top).offset(80)
			make.centerX.equalTo(self.contentView.snp_centerX)
			make.width.equalTo(150)
			make.height.equalTo(150)
		}
		
		//MARK: FIRST: BUTTONS
		
		let buttonsContainer = UIView()
		self.buttonsContainer = buttonsContainer
		self.contentView.addSubview(self.buttonsContainer)
		self.buttonsContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.logo.snp_bottom).offset(40)
			make.left.equalTo(self.contentView.snp_left)
			make.right.equalTo(self.contentView.snp_right)
			make.height.equalTo(50 + 20 + 50)
		}
		
		let fbButton = UIButton()
		self.fbButton = fbButton
		self.buttonsContainer.addSubview(self.fbButton)
		self.fbButton.backgroundColor = blueFacebook
		self.fbButton.setTitle("Sign in with Facebook", forState: UIControlState.Normal)
		self.fbButton.setTitleColor(whitePrimary, forState: UIControlState.Normal)
		self.fbButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
		self.fbButton.titleLabel?.font = UIFont(name: "Lato-Regular", size: kTitle17)
		self.fbButton.imageEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0)
		self.fbButton.addTarget(self, action: "facebookLogin:", forControlEvents: UIControlEvents.TouchUpInside)
		self.fbButton.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.buttonsContainer.snp_top)
			make.left.equalTo(self.buttonsContainer.snp_left).offset(8)
			make.right.equalTo(self.buttonsContainer.snp_right).offset(-8)
			make.height.equalTo(50)
		}
		
		let fbLogo = UIImageView()
		self.fbLogo = fbLogo
		self.fbButton.addSubview(self.fbLogo)
		self.fbLogo.image = UIImage(named: "facebook_512_white")
		self.fbLogo.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(self.fbButton.snp_bottom).offset(9)
			make.left.equalTo(self.fbButton.snp_left).offset(0)
			make.width.equalTo(55)
			make.height.equalTo(55)
		}
		
		let emailButton = UIButton()
		self.emailButton = emailButton
		self.buttonsContainer.addSubview(self.emailButton)
		self.emailButton.backgroundColor = whitePrimary
		self.emailButton.setTitle("Email sign in", forState: UIControlState.Normal)
		self.emailButton.setTitleColor(whitePrimary, forState: UIControlState.Normal)
		self.emailButton.titleLabel?.font = UIFont(name: "Lato-Regular", size: kTitle17)
		self.emailButton.addTarget(self, action: "didTapEmailButton:", forControlEvents: UIControlEvents.TouchUpInside)
		self.emailButton.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.fbButton.snp_bottom).offset(20)
			make.left.equalTo(self.buttonsContainer.snp_left).offset(8)
			make.right.equalTo(self.buttonsContainer.snp_right).offset(-8)
			make.height.equalTo(50)
		}
		
		//MARK: SECOND: TEXTFIELDS
		
		/*let emailRegisterContainer = UIView()
		self.emailRegisterContainer = emailRegisterContainer
		self.emailField.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(logo.snp_bottom).offset(20)
			make.left.equalTo(contentView.snp_left).offset(8)
			make.right.equalTo(contentView.snp_right).offset(-8)
			make.height.equalTo(50)
		}
		
		let emailField = UITextField()
		self.emailField = emailField
		self.contentView.addSubview(emailField)
		self.emailField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: blackPrimary.colorWithAlphaComponent(0.75)])
		self.emailField.font = UIFont(name: "Lato-Regular", size: kText15)
		self.emailField.keyboardType = UIKeyboardType.EmailAddress
		self.emailField.backgroundColor = whitePrimary
		self.emailField.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(logo.snp_bottom).offset(20)
			make.left.equalTo(contentView.snp_left).offset(8)
			make.right.equalTo(contentView.snp_right).offset(-8)
			make.height.equalTo(50)
		}
		
		let passwordField = UITextField()
		self.passwordField = passwordField
		self.contentView.addSubview(passwordField)
		self.passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: blackPrimary.colorWithAlphaComponent(0.75)])
		self.passwordField.font = UIFont(name: "Lato-Regular", size: kText15)
		self.passwordField.keyboardType = UIKeyboardType.EmailAddress
		self.passwordField.backgroundColor = whitePrimary
		self.passwordField.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(passwordField.snp_bottom).offset(10)
			make.left.equalTo(contentView.snp_left).offset(8)
			make.right.equalTo(contentView.snp_right).offset(-8)
			make.height.equalTo(50)
		}*/
	}
	
	func adjustUI(){
		
		/*self.logoImage.image = UIImage(named: "logo_beige_nobackground_v2")
		self.logoImage.contentMode = UIViewContentMode.ScaleAspectFill
		
		self.container.backgroundColor = redPrimary
		
		self.nelperLabel.textColor = whiteBackground
		self.nelperLabel.text = "Nelper"
		self.nelperLabel.font = UIFont(name: "ABeeZee-Regular", size: kLoginScreenFontSize)
		
		self.emailField.layer.cornerRadius = 3
		self.emailField.layer.borderWidth = 2
		self.emailField.layer.borderColor = blackPrimary.CGColor
		
		self.passwordField.layer.cornerRadius = 3
		self.passwordField.layer.borderWidth = 2
		self.passwordField.layer.borderColor = blackPrimary.CGColor
		
		self.loginButton.setTitle("Login", forState: UIControlState.Normal)
		self.loginButton.titleLabel?.font = UIFont(name: "ABeeZee-Regular", size: kTitle17 + 2)
		
		self.facebookLoginButton.backgroundColor = blueFacebook
		self.facebookLoginButton.layer.cornerRadius = 3
		self.facebookLoginButton.setTitle("Sign in with Facebook", forState: UIControlState.Normal)
		self.facebookLoginButton.setTitleColor(whiteBackground, forState: UIControlState.Normal)
		self.facebookLoginButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
		self.facebookLoginButton.titleLabel?.font = UIFont(name: "ABeeZee-Regular", size: kTitle17)
		self.facebookLoginButton.layer.borderColor = blackPrimary.CGColor
		self.facebookLoginButton.layer.borderWidth = 2
		self.facebookLoginButton.imageEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0)
		
		let facebooklogo = UIImageView()
		facebooklogo.image = UIImage(named: "facebook_512_white")
		self.facebookLoginButton.addSubview(facebooklogo)
		facebooklogo.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(self.facebookLoginButton.snp_bottom).offset(9)
			make.left.equalTo(self.facebookLoginButton.snp_left).offset(0)
			make.width.equalTo(55)
			make.height.equalTo(55)
		}
		
		self.skipButton.backgroundColor = blackPrimary
		self.skipButton.layer.cornerRadius = 3
		self.skipButton.setTitle("Maybe later", forState: UIControlState.Normal)
		self.skipButton.setTitleColor(whiteBackground, forState: UIControlState.Normal)
		self.skipButton.titleLabel?.font = UIFont(name: "ABeeZee-Regular", size: kTitle17)
		self.skipButton.layer.borderColor = UIColor.blackColor().CGColor
		self.skipButton.layer.borderWidth = 2
		
		self.forgotPass.setTitle("I forgot my password", forState: UIControlState.Normal)
		*/
	}
	
	// Elements animation (fade in)
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
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
	
	func skipLogin(sender: AnyObject) {
		self.loginCompleted()
	}
	
	
	func loginClicked(sender: AnyObject) {
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
	}

}

