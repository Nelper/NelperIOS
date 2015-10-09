//
//  MoreViewController.swift
//  Nelper
//
//  Created by Pierre-Luc Benoit on 2015-09-25.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Alamofire

class MoreViewController: UIViewController {
	var profilePicture:UIImageView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.createView()
		self.setProfilePicture()
	}
	
	func createView(){
				let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
		self.view = UIVisualEffectView(effect: blurEffect)
		
		let menuTitle = UILabel()
		self.view.addSubview(menuTitle)
		menuTitle.text = "More"
		menuTitle.font = UIFont(name: "Lato-Regular", size: kTitle17)
		menuTitle.textColor = whitePrimary
		menuTitle.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(self.view.snp_top).offset(32)
			make.left.equalTo(self.view.snp_left).offset(20)
		}
		
		// Profile "Cell"
		let profileContainer = UIView()
		profileContainer.backgroundColor = UIColor.clearColor()
		self.view.addSubview(profileContainer)
		profileContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.view.snp_top).offset(80)
			make.left.equalTo(menuTitle.snp_left)
			make.right.equalTo(self.view.snp_right)
			make.height.equalTo(40)
		}
		
		let profilePicture = UIImageView()
		profileContainer.addSubview(profilePicture)
		self.profilePicture = profilePicture
		let profilePictureSize:CGFloat = 40
		profilePicture.contentMode = UIViewContentMode.ScaleAspectFill
		self.profilePicture.layer.cornerRadius = profilePictureSize/2
		self.profilePicture.clipsToBounds = true
		profilePicture.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(profileContainer)
			make.top.equalTo(profileContainer)
			make.width.equalTo(profilePictureSize)
			make.height.equalTo(profilePictureSize)
		}
		
		let profileLabel = UILabel()
		profileContainer.addSubview(profileLabel)
		profileLabel.text = "My Profile"
		profileLabel.textColor = whitePrimary
		profileLabel.font = UIFont(name: "Lato-Regular", size: kTitle17)
		profileLabel.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(profilePicture.snp_right).offset(8)
			make.centerY.equalTo(profilePicture.snp_centerY)
		}
		
		//Setting "cell"
		
		let settingsContainer = UIView()
		settingsContainer.backgroundColor = UIColor.clearColor()
		self.view.addSubview(settingsContainer)
		settingsContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(profileContainer.snp_bottom).offset(20)
			make.left.equalTo(menuTitle.snp_left)
			make.right.equalTo(self.view.snp_right)
			make.height.equalTo(40)
		}
		
		let settingsIcon = UIImageView()
		settingsContainer.addSubview(settingsIcon)
		settingsIcon.image = UIImage(named: "twitter-black")
		settingsIcon.contentMode = UIViewContentMode.ScaleAspectFill
		settingsIcon.layer.cornerRadius = profilePictureSize/2
		settingsIcon.clipsToBounds = true
		settingsIcon.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(settingsContainer)
			make.top.equalTo(settingsContainer)
			make.width.equalTo(profilePictureSize)
			make.height.equalTo(profilePictureSize)
		}
		
		let settingsLabel = UILabel()
		settingsContainer.addSubview(settingsLabel)
		settingsLabel.text = "Settings"
		settingsLabel.textColor = whitePrimary
		settingsLabel.font = UIFont(name: "Lato-Regular", size: kTitle17)
		settingsLabel.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(settingsIcon.snp_right).offset(8)
			make.centerY.equalTo(settingsIcon.snp_centerY)
		}
		
		//Logout "cell"
		
		let logoutContainer = UIView()
		logoutContainer.backgroundColor = UIColor.clearColor()
		self.view.addSubview(logoutContainer)
		logoutContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(settingsContainer.snp_bottom).offset(20)
			make.left.equalTo(menuTitle.snp_left)
			make.right.equalTo(self.view.snp_right)
			make.height.equalTo(40)
		}
		
		let logoutIcon = UIImageView()
		logoutContainer.addSubview(logoutIcon)
		logoutIcon.image = UIImage(named: "twitter-black")
		logoutIcon.contentMode = UIViewContentMode.ScaleAspectFill
		logoutIcon.layer.cornerRadius = profilePictureSize/2
		logoutIcon.clipsToBounds = true
		logoutIcon.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(logoutContainer)
			make.top.equalTo(logoutContainer)
			make.width.equalTo(profilePictureSize)
			make.height.equalTo(profilePictureSize)
		}
		
		let logoutLabel = UILabel()
		logoutContainer.addSubview(logoutLabel)
		logoutLabel.text = "Logout"
		logoutLabel.textColor = whitePrimary
		logoutLabel.font = UIFont(name: "Lato-Regular", size: kTitle17)
		logoutLabel.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(logoutIcon.snp_right).offset(8)
			make.centerY.equalTo(logoutIcon.snp_centerY)
		}
		
		//White line
		
		let whiteLine = UIView()
		self.view.addSubview(whiteLine)
		whiteLine.backgroundColor = blackPrimary.colorWithAlphaComponent(0.3)
		whiteLine.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(logoutContainer.snp_bottom).offset(20)
			make.left.equalTo(self.view.snp_left)
			make.right.equalTo(self.view.snp_right)
			make.height.equalTo(2)
		}
		
		let howItWorksContainer = UIView()
		howItWorksContainer.backgroundColor = UIColor.clearColor()
		self.view.addSubview(howItWorksContainer)
		howItWorksContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(whiteLine.snp_bottom).offset(20)
			make.left.equalTo(menuTitle.snp_left)
			make.right.equalTo(self.view.snp_right)
			make.height.equalTo(40)
		}
		
		let howItWorksLabel = UILabel()
		howItWorksContainer.addSubview(howItWorksLabel)
		howItWorksLabel.textColor = whitePrimary
		howItWorksLabel.font = UIFont(name: "Lato-Regular", size: kTitle17)
		howItWorksLabel.text = "How it works"
		howItWorksLabel.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(howItWorksContainer.snp_left)
			make.centerY.equalTo(howItWorksContainer.snp_centerY)
		}
		
		let faqContainer = UIView()
		faqContainer.backgroundColor = UIColor.clearColor()
		self.view.addSubview(faqContainer)
		faqContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(howItWorksContainer.snp_bottom).offset(20)
			make.left.equalTo(menuTitle.snp_left)
			make.right.equalTo(self.view.snp_right)
			make.height.equalTo(40)
		}
		
		let faqLabel = UILabel()
		faqContainer.addSubview(faqLabel)
		faqLabel.textColor = whitePrimary
		faqLabel.font = UIFont(name: "Lato-Regular", size: kTitle17)
		faqLabel.text = "FAQ"
		faqLabel.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(faqContainer.snp_left)
			make.centerY.equalTo(faqContainer.snp_centerY)
		}
	}
	
	//MARK: Data
	
	/**
	Sets the user profile picture
	*/
	func setProfilePicture() {
		
		let image = UIImage(named: "noProfilePicture")
		
		if PFUser.currentUser()!.objectForKey("customPicture") != nil {
			let profilePic = (PFUser.currentUser()!.objectForKey("customPicture") as? PFFile)!
			request(.GET,profilePic.url!).response() {
				(_, _, data, _) in
				let image = UIImage(data: data as NSData!)
				self.profilePicture.image = image
			}
			
		} else if PFUser.currentUser()!.objectForKey("pictureURL") != nil {
			let profilePic = (PFUser.currentUser()!.objectForKey("pictureURL") as? String)!
			request(.GET,profilePic).response() {
				(_, _, data, _) in
				let image = UIImage(data: data as NSData!)
				self.profilePicture.image = image
			}
		}
		
		self.profilePicture.image = image
	}
}

