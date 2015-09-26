//
//  OfferCreateViewController.swift
//  Nelper
//
//  Created by Janic Duplessis on 2015-07-03.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import UIKit

protocol PostTaskCategoriesViewControllerDelegate {
	func nelpTaskAdded(nelpTask: FindNelpTask) -> Void
}

class PostTaskCategoriesViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, PostTaskFormViewControllerDelegate {
	
	var delegate: PostTaskCategoriesViewControllerDelegate?
	var task: FindNelpTask!
	var technologyButton: UIButton!
	var multimediaButton: UIButton!
	var handyworkButton: UIButton!
	var gardeningButton: UIButton!
	var businessButton: UIButton!
	var cleaningButton: UIButton!
	var otherButton: UIButton!
	var scrollView:UIScrollView!
	var contentView:UIView!
	
	var kCategoryIconSize:CGFloat = 60
	
	//MARK: Initialization
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.task = FindNelpTask()
		self.createView()
	}
	
	override func viewDidAppear(animated: Bool) {
		self.scrollView.contentSize = self.contentView.frame.size
	}
	
	//MARK: UI
	
	//MARK: View Creation
	
	func createView(){
		
		let navBar = NavBar()
		self.view.addSubview(navBar)
		navBar.setTitle("Post a task")
		navBar.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.view.snp_top)
			make.right.equalTo(self.view.snp_right)
			make.left.equalTo(self.view.snp_left)
			make.height.equalTo(64)
		}
		
		//ScrollView + ContentView
		
		let backgroundView = UIView()
		backgroundView.backgroundColor = whiteNelpyColor
		self.view.addSubview(backgroundView)
		backgroundView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(navBar.snp_bottom)
			make.left.equalTo(self.view.snp_left)
			make.right.equalTo(self.view.snp_right)
			make.bottom.equalTo(self.view.snp_bottom)
		}
		
		let scrollView = UIScrollView()
		self.scrollView = scrollView
		backgroundView.addSubview(scrollView)
		scrollView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(backgroundView.snp_edges)
		}
		
		let contentView = UIView()
		self.contentView = contentView
		scrollView.addSubview(contentView)
		contentView.backgroundColor = whiteNelpyColor
		contentView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(scrollView.snp_top)
			make.left.equalTo(scrollView.snp_left)
			make.right.equalTo(scrollView.snp_right)
			make.width.equalTo(backgroundView.snp_width)
			make.height.greaterThanOrEqualTo(backgroundView.snp_height)
		}
		
		//Select your category label
		
		let selectCategoryLabel = UILabel()
		contentView.addSubview(selectCategoryLabel);
		selectCategoryLabel.text = "Select a Category"
		selectCategoryLabel.textColor = blackNelpyColor
		selectCategoryLabel.font = UIFont(name: "Lato-Regular", size: kTitle16)
		
		selectCategoryLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(contentView.snp_top).offset(20)
			make.centerX.equalTo(contentView.snp_centerX)
		}
		
		//Tap Gesture Recognizer for Categories
		
		let technologyTapAction = UITapGestureRecognizer(target: self, action: "didTapTechnology:")
		let businessTapAction = UITapGestureRecognizer(target: self, action: "didTapBusiness:")
		let multimediaTapAction = UITapGestureRecognizer(target: self, action: "didTapMultimedia:")
		let gardeningTapAction = UITapGestureRecognizer(target: self, action: "didTapGardening:")
		let handymanTapAction = UITapGestureRecognizer(target: self, action: "didTapHandyman:")
		let housecleaningTapAction = UITapGestureRecognizer(target: self, action: "didTapCleaning:")
		let otherTapAction = UITapGestureRecognizer(target: self, action: "didTapOther:")
		
		//Electronics component
		
		let technologyContainer = CategoryCardViewController(frame: CGRectZero, category: "technology")
		contentView.addSubview(technologyContainer)
		technologyContainer.addGestureRecognizer(technologyTapAction)
		technologyContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(selectCategoryLabel.snp_bottom).offset(20)
			make.left.equalTo(contentView.snp_left).offset(20)
			make.right.equalTo(contentView.snp_right).offset(-20)
			make.height.equalTo(240)
		}
		
		//Business component
		
		let businessContainer = CategoryCardViewController(frame: CGRectZero, category: "business")
		businessContainer.addGestureRecognizer(businessTapAction)
		contentView.addSubview(businessContainer)
		businessContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(technologyContainer.snp_bottom).offset(20)
			make.left.equalTo(contentView.snp_left).offset(20)
			make.right.equalTo(contentView.snp_right).offset(-20)
			make.height.equalTo(240)
		}
		
		//Multimedia component
		
		let multimediaContainer = CategoryCardViewController(frame: CGRectZero, category: "multimedia")
		multimediaContainer.addGestureRecognizer(multimediaTapAction)
		contentView.addSubview(multimediaContainer)
		multimediaContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(businessContainer.snp_bottom).offset(20)
			make.left.equalTo(contentView.snp_left).offset(20)
			make.right.equalTo(contentView.snp_right).offset(-20)
			make.height.equalTo(240)
		}
		
		//Gardening component
		
		let gardeningContainer = CategoryCardViewController(frame: CGRectZero, category: "gardening")
		gardeningContainer.addGestureRecognizer(gardeningTapAction)
		contentView.addSubview(gardeningContainer)
		gardeningContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(multimediaContainer.snp_bottom).offset(20)
			make.left.equalTo(contentView.snp_left).offset(20)
			make.right.equalTo(contentView.snp_right).offset(-20)
			make.height.equalTo(240)
		}
		
		//Handyman component
		
		let handymanContainer = CategoryCardViewController(frame: CGRectZero, category: "handywork")
		handymanContainer.addGestureRecognizer(handymanTapAction)
		contentView.addSubview(handymanContainer)
		handymanContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(gardeningContainer.snp_bottom).offset(20)
			make.left.equalTo(contentView.snp_left).offset(20)
			make.right.equalTo(contentView.snp_right).offset(-20)
			make.height.equalTo(240)
		}
		
		//Housecleaning component
		
		let housecleaningContainer = CategoryCardViewController(frame: CGRectZero, category: "housecleaning")
		housecleaningContainer.addGestureRecognizer(housecleaningTapAction)
		contentView.addSubview(housecleaningContainer)
		housecleaningContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(handymanContainer.snp_bottom).offset(20)
			make.left.equalTo(contentView.snp_left).offset(20)
			make.right.equalTo(contentView.snp_right).offset(-20)
			make.height.equalTo(240)
		}
		
		//Other component
		
		let otherContainer = CategoryCardViewController(frame: CGRectZero, category: "other")
		otherContainer.addGestureRecognizer(otherTapAction)
		contentView.addSubview(otherContainer)
		otherContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(housecleaningContainer.snp_bottom).offset(20)
			make.left.equalTo(contentView.snp_left).offset(20)
			make.right.equalTo(contentView.snp_right).offset(-20)
			make.height.equalTo(110)
			make.bottom.equalTo(contentView.snp_bottom).offset(-20)
		}
		
	}
	
	//MARK:View Delegate Method
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		self.scrollView.contentSize = self.contentView.frame.size
	}
	
	
	func technologyButtonTapped(sender:UIButton){
		self.task.category = "technology"
		self.moveToNextView()
	}
	
	func didTapTechnology(sender:UIView){
		self.task.category = "technology"
		self.moveToNextView()
	}
	
	func didTapBusiness(sender:UIView){
		self.task.category = "business"
		self.moveToNextView()
	}
	
	func didTapMultimedia(sender:UIView){
		self.task.category = "multimedia"
		self.moveToNextView()
	}
	
	func didTapGardening(sender:UIView){
		self.task.category = "gardening"
		self.moveToNextView()
	}
	
	func didTapHandyman(sender:UIView){
		self.task.category = "handywork"
		self.moveToNextView()
	}
	
	func didTapCleaning(sender:UIView){
		self.task.category = "housecleaning"
		self.moveToNextView()
	}
	
	func didTapOther(sender:UIView){
		self.task.category = "other"
		self.moveToNextView()
	}
	
	func moveToNextView(){
		let nextScreenVC = PostTaskFormViewController(task: self.task)
		nextScreenVC.delegate = self
		
		dispatch_async(dispatch_get_main_queue()){
			self.presentViewController(nextScreenVC, animated: true, completion: nil)
		}
	}
	
	
	//MARK: NelpTask Delegate Methods
	
	/**
	Adds the task to the Nelp Center "My Task" table view
	
	- parameter nelpTask: The newly created task
	*/
	func nelpTaskAdded(nelpTask: FindNelpTask) {
		delegate?.nelpTaskAdded(nelpTask)
	}
	
	
	func dismiss(){
		self.dismissViewControllerAnimated(true, completion: nil)
	}
}
