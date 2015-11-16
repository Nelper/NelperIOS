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
import SVProgressHUD

class MoreViewController: UIViewController {
	
	private var blurEffectView: UIVisualEffectView!
	
	private var sectionContainer: UIView!
	private var sectionButton: UIButton!
	private var sectionIcon: UIImageView?
	private var separatorLine: UIView!
	private var kTextSize: CGFloat!
	private var isFirstSection = true
	
	private var sections = [(title: String, icon: UIImage?, item: String)]()
	
	private var numberOfSections: Int!
	private var iconHeight: Int!
	private var sectionHeight: CGFloat!
	private var sectionPadding: CGFloat!
	
	private var sectionIcons = [UIImageView]()
	private var sectionButtons = [UIButton]()
	
	var fullView: UIViewController!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//SET SECTIONS
		let sections = [
			(title: "My Profile", icon: UIImage(named: "noProfilePicture"), item: "profile"),
			(title: "Settings", icon: UIImage(named:"settings-menu"), item: "settings"),
			(title: "Support", icon: UIImage(named:"support-menu"), item: "support"),
			(title: "FAQ", icon: UIImage(named:"faq-menu"), item: "faq"),
			(title: "Logout", icon: UIImage(named:"logout-menu"), item: "logout")
		]
		self.sections = sections
		self.numberOfSections = sections.count
		
		//SET LAYOUT K
		self.iconHeight = 40
		self.sectionHeight = 75
		self.sectionPadding = 0
		self.kTextSize = 19
		
