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
	
	@IBOutlet weak var newTaskContainer: UIView!
	@IBOutlet weak var newTaskTitle: UILabel!
	@IBOutlet weak var titleTextField: UITextField!
	
	@IBOutlet weak var categoriesContainer: UIView!
	@IBOutlet weak var categoriesTitle: UILabel!
	@IBOutlet weak var technologyButton: UIButton!
	@IBOutlet weak var handymanButton: UIButton!
	@IBOutlet weak var housecleaningButton: UIButton!
	@IBOutlet weak var gardeningButton: UIButton!
	@IBOutlet weak var cookingButton: UIButton!
	
	@IBOutlet weak var offeredContainer: UIView!
	@IBOutlet weak var offeringTitle: UILabel!
	@IBOutlet weak var priceOfferedTextField: UITextField!
	
	
	@IBOutlet weak var postalCodeTitle: UILabel!
	@IBOutlet weak var postalCodeContainer: UIView!
	@IBOutlet weak var postalCodeTextField: UITextField!
	

	@IBOutlet weak var descriptionContainer: UIView!
	@IBOutlet weak var brieflyTitle: UILabel!
	@IBOutlet weak var lookingForTitle: UILabel!
	@IBOutlet weak var descriptionTextArea: UITextView!
	
	@IBOutlet weak var findNelpButton: UIButton!
	
	
	convenience init() {
    self.init(nibName: "NelpTaskCreateViewController", bundle: nil)
		
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
		self.nelpTasksStore = NelpTasksStore()
		self.adjustUI()
		}
	
	func adjustUI(){
		self.formView.backgroundColor = orangeMainColor
		self.navBar.backgroundColor = orangeMainColor
		self.logoImage.image = UIImage(named: "logo_nobackground_v2")
		self.logoImage.contentMode = UIViewContentMode.ScaleAspectFit
		self.backButton.titleLabel?.font = UIFont(name: "Railway", size: kButtonFontSize)
		
		self.newTaskContainer.backgroundColor = orangeSecondaryColor
		self.newTaskTitle.font = UIFont(name: "Railway", size: kTitleFontSize)
		self.newTaskTitle.textColor = whiteNelpyColor
		self.titleTextField.layer.borderColor = orangeMainColor.CGColor
		self.titleTextField.backgroundColor = whiteNelpyColor
		
		self.categoriesContainer.backgroundColor = orangeSecondaryColor
		self.categoriesTitle.font = UIFont(name: "Railway", size: kSubtitleFontSize)
		self.categoriesTitle.textColor = whiteNelpyColor
		
		self.technologyButton.titleLabel?.font = UIFont(name: "Railway", size: kButtonFontSize)
		self.technologyButton.setTitleColor(whiteNelpyColor, forState: UIControlState.Normal)
		self.handymanButton.titleLabel?.font = UIFont(name: "Railway", size: kButtonFontSize)
		self.handymanButton.setTitleColor(whiteNelpyColor, forState: UIControlState.Normal)
		self.housecleaningButton.titleLabel?.font = UIFont(name: "Railway", size: kButtonFontSize)
		self.housecleaningButton.setTitleColor(whiteNelpyColor, forState: UIControlState.Normal)
		self.gardeningButton.titleLabel?.font = UIFont(name: "Railway", size: kButtonFontSize)
		self.gardeningButton.setTitleColor(whiteNelpyColor, forState: UIControlState.Normal)
		self.cookingButton.titleLabel?.font = UIFont(name: "Railway", size: kButtonFontSize)
		self.cookingButton.setTitleColor(whiteNelpyColor, forState: UIControlState.Normal)
		
		self.offeredContainer.backgroundColor = orangeSecondaryColor
		self.offeringTitle.font = UIFont(name: "Railway", size: kSubtitleFontSize)
		self.offeringTitle.textColor = whiteNelpyColor
		self.priceOfferedTextField.layer.borderColor = orangeMainColor.CGColor
		self.priceOfferedTextField.backgroundColor = whiteNelpyColor
		
		self.postalCodeContainer.backgroundColor = orangeSecondaryColor
		self.postalCodeTitle.font = UIFont(name: "Railway", size: kSubtitleFontSize)
		self.postalCodeTitle.textColor = whiteNelpyColor
		self.postalCodeTextField.layer.borderColor = orangeMainColor.CGColor
		self.postalCodeTextField.backgroundColor = whiteNelpyColor
		
		self.descriptionContainer.backgroundColor = orangeSecondaryColor
		self.brieflyTitle.font = UIFont(name:"Railway",size: kSubtitleFontSize)
		self.brieflyTitle.textColor = whiteNelpyColor
		self.lookingForTitle.font = UIFont(name:"Railway",size: kSubtitleFontSize)
		self.lookingForTitle.textColor = whiteNelpyColor
		self.descriptionTextArea.layer.borderColor = orangeMainColor.CGColor
		self.descriptionTextArea.backgroundColor = whiteNelpyColor
		
		self.findNelpButton.titleLabel?.font = UIFont(name: "RailWay", size: kSubtitleFontSize)
		self.findNelpButton.setTitleColor(whiteNelpyColor, forState: UIControlState.Normal)
		
	}
	
	@IBAction func backButtonTapped(sender: AnyObject) {
	
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	//TODO: Additional verifications: price offered = numbers only etc
	@IBAction func findNelpButtonTapped(sender: AnyObject) {
//		if(!self.titleTextField.text.isEmpty && !self.descriptionTextArea.text.isEmpty && !self.priceOfferedTextField.text.isEmpty){

		let task = nelpTasksStore.createWithTitle(titleTextField.text, description: descriptionTextArea.text, priceOffered:priceOfferedTextField.text)
			delegate?.nelpTaskAdded(task)
			self.dismissViewControllerAnimated(true, completion: nil)
	}

	
}
