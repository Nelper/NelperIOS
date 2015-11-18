//
//  TabBarViewController.swift
//  Nelper
//
//  Created by Pierre-Luc Benoit on 2015-11-17.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation

class TabBarViewController: UIViewController, TabBarControlDelegate {
	
	var contentView: UIViewController?
	
	var viewControllers = [
		BrowseViewController(),
		NelpCenterViewController(),
		PostTaskCategoriesViewController(),
		MoreViewController()
	]
	
	var selectedViewController: UIViewController!
	
	init(vc: UIViewController?) {
		super.init(nibName: nil, bundle: nil)
		
		self.createTabBar()
		self.createVC(vc, animated: false)
		self.selectedViewController = vc
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	//Create TabBar
	
	func createTabBar() {
		
		let tabBar = TabBarControl()
		self.view.addSubview(tabBar)
		tabBar.layer.zPosition = 10
		tabBar.delegate = self
		tabBar.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(self.view.snp_left)
			make.right.equalTo(self.view.snp_right)
			make.bottom.equalTo(self.view.snp_bottom)
			make.height.equalTo(49)
		}
	}
	
	//TabBarControl delegate
	
	func selectedIndex(index: Int) {
		print("called")
		self.createVC(self.viewControllers[index], animated:  true)
	}
	
	//Create VC
	
	func createVC(vc: UIViewController!, animated: Bool) {
		if self.contentView != nil {
			self.contentView!.view.removeFromSuperview()
			self.contentView!.removeFromParentViewController()
		}
		
		if !(animated) {
			let contentView = vc
			self.contentView = contentView
			self.view.addSubview(contentView.view)
			contentView.view.snp_makeConstraints { (make) -> Void in
				make.edges.equalTo(self.view.snp_edges).inset(UIEdgeInsetsMake(0, 0, 49, 0))
			}
		} else {
			//Animation
			//let tabViewControllers = self.viewControllers
			let fromView = self.selectedViewController!.view
			let toView = vc.view
			
			if (fromView == toView) {
				return
			}
			
			fromView.layer.zPosition = -1
			self.view.addSubview(fromView)
			
			//let toIndex = tabViewControllers.indexOf(vc)
			
			let offScreenRight = CGAffineTransformMakeTranslation(toView.frame.width / 3, 0)
			toView.transform = offScreenRight
			toView.alpha = 0
			
			self.view.userInteractionEnabled = false
			
			UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .CurveEaseOut, animations:  {
				toView.transform = CGAffineTransformIdentity
				toView.alpha = 1
				}, completion:  { finished in
					fromView.removeFromSuperview()
					self.view.userInteractionEnabled = true
			})
		}
		
		self.selectedViewController = vc
	}
	
}