//
//  SecondFormViewController.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-07-25.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation
import UIKit

protocol SecondFormViewControllerDelegate {
	func nelpTaskAdded(nelpTask: FindNelpTask) -> Void
	func dismiss()
}

class SecondFormViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate{
	
	var task: FindNelpTask!
	
	var delegate: SecondFormViewControllerDelegate?
	
	@IBOutlet weak var navBar: UIView!
	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var logoImage: UIImageView!
	
	@IBOutlet weak var nelpyTextBubble: UIImageView!
	@IBOutlet weak var nelpyText: UILabel!
	
	@IBOutlet weak var locationTextField: UITextField!
	@IBOutlet weak var priceOfferedTextField: UITextField!

	@IBOutlet weak var formBackground: UIView!
	
	@IBOutlet weak var categoriesBackground: UIView!
	@IBOutlet weak var technologyFilter: UIButton!
	@IBOutlet weak var houseCleaningFilter: UIButton!
	@IBOutlet weak var gardeningFilter: UIButton!
	@IBOutlet weak var cookingFilter: UIButton!
	@IBOutlet weak var handyMan: UIButton!
	
	@IBOutlet weak var postButton: UIButton!
	
	
	convenience init(task: FindNelpTask){
		self.init(nibName: "SecondFormScreen", bundle: nil)
		self.task = task
	}
	
	override func viewDidLoad() {
		self.nelpyText.alpha = 0
		self.nelpyTextBubble.alpha = 0
		self.priceOfferedTextField.alpha = 0
		self.nelpyText.textColor = blackNelpyColor
		self.nelpyText.font = UIFont(name: "Railway", size: kTextFontSize)
		self.nelpyText.textAlignment = NSTextAlignment.Center
		self.nelpyTextBubble.image = UIImage(named: "bubble.png")
		self.nelpyText.text = "Enter the postal code where the task needs to be done."
		self.adjustUI()
		
	}
	
	override func viewDidAppear(animated: Bool) {
	
		UIView.animateWithDuration(0.4, animations:{self.nelpyText.alpha = 1}, completion: nil)
		UIView.animateWithDuration(0.4, animations:{self.nelpyTextBubble.alpha = 1}, completion: nil)
		
	}
	
