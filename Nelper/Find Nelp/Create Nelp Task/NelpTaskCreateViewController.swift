//
//  OfferCreateViewController.swift
//  Nelper
//
//  Created by Janic Duplessis on 2015-07-03.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import UIKit

protocol NelpTaskCreateViewControllerDelegate {
  func nelpTaskAdded(nelpTask: NelpTask) -> Void
}

class NelpTaskCreateViewController: UIViewController {
  
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var descriptionTextView: UITextView!
  
  var nelpTasksStore: NelpTasksStore!
  var delegate: NelpTaskCreateViewControllerDelegate?
  
  convenience init(nelpTasksStore: NelpTasksStore) {
    self.init(nibName: "NelpTaskCreateViewController", bundle: nil)
    
    self.nelpTasksStore = nelpTasksStore
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "onDoneClicked")
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "onCancelClicked")
    
    self.title = "New task"
    
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
    
    let title = titleTextField.text
    let desc = descriptionTextView.text
    
    if title.isEmpty || desc.isEmpty {
      return
    }
    
    let nelpTask = nelpTasksStore.createWithTitle(titleTextField.text, description: descriptionTextView.text)
    
    self.navigationController?.popViewControllerAnimated(true)
    
    delegate?.nelpTaskAdded(nelpTask)
  }
  
  func onCancelClicked() {
    self.navigationController?.popViewControllerAnimated(true)
  }
  
}
