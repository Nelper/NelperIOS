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

class NelpTaskCreateViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
  
  var nelpTasksStore: NelpTasksStore!
  var delegate: NelpTaskCreateViewControllerDelegate?
	
	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var navBar: UIView!
	@IBOutlet weak var logoImage: UIImageView!
	
	@IBOutlet weak var formView: UIView!
	@IBOutlet weak var titleTextField: UITextField!
	@IBOutlet weak var descriptionTextField: UITextView!
	

	
	
	
	convenience init() {
    self.init(nibName: "NelpTaskCreateViewController", bundle: nil)
		
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
		self.titleTextField.delegate = self
		self.descriptionTextField.delegate = self
		self.nelpTasksStore = NelpTasksStore()
		self.adjustUI()
		}
	
	func adjustUI(){
		self.formView.backgroundColor = orangeSecondaryColor
		self.navBar.backgroundColor = orangeMainColor
		self.logoImage.image = UIImage(named: "logo_nobackground_v2")
		self.logoImage.contentMode = UIViewContentMode.ScaleAspectFit
		self.backButton.titleLabel?.font = UIFont(name: "Railway", size: kButtonFontSize)
		
		self.titleTextField.backgroundColor = orangeSecondaryColor
		self.titleTextField.font = UIFont(name: "Railway", size: kTitleFontSize)
		self.titleTextField.textAlignment = NSTextAlignment.Center
		self.titleTextField.attributedPlaceholder = NSAttributedString(string:"Title",
			attributes:[NSForegroundColorAttributeName: whiteNelpyColor])
		self.titleTextField.becomeFirstResponder()
		self.titleTextField.tintColor = whiteNelpyColor
		self.titleTextField.textColor = blackNelpyColor
		
		self.descriptionTextField.backgroundColor = orangeMainColor.colorWithAlphaComponent(0)
		self.descriptionTextField.layer.cornerRadius = 6
		self.descriptionTextField.tintColor = orangeMainColor
		self.descriptionTextField.font = UIFont(name: "Railway", size: kTextFontSize)
		self.descriptionTextField.textColor = blackNelpyColor
		

		
	}
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		self.descriptionTextField.backgroundColor = whiteNelpyColor.colorWithAlphaComponent(1)
		self.descriptionTextField.becomeFirstResponder()
		return false
	}
	
	func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
		
		if(text == "\n") {
			textView.resignFirstResponder()
			return false
		}
		return true
	}
	
	
	@IBAction func backButtonTapped(sender: AnyObject) {
	
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
//	TODO: Additional verifications: price offered = numbers only etc
//	@IBAction func findNelpButtonTapped(sender: AnyObject) {
//		if(!self.titleTextField.text.isEmpty && !self.descriptionTextArea.text.isEmpty && !self.priceOfferedTextField.text.isEmpty){
//
//		let task = nelpTasksStore.createWithTitle(titleTextField.text, description: descriptionTextArea.text, priceOffered:priceOfferedTextField.text)
//			delegate?.nelpTaskAdded(task)
//			self.dismissViewControllerAnimated(true, completion: nil)
//	}

}
