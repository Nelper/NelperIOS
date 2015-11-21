//
//  TabBarViewController.swift
//  Nelper
//
//  Created by Pierre-Luc Benoit on 2015-11-17.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation

class TabBarViewController: UIViewController, TabBarControlDelegate {
	
	//MARK: var
	
	var tabBar: TabBarControl!
	var tabBarImage: UIImage!
	var contentView: UIViewController?
	
	var viewControllers = [
		BrowseViewController(),
		NelpCenterViewController(),
		PostTaskCategoriesViewController(),
		MoreViewController(fullView: nil)
	]
	
	var selectedViewController: UIViewController!
	var selectedIndex: Int!
	
	var backgroundDark: UIView!
	var moreVC: UINavigationController!
	let menuToScreenRatio: CGFloat = 0.70
	let swipeRec = UISwipeGestureRecognizer()
	let tapRec = UITapGestureRecognizer()
	
	//MARK: Init
	
	init(vc: UIViewController?) {
		super.init(nibName: nil, bundle: nil)
		
		self.createTabBar()
		self.createVC(vc, animated: false)
		self.selectedViewController = vc!
		self.selectedIndex = 0
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	//MARK: Create TabBar
	
	func createTabBar() {
		let tabBar = TabBarControl()
		self.tabBar = tabBar
		self.view.addSubview(tabBar)
		tabBar.delegate = self
		tabBar.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(self.view.snp_left)
			make.right.equalTo(self.view.snp_right)
			make.bottom.equalTo(self.view.snp_bottom)
			make.height.equalTo(49)
		}
	}
	
	//MARK: TabBarControl delegate
	
	/*Browse: 0
	NelpCenter: 1
	PostTask: 2
	More: 3*/
	
	func didSelectIndex(index: Int) {
		
		if index == 3 {
			self.createMoreVC()
			return
		}
		
		self.createVC(self.viewControllers[index], animated:  true)
		self.selectedIndex = index
	}
	
	//MARK: Create VC
	
	func createVC(vc: UIViewController!, animated: Bool) {
		
		let viewNavigationController = UINavigationController(rootViewController: vc)
		viewNavigationController.navigationBarHidden = true
		
		if !(animated) {
			
			let contentView = viewNavigationController
			self.contentView = contentView
			self.view.addSubview(contentView.view)
			contentView.view.snp_makeConstraints { (make) -> Void in
				make.edges.equalTo(self.view.snp_edges).inset(UIEdgeInsetsMake(0, 0, 0, 0))
			}
			
			self.view.bringSubviewToFront(self.tabBar)
			
		} else {
			
			let fromView = self.selectedViewController.view
			self.view.addSubview(fromView)
			
			self.contentView!.view.removeFromSuperview()
			
			let contentView = viewNavigationController
			self.contentView = contentView
			self.view.addSubview(contentView.view)
			contentView.view.snp_makeConstraints { (make) -> Void in
				make.edges.equalTo(self.view.snp_edges).inset(UIEdgeInsetsMake(0, 0, 0, 0))
			}
			
			let offScreenRight = CGAffineTransformMakeTranslation(contentView.view.frame.width / 3, 0)
			contentView.view.transform = offScreenRight
			contentView.view.alpha = 0
			
			self.view.userInteractionEnabled = false
			
			UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .CurveEaseOut, animations:  {
				contentView.view.transform = CGAffineTransformIdentity
				contentView.view.alpha = 1
				}, completion:  { finished in
					fromView.removeFromSuperview()
					self.view.userInteractionEnabled = true
			})
			
			self.view.bringSubviewToFront(self.tabBar)
		}
		
