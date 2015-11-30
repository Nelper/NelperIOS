//
//  OnboardingFirstViewController.swift
//  Nelper
//
//  Created by Pierre-Luc Benoit on 2015-11-29.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation

class OnboardingFirstViewController: UIViewController {
	
	var categoryFilters: CategoryFilters!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.createView()
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		var delay = 0.5
		
		for categoryImage in self.categoryFilters.categoryImages {
			UIView.animateWithDuration(delay * 1.5, delay: delay, options: [.CurveEaseOut], animations:  {
				categoryImage.alpha = 1
				}, completion: nil)
			delay += 0.1
		}
	}
	
	func createView() {
		
		let contentView = UIView()
		self.view.addSubview(contentView)
		contentView.backgroundColor = Color.whitePrimary
		contentView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self.view.snp_edges)
		}
		
		let titleLabel = UILabel()
		contentView.addSubview(titleLabel)
		titleLabel.text = "Welcome"
		titleLabel.textColor = Color.textFieldTextColor
		titleLabel.font = UIFont(name: "Lato-Light", size: 30)
		titleLabel.textAlignment = NSTextAlignment.Center
		titleLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(contentView.snp_top).offset(50)
			make.centerX.equalTo(contentView.snp_centerX)
		}
		
		let categoryFilters = CategoryFilters()
		self.categoryFilters = categoryFilters
		contentView.addSubview(categoryFilters)
		categoryFilters.userInteractionEnabled = false
		categoryFilters.snp_makeConstraints { (make) -> Void in
			make.width.equalTo(categoryFilters.categories.count * (categoryFilters.imageSize + categoryFilters.padding) / 2)
			make.centerX.equalTo(contentView.snp_centerX).offset(categoryFilters.padding / 2)
			make.centerY.equalTo(contentView.snp_centerY)
			make.height.equalTo((2 * categoryFilters.imageSize) + categoryFilters.padding)
		}
		for categoryImage in categoryFilters.categoryImages {
			categoryImage.alpha = 0
		}
		
		categoryFilters.layoutIfNeeded()
	}
}