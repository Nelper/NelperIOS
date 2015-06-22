//
//  LoginViewController.swift
//  Nelper
//
//  Created by Janic Duplessis on 2015-06-21.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
  
  let permissions = ["public_profile"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func loginWithFacebook(sender: UIButton) {
    PFFacebookUtils.logInWithPermissions(self.permissions, block: { (user: PFUser?, error: NSError?) -> Void in
      if user == nil {
        NSLog("Uh oh. The user cancelled the Facebook login.")
      } else if user!.isNew {
        NSLog("User signed up and logged in through Facebook!")
      } else {
        NSLog("User logged in through Facebook! \(user!.username)")
      }
    })
  }

}

