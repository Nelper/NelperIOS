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
import SVProgressHUD

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
		let browseVC = UINavigationController(rootViewController: BrowseViewController())
		browseVC.navigationBarHidden = true
		let browseVCItem = UITabBarItem(title: "Browse tasks", image: UIImage(named: "browse_default"), selectedImage: UIImage(named: "browse_default"))
		browseVC.tabBarItem = browseVCItem
		
		let nelpCenterVC = UINavigationController(rootViewController: NelpCenterViewController())
		nelpCenterVC.navigationBarHidden = true
		let nelpCenterVCItem = UITabBarItem(title: "Nelp Center", image: UIImage(named: "nelpcenter_default"), selectedImage: UIImage(named: "nelpcenter_default"))
		nelpCenterVC.tabBarItem = nelpCenterVCItem
		
		let postVC = UINavigationController(rootViewController: PostTaskCategoriesViewController())
		postVC.navigationBarHidden = true
		let postVCItem = UITabBarItem(title: "Post a task", image: UIImage(named: "post_task"), selectedImage: UIImage(named: "post_task"))
		postVC.tabBarItem = postVCItem
		
		//let moreVC = MoreViewController(menuViewController: UIViewController(), contentViewController: MoreMenuTableViewController())
		let moreVC = UINavigationController(rootViewController: MoreViewController())
		moreVC.navigationBarHidden = true
		let moreVCItem = UITabBarItem(title: "More", image: UIImage(named: "menu"), selectedImage: UIImage(named: "more"))
		moreVC.tabBarItem = moreVCItem
		
		let controllersArray = [browseVC, nelpCenterVC, postVC, moreVC]
		
		self.viewControllers = controllersArray
		self.tabBar.tintColor = Color.redPrimary
		
	}
	
	func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
		if viewController != self.viewControllers![3] {
			self.viewIsCreated = false
			
			if !(self.selectedViewController == viewController) && viewController == self.viewControllers![1] {
				SVProgressHUD.setBackgroundColor(Color.redPrimary)
				SVProgressHUD.setForegroundColor(Color.whitePrimary)
				SVProgressHUD.show()
			}
			
			//Animation
			let tabViewControllers = tabBarController.viewControllers
			let fromView = tabBarController.selectedViewController!.view
			let toView = viewController.view
			if (fromView == toView) {
				return false
			}
			
			let toIndex = tabViewControllers?.indexOf(viewController)
			
			let offScreenRight = CGAffineTransformMakeTranslation(toView.frame.width / 3, 0)
			
			toView.transform = offScreenRight
			
			toView.alpha = 0
			fromView.layer.zPosition = -1
			self.view.addSubview(fromView)
			
			self.view.userInteractionEnabled = false
			
			UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .CurveEaseOut, animations:  {
				toView.transform = CGAffineTransformIdentity
				toView.alpha = 1
				}, completion:  { finished in
					fromView.removeFromSuperview()
					tabBarController.selectedIndex = toIndex!
					self.view.userInteractionEnabled = true
			})
		}
		
		if viewController == self.viewControllers![3] {
			if self.moreIsOpen == false {
				
				self.tabBar.userInteractionEnabled = false
				
				UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Slide)
				
				if self.viewIsCreated == false {
					
					let backgroundDark = UIView()
					self.backgroundDark = backgroundDark
					self.presentedVC.view.addSubview(backgroundDark)
					self.backgroundDark.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
					self.backgroundDark.alpha = 0
					self.backgroundDark.snp_makeConstraints(closure: { (make) -> Void in
						make.edges.equalTo(presentedVC.view.snp_edges)
					})
					backgroundDark.addGestureRecognizer(swipeRec)
					backgroundDark.addGestureRecognizer(tapRec)
					backgroundDark.userInteractionEnabled = true
					
					let nextVC = MoreViewController()
					self.nextVC = nextVC
					self.presentedVC.addChildViewController(nextVC)
					self.presentedVC.view.addSubview(nextVC.view)
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
					}, completion: { (finished: Bool) in
						self.tabBar.userInteractionEnabled = true
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
		self.tabBar.userInteractionEnabled = false
		UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Slide)
		
		nextVC.view.snp_remakeConstraints(closure: { (make) -> Void in
			make.top.equalTo(presentedVC.view.snp_top)
			make.bottom.equalTo(presentedVC.view.snp_bottom)
			make.left.equalTo(presentedVC.view.snp_right)
			make.width.equalTo(presentedVC.view.snp_width).multipliedBy(0.70)
		})
		swipeRec.removeTarget(self, action: "swipedView")
		swipeRec2.removeTarget(self, action: "swipedView")
		tapRec.removeTarget(self, action: "swipedView")
		
		UIView.animateWithDuration(0.4, animations: { () -> Void in
			self.nextVC.view.layoutIfNeeded()
			self.backgroundDark.alpha = 0
			}, completion: { (finished: Bool) in
				self.tabBar.userInteractionEnabled = true
		})
		
		nextVC.closingAnimation()
		
		self.moreIsOpen = false
	}
}