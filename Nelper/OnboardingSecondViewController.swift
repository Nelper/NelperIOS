//
//  OnboardingSecondViewController.swift
//  Nelper
//
//  Created by Pierre-Luc Benoit on 2015-11-29.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation

class OnboardingSecondViewController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.createView()
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
		titleLabel.text = "To"
		titleLabel.textColor = Color.textFieldTextColor
		titleLabel.font = UIFont(name: "Lato-Light", size: 30)
		titleLabel.textAlignment = NSTextAlignment.Center
		titleLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(contentView.snp_top).offset(50)
			make.centerX.equalTo(contentView.snp_centerX)
		}
	}
}