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
	
	var presentedVC:UIViewController!
	var moreIsOpen:Bool!
	var nextVC:MoreViewController!
	
	//MARK: Initialization
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		self.createView()
		self.moreIsOpen = false
		self.delegate = self
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.createView()
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
		if viewController == self.viewControllers![3]{
			if self.moreIsOpen == false{
			let nextVC = MoreViewController()
			self.nextVC = nextVC
			presentedVC.addChildViewController(nextVC)
			presentedVC.view.addSubview(nextVC.view)
			nextVC.didMoveToParentViewController(presentedVC)
			
			nextVC.view.snp_makeConstraints(closure: { (make) -> Void in
				make.top.equalTo(presentedVC.view.snp_top)
				make.bottom.equalTo(presentedVC.view.snp_bottom)
				make.left.equalTo(presentedVC.view.snp_right)
			})
			nextVC.view.layoutIfNeeded()
			
			nextVC.view.snp_remakeConstraints(closure: { (make) -> Void in
				make.top.equalTo(presentedVC.view.snp_top)
				make.bottom.equalTo(presentedVC.view.snp_bottom)
				make.right.equalTo(presentedVC.view.snp_right)
				make.width.equalTo(presentedVC.view.snp_width).multipliedBy(0.70)
			})
			
			UIView.animateWithDuration(0.5, animations: { () -> Void in
				nextVC.view.layoutIfNeeded()
			})
			self.moreIsOpen = true
			}else {
				self.closeMoreMenu()
			}
			
			return false
		}
		if self.moreIsOpen == true{
			self.closeMoreMenu()
		}
		return true
	}
	
	func closeMoreMenu(){
		nextVC.view.snp_remakeConstraints(closure: { (make) -> Void in
			make.top.equalTo(presentedVC.view.snp_top)
			make.bottom.equalTo(presentedVC.view.snp_bottom)
			make.left.equalTo(presentedVC.view.snp_right)
			make.width.equalTo(presentedVC.view.snp_width).multipliedBy(0.70)
		})
		
		UIView.animateWithDuration(0.5, animations: { () -> Void in
			self.nextVC.view.layoutIfNeeded()
		})
		self.moreIsOpen = false
	}
}