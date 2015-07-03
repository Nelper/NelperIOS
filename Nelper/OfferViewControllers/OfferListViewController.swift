//
//  OfferViewController.swift
//  Nelper
//
//  Created by Janic Duplessis on 2015-06-24.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import UIKit

class OfferListViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()

    self.title = "Offer"
    
    let addButton = UIBarButtonItem(title: "new", style: UIBarButtonItemStyle.Plain, target: self, action: "onAddButtonClick")
    self.navigationItem.rightBarButtonItem = addButton;
  }
  
  func onAddButtonClick() {
    performSegueWithIdentifier("offer_create", sender: self)
  }

}

