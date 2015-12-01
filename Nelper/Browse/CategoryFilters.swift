//
//  CategoryFilters.swift
//  Nelper
//
//  Created by Pierre-Luc Benoit on 2015-11-08.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation
import UIKit

protocol CategoryFiltersDelegate {
	func categoryTapped(sender: UIButton, category: String)
}

class CategoryFilters: UIView {
	
	var imageSize = 50
	var padding = 22
	var delegate: CategoryFiltersDelegate!
	var categoryImages = [UIButton]()
	
	let categories = [
		"all",
		"technology",
		"business",
		"multimedia",
		"gardening",
		"handywork",
		"housecleaning",
		"other"
	]
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		createView()
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	func createView() {
		for subview in self.subviews {
			subview.removeFromSuperview()
		}
		
		for i in 0...self.categories.count - 1 {
			var xCoord = i * (self.imageSize + self.padding)
			var yCoord = 0
			
			if i >= 4 {
				yCoord = self.imageSize + self.padding
				xCoord = (i - 4) * (self.imageSize + self.padding)
			}
			
			let categoryImage = UIButton(frame: CGRect(x: xCoord, y: yCoord, width: imageSize, height: imageSize))
			categoryImage.setImage(UIImage(named: self.categories[i]+"-filter"), forState: .Normal)
			categoryImage.contentMode = .ScaleAspectFit
			categoryImage.alpha = 0.3
			categoryImage.addTarget(self, action: "categoryTapped:", forControlEvents: UIControlEvents.TouchUpInside)
			categoryImage.transform = CGAffineTransformMakeScale(0.9, 0.9)
			categoryImage.tag = i
			
			categoryImages.append(categoryImage)
			self.addSubview(categoryImage)
		}
	}
	
	func categoryTapped(sender: UIButton) {
		let category: String! = self.categories[sender.tag]
		self.delegate.categoryTapped(sender, category: category)
	}
}
