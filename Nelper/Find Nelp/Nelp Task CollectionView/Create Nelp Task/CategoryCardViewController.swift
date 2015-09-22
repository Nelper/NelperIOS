//
//  CategoryCardViewController.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-09-22.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation
import UIKit

class CategoryCardViewController:UIView{
	
	var category:String?
	var kCategoryIconSize:CGFloat = 70
	var kCardHeight:CGFloat = 240
	
	init(frame:CGRect,category:String){
			super.init(frame: frame)
			self.category = category
			self.createView()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func createView(){
		self.layer.borderColor = darkGrayDetails.CGColor
		self.layer.borderWidth = 0.5
		self.backgroundColor = navBarColor
		let categoryIcon = UIImageView()
		self.addSubview(categoryIcon)
		categoryIcon.image = UIImage(named: self.category!)
		categoryIcon.layer.cornerRadius = kCategoryIconSize / 2
		categoryIcon.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self).offset(20)
			make.centerX.equalTo(self.snp_centerX)
			make.width.equalTo(kCategoryIconSize)
			make.height.equalTo(kCategoryIconSize)
		}
	}
	
}
