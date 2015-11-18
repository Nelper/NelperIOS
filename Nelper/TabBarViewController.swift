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
		self.createVC(self.viewControllers[index], animated:  true)
	}
	
	//Create VC
	
	func createVC(vc: UIViewController!, animated: Bool) {
		
		let viewNavigationController = UINavigationController(rootViewController: vc)
		viewNavigationController.navigationBarHidden = true
		
		if !(animated) {
			
			let contentView = viewNavigationController
			self.contentView = contentView
			self.view.addSubview(contentView.view)
			contentView.view.snp_makeConstraints { (make) -> Void in
				make.edges.equalTo(self.view.snp_edges).inset(UIEdgeInsetsMake(0, 0, 49, 0))
			}
			
		} else {
			let fromView = self.selectedViewController.view
			self.view.addSubview(fromView)
			
			self.contentView!.view.removeFromSuperview()
			
			let contentView = viewNavigationController
			self.contentView = contentView
			self.view.addSubview(contentView.view)
			contentView.view.snp_makeConstraints { (make) -> Void in
				make.edges.equalTo(self.view.snp_edges).inset(UIEdgeInsetsMake(0, 0, 49, 0))
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
		}
		
		self.selectedViewController = vc
	}
	
}