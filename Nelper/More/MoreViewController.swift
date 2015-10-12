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
	
	private var menuTitle: UILabel!
	
	private var sectionContainer: UIView!
	private var sectionButton: UIButton!
	private var sectionIcon: UIImageView?
	private var firstEmptyIconSection = true
	private var separatorLine: UIView!
	
	private var sections = [(title: String, icon: UIImage?, action: Selector)]()
	
	private var numberOfSections: Int!
	private var iconHeight: Int!
	private var sectionHeight: Int!
	private var sectionPadding: Int!
	
	private var sectionIcons = [UIImageView]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//SET SECTIONS
		let sections = [
			(title: "Profile", icon: UIImage(named: "noProfilePicture"), action: Selector("profileTapped:")),
			(title: "Settings", icon: UIImage(named:"twitter-black"), action: Selector("settingsTapped:")),
			(title: "Logout", icon: UIImage(named:"twitter-black"), action: Selector("logoutTapped:")),
			(title: "", icon: nil, action: Selector("spaceHack:")),
			(title: "How it works", icon: nil, action: Selector("howItWorksTapped:")),
			(title: "FAQ", icon: nil, action: Selector("faqTapped:"))
		]
		self.sections = sections
		self.numberOfSections = sections.count
		
		//SET LAYOUT K
		self.iconHeight = 40
		self.sectionHeight = 40
		self.sectionPadding = 15
		
		self.createView()
		self.setProfilePicture()
	}
	
	func createView(){
		
		let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
		self.view = UIVisualEffectView(effect: blurEffect)
		
		let menuTitle = UILabel()
		self.menuTitle = menuTitle
		self.view.addSubview(menuTitle)
		menuTitle.text = "More"
		menuTitle.font = UIFont(name: "Lato-Regular", size: kNavTitle18)
		menuTitle.textColor = whitePrimary
		menuTitle.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(self.view.snp_top).offset(40)
			make.left.equalTo(self.view.snp_left).offset(20)
		}
		
		let sectionContainer = UIView()
		self.sectionContainer = sectionContainer
		self.view.addSubview(sectionContainer)
		self.sectionContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.menuTitle.snp_top).offset(70)
			make.left.equalTo(self.view.snp_left)
			make.right.equalTo(self.view.snp_right)
			make.height.equalTo(sectionHeight * numberOfSections)
		}
		
		for index in 0...(numberOfSections - 1) {
			
			let sectionButton = UIButton()
			self.sectionButton = sectionButton
			self.sectionButton.setTitle(self.sections[index].title, forState: UIControlState.Normal)
			self.sectionButton.setTitleColor(whitePrimary, forState: UIControlState.Normal)
			self.sectionButton.titleLabel!.font = UIFont(name: "Lato-Regular", size: kNavTitle18)
			self.sectionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
			self.sectionButton.addTarget(self, action: self.sections[index].action, forControlEvents: UIControlEvents.TouchUpInside)
			self.sectionContainer.addSubview(sectionButton)
			self.sectionButton.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(sectionContainer.snp_top).offset(index * (self.sectionHeight + self.sectionPadding))
				make.left.equalTo(self.sectionContainer.snp_left)
				make.right.equalTo(self.sectionContainer.snp_right)
				make.height.equalTo(self.sectionHeight)
			}

			
			if sections[index].icon != nil {
				
				let sectionIcon = UIImageView()
				self.sectionIcon = sectionIcon
				self.sectionButton.addSubview(sectionIcon)
				self.sectionIcon!.layer.cornerRadius = CGFloat(iconHeight) / 2
				self.sectionIcon!.layer.masksToBounds = true
				self.sectionIcon!.clipsToBounds = true
				self.sectionIcon!.contentMode = UIViewContentMode.ScaleAspectFill
				self.sectionIcon!.image = self.sections[index].icon
				self.sectionIcon!.snp_makeConstraints { (make) -> Void in
					make.left.equalTo(self.sectionButton.snp_left).offset(20)
					make.centerY.equalTo(self.sectionButton.snp_centerY)
					make.height.equalTo(self.iconHeight)
					make.width.equalTo(self.iconHeight)
				}
				
				self.sectionButton.titleEdgeInsets = UIEdgeInsetsMake(0, (CGFloat(iconHeight) * 2), 0, 0)
				
				self.sectionIcons.append(sectionIcon)
				
			} else {
				
				if self.firstEmptyIconSection {

					let separatorLine = UIView()
					self.separatorLine = separatorLine
					self.sectionButton.addSubview(separatorLine)
					self.separatorLine.backgroundColor = grayDetails
					self.separatorLine.snp_updateConstraints { (make) -> Void in
						make.height.equalTo(0.5)
						make.centerY.equalTo(self.sectionButton.snp_centerY)
						make.width.equalTo(self.sectionButton.snp_width)
						make.left.equalTo(self.sectionContainer.snp_left)
					}
					
					self.firstEmptyIconSection = false
				}
				
				self.sectionButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0)
			}
		}
	}
	
	//MARK: ACTIONS
	
	func profileTapped(sender: UIButton) {
		
	}
	
	func settingsTapped(sender:UIButton) {
		
	}
	
	func logoutTapped(sender:UIButton) {
		ApiHelper.logout()
		
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		appDelegate.showLogin(true)
	}
	
	func spaceHack(sender:UIButton) {
		
	}
	
	func howItWorksTapped(sender: UIButton) {
		
	}
	
	func faqTapped(sender: UIButton) {
		
	}
	
	//MARK: Data
	
	/**
	Sets the user profile picture
	*/
	func setProfilePicture() {
		
		if PFUser.currentUser()!.objectForKey("customPicture") != nil {
			let profilePic = (PFUser.currentUser()!.objectForKey("customPicture") as? PFFile)!
			request(.GET,profilePic.url!).response() {
				(_, _, data, _) in
				let image = UIImage(data: data as NSData!)
				self.sectionIcons[0].image = image
			}
			
		} else if PFUser.currentUser()!.objectForKey("pictureURL") != nil {
			let profilePic = (PFUser.currentUser()!.objectForKey("pictureURL") as? String)!
			request(.GET,profilePic).response() {
				(_, _, data, _) in
				let image = UIImage(data: data as NSData!)
				self.sectionIcons[0].image = image
			}
		}
	}
}

