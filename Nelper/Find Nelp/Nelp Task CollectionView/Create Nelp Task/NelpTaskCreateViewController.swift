//
//  OfferCreateViewController.swift
//  Nelper
//
//  Created by Janic Duplessis on 2015-07-03.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import UIKit
import pop

protocol NelpTaskCreateViewControllerDelegate {
  func nelpTaskAdded(nelpTask: FindNelpTask) -> Void
}

class NelpTaskCreateViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, SecondFormViewControllerDelegate {
	
  var delegate: NelpTaskCreateViewControllerDelegate?
	var task: FindNelpTask!
	
	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var navBar: UIView!
	@IBOutlet weak var logoImage: UIImageView!
	
	@IBOutlet weak var nelpyTextBubble: UIImageView!
	@IBOutlet weak var nelpyText: UILabel!
	
	@IBOutlet weak var formView: UIView!
	@IBOutlet weak var titleTextField: UITextField!
	@IBOutlet weak var descriptionTextField: UITextView!
	
	
	@IBOutlet weak var nextButton: UIButton!
	

//INITIALIZATION
	
	convenience init() {
    self.init(nibName: "NelpTaskCreateViewController", bundle: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.task = FindNelpTask()
		self.titleTextField.delegate = self
		self.descriptionTextField.delegate = self
		self.nelpyText.alpha = 0
		self.nelpyTextBubble.alpha = 0
		self.nextButton.alpha = 0
		self.nelpyText.textColor = blackNelpyColor
		self.nelpyText.font = UIFont(name: "Railway", size: kTextFontSize)
		self.nelpyText.textAlignment = NSTextAlignment.Center
		self.nelpyTextBubble.image = UIImage(named: "bubble.png")
		self.nelpyText.text = "Please enter short title for your request. \n ( Ex: Install a wifi router.)"
		self.adjustUI()
		
		
		}
	
	override func viewDidAppear(animated: Bool) {
		UIView.animateWithDuration(0.4, animations:{self.nelpyText.alpha = 1}, completion: nil)
		UIView.animateWithDuration(0.4, animations:{self.nelpyTextBubble.alpha = 1}, completion: nil)
	}
	
	
//UI
	
	func adjustUI(){
		self.formView.backgroundColor = orangeSecondaryColor
		self.navBar.backgroundColor = orangeMainColor
		self.logoImage.image = UIImage(named: "logo_nobackground_v2")
		self.logoImage.contentMode = UIViewContentMode.ScaleAspectFit
		self.backButton.titleLabel?.font = UIFont(name: "Railway", size: kButtonFontSize)
		
		self.titleTextField.backgroundColor = whiteNelpyColor.colorWithAlphaComponent(0.2)
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
		
		self.nextButton.backgroundColor = orangeSecondaryColor
		self.nextButton.setTitle("NEXT", forState: UIControlState.Normal)
		self.nextButton.setTitleColor(whiteNelpyColor, forState: UIControlState.Normal)
		self.nextButton.titleLabel?.font = UIFont(name: "Railway", size: kTitleFontSize)
		

		
	}
	
//DELEGATE METHODS
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		self.descriptionTextField.backgroundColor = whiteNelpyColor.colorWithAlphaComponent(1)
		self.descriptionTextField.becomeFirstResponder()
		
		UIView.animateWithDuration(0.4, animations:{self.nelpyText.alpha = 0}, completion: nil)
		UIView.animateWithDuration(0.4, animations:{self.nelpyTextBubble.alpha = 0}, completion: nil)
		
		self.nelpyText.text = "Great! \n Now please enter a description of what you need to get done."
		
		UIView.animateWithDuration(0.4, animations:{self.nelpyText.alpha = 1}, completion: nil)
		UIView.animateWithDuration(0.4, animations:{self.nelpyTextBubble.alpha = 1}, completion: nil)
		
		return false
	}
	
	func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
		
		if(text == "\n") {
			textView.resignFirstResponder()
			UIView.animateWithDuration(0.4, animations:{self.nextButton.alpha = 1}, completion: nil)
			return false
		}
		return true
	}
	
//NELPTASK DELEGATE METHODS
	
	func nelpTaskAdded(nelpTask: FindNelpTask) {
		delegate?.nelpTaskAdded(nelpTask)
	}
	
	func dismiss(){
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	

//IBACTIONS
	
	@IBAction func backButtonTapped(sender: AnyObject) {
	
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	@IBAction func nextButtonTapped(sender: AnyObject) {
		
		self.task.title = self.titleTextField.text
		self.task.desc = self.descriptionTextField.text
		let nextScreenVC = SecondFormViewController(task: self.task)
		nextScreenVC.delegate = self
		self.presentViewController(nextScreenVC, animated: true, completion: nil)
		
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
