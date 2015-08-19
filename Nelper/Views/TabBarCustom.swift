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

class TabBarCustom: UITabBar {
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		createView()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		createView()
	}
	
	func createView(){
		
	var container = UIView()
	self.addSubview(container)
	container.snp_makeConstraints { (make) -> Void in
		make.edges.equalTo(self)
		}
	container.backgroundColor = tabBarColor
	self.tintColor = orangeTextColor
	self.translucent = false
		
		var nelpVC = NelpViewController()
		var nelpVCItem = UITabBarItem(title: "Nelp", image: UIImage(named: "nelp_dark"), selectedImage: UIImage(named: "nelp_dark"))
		
		var nelpCenterVC = ProfileViewController()
		var nelpCenterVCItem = UITabBarItem(title: "Nelp Center", image: UIImage(named: "nelpcenter_dark"), selectedImage: UIImage(named: "nelpcenter_dark"))
		
		var findNelpVC = NelpTaskCreateViewController()
		var findNelpVCItem = UITabBarItem(title: "Find Nelp", image: UIImage(named: "find_nelp_dark"), selectedImage: UIImage(named: "search_orange"))
		var controllersArray = [nelpVC, nelpCenterVC, findNelpVC]
		
		var tabs = UITabBarController()
		tabs.viewControllers = controllersArray
		self.window!.rootViewController = tabs
		
		
		
		
		
		
		
	}
	

	
	
	


}