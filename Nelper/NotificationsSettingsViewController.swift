//
//  NotificationsSettingsViewController.swift
//  Nelper
//
//  Created by Pierre-Luc Benoit on 2015-10-14.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation
import UIKit

class NotificationsSettingsViewController: UIViewController {
	
	private var navBar: NavBar!
	
	var scrollView: UIScrollView!
	var contentView: UIView!
	
	var t1FirstSwitch: UISwitch!
	var t1SecondSwitch: UISwitch!
	
	
	var t2FirstSwitch: UISwitch!
	var t2SecondSwitch: UISwitch!
	
	var t3FirstSwitch: UISwitch!
	
	let kPadding: Int = 20
	
	var userPrivateData: UserPrivateData!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		userPrivateData = ApiHelper.getUserPrivateData()
		
		
		createView()
		adjustUI()
	}
	
	//MARK: UI
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		self.scrollView.contentSize = self.contentView.frame.size
		self.scrollView.alwaysBounceVertical = true
	}
	
	func createView() {
		
		let notifications = userPrivateData.notifications
		
		//NAVBAR
		let navBar = NavBar()
		self.navBar = navBar
		self.view.addSubview(navBar)
		navBar.setTitle("Notification Settings")
		let previousBtn = UIButton()
		previousBtn.addTarget(self, action: "backButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		navBar.backButton = previousBtn
		navBar.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.view.snp_top)
			make.right.equalTo(self.view.snp_right)
			make.left.equalTo(self.view.snp_left)
			make.height.equalTo(64)
		}
		
		let backgroundView = UIView()
		self.view.addSubview(backgroundView)
		backgroundView.backgroundColor = Color.whiteBackground
		backgroundView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(navBar.snp_bottom)
			make.left.equalTo(self.view.snp_left)
			make.right.equalTo(self.view.snp_right)
			make.bottom.equalTo(self.view.snp_bottom)
		}
		
		let scrollView = UIScrollView()
		self.scrollView = scrollView
		backgroundView.addSubview(scrollView)
		scrollView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(backgroundView)
		}
		
		let contentView = UIView()
		self.contentView = contentView
		self.scrollView.addSubview(contentView)
		contentView.backgroundColor = Color.whiteBackground
		contentView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(scrollView.snp_top)
			make.left.equalTo(scrollView.snp_left)
			make.right.equalTo(scrollView.snp_right)
			make.height.greaterThanOrEqualTo(backgroundView.snp_height)
			make.width.equalTo(backgroundView.snp_width)
		}
		
		//EMAIL NOTIFICATIONS
		let emailNotContainer = DefaultContainerView()
		self.contentView.addSubview(emailNotContainer)
		emailNotContainer.containerTitle = "Email Notifications"
		emailNotContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(contentView.snp_top).offset(self.kPadding)
			make.left.equalTo(contentView.snp_left)
			make.right.equalTo(contentView.snp_right)
		}
		
		//TASK POSTER
		let t1Label = UILabel()
		emailNotContainer.contentView.addSubview(t1Label)
		t1Label.text = "Task Poster"
		t1Label.font = UIFont(name: "Lato-Regular", size: kTitle17)
		t1Label.textColor = Color.redPrimary
		t1Label.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(emailNotContainer.contentView.snp_top).offset(15)
			make.left.equalTo(emailNotContainer.snp_left).offset(self.kPadding)
		}
		
		let t1EmailMeWhen = UILabel()
		emailNotContainer.contentView.addSubview(t1EmailMeWhen)
		t1EmailMeWhen.text = "Email me when"
		t1EmailMeWhen.font = UIFont(name: "Lato-Regular", size: kText15)
		t1EmailMeWhen.textColor = Color.darkGrayText
		t1EmailMeWhen.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(t1Label.snp_bottom).offset(15)
			make.left.equalTo(t1Label.snp_left)
		}
		
		let t1FirstSwitch = UISwitch()
		self.t1FirstSwitch = t1FirstSwitch
		emailNotContainer.contentView.addSubview(t1FirstSwitch)
		t1FirstSwitch.on = notifications.posterApplication.email
		t1FirstSwitch.onTintColor = Color.redPrimary
		t1FirstSwitch.tintColor = Color.grayDetails
		t1FirstSwitch.thumbTintColor = Color.whitePrimary
		t1FirstSwitch.addTarget(self, action: "t1FirstSwitchChanged:", forControlEvents: .ValueChanged)
		t1FirstSwitch.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(emailNotContainer.snp_right).offset(-self.kPadding)
			make.top.equalTo(t1EmailMeWhen.snp_bottom).offset(kPadding)
		}
		
		let t1FirstEvent = UILabel()
		emailNotContainer.contentView.addSubview(t1FirstEvent)
		t1FirstEvent.text = "A Nelper applies for my task"
		t1FirstEvent.font = UIFont(name: "Lato-Light", size: kText15)
		t1FirstEvent.textColor = Color.blackPrimary
		t1FirstEvent.numberOfLines = 0
		t1FirstEvent.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(t1EmailMeWhen.snp_bottom).offset(kPadding)
			make.left.equalTo(t1Label.snp_left)
			make.right.equalTo(t1FirstSwitch.snp_left).offset(-15)
		}
		
		let t1SecondSwitch = UISwitch()
		self.t1SecondSwitch = t1SecondSwitch
		emailNotContainer.contentView.addSubview(t1SecondSwitch)
		t1SecondSwitch.on = notifications.posterRequestPayment.email
		t1SecondSwitch.onTintColor = Color.redPrimary
		t1SecondSwitch.tintColor = Color.grayDetails
		t1SecondSwitch.thumbTintColor = Color.whitePrimary
		t1SecondSwitch.addTarget(self, action: "t1SecondSwitchChanged:", forControlEvents: .ValueChanged)
		t1SecondSwitch.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(t1FirstSwitch.snp_right)
			make.top.equalTo(t1FirstEvent.snp_bottom).offset(kPadding)
		}
		
		let t1SecondEvent = UILabel()
		emailNotContainer.contentView.addSubview(t1SecondEvent)
		t1SecondEvent.text = "My Nelper requests their payment"
		t1SecondEvent.font = UIFont(name: "Lato-Light", size: kText15)
		t1SecondEvent.textColor = Color.blackPrimary
		t1SecondEvent.numberOfLines = 0
		t1SecondEvent.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(t1FirstEvent.snp_bottom).offset(kPadding)
			make.left.equalTo(t1FirstEvent.snp_left)
			make.right.equalTo(t1SecondSwitch.snp_left).offset(-15)
		}
		
		let t2SeparatorLine = UIView()
		emailNotContainer.addSubview(t2SeparatorLine)
		t2SeparatorLine.backgroundColor = Color.grayDetails
		t2SeparatorLine.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(emailNotContainer.snp_right)
			make.left.equalTo(emailNotContainer.snp_left)
			make.top.equalTo(t1SecondSwitch.snp_bottom).offset(15)
			make.height.equalTo(0.5)
		}
		
		//NELPER
		let t2Label = UILabel()
		emailNotContainer.contentView.addSubview(t2Label)
		t2Label.text = "Nelper"
		t2Label.font = UIFont(name: "Lato-Regular", size: kTitle17)
		t2Label.textColor = Color.redPrimary
		t2Label.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(t2SeparatorLine.snp_bottom).offset(15)
			make.left.equalTo(emailNotContainer.snp_left).offset(self.kPadding)
		}
		
		let t2EmailMeWhen = UILabel()
		emailNotContainer.contentView.addSubview(t2EmailMeWhen)
		t2EmailMeWhen.text = "Email me when"
		t2EmailMeWhen.font = UIFont(name: "Lato-Regular", size: kText15)
		t2EmailMeWhen.textColor = Color.darkGrayText
		t2EmailMeWhen.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(t2Label.snp_bottom).offset(15)
			make.left.equalTo(t2Label.snp_left)
		}
		
		let t2FirstEvent = UILabel()
		emailNotContainer.contentView.addSubview(t2FirstEvent)
		t2FirstEvent.text = "My task application status changes"
		t2FirstEvent.font = UIFont(name: "Lato-Light", size: kText15)
		t2FirstEvent.textColor = Color.blackPrimary
		t2FirstEvent.numberOfLines = 0
		t2FirstEvent.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(t2EmailMeWhen.snp_bottom).offset(kPadding)
			make.left.equalTo(t2Label.snp_left)
		}
		
		let t2FirstSwitch = UISwitch()
		self.t2FirstSwitch = t2FirstSwitch
		emailNotContainer.contentView.addSubview(t2FirstSwitch)
		t2FirstSwitch.on = notifications.nelperApplicationStatus.email
		t2FirstSwitch.onTintColor = Color.redPrimary
		t2FirstSwitch.tintColor = Color.grayDetails
		t2FirstSwitch.thumbTintColor = Color.whitePrimary
		t2FirstSwitch.addTarget(self, action: "t2FirstSwitchChanged:", forControlEvents: .ValueChanged)
		t2FirstSwitch.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(t1FirstSwitch.snp_right)
			make.centerY.equalTo(t2FirstEvent.snp_centerY)
		}
		
		t2FirstEvent.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(t2FirstSwitch.snp_left).offset(-15)
		}
		
		let t2SecondEvent = UILabel()
		emailNotContainer.contentView.addSubview(t2SecondEvent)
		t2SecondEvent.text = "I receive a payment"
		t2SecondEvent.font = UIFont(name: "Lato-Light", size: kText15)
		t2SecondEvent.textColor = Color.blackPrimary
		t2SecondEvent.numberOfLines = 0
		t2SecondEvent.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(t2FirstEvent.snp_bottom).offset(kPadding)
			make.left.equalTo(t2FirstEvent.snp_left)
		}
		
		let t2SecondSwitch = UISwitch()
		self.t2SecondSwitch = t2SecondSwitch
		emailNotContainer.contentView.addSubview(t2SecondSwitch)
		t2SecondSwitch.on = notifications.nelperReceivedPayment.email
		t2SecondSwitch.onTintColor = Color.redPrimary
		t2SecondSwitch.tintColor = Color.grayDetails
		t2SecondSwitch.thumbTintColor = Color.whitePrimary
		t2SecondSwitch.addTarget(self, action: "t2SecondSwitchChanged:", forControlEvents: .ValueChanged)
		t2SecondSwitch.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(t1FirstSwitch.snp_right)
			make.centerY.equalTo(t2SecondEvent.snp_centerY)
		}
		
		t2SecondEvent.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(t2FirstEvent.snp_right)
		}
		
		let t3SeparatorLine = UIView()
		emailNotContainer.addSubview(t3SeparatorLine)
		t3SeparatorLine.backgroundColor = Color.grayDetails
		t3SeparatorLine.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(emailNotContainer.snp_right)
			make.left.equalTo(emailNotContainer.snp_left)
			make.top.equalTo(t2SecondSwitch.snp_bottom).offset(15)
			make.height.equalTo(0.5)
		}
		
		//NEWSLETTER
		let t3Label = UILabel()
		emailNotContainer.contentView.addSubview(t3Label)
		t3Label.text = "Newsletter"
		t3Label.font = UIFont(name: "Lato-Regular", size: kTitle17)
		t3Label.textColor = Color.redPrimary
		t3Label.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(t3SeparatorLine.snp_bottom).offset(15)
			make.left.equalTo(emailNotContainer.snp_left).offset(self.kPadding)
		}
		
		let t3SendMe = UILabel()
		emailNotContainer.contentView.addSubview(t3SendMe)
		t3SendMe.text = "Send me"
		t3SendMe.font = UIFont(name: "Lato-Regular", size: kText15)
		t3SendMe.textColor = Color.darkGrayText
		t3SendMe.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(t3Label.snp_bottom).offset(15)
			make.left.equalTo(t3Label.snp_left)
		}
		
		let t3FirstEvent = UILabel()
		emailNotContainer.contentView.addSubview(t3FirstEvent)
		t3FirstEvent.text = "Newsletters introducing new features"
		t3FirstEvent.font = UIFont(name: "Lato-Light", size: kText15)
		t3FirstEvent.textColor = Color.blackPrimary
		t3FirstEvent.numberOfLines = 0
		t3FirstEvent.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(t3SendMe.snp_bottom).offset(kPadding)
			make.left.equalTo(t3Label.snp_left)
		}
		
		let t3FirstSwitch = UISwitch()
		self.t3FirstSwitch = t3FirstSwitch
		emailNotContainer.contentView.addSubview(t3FirstSwitch)
		t3FirstSwitch.on = notifications.newsletter.email
		t3FirstSwitch.onTintColor = Color.redPrimary
		t3FirstSwitch.tintColor = Color.grayDetails
		t3FirstSwitch.thumbTintColor = Color.whitePrimary
		t3FirstSwitch.addTarget(self, action: "t3FirstSwitchChanged:", forControlEvents: .ValueChanged)
		t3FirstSwitch.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(t1FirstSwitch.snp_right)
			make.centerY.equalTo(t3FirstEvent.snp_centerY)
		}
		
		t3FirstEvent.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(t3FirstSwitch.snp_left).offset(-15)
		}
		
		emailNotContainer.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(t3FirstSwitch.snp_bottom).offset(self.kPadding)
		}
		
		contentView.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(emailNotContainer.snp_bottom).offset(20)
		}
	}
	
	func adjustUI() {
	
	}
	
	//MARK: ACTIONS
	func backButtonTapped(sender: UIButton) {
		self.navigationController?.popViewControllerAnimated(true)
		view.endEditing(true)
	}
	
	func t1FirstSwitchChanged(sender: UISwitch) {
		self.userPrivateData.notifications.posterApplication.email = !self.userPrivateData.notifications.posterApplication.email
		ApiHelper.updateNotificationSettings(self.userPrivateData.notifications)
	}
	
	func t1SecondSwitchChanged(sender: UISwitch) {
		self.userPrivateData.notifications.posterRequestPayment.email = !self.userPrivateData.notifications.posterRequestPayment.email
		ApiHelper.updateNotificationSettings(self.userPrivateData.notifications)
	}
	
	func t2FirstSwitchChanged(sender: UISwitch) {
		self.userPrivateData.notifications.nelperApplicationStatus.email = !self.userPrivateData.notifications.nelperApplicationStatus.email
		ApiHelper.updateNotificationSettings(self.userPrivateData.notifications)
	}
	
	func t2SecondSwitchChanged(sender: UISwitch) {
		self.userPrivateData.notifications.nelperReceivedPayment.email = !self.userPrivateData.notifications.nelperReceivedPayment.email
		ApiHelper.updateNotificationSettings(self.userPrivateData.notifications)
	}
	
	func t3FirstSwitchChanged(sender: UISwitch) {
		self.userPrivateData.notifications.newsletter.email = !self.userPrivateData.notifications.newsletter.email
		ApiHelper.updateNotificationSettings(self.userPrivateData.notifications)
	}
	
}