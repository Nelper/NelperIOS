//
//  OnboardingFourthViewController.swift
//  Nelper
//
//  Created by Pierre-Luc Benoit on 2015-11-30.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation

class OnboardingFourthViewController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.createView()
	}
	
	func createView() {
		
		self.view.backgroundColor = UIColor.whiteColor()
		
		let contentView = UIView()
		self.view.addSubview(contentView)
		contentView.backgroundColor = Color.redPrimary.colorWithAlphaComponent(0.9)
		contentView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self.view.snp_edges)
		}
		
		let titleLabel = UILabel()
		contentView.addSubview(titleLabel)
		titleLabel.text = "Devenez un Nelper"
		titleLabel.textColor = Color.whitePrimary
		titleLabel.numberOfLines = 0
		titleLabel.font = UIFont(name: "Lato-Light", size: 31)
		titleLabel.textAlignment = NSTextAlignment.Center
		titleLabel.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(contentView.snp_centerY).offset(-150)
			make.centerX.equalTo(contentView.snp_centerX)
		}
		
		let descLabel = UILabel()
		contentView.addSubview(descLabel)
		descLabel.text = "Vous souhaitez mettre à profit\nvos talents et faire de l'argent?"
		descLabel.textColor = Color.whitePrimary
		descLabel.numberOfLines = 0
		descLabel.font = UIFont(name: "Lato-Light", size: 20)
		descLabel.textAlignment = NSTextAlignment.Center
		descLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(titleLabel.snp_bottom).offset(70)
			make.centerX.equalTo(contentView.snp_centerX)
		}
		
		let descLabel2 = UILabel()
		contentView.addSubview(descLabel2)
		descLabel2.text = "Parcourez, appliquez, et complétez\ndes tâches dès maintenant."
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
		tabImage.image = UIImage(named: "onboarding-browse")
		tabImage.contentMode = .ScaleAspectFit
		tabImage.alpha = 0.8
		tabImage.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(descLabel2.snp_bottom).offset(50)
			make.centerX.equalTo(contentView.snp_centerX)
			make.width.equalTo(60)
			make.height.equalTo(60)
		}
	}
}