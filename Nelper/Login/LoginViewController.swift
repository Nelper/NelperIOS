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
  
  let permissions = ["public_profile"]
  
  var delegate: LoginViewControllerDelegate?
  
  convenience init() {
    self.init(nibName: "LoginViewController", bundle: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
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

  func getFBUserInfo() {
    let request = FBSDKGraphRequest(graphPath: "me", parameters: nil)
    request.startWithCompletionHandler { (conn:FBSDKGraphRequestConnection!, user:AnyObject!, error:NSError!) -> Void in
      if error != nil {
        self.loginCompleted()
      } else {
        PFUser.currentUser()!.setValue(user.valueForKey("name"), forKey: "name")
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

