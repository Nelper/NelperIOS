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
    PFFacebookUtils.logInWithPermissions(self.permissions, block: { (user: PFUser?, error: NSError?) -> Void in
      if error != nil {
        self.handleFBLoginError(error!)
        return
      }
      
      if user!.isNew {
        NSLog("User signed up and logged in through Facebook!")
        self.getFBUserInfo()
      } else {
        NSLog("User logged in through Facebook! \(user!.username)")
        self.getFBUserInfo()
      }
    })
  }

  func getFBUserInfo() {
    FBRequestConnection.startForMeWithCompletionHandler { (conn:FBRequestConnection!, user:AnyObject!, error:NSError!) -> Void in
      if error != nil {
        self.loginCompleted()
      } else {
        PFUser.currentUser()!.setValue(user.name, forKey: "name")
        PFUser.currentUser()!.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
          self.loginCompleted()
        })
      }
    }
  }
  
  func loginCompleted() {
    delegate?.onLogin()
  }
  
  func handleFBLoginError(error: NSError) {
    var alertMessage,
    alertTitle: String?
    var errorCategory = FBErrorUtility.errorCategoryForError(error)
    if FBErrorUtility.shouldNotifyUserForError(error) {
      // If the SDK has a message for the user, show it.
      alertTitle = "Something Went Wrong"
      alertMessage = FBErrorUtility.userMessageForError(error)
    } else if errorCategory == FBErrorCategory.AuthenticationReopenSession {
      // It is important to handle session closures. We notify the user.
      alertTitle = "Session Error"
      alertMessage = "Your current session is no longer valid. Please log in again."
    } else if errorCategory == FBErrorCategory.UserCancelled {
      NSLog("user cancelled login")
    } else {
      // Handle all other errors in a generic fashion
      alertTitle  = "Unknown Error"
      alertMessage = "Error. Please try again later."
    }
    
    if alertMessage != nil {
      var alert = UIAlertController(title: alertTitle, message: alertMessage,preferredStyle: UIAlertControllerStyle.Alert)
      self.presentViewController(alert, animated: true, completion: nil)
    }
  }
}

