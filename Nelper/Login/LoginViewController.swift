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

class LoginViewController: UIViewController {
	
	@IBOutlet weak var logoImage: UIImageView!
	
	@IBOutlet weak var nelperLabel: UILabel!
	
	@IBOutlet weak var facebookLoginButton: UIButton!
	
	@IBOutlet weak var skipButton: UIButton!
	
	@IBOutlet weak var container: UIView!
  
  let permissions = ["public_profile"]
  
  var delegate: LoginViewControllerDelegate?
  
	
	
	//Initialization
	
	convenience init() {
    self.init(nibName: "LoginViewController", bundle: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
			self.adjustUI()
	}
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
	
	
	//UI
	
	func adjustUI(){
		
		self.logoImage.image = UIImage(named: "logo_nobackground_v2")
		self.logoImage.contentMode = UIViewContentMode.ScaleAspectFill
		
		var gradient: CAGradientLayer = CAGradientLayer()
		gradient.frame = view.bounds
		gradient.colors = [orangeSecondaryGradientColor.CGColor, orangeMainGradientColor.CGColor]
		self.container.layer.insertSublayer(gradient, atIndex: 0)
		
		
		
		
		self.nelperLabel.text = "Nelper"
		self.nelperLabel.textColor = whiteNelpyColor
		self.nelperLabel.font = UIFont(name: "Railway", size: kLoginScreenFontSize)
		
		
		self.facebookLoginButton.backgroundColor = facebookBlueColor
		self.facebookLoginButton.layer.cornerRadius = 6
		self.facebookLoginButton.setTitle("Login with Facebook", forState: UIControlState.Normal)
		self.facebookLoginButton.setTitleColor(whiteNelpyColor, forState: UIControlState.Normal)
		self.facebookLoginButton.titleLabel?.font = UIFont(name: "Railway", size: kSubtitleFontSize)
		self.facebookLoginButton.layer.borderColor = blackNelpyColor.CGColor
		self.facebookLoginButton.layer.borderWidth = 2
		self.facebookLoginButton.setImage(UIImage(named: "facebookButtonIcon"), forState: UIControlState.Normal)
		self.facebookLoginButton.imageEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0)
		
		self.skipButton.backgroundColor = whiteNelpyColor
		self.skipButton.layer.cornerRadius = 6
		self.skipButton.setTitle("Mmm, maybe later", forState: UIControlState.Normal)
		self.skipButton.setTitleColor(whiteNelpyColor, forState: UIControlState.Normal)
		self.skipButton.titleLabel?.font = UIFont(name: "Railway", size: kSubtitleFontSize)
		self.skipButton.layer.borderColor = UIColor.blackColor().CGColor
		self.skipButton.layer.borderWidth = 2
		
		
	}
	
	//IBActions
  
  @IBAction func facebookLogin(sender: UIButton) {
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
	
	@IBAction func skipLogin(sender: AnyObject) {
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
				
				var currentUser = PFUser.currentUser()!
				var fbID = results["id"] as AnyObject? as! String
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
    delegate?.onLogin()
  }
}

