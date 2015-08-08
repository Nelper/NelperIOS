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
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var forgotPass: UIButton!
    
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
        
        self.logoImage.image = UIImage(named: "logo_beige_nobackground_v2")
        self.logoImage.contentMode = UIViewContentMode.ScaleAspectFill
        
        var gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [orangeSecondaryGradientColor.CGColor, orangeMainGradientColor.CGColor]
        self.container.layer.insertSublayer(gradient, atIndex: 0)
        
        self.nelperLabel.textColor = whiteNelpyColor
        self.nelperLabel.font = UIFont(name: "ABeeZee-Regular", size: kLoginScreenFontSize)
        
        self.emailField.layer.cornerRadius = 3
        self.emailField.layer.borderWidth = 2
        self.emailField.layer.borderColor = blackNelpyColor.CGColor

        self.passwordField.layer.cornerRadius = 3
        self.passwordField.layer.borderWidth = 2
        self.passwordField.layer.borderColor = blackNelpyColor.CGColor
        
        self.loginButton.setTitle("Login", forState: UIControlState.Normal)
        self.loginButton.titleLabel?.font = UIFont(name: "ABeeZee-Regular", size: kButtonFontSize + 2)
        
        self.facebookLoginButton.backgroundColor = facebookBlueColor
        self.facebookLoginButton.layer.cornerRadius = 3
        self.facebookLoginButton.setTitle("Sign in with Facebook", forState: UIControlState.Normal)
        self.facebookLoginButton.setTitleColor(whiteNelpyColor, forState: UIControlState.Normal)
        self.facebookLoginButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        self.facebookLoginButton.titleLabel?.font = UIFont(name: "ABeeZee-Regular", size: kButtonFontSize)
        self.facebookLoginButton.layer.borderColor = blackNelpyColor.CGColor
        self.facebookLoginButton.layer.borderWidth = 2
        self.facebookLoginButton.imageEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0)
        
        var facebooklogo = UIImageView()
        facebooklogo.image = UIImage(named: "facebook_512_white")
        self.facebookLoginButton.addSubview(facebooklogo)
        facebooklogo.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(self.facebookLoginButton.snp_bottom).offset(9)
            make.left.equalTo(self.facebookLoginButton.snp_left).offset(0)
            make.width.equalTo(55)
            make.height.equalTo(55)
        }
        
        self.skipButton.backgroundColor = blackNelpyColor
        self.skipButton.layer.cornerRadius = 3
        self.skipButton.setTitle("Maybe later", forState: UIControlState.Normal)
        self.skipButton.setTitleColor(whiteNelpyColor, forState: UIControlState.Normal)
        self.skipButton.titleLabel?.font = UIFont(name: "ABeeZee-Regular", size: kButtonFontSize)
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
    
    
    @IBAction func loginClicked(sender: AnyObject) {
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

