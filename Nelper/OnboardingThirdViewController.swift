//
//  OnboardingThirdViewController.swift
//  Nelper
//
//  Created by Pierre-Luc Benoit on 2015-11-29.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation

class OnboardingThirdViewController: UIViewController {
	
	var goButton: PrimaryActionButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.createView()
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
	}
	
	func createView() {
		
		self.view.backgroundColor = UIColor.whiteColor()
		
		let contentView = UIView()
		self.view.addSubview(contentView)
		contentView.backgroundColor = Color.redPrimary.colorWithAlphaComponent(0.9)
		contentView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self.view.snp_edges)
		}
		
		contentView.layoutIfNeeded()
		
		let titleLabel = UILabel()
		contentView.addSubview(titleLabel)
		titleLabel.text = "Faites compléter\nvos tâches"
		titleLabel.textColor = Color.whitePrimary
		titleLabel.numberOfLines = 0
		titleLabel.font = UIFont(name: "Lato-Light", size: 31)
		titleLabel.textAlignment = NSTextAlignment.Center
		titleLabel.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(contentView.snp_centerY).offset(-120)
			make.centerX.equalTo(contentView.snp_centerX)
		}
		
		let descLabel = UILabel()
		contentView.addSubview(descLabel)
		descLabel.text = "Il y a quelqu'un dans votre\nvoisinage qui peut vous aider."
		descLabel.textColor = Color.whitePrimary
		descLabel.numberOfLines = 0
		descLabel.font = UIFont(name: "Lato-Light", size: 20)
		descLabel.textAlignment = NSTextAlignment.Center
		descLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(titleLabel.snp_bottom).offset(50)
			make.centerX.equalTo(contentView.snp_centerX)
		}
		
		let descLabel2 = UILabel()
		contentView.addSubview(descLabel2)
		descLabel2.text = "Publier une tâche est gratuit."
		descLabel2.textColor = Color.whitePrimary
		descLabel2.numberOfLines = 0
		descLabel2.font = UIFont(name: "Lato-Light", size: 20)
		descLabel2.textAlignment = NSTextAlignment.Center
		descLabel2.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(descLabel.snp_bottom).offset(20)
			make.centerX.equalTo(contentView.snp_centerX)
		}
		
		let tabImage = UIImageView()
		contentView.addSubview(tabImage)
		tabImage.image = UIImage(named: "onboarding-post")
		tabImage.contentMode = .ScaleAspectFit
		tabImage.alpha = 0.8
		tabImage.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(descLabel2.snp_bottom).offset(65)
			make.centerX.equalTo(contentView.snp_centerX)
			make.width.equalTo(60)
			make.height.equalTo(60)
		}
	}
	
//MARK: Actions
	
	
	
}