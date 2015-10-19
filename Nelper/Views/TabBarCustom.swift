//
//  TabBarCustom.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-08-15.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class TabBarCustom: UITabBarController, UITabBarControllerDelegate {
	
	var presentedVC: UIViewController!
	var nextVC: MoreViewController!
	var backgroundDark: UIView!
	var viewIsCreated = false
	var moreIsOpen = false
	
	let swipeRec = UISwipeGestureRecognizer()
	let swipeRec2 = UISwipeGestureRecognizer()
	let tapRec = UITapGestureRecognizer()
	
	//MARK: Initialization
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		self.createView()
		self.delegate = self
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.createView()
		self.delegate = self
	}
	
	//MARK: View Creation
	
	func createView(){
		self.tabBar.translucent = false
		let browseVC = BrowseViewController()
		let browseVCItem = UITabBarItem(title: "Browse tasks", image: UIImage(named: "browse_default"), selectedImage: UIImage(named: "browse_default"))
		browseVC.tabBarItem = browseVCItem
		
		let nelpCenterVC = NelpCenterViewController()
		let nelpCenterVCItem = UITabBarItem(title: "Nelp Center", image: UIImage(named: "nelpcenter_default"), selectedImage: UIImage(named: "nelpcenter_default"))
		nelpCenterVC.tabBarItem = nelpCenterVCItem
		
		let postVC = PostTaskCategoriesViewController()
		let postVCItem = UITabBarItem(title: "Post a task", image: UIImage(named: "post_task"), selectedImage: UIImage(named: "post_task"))
		postVC.tabBarItem = postVCItem
		
		//		let moreVC = MoreViewController(menuViewController: UIViewController(), contentViewController: MoreMenuTableViewController())
		let moreVC = MoreViewController()
		let moreVCItem = UITabBarItem(title: "More", image: UIImage(named: "menu"), selectedImage: UIImage(named: "more"))
		moreVC.tabBarItem = moreVCItem
		
		let controllersArray = [browseVC, nelpCenterVC, postVC, moreVC]
		
		self.viewControllers = controllersArray
		self.tabBar.tintColor = redPrimary
		
	}
	
	func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
		if viewController != self.viewControllers![3] {
			self.viewIsCreated = false
		}
		
		if viewController == self.viewControllers![3] {
			if self.moreIsOpen == false {
				
				if self.viewIsCreated == false {
					
					let backgroundDark = UIView()
					self.backgroundDark = backgroundDark
					presentedVC.view.addSubview(backgroundDark)
					self.backgroundDark.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
					self.backgroundDark.alpha = 0
					self.backgroundDark.snp_makeConstraints(closure: { (make) -> Void in
						make.edges.equalTo(presentedVC.view.snp_edges)
					})
					backgroundDark.addGestureRecognizer(swipeRec)
					backgroundDark.addGestureRecognizer(tapRec)
					backgroundDark.userInteractionEnabled = true
					
					let nextVC = MoreViewController()
					self.nextVC = nextVC
					presentedVC.addChildViewController(nextVC)
					presentedVC.view.addSubview(nextVC.view)
					nextVC.didMoveToParentViewController(presentedVC)
					
					nextVC.fullView = presentedVC
					
					nextVC.view.snp_makeConstraints(closure: { (make) -> Void in
						make.top.equalTo(presentedVC.view.snp_top)
						make.bottom.equalTo(presentedVC.view.snp_bottom)
						make.width.equalTo(presentedVC.view.snp_width).multipliedBy(0.70)
						make.left.equalTo(presentedVC.view.snp_right)
					})
					nextVC.view.layoutIfNeeded()
					
					nextVC.view.addGestureRecognizer(swipeRec2)
					nextVC.view.userInteractionEnabled = true
					
					viewIsCreated = true
				} else {
					nextVC.openingAnimation()
				}
				
				nextVC.view.snp_updateConstraints(closure: { (make) -> Void in
					make.left.equalTo(presentedVC.view.snp_right).offset(-nextVC.view.frame.width)
				})
				
				UIView.animateWithDuration(0.4, animations: { () -> Void in
					self.nextVC.view.layoutIfNeeded()
					self.backgroundDark.alpha = 1
				})
				
				swipeRec.addTarget(self, action: "swipedView")
				swipeRec2.addTarget(self, action: "swipedView")
				tapRec.addTarget(self, action: "swipedView")
				
				self.moreIsOpen = true
				
			} else {
				
				closeMoreMenu()
			}
			
			return false
		}
		
		if self.moreIsOpen {
			closeMoreMenu()
		}
		
		return true
	}
	
	func swipedView() {
		closeMoreMenu()
	}
	
	func closeMoreMenu() {
		nextVC.view.snp_remakeConstraints(closure: { (make) -> Void in
			make.top.equalTo(presentedVC.view.snp_top)
			make.bottom.equalTo(presentedVC.view.snp_bottom)
			make.left.equalTo(presentedVC.view.snp_right)
			make.width.equalTo(presentedVC.view.snp_width).multipliedBy(0.70)
		})
		//swipeRec.removeTarget(self, action: "swipedView")
		//swipeRec2.removeTarget(self, action: "swipedView")
		//tapRec.removeTarget(self, action: "swipedView")
		
		UIView.animateWithDuration(0.4, animations: { () -> Void in
			self.nextVC.view.layoutIfNeeded()
			self.backgroundDark.alpha = 0
		})
		
		nextVC.closingAnimation()
		
		self.moreIsOpen = false
	}
}