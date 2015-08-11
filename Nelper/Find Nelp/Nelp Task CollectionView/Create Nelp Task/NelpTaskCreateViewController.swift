//
//  OfferCreateViewController.swift
//  Nelper
//
//  Created by Janic Duplessis on 2015-07-03.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import UIKit

protocol NelpTaskCreateViewControllerDelegate {
  func nelpTaskAdded(nelpTask: FindNelpTask) -> Void
}

class NelpTaskCreateViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, SecondFormViewControllerDelegate {
	
  var delegate: NelpTaskCreateViewControllerDelegate?
	var task: FindNelpTask!
	
	@IBOutlet weak var navBar: NavBar!
	@IBOutlet weak var formView: UIView!


	
	
	@IBOutlet weak var nextButton: UIButton!
	

//INITIALIZATION
	
	convenience init() {
    self.init(nibName: "NelpTaskCreateViewController", bundle: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.task = FindNelpTask()
	  self.createView()
		self.adjustUI()
		
		
		}
	
	override func viewDidAppear(animated: Bool) {

	}
	
	
//UI
	
	func adjustUI(){
		let backBtn = UIButton()
		backBtn.addTarget(self, action: "backButtonTapped", forControlEvents: UIControlEvents.TouchUpInside)
		self.navBar.backButton = backBtn
		
		self.formView.backgroundColor = whiteNelpyColor
}
	
	func createView(){
		
		//Select your category label
		
		var selectCategoryLabel = UILabel()
		self.formView.addSubview(selectCategoryLabel);
		selectCategoryLabel.text = "Select your task category"
		selectCategoryLabel.textColor = blackNelpyColor
		selectCategoryLabel.font = UIFont(name: "ABeeZee-Regular", size: kSubtitleFontSize)
		
		selectCategoryLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.navBar.snp_bottom).offset(24)
			make.left.equalTo(self.formView.snp_left).offset(20)
		}
		
