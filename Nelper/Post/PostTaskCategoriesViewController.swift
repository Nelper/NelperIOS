//
//  OfferCreateViewController.swift
//  Nelper
//
//  Created by Janic Duplessis on 2015-07-03.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import UIKit

protocol PostTaskCategoriesViewControllerDelegate {
	func nelpTaskAdded(task: FindNelpTask) -> Void
}

class PostTaskCategoriesViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, PostTaskFormViewControllerDelegate {
	
	var delegate: PostTaskCategoriesViewControllerDelegate?
	var task: FindNelpTask!
	var scrollView: UIScrollView!
	var contentView: UIView!
	
	let categories = [
		"technology",
		"business",
		"multimedia",
		"gardening",
		"handywork",
		"housecleaning",
		"other"
	]
	
	var categoryContainers = [CategoryCardViewController]()
	
	//MARK: Initialization
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.task = FindNelpTask()
		self.createView()
	}
	
	override func viewDidAppear(animated: Bool) {
		self.scrollView.contentSize = self.contentView.frame.size
		let rootvc:TabBarCustom = UIApplication.sharedApplication().delegate!.window!?.rootViewController as! TabBarCustom
		rootvc.presentedVC = self
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
		backgroundView.backgroundColor = whiteBackground
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
		contentView.backgroundColor = whiteBackground
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
		selectCategoryLabel.textColor = blackPrimary
		selectCategoryLabel.font = UIFont(name: "Lato-Regular", size: kTitle17)
		
		selectCategoryLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(contentView.snp_top).offset(20)
			make.centerX.equalTo(contentView.snp_centerX)
		}
		
		//Tap Gesture Recognizer for Categories
		
		let topPadding = 20
		let sidePadding = 20
		
		for i in 0...self.categories.count - 1 {
			
			let categoryContainer = CategoryCardViewController(frame: CGRectZero, category: self.categories[i])
			contentView.addSubview(categoryContainer)
			categoryContainer.tag = i
			categoryContainer.addTarget(self, action: "didTapCategory:", forControlEvents: .TouchUpInside)
			
			if i == 0 {
				categoryContainer.snp_makeConstraints { (make) -> Void in
					make.top.equalTo(selectCategoryLabel.snp_bottom).offset(topPadding)
					make.left.equalTo(contentView.snp_left).offset(sidePadding)
					make.right.equalTo(contentView.snp_right).offset(-sidePadding)
				}
			} else if i == self.categories.indexOf("other") {
				categoryContainer.snp_makeConstraints { (make) -> Void in
					make.top.equalTo(self.categoryContainers[i-1].snp_bottom).offset(topPadding)
					make.left.equalTo(contentView.snp_left).offset(sidePadding)
					make.right.equalTo(contentView.snp_right).offset(-sidePadding)
					make.height.equalTo(110)
					make.bottom.equalTo(contentView.snp_bottom).offset(-topPadding)
				}
			} else {
				categoryContainer.snp_makeConstraints { (make) -> Void in
					make.top.equalTo(self.categoryContainers[i-1].snp_bottom).offset(topPadding)
					make.left.equalTo(contentView.snp_left).offset(sidePadding)
					make.right.equalTo(contentView.snp_right).offset(-sidePadding)
				}
			}
			
			categoryContainer.layoutIfNeeded()
			self.categoryContainers.append(categoryContainer)
		}
	}
	
	//MARK:View Delegate Method
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		self.scrollView.contentSize = self.contentView.frame.size
	}
	
	func didTapCategory(sender: CategoryCardViewController) {
		self.task.category = self.categories[sender.tag]
		self.moveToNextView()
	}
	
	func moveToNextView() {
		let nextScreenVC = PostTaskFormViewController(task: self.task)
		nextScreenVC.delegate = self
		nextScreenVC.hidesBottomBarWhenPushed = true
		
		dispatch_async(dispatch_get_main_queue()) {
			self.navigationController?.pushViewController(nextScreenVC, animated: true)
		}
	}
	
	
	//MARK: Task Delegate Methods
	
	/**
	Adds the task to the Nelp Center "My Task" table view
	
	- parameter task: The newly created task
	*/
	func nelpTaskAdded(task: FindNelpTask) {
		delegate?.nelpTaskAdded(task)
	}
	
	func dismiss() {
		
	}
}
