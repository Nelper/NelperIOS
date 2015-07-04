//
//  OfferCreateViewController.swift
//  Nelper
//
//  Created by Janic Duplessis on 2015-07-03.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import UIKit

class OfferCreateViewController: UIViewController {
  
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var descriptionTextView: UITextView!
  
  var offerStore: OfferStore!
  
  convenience init(offerStore: OfferStore) {
    self.init(nibName: "OfferCreateViewController", bundle: nil)
    
    self.offerStore = offerStore
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "onDoneClicked")
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "onCancelClicked")
    
    self.title = "New offer"
    
    titleTextField.layer.cornerRadius = 5
    titleTextField.layer.borderColor = UIColor.lightGrayColor().CGColor
    titleTextField.layer.borderWidth = 1
    
    descriptionTextView.layer.cornerRadius = 5
    descriptionTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
    descriptionTextView.layer.borderWidth = 1
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func onDoneClicked() {
    
    offerStore.createWithTitle(titleTextField.text, description: descriptionTextView.text)
    
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func onCancelClicked() {
    self.navigationController?.popViewControllerAnimated(true)
  }
  
}