		self.createView()
		self.setProfilePicture()
	}
	
	func createView(){
		
		//BLUR
		let blurEffect = UIBlurEffect(style: .ExtraLight)
		self.blurEffectView = UIVisualEffectView(effect: blurEffect)
		self.view.addSubview(blurEffectView)
		self.blurEffectView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self.view.snp_edges)
		}
		
		let verticalLine = UIView()
		blurEffectView.addSubview(verticalLine)
		verticalLine.backgroundColor = Color.blackPrimary.colorWithAlphaComponent(0.7)
		verticalLine.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(blurEffectView.snp_left)
			make.width.equalTo(0.5)
			make.height.equalTo(blurEffectView.snp_height)
			make.top.equalTo(blurEffectView.snp_top)
		}
		
		//CONTAINER
		let sectionContainer = UIView()
		self.sectionContainer = sectionContainer
		self.blurEffectView.addSubview(sectionContainer)
		self.sectionContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.view.snp_top).offset(80)
			make.left.equalTo(self.view.snp_left)
			make.width.equalTo(self.view.snp_width)
			make.height.equalTo(self.view.snp_height)
		}
		self.sectionContainer.layoutIfNeeded()
		
		//EACH SECTIONS
		for index in 0...(numberOfSections - 1) {
			
			let sectionButton = UIButton()
			self.sectionButton = sectionButton
			self.sectionButton.setTitle(self.sections[index].title, forState: UIControlState.Normal)
			self.sectionButton.setTitleColor(Color.blackPrimary.colorWithAlphaComponent(0.8), forState: UIControlState.Normal)
			self.sectionButton.titleLabel!.font = UIFont(name: "Lato-Regular", size: kTextSize)
			self.sectionButton.setBackgroundColor(Color.whitePrimary.colorWithAlphaComponent(0.5), forState: UIControlState.Highlighted)
			self.sectionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
			self.sectionButton.addTarget(self, action: "sectionTapped:", forControlEvents: UIControlEvents.TouchUpInside)
			self.sectionButton.tag = index
			self.sectionContainer.addSubview(sectionButton)
			self.sectionButton.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(self.sectionContainer.snp_top).offset(CGFloat(index) * (self.sectionHeight + self.sectionPadding))
				make.left.equalTo(self.sectionContainer.snp_right)
				make.width.equalTo(self.sectionContainer.snp_width)
				make.height.equalTo(self.sectionHeight)
			}
			self.sectionButton.alpha = 0
			self.sectionButton.layoutIfNeeded()
			
			if !isFirstSection {
				let separatorLine = UIView()
				self.separatorLine = separatorLine
				self.sectionButton.addSubview(separatorLine)
				self.separatorLine.backgroundColor = Color.blackPrimary.colorWithAlphaComponent(0.2)
				self.separatorLine.alpha = 0.5
				self.separatorLine.snp_updateConstraints { (make) -> Void in
					make.height.equalTo(0.5)
					make.top.equalTo(self.sectionButton.snp_top).offset(-(sectionPadding / 2))
					make.width.equalTo(self.sectionButton.snp_width).multipliedBy(0.5)
					make.centerX.equalTo(self.sectionButton.snp_centerX).offset(-15)
				}
				self.separatorLine.layoutIfNeeded()
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
				self.sectionIcon!.layoutIfNeeded()
				
				if index != 0 {
					self.sectionIcon!.alpha = 0.4
					self.sectionIcon!.layer.cornerRadius = 0
				}
				
				self.sectionButton.titleEdgeInsets = UIEdgeInsetsMake(0, ((CGFloat(iconHeight) * 2) + 15), 0, 0)
				
				self.sectionIcons.append(self.sectionIcon!)
				
			} else {
				
				self.sectionButton.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0)
			}
			
			//ANIMATION
			let animationDuration = (Double(index) * 0.1) + 0.4
			
			self.sectionButton.snp_updateConstraints { (make) -> Void in
				make.left.equalTo(self.sectionContainer.snp_right).offset((-self.view.frame.width) * 0.70)
			}
			
			UIView.animateWithDuration(animationDuration, delay: 0, options: [.CurveEaseOut], animations:  {
				self.sectionButton.alpha = 1
				self.sectionButton.layoutIfNeeded()
			}, completion: nil)
			
			self.sectionButtons.append(sectionButton)
			
			isFirstSection = false
		}
	}
	
	//MARK ANIMATIONS
	func closingAnimation() {
		
		for sectionButton in self.sectionButtons {
			sectionButton.snp_updateConstraints { (make) -> Void in
				make.left.equalTo(self.sectionContainer.snp_right)
			}
			
			UIView.animateWithDuration(0.4, delay: 0, options: [.CurveEaseOut], animations:  {
				sectionButton.alpha = 0
				sectionButton.layoutIfNeeded()
				}, completion: nil)
		}
	}
	
	func openingAnimation() {
		for i in 0...(numberOfSections) - 1 {
			
			let animationDuration = (Double(i) * 0.1) + 0.4
			
			self.sectionButtons[i].snp_updateConstraints { (make) -> Void in
				make.left.equalTo(self.sectionContainer.snp_right).offset((-self.fullView.view.frame.width) * 0.70)
			}
			
			UIView.animateWithDuration(animationDuration, delay: 0, options: [.CurveEaseOut], animations:  {
				self.sectionButtons[i].alpha = 1
				self.sectionButtons[i].layoutIfNeeded()
				}, completion: nil)
		}
	}
	
	//MARK: ACTIONS
	
	func sectionTapped(sender: UIButton) {
		UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Slide)
		var nextVC: UIViewController?
		
		switch self.sections[sender.tag].item {
		case "profile":
			nextVC = FullProfileViewController()
		case "settings":
			nextVC = MainSettingsViewController()
		case "support":
			SupportKit.show()
			return
		case "faq":
			nextVC = FaqViewController()
		case "logout":
			SVProgressHUD.setBackgroundColor(Color.whitePrimary)
			SVProgressHUD.setForegroundColor(Color.redPrimary)
			SVProgressHUD.showWithStatus("Logging out")
			
			self.blurEffectView.snp_remakeConstraints { (make) -> Void in
				make.edges.equalTo(self.view.snp_edges).inset(UIEdgeInsetsMake(0, self.view.bounds.width, 0, 0))
			}
			UIView.animateWithDuration(0.4, animations: { () -> Void in
				self.blurEffectView.layoutIfNeeded()
			})
			
			self.closingAnimation()
			
			_ = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: "logoutUser", userInfo: nil, repeats: false)
			
			return
		default:
			break
		}
		
		nextVC!.hidesBottomBarWhenPushed = true
		self.navigationController?.pushViewController(nextVC!, animated: true)
	}
	
	func logoutUser() {
		ApiHelper.logout()
			
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		appDelegate.showLogin(true)
		
		SVProgressHUD.dismiss()
	}
	
	//MARK: Data
	
	/*
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

