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
	var scrollView:UIScrollView!
	var contentView:UIView!
	
	@IBOutlet weak var navBar: NavBar!
	@IBOutlet weak var formView: UIView!
	
	var kCategoryIconSize:CGFloat = 60

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
		
		//ScrollView + ContentView
		
		let scrollView = UIScrollView()
		self.scrollView = scrollView
		self.formView.addSubview(scrollView)
		scrollView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self.formView.snp_edges)
		}
		
		let contentView = UIView()
		self.contentView = contentView
		scrollView.addSubview(contentView)
		contentView.backgroundColor = whiteNelpyColor
		contentView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(scrollView.snp_top)
			make.left.equalTo(scrollView.snp_left)
			make.right.equalTo(scrollView.snp_right)
			make.width.equalTo(formView.snp_width)
			make.height.greaterThanOrEqualTo(formView.snp_height)
		}
		
		//Select your category label
		
		let selectCategoryLabel = UILabel()
		contentView.addSubview(selectCategoryLabel);
		selectCategoryLabel.text = "Select a Category"
		selectCategoryLabel.textColor = blackNelpyColor
		selectCategoryLabel.font = UIFont(name: "Lato-Regular", size: kFormViewLabelFontSize)
		
		selectCategoryLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.contentView.snp_top).offset(20)
			make.centerX.equalTo(contentView.snp_centerX)
		}
		
		//Electronics component
		
		let technologyContainer = CategoryCardViewController(frame: CGRectZero, category: "technology")
		contentView.addSubview(technologyContainer)
		technologyContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(selectCategoryLabel.snp_bottom).offset(20)
			make.left.equalTo(contentView.snp_left).offset(20)
			make.right.equalTo(contentView.snp_right).offset(-20)
			make.height.equalTo(240)
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
