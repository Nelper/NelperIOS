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
	private var separatorLine: UIView!
	private var kTextSize: CGFloat!
	private var isFirstSection = true
	
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
			(title: "My Profile", icon: UIImage(named: "noProfilePicture"), action: Selector("profileTapped:")),
			(title: "Settings", icon: UIImage(named:"settings-menu"), action: Selector("settingsTapped:")),
			(title: "Support", icon: UIImage(named:"support-menu"), action: Selector("howItWorksTapped:")),
			(title: "FAQ", icon: UIImage(named:"faq-menu"), action: Selector("faqTapped:")),
			(title: "Logout", icon: UIImage(named:"logout-menu"), action: Selector("logoutTapped:"))
		]
		self.sections = sections
		self.numberOfSections = sections.count
		
		//SET LAYOUT K
		self.iconHeight = 40
		self.sectionHeight = 50
		self.sectionPadding = 25
		self.kTextSize = 19
		
		self.createView()
		self.setProfilePicture()
	}
	
	func createView(){
		
		//BLUR AND VIBRANCY
		let blurEffect = UIBlurEffect(style: .ExtraLight)
		self.view = UIVisualEffectView(effect: blurEffect)
		
		//CONTAINER
		let sectionContainer = UIView()
		self.sectionContainer = sectionContainer
		self.view.addSubview(sectionContainer)
		self.sectionContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.view.snp_top).offset(80)
			make.left.equalTo(self.view.snp_left)
			make.right.equalTo(self.view.snp_right)
			make.bottom.equalTo(self.view.snp_bottom)
		}
		
		//EACH SECTIONS
		for index in 0...(numberOfSections - 1) {
			
			let sectionButton = UIButton()
			self.sectionButton = sectionButton
			self.sectionButton.setTitle(self.sections[index].title, forState: UIControlState.Normal)
			self.sectionButton.setTitleColor(blackPrimary.colorWithAlphaComponent(0.5), forState: UIControlState.Normal)
			self.sectionButton.titleLabel!.font = UIFont(name: "Lato-Regular", size: kTextSize)
			self.sectionButton.setBackgroundColor(whitePrimary.colorWithAlphaComponent(0.5), forState: UIControlState.Highlighted)
			self.sectionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
			self.sectionButton.addTarget(self, action: self.sections[index].action, forControlEvents: UIControlEvents.TouchUpInside)
			self.sectionContainer.addSubview(sectionButton)
			self.sectionButton.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(sectionContainer.snp_top).offset(index * (self.sectionHeight + self.sectionPadding))
				make.left.equalTo(self.sectionContainer.snp_right)
				make.width.equalTo(self.sectionContainer.snp_width)
				make.height.equalTo(self.sectionHeight)
			}
			
			if !isFirstSection {
				let separatorLine = UIView()
				self.separatorLine = separatorLine
				self.sectionButton.addSubview(separatorLine)
				self.separatorLine.backgroundColor = blackPrimary.colorWithAlphaComponent(0.2)
				self.separatorLine.alpha = 0.5
				self.separatorLine.snp_updateConstraints { (make) -> Void in
					make.height.equalTo(0.5)
					make.top.equalTo(self.sectionButton.snp_top).offset(-(sectionPadding / 2))
					make.width.equalTo(self.sectionButton.snp_width).multipliedBy(0.5)
					make.centerX.equalTo(self.sectionButton.snp_centerX).offset(-15)
				}
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
					make.left.equalTo(self.sectionButton.snp_left).offset(30)
					make.centerY.equalTo(self.sectionButton.snp_centerY)
					make.height.equalTo(self.iconHeight)
					make.width.equalTo(self.iconHeight)
				}
				
				if index != 0 {
					self.sectionIcon!.alpha = 0.4
					self.sectionIcon!.layer.cornerRadius = 0
				}
				
				self.sectionButton.titleEdgeInsets = UIEdgeInsetsMake(0, ((CGFloat(iconHeight) * 2) + 10), 0, 0)
				
				self.sectionIcons.append(sectionIcon)
				
			} else {
				
				self.sectionButton.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0)
			}
			
			self.sectionButton.snp_updateConstraints { (make) -> Void in
				make.left.equalTo(self.sectionContainer.snp_left)
			}
			
			let animationDuration = Double(index) * 0.3
			
			UIView.animateWithDuration(animationDuration, delay: 0.0, options: [.CurveEaseOut], animations:  {
				self.sectionButton.layoutIfNeeded()
			}, completion: nil)
			
			isFirstSection = false
		}
	}
	
	//MARK: ACTIONS
	
	func profileTapped(sender: UIButton) {
		print("profile")
	}
	
	func settingsTapped(sender: UIButton) {
		print("settings")
	}
	
	func logoutTapped(sender: UIButton) {
		ApiHelper.logout()
		
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		appDelegate.showLogin(true)
	}
	
	func spaceHack(sender:UIButton) {
		
	}
	
	func howItWorksTapped(sender: UIButton) {
		print("how it works")
	}
	
	func faqTapped(sender: UIButton) {
		print("faq")
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