		//Technology Button + Label
		var technologyButton = UIButton()
		self.formView.addSubview(technologyButton)
		technologyButton.setBackgroundImage(UIImage(named: "technology"), forState: UIControlState.Normal)
		technologyButton.layer.cornerRadius = technologyButton.frame.size.width / 2;
		technologyButton.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(selectCategoryLabel.snp_bottom).offset(24)
			make.centerX.equalTo(self.formView.snp_centerX).offset(-85)
			make.width.equalTo(65)
			make.height.equalTo(65)
		}
		
		var technologyLabel = UILabel()
		self.formView.addSubview(technologyLabel)
		technologyLabel.numberOfLines = 0
		technologyLabel.text = "Technology & IT\n Support"
		technologyLabel.font = UIFont(name: "ABeeZee-Regular", size: kTextFontSize)
		technologyLabel.textAlignment = NSTextAlignment.Center
		technologyLabel.textColor = blackNelpyColor
		
		technologyLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(technologyButton.snp_bottom).offset(6)
			make.centerX.equalTo(technologyButton.snp_centerX)
		}
		
		//Multimedia & Design
		var multimediaButton = UIButton()
		self.formView.addSubview(multimediaButton)
		multimediaButton.setBackgroundImage(UIImage(named: "multimedia"), forState: UIControlState.Normal)
		multimediaButton.layer.cornerRadius = multimediaButton.frame.size.width / 2;
		multimediaButton.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(selectCategoryLabel.snp_bottom).offset(24)
			make.centerX.equalTo(self.formView.snp_centerX).offset(85)
			make.width.equalTo(65)
			make.height.equalTo(65)
		}
		
		var multimediaLabel = UILabel()
		self.formView.addSubview(multimediaLabel)
		multimediaLabel.numberOfLines = 0
		multimediaLabel.text = "Multimedia &\nDesign"
		multimediaLabel.font = UIFont(name: "ABeeZee-Regular", size: kTextFontSize)
		multimediaLabel.textAlignment = NSTextAlignment.Center
		multimediaLabel.textColor = blackNelpyColor
		
		multimediaLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(multimediaButton.snp_bottom).offset(6)
			make.centerX.equalTo(multimediaButton.snp_centerX)
		}
		
		//Handywork
		var handyworkButton = UIButton()
		self.formView.addSubview(handyworkButton)
		handyworkButton.setBackgroundImage(UIImage(named: "handywork"), forState: UIControlState.Normal)
		handyworkButton.layer.cornerRadius = multimediaButton.frame.size.width / 2;
		handyworkButton.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(technologyLabel.snp_bottom).offset(10)
			make.centerX.equalTo(self.formView.snp_centerX).offset(-85)
			make.width.equalTo(65)
			make.height.equalTo(65)
		}
		
		var handyworkLabel = UILabel()
		self.formView.addSubview(handyworkLabel)
		handyworkLabel.numberOfLines = 0
		handyworkLabel.text = "Handywork"
		handyworkLabel.font = UIFont(name: "ABeeZee-Regular", size: kTextFontSize)
		handyworkLabel.textAlignment = NSTextAlignment.Center
		handyworkLabel.textColor = blackNelpyColor
		
		handyworkLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(handyworkButton.snp_bottom).offset(6)
			make.centerX.equalTo(handyworkButton.snp_centerX)
		}
		
		//Gardening
		var gardeningButton = UIButton()
		self.formView.addSubview(gardeningButton)
		gardeningButton.setBackgroundImage(UIImage(named: "gardening"), forState: UIControlState.Normal)
		gardeningButton.layer.cornerRadius = multimediaButton.frame.size.width / 2;
		gardeningButton.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(technologyLabel.snp_bottom).offset(10)
			make.centerX.equalTo(self.formView.snp_centerX).offset(85)
			make.width.equalTo(65)
			make.height.equalTo(65)
		}
		
		var gardeningLabel = UILabel()
		self.formView.addSubview(gardeningLabel)
		gardeningLabel.numberOfLines = 0
		gardeningLabel.text = "Gardening"
		gardeningLabel.font = UIFont(name: "ABeeZee-Regular", size: kTextFontSize)
		gardeningLabel.textAlignment = NSTextAlignment.Center
		gardeningLabel.textColor = blackNelpyColor
		
		gardeningLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(gardeningButton.snp_bottom).offset(6)
			make.centerX.equalTo(gardeningButton.snp_centerX)
		}
		
		//Business
		var businessButton = UIButton()
		self.formView.addSubview(businessButton)
		businessButton.setBackgroundImage(UIImage(named: "business"), forState: UIControlState.Normal)
		businessButton.layer.cornerRadius = multimediaButton.frame.size.width / 2;
		businessButton.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(handyworkLabel.snp_bottom).offset(10)
			make.centerX.equalTo(self.formView.snp_centerX).offset(-85)
			make.width.equalTo(65)
			make.height.equalTo(65)
		}
		
		var businessLabel = UILabel()
		self.formView.addSubview(businessLabel)
		businessLabel.numberOfLines = 0
		businessLabel.text = "Business &\nAdmin"
		businessLabel.font = UIFont(name: "ABeeZee-Regular", size: kTextFontSize)
		businessLabel.textAlignment = NSTextAlignment.Center
		businessLabel.textColor = blackNelpyColor
		
		businessLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(businessButton.snp_bottom).offset(6)
			make.centerX.equalTo(businessButton.snp_centerX)
		}
		
		//Cleaning
		var cleaningButton = UIButton()
		self.formView.addSubview(cleaningButton)
		cleaningButton.setBackgroundImage(UIImage(named: "housecleaning"), forState: UIControlState.Normal)
		cleaningButton.layer.cornerRadius = multimediaButton.frame.size.width / 2;
		cleaningButton.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(gardeningLabel.snp_bottom).offset(10)
			make.centerX.equalTo(self.formView.snp_centerX).offset(85)
			make.width.equalTo(65)
			make.height.equalTo(65)
		}
		
		var cleaningLabel = UILabel()
		self.formView.addSubview(cleaningLabel)
		cleaningLabel.numberOfLines = 0
		cleaningLabel.text = "Cleaning"
		cleaningLabel.font = UIFont(name: "ABeeZee-Regular", size: kTextFontSize)
		cleaningLabel.textAlignment = NSTextAlignment.Center
		cleaningLabel.textColor = blackNelpyColor
		
		cleaningLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(cleaningButton.snp_bottom).offset(6)
			make.centerX.equalTo(cleaningButton.snp_centerX)
		}
		
		//Next Button
		var nextButton = UIButton()
		self.formView.addSubview(nextButton)
		nextButton.backgroundColor = whiteNelpyColor
		nextButton.setTitle("NEXT", forState: UIControlState.Normal)
		nextButton.setTitleColor(orangeTextColor, forState: UIControlState.Normal)
		nextButton.titleLabel?.font = UIFont(name: "ABeeZee-Regular", size: kSubtitleFontSize)
		nextButton.layer.borderWidth = 2
		nextButton.layer.borderColor = orangeTextColor.CGColor
		nextButton.layer.cornerRadius = 6
		
		nextButton.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(self.formView.snp_bottom).offset(-40)
			make.centerX.equalTo(self.formView.snp_centerX)
			make.width.equalTo(160)
			make.height.equalTo(40)
		}

	}
	
	
//NELPTASK DELEGATE METHODS
	
	func nelpTaskAdded(nelpTask: FindNelpTask) {
		delegate?.nelpTaskAdded(nelpTask)
	}
	
	func dismiss(){
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	

//IBACTIONS
	
	func backButtonTapped() {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	@IBAction func nextButtonTapped(sender: AnyObject) {
		
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
