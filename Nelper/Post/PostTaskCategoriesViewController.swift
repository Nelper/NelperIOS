//
//  OfferCreateViewController.swift
//  Nelper
//
//  Created by Janic Duplessis on 2015-07-03.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import UIKit

protocol PostTaskCategoriesViewControllerDelegate {
	func nelpTaskAdded(task: Task) -> Void
}

class PostTaskCategoriesViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, PostTaskFormViewControllerDelegate {
	
	var delegate: PostTaskCategoriesViewControllerDelegate?
	var task: Task!
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
	
	var tabBarViewController: TabBarViewController!
	var tabBarFakeView: UIImageView!
	
	//MARK: Initialization
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tabBarViewController = UIApplication.sharedApplication().delegate!.window!?.rootViewController as! TabBarViewController
		
		self.task = Task()
		self.createView()
	}
	
	override func viewWillAppear(animated: Bool) {
		self.tabBarViewController.tabBarWillHide(false)
	}
	
	override func viewDidAppear(animated: Bool) {
		self.scrollView.contentSize = self.contentView.frame.size
	}
	
	//MARK: UI
	
	//MARK: View Creation
	
	func createView(){
		
		let navBar = NavBar()
		self.view.addSubview(navBar)
		navBar.setTitle("Post a Task")
		navBar.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.view.snp_top)
			make.right.equalTo(self.view.snp_right)
			make.left.equalTo(self.view.snp_left)
			make.height.equalTo(64)
		}
		
		//ScrollView + ContentView
		
		let backgroundView = UIView()
		backgroundView.backgroundColor = Color.whiteBackground
		self.view.addSubview(backgroundView)
		backgroundView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(navBar.snp_bottom)
			make.left.equalTo(self.view.snp_left)
			make.right.equalTo(self.view.snp_right)
			make.bottom.equalTo(self.view.snp_bottom).offset(-49)
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
		contentView.backgroundColor = Color.whiteBackground
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
		selectCategoryLabel.textColor = Color.blackPrimary
		selectCategoryLabel.font = UIFont(name: "Lato-Regular", size: kTitle17)
		
		selectCategoryLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(contentView.snp_top).offset(20)
			make.centerX.equalTo(contentView.snp_centerX)
		}
		
		//Category boxes
		
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
		
		//Fake view for tabbar transition
		
		let tabBarFakeView = UIImageView()
		self.tabBarFakeView = tabBarFakeView
		self.view.addSubview(tabBarFakeView)
		tabBarFakeView.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(self.view.snp_left)
			make.right.equalTo(self.view.snp_right)
			make.bottom.equalTo(self.view.snp_bottom)
			make.height.equalTo(49)
		}
	}
	
	//MARK: View Delegate Method
	
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
		
		self.hideTabBar()
		dispatch_async(dispatch_get_main_queue()) {
			self.navigationController?.pushViewController(nextScreenVC, animated: true)
		}
	}
	
	
	//MARK: Task Delegate Methods
	
	/**
	Adds the task to the Nelp Center "My Task" table view
	
	- parameter task: The newly created task
	*/
	func nelpTaskAdded(task: Task) {
		delegate?.nelpTaskAdded(task)
	}
	
	func dismiss() {
		
	}
	
	//MARK: Utilities
	
	func hideTabBar() {
		self.tabBarViewController!.tabBarWillHide(true)
		self.tabBarFakeView.image = self.tabBarViewController.tabBarImage
		self.tabBarViewController!.tabBar.hidden = true
	}
}