	func adjustUI(){
		self.navBar.backgroundColor = orangeMainColor
		self.logoImage.image = UIImage(named: "logo_nobackground_v2")
		self.backButton.titleLabel?.font = UIFont(name: "Railway", size: kButtonFontSize)
		self.formBackground.backgroundColor = orangeSecondaryColor
		
		self.locationTextField.backgroundColor = whiteNelpyColor.colorWithAlphaComponent(0.2)
		self.locationTextField.delegate = self
		self.locationTextField.font = UIFont(name: "Railway", size: kTitleFontSize)
		self.locationTextField.textAlignment = NSTextAlignment.Center
		self.locationTextField.attributedPlaceholder = NSAttributedString(string:"Postal Code",
			attributes:[NSForegroundColorAttributeName: whiteNelpyColor])
		self.locationTextField.becomeFirstResponder()
		self.locationTextField.tintColor = whiteNelpyColor
		self.locationTextField.textColor = blackNelpyColor
		
		self.priceOfferedTextField.backgroundColor = whiteNelpyColor.colorWithAlphaComponent(0.2)
		self.priceOfferedTextField.delegate = self
		self.priceOfferedTextField.font = UIFont(name: "Railway", size: kTitleFontSize)
		self.priceOfferedTextField.textAlignment = NSTextAlignment.Center
		self.priceOfferedTextField.attributedPlaceholder = NSAttributedString(string:"Price Offered",
			attributes:[NSForegroundColorAttributeName: whiteNelpyColor])
		self.priceOfferedTextField.becomeFirstResponder()
		self.priceOfferedTextField.tintColor = whiteNelpyColor
		self.priceOfferedTextField.textColor = blackNelpyColor
		
		self.categoriesBackground.backgroundColor = whiteNelpyColor.colorWithAlphaComponent(0.2)
		
		self.technologyFilter.backgroundColor = whiteNelpyColor.colorWithAlphaComponent(0.0)
		self.technologyFilter.setTitle("Technology", forState: UIControlState.Normal)
		self.technologyFilter.setTitleColor(whiteNelpyColor, forState: UIControlState.Normal)
		self.technologyFilter.setTitleColor(orangeMainColor, forState: UIControlState.Selected)
		self.technologyFilter.titleLabel?.font = UIFont(name: "Railway", size: kTextFontSize)
		
		self.houseCleaningFilter.backgroundColor = whiteNelpyColor.colorWithAlphaComponent(0.0)
		self.houseCleaningFilter.setTitle("House cleaning", forState: UIControlState.Normal)
		self.houseCleaningFilter.setTitleColor(whiteNelpyColor, forState: UIControlState.Normal)
		self.houseCleaningFilter.setTitleColor(orangeMainColor, forState: UIControlState.Selected)
		self.houseCleaningFilter.titleLabel?.font = UIFont(name: "Railway", size: kTextFontSize)
		
		self.handyMan.backgroundColor = whiteNelpyColor.colorWithAlphaComponent(0.0)
		self.handyMan.setTitle("Handyman", forState: UIControlState.Normal)
		self.handyMan.setTitleColor(whiteNelpyColor, forState: UIControlState.Normal)
		self.handyMan.setTitleColor(orangeMainColor, forState: UIControlState.Selected)
		self.handyMan.titleLabel?.font = UIFont(name: "Railway", size: kTextFontSize)
		
		self.gardeningFilter.backgroundColor = whiteNelpyColor.colorWithAlphaComponent(0.0)
		self.gardeningFilter.setTitle("Gardening", forState: UIControlState.Normal)
		self.gardeningFilter.setTitleColor(whiteNelpyColor, forState: UIControlState.Normal)
		self.gardeningFilter.setTitleColor(orangeMainColor, forState: UIControlState.Selected)
		self.gardeningFilter.titleLabel?.font = UIFont(name: "Railway", size: kTextFontSize)
		
		self.cookingFilter.backgroundColor = whiteNelpyColor.colorWithAlphaComponent(0.0)
		self.cookingFilter.setTitle("Cooking", forState: UIControlState.Normal)
		self.cookingFilter.setTitleColor(whiteNelpyColor, forState: UIControlState.Normal)
		self.cookingFilter.setTitleColor(orangeMainColor, forState: UIControlState.Selected)
		self.cookingFilter.titleLabel?.font = UIFont(name: "Railway", size: kTextFontSize)
		
		self.categoriesBackground.alpha = 0
		
		self.postButton.backgroundColor = orangeSecondaryColor
		self.postButton.setTitle("Ask for nelp!", forState: UIControlState.Normal)
		self.postButton.setTitleColor(whiteNelpyColor, forState: UIControlState.Normal)
		self.postButton.titleLabel?.font = UIFont(name: "Railway", size: kTitleFontSize)
		self.postButton.layer.borderWidth = 2
		self.postButton.layer.cornerRadius = 6
		self.postButton.layer.borderColor = whiteNelpyColor.CGColor
		
		self.postButton.alpha = 0
	}
	
	//TextFieldDelegate
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		
		if(textField == locationTextField){
		self.priceOfferedTextField.alpha = 1
		self.priceOfferedTextField.becomeFirstResponder()
		
		UIView.animateWithDuration(0.4, animations:{self.nelpyText.alpha = 0}, completion: nil)
		UIView.animateWithDuration(0.4, animations:{self.nelpyTextBubble.alpha = 0}, completion: nil)
		
		self.nelpyText.text = "Now that I know where you are, tell me how much you are willing to pay :D ."
		
		UIView.animateWithDuration(0.4, animations:{self.nelpyText.alpha = 1}, completion: nil)
		UIView.animateWithDuration(0.4, animations:{self.nelpyTextBubble.alpha = 1}, completion: nil)
		}else if(textField == priceOfferedTextField){
			
			UIView.animateWithDuration(0.4, animations:{self.nelpyText.alpha = 0}, completion: nil)
			UIView.animateWithDuration(0.4, animations:{self.nelpyTextBubble.alpha = 0}, completion: nil)
			
			self.nelpyText.text = "Amazing!\n Last step. Select a category for your task and we're done!"
			
			UIView.animateWithDuration(0.4, animations:{self.nelpyText.alpha = 1}, completion: nil)
			UIView.animateWithDuration(0.4, animations:{self.nelpyTextBubble.alpha = 1}, completion: nil)
			
			self.categoriesBackground.alpha = 1
			self.postButton.alpha = 1
			
		}
		return false
	}
	
	//IBACTIONS
	
	@IBAction func backButtonTapped(sender: AnyObject) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	
	
	@IBAction func postButtonTapped(sender: AnyObject) {
		self.task.priceOffered = priceOfferedTextField.text
    //TODO: set location using GeoPoint
		//self.task.location = locationTextField.text
		
		let taskComplete = ParseHelper.createWithTitle(self.task.title, description: self.task.desc, priceOffered:self.task.priceOffered!)
		
		delegate?.nelpTaskAdded(taskComplete)
		self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	
	
	
}
