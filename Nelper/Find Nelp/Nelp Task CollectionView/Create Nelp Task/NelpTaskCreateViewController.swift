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
	var technologyButton: UIButton!
	var multimediaButton: UIButton!
	var handyworkButton: UIButton!
	var gardeningButton: UIButton!
	var businessButton: UIButton!
	var cleaningButton: UIButton!
	var otherButton: UIButton!
	
	@IBOutlet weak var navBar: NavBar!
	@IBOutlet weak var formView: UIView!
	

	//MARK: Initialization
	
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
	
	
	//MARK: UI
	
	func adjustUI(){
			
		self.formView.backgroundColor = whiteNelpyColor
		self.navBar.setTitle("Post a task")

}
	
	//MARK: View Creation

	func createView(){
		
		//Select your category label
		
		var selectCategoryLabel = UILabel()
		self.formView.addSubview(selectCategoryLabel);
		selectCategoryLabel.text = "Select your task category"
		selectCategoryLabel.textColor = blackNelpyColor
		selectCategoryLabel.font = UIFont(name: "HelveticaNeue", size: kFormViewLabelFontSize)
		
		selectCategoryLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.navBar.snp_bottom).offset(10)
			make.left.equalTo(self.formView.snp_left).offset(20)
		}
		
		//Technology Button + Label
		var technologyButton = UIButton()
		self.technologyButton = technologyButton
		self.formView.addSubview(self.technologyButton)
		self.technologyButton.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(selectCategoryLabel.snp_bottom).offset(20)
			make.centerX.equalTo(self.formView.snp_centerX).offset(-85)
			make.width.equalTo(65)
			make.height.equalTo(65)
		}
		self.technologyButton.addTarget(self, action: "technologyButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		self.technologyButton.setBackgroundImage(UIImage(named: "technology"), forState: UIControlState.Normal)

		
		
		var technologyLabel = UILabel()
		self.formView.addSubview(technologyLabel)
		technologyLabel.numberOfLines = 0
		technologyLabel.text = "Technology & IT\n Support"
		technologyLabel.font = UIFont(name: "HelveticaNeue", size: kTextFontSize)
		technologyLabel.textAlignment = NSTextAlignment.Center
		technologyLabel.textColor = blackNelpyColor
		
		technologyLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(technologyButton.snp_bottom).offset(6)
			make.centerX.equalTo(technologyButton.snp_centerX)
		}
		
		//Multimedia & Design
		var multimediaButton = UIButton()
		self.multimediaButton = multimediaButton
		self.multimediaButton.addTarget(self, action: "multimediaButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		self.formView.addSubview(multimediaButton)
		multimediaButton.setBackgroundImage(UIImage(named: "multimedia"), forState: UIControlState.Normal)
		multimediaButton.layer.cornerRadius = multimediaButton.frame.size.width / 2;
		
		multimediaButton.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(selectCategoryLabel.snp_bottom).offset(20)
			make.centerX.equalTo(self.formView.snp_centerX).offset(85)
			make.width.equalTo(65)
			make.height.equalTo(65)
		}
		
		var multimediaLabel = UILabel()
		self.formView.addSubview(multimediaLabel)
		multimediaLabel.numberOfLines = 0
		multimediaLabel.text = "Multimedia &\nDesign"
		multimediaLabel.font = UIFont(name: "HelveticaNeue", size: kTextFontSize)
		multimediaLabel.textAlignment = NSTextAlignment.Center
		multimediaLabel.textColor = blackNelpyColor
		
		multimediaLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(multimediaButton.snp_bottom).offset(6)
			make.centerX.equalTo(multimediaButton.snp_centerX)
		}
		
		//Handywork
		var handyworkButton = UIButton()
		self.handyworkButton = handyworkButton
		self.handyworkButton.addTarget(self, action: "handyworkButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		self.formView.addSubview(handyworkButton)
		handyworkButton.setBackgroundImage(UIImage(named: "handywork"), forState: UIControlState.Normal)
		handyworkButton.layer.cornerRadius = multimediaButton.frame.size.width / 2;
		handyworkButton.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(technologyLabel.snp_bottom).offset(20)
			make.centerX.equalTo(self.formView.snp_centerX).offset(-85)
			make.width.equalTo(65)
			make.height.equalTo(65)
		}
		
		var handyworkLabel = UILabel()
		self.formView.addSubview(handyworkLabel)
		handyworkLabel.numberOfLines = 0
		handyworkLabel.text = "Handywork"
		handyworkLabel.font = UIFont(name: "HelveticaNeue", size: kTextFontSize)
		handyworkLabel.textAlignment = NSTextAlignment.Center
		handyworkLabel.textColor = blackNelpyColor
		
		handyworkLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(handyworkButton.snp_bottom).offset(6)
			make.centerX.equalTo(handyworkButton.snp_centerX)
		}
		
		//Gardening
		var gardeningButton = UIButton()
		self.gardeningButton = gardeningButton
		self.gardeningButton.addTarget(self, action: "gardeningButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		self.formView.addSubview(gardeningButton)
		gardeningButton.setBackgroundImage(UIImage(named: "gardening"), forState: UIControlState.Normal)
		gardeningButton.layer.cornerRadius = multimediaButton.frame.size.width / 2;
		gardeningButton.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(multimediaLabel.snp_bottom).offset(20)
			make.centerX.equalTo(self.formView.snp_centerX).offset(85)
			make.width.equalTo(65)
			make.height.equalTo(65)
		}
		
		var gardeningLabel = UILabel()
		self.formView.addSubview(gardeningLabel)
		gardeningLabel.numberOfLines = 0
		gardeningLabel.text = "Gardening"
		gardeningLabel.font = UIFont(name: "HelveticaNeue", size: kTextFontSize)
		gardeningLabel.textAlignment = NSTextAlignment.Center
		gardeningLabel.textColor = blackNelpyColor
		
		gardeningLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(gardeningButton.snp_bottom).offset(6)
			make.centerX.equalTo(gardeningButton.snp_centerX)
		}
		
		//Business
		var businessButton = UIButton()
		self.businessButton = businessButton
		self.businessButton.addTarget(self, action: "businessButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		self.formView.addSubview(businessButton)
		businessButton.setBackgroundImage(UIImage(named: "business"), forState: UIControlState.Normal)
		businessButton.layer.cornerRadius = multimediaButton.frame.size.width / 2;
		businessButton.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(handyworkLabel.snp_bottom).offset(20)
			make.centerX.equalTo(self.formView.snp_centerX).offset(-85)
			make.width.equalTo(65)
			make.height.equalTo(65)
		}
		
		var businessLabel = UILabel()
		self.formView.addSubview(businessLabel)
		businessLabel.numberOfLines = 0
		businessLabel.text = "Business &\nAdmin"
		businessLabel.font = UIFont(name: "HelveticaNeue", size: kTextFontSize)
		businessLabel.textAlignment = NSTextAlignment.Center
		businessLabel.textColor = blackNelpyColor
		
		businessLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(businessButton.snp_bottom).offset(6)
			make.centerX.equalTo(businessButton.snp_centerX)
		}
		
		//Cleaning
		var cleaningButton = UIButton()
		self.cleaningButton = cleaningButton
		self.cleaningButton.addTarget(self, action: "cleaningButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		self.formView.addSubview(cleaningButton)
		cleaningButton.setBackgroundImage(UIImage(named: "housecleaning"), forState: UIControlState.Normal)
		cleaningButton.layer.cornerRadius = multimediaButton.frame.size.width / 2;
		cleaningButton.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(gardeningLabel.snp_bottom).offset(20)
			make.centerX.equalTo(self.formView.snp_centerX).offset(85)
			make.width.equalTo(65)
			make.height.equalTo(65)
		}
		
		var cleaningLabel = UILabel()
		self.formView.addSubview(cleaningLabel)
		cleaningLabel.numberOfLines = 0
		cleaningLabel.text = "Cleaning"
		cleaningLabel.font = UIFont(name: "HelveticaNeue", size: kTextFontSize)
		cleaningLabel.textAlignment = NSTextAlignment.Center
		cleaningLabel.textColor = blackNelpyColor
		
		cleaningLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(cleaningButton.snp_bottom).offset(6)
			make.centerX.equalTo(cleaningButton.snp_centerX)
		}
		
		//Other
		var otherButton = UIButton()
		self.otherButton = otherButton
		self.otherButton.addTarget(self, action: "otherButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		self.formView.addSubview(otherButton)
		otherButton.setBackgroundImage(UIImage(named: "other"), forState: UIControlState.Normal)
		otherButton.layer.cornerRadius = multimediaButton.frame.size.width / 2;
		otherButton.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(cleaningLabel.snp_bottom).offset(20)
			make.centerX.equalTo(self.formView.snp_centerX)
			make.width.equalTo(65)
			make.height.equalTo(65)
		}
		
		var otherLabel = UILabel()
		self.formView.addSubview(otherLabel)
		otherLabel.numberOfLines = 0
		otherLabel.text = "Other"
		otherLabel.font = UIFont(name: "HelveticaNeue", size: kTextFontSize)
		otherLabel.textAlignment = NSTextAlignment.Center
		otherLabel.textColor = blackNelpyColor
		
		otherLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(otherButton.snp_bottom).offset(6)
			make.centerX.equalTo(otherButton.snp_centerX)
		}

	}
	
	//MARK: Category Buttons
	func deselectAllButton(){
		self.multimediaButton.selected = false
		self.handyworkButton.selected = false
		self.businessButton.selected = false
		self.technologyButton.selected = false
		self.gardeningButton.selected = false
		self.cleaningButton.selected = false
	}
	
	func technologyButtonTapped(sender:UIButton){
		self.task.category = "technology"
		self.moveToNextView()
	}
	
	func multimediaButtonTapped(sender:UIButton){
		self.task.category = "multimedia"
		self.moveToNextView()
	}
	
	func handyworkButtonTapped(sender:UIButton){
		self.task.category = "handywork"
		self.moveToNextView()
	}
	
	func gardeningButtonTapped(sender:UIButton){
		self.task.category = "gardening"
		self.moveToNextView()
	}
	
	func businessButtonTapped(sender:UIButton){
		self.task.category = "business"
		self.moveToNextView()
	}
	
	func cleaningButtonTapped(sender:UIButton){
		self.task.category = "housecleaning"
		self.moveToNextView()
	}
	
	func otherButtonTapped(sender:UIButton){
		self.task.category = "other"
		self.moveToNextView()
	}

	func moveToNextView(){
		let nextScreenVC = SecondFormViewController(task: self.task)
		nextScreenVC.delegate = self
		self.presentViewController(nextScreenVC, animated: true, completion: nil)
	}
	
	
	//MARK: NelpTask Delegate Methods
	
	func nelpTaskAdded(nelpTask: FindNelpTask) {
		delegate?.nelpTaskAdded(nelpTask)
	}
	
	func dismiss(){
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	

	//MARK: Actions	
	
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
