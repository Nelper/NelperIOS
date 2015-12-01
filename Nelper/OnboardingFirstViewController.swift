//
//  OnboardingFirstViewController.swift
//  Nelper
//
//  Created by Pierre-Luc Benoit on 2015-11-29.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation

class OnboardingFirstViewController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.createView()
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	func createView() {
		
		let contentView = UIView()
		self.view.addSubview(contentView)
		contentView.backgroundColor = Color.blackPrimary
		contentView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self.view.snp_edges)
		}
		
		let backgroundImage = UIImageView()
		contentView.addSubview(backgroundImage)
		backgroundImage.image = UIImage(named: "onboarding-first-bg")
		backgroundImage.contentMode = .ScaleAspectFill
		backgroundImage.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(contentView.snp_edges).inset(UIEdgeInsetsMake(0, 0, 20, 0))
		}
		
		let backgroundImageDarken = UIView()
		backgroundImage.addSubview(backgroundImageDarken)
		backgroundImageDarken.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
		backgroundImageDarken.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(backgroundImage.snp_edges)
		}
		
		let titleLabel = UILabel()
		contentView.addSubview(titleLabel)
		titleLabel.text = "Bienvenue sur"
		titleLabel.textColor = Color.whitePrimary
		titleLabel.font = UIFont(name: "Lato-Light", size: 31)
		titleLabel.textAlignment = NSTextAlignment.Center
		titleLabel.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(contentView.snp_centerY).offset(-150)
			make.centerX.equalTo(contentView.snp_centerX)
		}
		
		let titleLabel2 = UILabel()
		contentView.addSubview(titleLabel2)
		titleLabel2.text = "Nelper!"
		titleLabel2.textColor = Color.whitePrimary
		titleLabel2.font = UIFont(name: "Lato-Light", size: 60)
		titleLabel2.textAlignment = NSTextAlignment.Center
		titleLabel2.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(titleLabel.snp_bottom)
			make.centerX.equalTo(contentView.snp_centerX)
		}
		
		let descLabel = UILabel()
		contentView.addSubview(descLabel)
		descLabel.text = "Entrez en contact avec des gens près de vous\net faites compléter vos tâches."
		descLabel.textColor = Color.whitePrimary
		descLabel.numberOfLines = 0
		descLabel.font = UIFont(name: "Lato-Light", size: 16)
		descLabel.textAlignment = NSTextAlignment.Center
		descLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(titleLabel2.snp_bottom).offset(40)
			make.centerX.equalTo(contentView.snp_centerX)
		}
		
		let descLine = UIView()
		contentView.addSubview(descLine)
		descLine.backgroundColor = Color.whitePrimary.colorWithAlphaComponent(0.3)
		descLine.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(descLabel.snp_bottom).offset(25)
			make.centerX.equalTo(contentView.snp_centerX)
			make.height.equalTo(0.5)
			make.width.equalTo(contentView.snp_width).multipliedBy(0.7)
		}
		
		let descLabel2 = UILabel()
		contentView.addSubview(descLabel2)
		descLabel2.text = "Faites de l'argent en complétant les tâches\ndes gens de votre communauté."
		descLabel2.textColor = Color.whitePrimary
		descLabel2.numberOfLines = 0
		descLabel2.font = UIFont(name: "Lato-Light", size: 16)
		descLabel2.textAlignment = NSTextAlignment.Center
		descLabel2.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(descLine.snp_bottom).offset(25)
			make.centerX.equalTo(contentView.snp_centerX)
		}
	}
}