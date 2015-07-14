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
  
  var nelpTasksStore: NelpTasksStore!
  var delegate: NelpTaskCreateViewControllerDelegate?
	
	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var navBar: UIView!
	@IBOutlet weak var formView: UIView!
	@IBOutlet weak var logoImage: UIImageView!
	@IBOutlet weak var titleTextField: UITextField!
	@IBOutlet weak var priceOfferedTextField: UITextField!
	@IBOutlet weak var descriptionTextArea: UITextView!
	

	
	convenience init() {
    self.init(nibName: "NelpTaskCreateViewController", bundle: nil)
		
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
		self.nelpTasksStore = NelpTasksStore()
		self.adjustUI()
		}
	
	func adjustUI(){
		self.formView.backgroundColor = fireColor
		self.navBar.backgroundColor = fireColor
		self.logoImage.image = UIImage(named: "logo_nobackground_v2")
		
	}
	
	@IBAction func backButtonTapped(sender: AnyObject) {
	
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	//TODO: Additional verifications: price offered = numbers only etc
	@IBAction func postButtonTapped(sender: AnyObject) {
//		if(!self.titleTextField.text.isEmpty && !self.descriptionTextArea.text.isEmpty && !self.priceOfferedTextField.text.isEmpty){

		let task = nelpTasksStore.createWithTitle(titleTextField.text, description: descriptionTextArea.text, priceOffered:priceOfferedTextField.text)
			delegate?.nelpTaskAdded(task)
			self.dismissViewControllerAnimated(true, completion: nil)
	}
//  func onDoneClicked() {
//		
//    
//    let nelpTask = nelpTasksStore.createWithTitle(titleTextField.text, description: descriptionTextView.text)
//    
//    delegate?.nelpTaskAdded(nelpTask)
//  }
	
}
