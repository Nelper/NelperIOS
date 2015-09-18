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

class TabBarCustom: UITabBarController {
	
	//MARK: Initialization
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		self.createView()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.createView()
	}
	
	//MARK: View Creation
	
	func createView(){
		self.tabBar.translucent = false		
		var browseVC = NelpViewController()
		var browseVCItem = UITabBarItem(title: "Browse tasks", image: UIImage(named: "browse_default"), selectedImage: UIImage(named: "browse_default"))
		browseVC.tabBarItem = browseVCItem
		
		var nelpCenterVC = NelpCenterViewController()
		var nelpCenterVCItem = UITabBarItem(title: "Nelp Center", image: UIImage(named: "nelpcenter_default"), selectedImage: UIImage(named: "nelpcenter_default"))
		nelpCenterVC.tabBarItem = nelpCenterVCItem
		
		var postVC = NelpTaskCreateViewController()
		var postVCItem = UITabBarItem(title: "Post a task", image: UIImage(named: "post_task"), selectedImage: UIImage(named: "post_task"))
		postVC.tabBarItem = postVCItem
		
		var controllersArray = [browseVC, nelpCenterVC, postVC]
		
		self.viewControllers = controllersArray
		self.tabBar.tintColor = nelperRedColor
		
	}
}