		self.selectedViewController = vc
	}
	
	//MARK: Create More VC
	
	func createMoreVC() {
		
		//View
		
		self.tabBar.userInteractionEnabled = false
		
		let backgroundDark = UIView()
		self.backgroundDark = backgroundDark
		self.view.addSubview(backgroundDark)
		backgroundDark.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
		backgroundDark.alpha = 0
		backgroundDark.snp_makeConstraints(closure: { (make) -> Void in
			make.top.equalTo(self.view.snp_top)
			make.left.equalTo(self.view.snp_left)
			make.bottom.equalTo(self.view.snp_bottom)
			make.width.equalTo(self.view.snp_width)
		})
		backgroundDark.layoutIfNeeded()
		
		let moreVC = UINavigationController(rootViewController: MoreViewController(fullView: self))
		self.moreVC = moreVC
		moreVC.navigationBarHidden = true
		self.addChildViewController(moreVC)
		self.view.addSubview(moreVC.view)
		moreVC.didMoveToParentViewController(self)
		moreVC.view.snp_makeConstraints(closure: { (make) -> Void in
			make.top.equalTo(self.view.snp_top)
			make.bottom.equalTo(self.view.snp_bottom)
			make.width.equalTo(self.view.snp_width).multipliedBy(self.menuToScreenRatio)
			make.left.equalTo(self.view.snp_right)
		})
		moreVC.view.layoutIfNeeded()
		
		moreVC.view.snp_updateConstraints(closure: { (make) -> Void in
			make.left.equalTo(self.view.snp_right).offset(-moreVC.view.frame.width)
		})
		
		UIView.animateWithDuration(0.4, animations: { () -> Void in
			backgroundDark.transform = CGAffineTransformMakeTranslation(-self.view.frame.width * self.menuToScreenRatio, 0)
			moreVC.view.layoutIfNeeded()
			self.backgroundDark.alpha = 1
			}, completion: { (finished: Bool) in
		})
		
		//Gestures
		
		self.view.addGestureRecognizer(self.swipeRec)
		self.swipeRec.addTarget(self, action: "closingGesture:")
		
		self.view.addGestureRecognizer(self.tapRec)
		self.tapRec.addTarget(self, action: "closingGesture:")
	}
	
	//MARK: Update more menu layout
	
	func updateMoreMenuState(inSection: Bool) {
		let rootMoreVC = self.moreVC.viewControllers.first as! MoreViewController
		
		if inSection {
			self.moreVC.view.snp_remakeConstraints(closure: { (make) -> Void in
				make.top.equalTo(self.view.snp_top)
				make.bottom.equalTo(self.view.snp_bottom)
				make.width.equalTo(self.view.snp_width).multipliedBy(1)
				make.left.equalTo(self.view.snp_right).offset(-self.view.frame.width)
			})
			
			UIView.animateWithDuration(0.2, animations: { () -> Void in
				rootMoreVC.sectionContainer.alpha = 0
				}, completion: { (finished: Bool) in
			})
			
			UIView.animateWithDuration(0.4, animations: { () -> Void in
				self.moreVC.view.layoutIfNeeded()
				}, completion: { (finished: Bool) in
					self.backgroundDark.hidden = true
			})
			
			self.view.removeGestureRecognizer(swipeRec)
			self.view.removeGestureRecognizer(tapRec)
		} else {
			self.moreVC.view.snp_remakeConstraints(closure: { (make) -> Void in
				make.top.equalTo(self.view.snp_top)
				make.bottom.equalTo(self.view.snp_bottom)
				make.width.equalTo(self.view.snp_width).multipliedBy(self.menuToScreenRatio)
				make.left.equalTo(self.view.snp_right).offset(-moreVC.view.frame.width * self.menuToScreenRatio)
			})
			
			self.backgroundDark.hidden = false
			
			UIView.animateWithDuration(0.2, animations: { () -> Void in
				rootMoreVC.sectionContainer.alpha = 1
				}, completion: { (finished: Bool) in
			})
			
			UIView.animateWithDuration(0.4, animations: { () -> Void in
				self.moreVC.view.layoutIfNeeded()
				rootMoreVC.sectionContainer.alpha = 1
				}, completion: { (finished: Bool) in
			})
			
			self.view.addGestureRecognizer(self.swipeRec)
			self.view.addGestureRecognizer(self.tapRec)
		}
	}
	
	//MARK: Close and remove More VC
	
	func closeMoreMenu() {
		self.tabBar.didSelectIndex(selectedIndex, loadView: false)
		
		self.moreVC.view.snp_updateConstraints(closure: { (make) -> Void in
			make.left.equalTo(self.view.snp_right)
		})
		
		UIView.animateWithDuration(0.3, delay: 0.2, options: [.CurveEaseOut], animations:  {
			self.moreVC.view.layoutIfNeeded()
			self.backgroundDark.transform = CGAffineTransformMakeTranslation(0, 0)
			self.backgroundDark.alpha = 0
			}, completion: { (finished: Bool) in
				
				self.tabBar.userInteractionEnabled = true
				self.backgroundDark.removeFromSuperview()
				self.moreVC.view.removeFromSuperview()
				self.moreVC.removeFromParentViewController()
				self.view.removeGestureRecognizer(self.swipeRec)
				self.view.removeGestureRecognizer(self.tapRec)
		})
	}
	
	//MARK: Hide tabBar
	
	func tabBarWillHide(willHide: Bool) {
		if willHide {
			UIGraphicsBeginImageContextWithOptions(self.tabBar.bounds.size, false, UIScreen.mainScreen().scale)
			self.tabBar.drawViewHierarchyInRect(self.tabBar.bounds, afterScreenUpdates: true)
			let tabBarImage = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
			self.tabBarImage = tabBarImage
		} else {
			self.tabBar.hidden = false
		}
	}
	
	//MARK: Actions
	
	func closingGesture(sender: AnyObject) {
		self.closeMoreMenu()
	}
	
}