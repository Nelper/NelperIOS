//
//  ProfileAcceptedView.swift
//  Nelper
//
//  Created by Pierre-Luc Benoit on 2015-11-27.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation

class ProfileAcceptedView: UIView {
	
	var profileContainer: ProfileCellView!
	
	init(user: User) {
		super.init(frame: CGRectZero)
		
		self.createView(user)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	func createView(user: User) {
		
		//Applicant
		
		let profileContainer = ProfileCellView(user: user)
		self.profileContainer = profileContainer
		self.addSubview(profileContainer)
		profileContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.snp_top)
			make.left.equalTo(self.snp_left)
			make.right.equalTo(self.snp_right)
			make.height.equalTo(90)
		}
		profileContainer.profileContainer.layer.borderWidth = 0
		
		let profileContainerUnderline = UIView()
		profileContainer.addSubview(profileContainerUnderline)
		profileContainerUnderline.backgroundColor = Color.grayDetails
		profileContainerUnderline.snp_makeConstraints { (make) -> Void in
			make.width.equalTo(profileContainer.snp_width)
			make.centerX.equalTo(profileContainer.snp_centerX)
			make.bottom.equalTo(profileContainer.snp_bottom)
			make.height.equalTo(0.5)
		}
		
		//Nelper info Container
		
		let informationContainer = UIView()
		self.addSubview(informationContainer)
		informationContainer.backgroundColor = Color.whitePrimary
		informationContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(profileContainer.snp_bottom)
			make.left.equalTo(self.snp_left)
			make.right.equalTo(self.snp_right)
		}
		
		let emailLabel = UILabel()
		informationContainer.addSubview(emailLabel)
		emailLabel.text = "very@hardcoded.com"
		emailLabel.textColor = Color.darkGrayDetails
		emailLabel.font = UIFont(name: "Lato-Regular", size: kText15)
		emailLabel.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(informationContainer.snp_centerX).offset(15)
			make.top.equalTo(informationContainer.snp_top).offset(20)
		}
		
		let emailIcon = UIImageView()
		informationContainer.addSubview(emailIcon)
		emailIcon.image = UIImage(named: "at")
		emailIcon.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(emailLabel.snp_left).offset(-15)
			make.centerY.equalTo(emailLabel.snp_centerY)
			make.height.equalTo(25)
			make.width.equalTo(25)
		}
		
		let phoneLabel = UILabel()
		informationContainer.addSubview(phoneLabel)
		phoneLabel.text = "#hardcoded"
		phoneLabel.textColor = Color.darkGrayDetails
		phoneLabel.font = UIFont(name: "Lato-Regular", size: kText15)
		phoneLabel.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(informationContainer.snp_centerX).offset(15)
			make.top.equalTo(emailLabel.snp_bottom).offset(30)
		}
		
		let phoneIcon = UIImageView()
		informationContainer.addSubview(phoneIcon)
		phoneIcon.image = UIImage(named: "phone")
		phoneIcon.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(phoneLabel.snp_left).offset(-15)
			make.centerY.equalTo(phoneLabel.snp_centerY)
			make.height.equalTo(25)
			make.width.equalTo(25)
		}
		
		informationContainer.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(phoneIcon.snp_bottom).offset(20)
		}
		
		self.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(informationContainer.snp_bottom)
		}
	}
}