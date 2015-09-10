//
//  MyTaskDetailsAcceptedViewController.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-09-07.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class MyTaskDetailsAcceptedViewController: UIViewController, ApplicantProfileViewControllerDelegate {
	
	var contentView:UIView!
	var scrollView:UIScrollView!
	var task:FindNelpTask!
	var acceptedApplicant:User!
	var acceptedApplication:NelpTaskApplication!
	var picture:UIImageView!
	var firstStar:UIImageView!
	var secondStar:UIImageView!
	var thirdStar:UIImageView!
	var fourthStar:UIImageView!
	var fifthStar:UIImageView!
	var chatButton:UIButton!
	var conversationController:UINavigationController?
	var tempVC:UIViewController!
	var fakeButton:UIButton!
	var navBar:NavBar!
	
	//MARK: Initialization
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.setApplicant()
		self.setImages(acceptedApplicant)
		self.createView()
		self.setFeedback(acceptedApplicant)
	}
	
	//MARK:Creating the View
	
	func createView(){
		
		var navBar = NavBar()
		self.navBar = navBar
		self.view.addSubview(navBar)
		navBar.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.view.snp_top)
			make.right.equalTo(self.view.snp_right)
			make.left.equalTo(self.view.snp_left)
			make.height.equalTo(64)
		}
		
		let backBtn = UIButton()
		backBtn.addTarget(self, action: "backButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		navBar.backButton = backBtn
		navBar.setImage(UIImage(named: "close_red" )!)
		navBar.setTitle("My Task")
		
		var backgroundView = UIView()
		self.view.addSubview(backgroundView)
		backgroundView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(navBar.snp_bottom)
			make.width.equalTo(self.view.snp_width)
			make.bottom.equalTo(self.view.snp_bottom)
		}
		backgroundView.backgroundColor = whiteNelpyColor
		
		var scrollView = UIScrollView()
		self.scrollView = scrollView
		backgroundView.addSubview(scrollView)
		scrollView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(backgroundView)
		}
		
		var contentView = UIView()
		self.contentView = contentView
		scrollView.addSubview(contentView)
		contentView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(scrollView.snp_top)
			make.left.equalTo(scrollView.snp_left)
			make.right.equalTo(scrollView.snp_right)
			make.height.greaterThanOrEqualTo(backgroundView.snp_height)
			make.width.equalTo(backgroundView.snp_width)
		}
		contentView.backgroundColor = whiteNelpyColor
		
		var taskLabelContainer = UIView()
		self.contentView.addSubview(taskLabelContainer)
		taskLabelContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(contentView.snp_top)
			make.width.equalTo(contentView.snp_width)
			make.height.equalTo(65)
		}
		
		var taskLabel = UILabel()
		taskLabel.textAlignment = NSTextAlignment.Center
		taskLabel.numberOfLines = 0
		taskLabel.text = self.task.title
		taskLabelContainer.addSubview(taskLabel)
		taskLabel.textColor = darkGrayDetails
		taskLabel.font = UIFont(name: "HelveticaNeue", size: kSubtitleFontSize)
		taskLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(taskLabelContainer.snp_top).offset(4)
			make.bottom.equalTo(taskLabelContainer.snp_bottom).offset(-4)
			make.left.equalTo(taskLabelContainer.snp_left).offset(8)
			make.right.equalTo(taskLabelContainer.snp_right).offset(-4)
		}
		
		//Progress + Payment Container
		
		var progressContainer = UIView()
		contentView.addSubview(progressContainer)
		progressContainer.layer.borderColor = grayDetails.CGColor
		progressContainer.layer.borderWidth = 1
		progressContainer.backgroundColor = navBarColor
		progressContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(taskLabelContainer.snp_bottom)
			make.left.equalTo(contentView.snp_left)
			make.right.equalTo(contentView.snp_right)
			make.height.equalTo(backgroundView.snp_height).dividedBy(1.6)
		}
		
		//Progress Bar
		
		//Nelper Accepted
		var nelperAcceptedLabel = UILabel()
		progressContainer.addSubview(nelperAcceptedLabel)
		nelperAcceptedLabel.numberOfLines = 0
		nelperAcceptedLabel.textAlignment = NSTextAlignment.Center
		nelperAcceptedLabel.text = "Nelper \nAccepted"
		nelperAcceptedLabel.textColor = blackNelpyColor
		nelperAcceptedLabel.font = UIFont(name: "HelveticaNeue", size: kProgressBarTextFontSize)
		nelperAcceptedLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(progressContainer.snp_top).offset(20)
			make.left.equalTo(progressContainer.snp_left).offset(12)
		}
		
		var nelperAcceptedImageView = UIImageView()
		progressContainer.addSubview(nelperAcceptedImageView)
		nelperAcceptedImageView.image = UIImage(named: "accepted")
		nelperAcceptedImageView.contentMode = UIViewContentMode.ScaleAspectFill
		nelperAcceptedImageView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(nelperAcceptedLabel.snp_bottom).offset(20)
			make.centerX.equalTo(nelperAcceptedLabel.snp_centerX)
			make.width.equalTo(30)
			make.height.equalTo(30)
		}
		
		var nelperAcceptedLine = UIView()
		progressContainer.addSubview(nelperAcceptedLine)
		nelperAcceptedLine.backgroundColor = blackNelpyColor
		nelperAcceptedLine.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(nelperAcceptedLabel.snp_bottom)
			make.bottom.equalTo(nelperAcceptedImageView.snp_top).offset(-2)
			make.width.equalTo(1)
			make.centerX.equalTo(nelperAcceptedLabel.snp_centerX)
		}
		
		//Leave Feedback(Last for size)
		
		var leaveFeedbackImageView = UIImageView()
		progressContainer.addSubview(leaveFeedbackImageView)
		leaveFeedbackImageView.image = UIImage(named: "black_circle")
		leaveFeedbackImageView.contentMode = UIViewContentMode.ScaleAspectFill
		leaveFeedbackImageView.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(nelperAcceptedImageView.snp_centerY)
			make.right.equalTo(progressContainer.snp_right).offset(-30)
			make.width.equalTo(40)
			make.height.equalTo(40)
		}
		
		var leaveFeedbackLabel = UILabel()
		progressContainer.addSubview(leaveFeedbackLabel)
		leaveFeedbackLabel.numberOfLines = 0
		leaveFeedbackLabel.textAlignment = NSTextAlignment.Center
		leaveFeedbackLabel.text = "Rating\n&\nFeedback"
		leaveFeedbackLabel.textColor = blackNelpyColor
		leaveFeedbackLabel.font = UIFont(name: "HelveticaNeue", size: kProgressBarTextFontSize)
		leaveFeedbackLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(leaveFeedbackImageView.snp_bottom).offset(10)
			make.right.equalTo(progressContainer.snp_right).offset(-18)
		}
		
		var leaveFeedbackLine = UIView()
		progressContainer.addSubview(leaveFeedbackLine)
		leaveFeedbackLine.backgroundColor = blackNelpyColor
		leaveFeedbackLine.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(leaveFeedbackImageView.snp_bottom).offset(-2)
			make.bottom.equalTo(leaveFeedbackLabel.snp_top)
			make.width.equalTo(1)
			make.centerX.equalTo(leaveFeedbackImageView.snp_centerX)
		}
		
		var paymentImageView = UIImageView()
		progressContainer.addSubview(paymentImageView)
		paymentImageView.image = UIImage(named: "accepted")
		paymentImageView.contentMode = UIViewContentMode.ScaleAspectFill
		paymentImageView.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(nelperAcceptedImageView.snp_centerY)
			make.left.equalTo(nelperAcceptedImageView.snp_right).offset(40)
			make.height.equalTo(30)
			make.width.equalTo(30)
		}
		
		var paymentLabel = UILabel()
		progressContainer.addSubview(paymentLabel)
		paymentLabel.numberOfLines = 0
		paymentLabel.textAlignment = NSTextAlignment.Center
		paymentLabel.text = "Payment Sent"
		paymentLabel.textColor = blackNelpyColor
		paymentLabel.font = UIFont(name: "HelveticaNeue", size: kProgressBarTextFontSize)
		paymentLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(paymentImageView.snp_bottom).offset(20)
			make.centerX.equalTo(paymentImageView.snp_centerX)
		}
		
		var paymentLine = UIView()
		progressContainer.addSubview(paymentLine)
		paymentLine.backgroundColor = blackNelpyColor
		paymentLine.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(paymentImageView.snp_bottom).offset(2)
			make.bottom.equalTo(paymentLabel.snp_top)
			make.width.equalTo(1)
			make.centerX.equalTo(paymentImageView.snp_centerX)
		}
		
		var approvedTaskImageView = UIImageView()
		progressContainer.addSubview(approvedTaskImageView)
		approvedTaskImageView.image = UIImage(named: "pending")
		approvedTaskImageView.contentMode = UIViewContentMode.ScaleAspectFill
		approvedTaskImageView.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(nelperAcceptedImageView.snp_centerY)
			make.right.equalTo(leaveFeedbackImageView.snp_left).offset(-40)
			make.height.equalTo(30)
			make.width.equalTo(30)
		}
		
		var approvedTaskLabel = UILabel()
		progressContainer.addSubview(approvedTaskLabel)
		approvedTaskLabel.numberOfLines = 0
		approvedTaskLabel.textAlignment = NSTextAlignment.Center
		approvedTaskLabel.text = "Approved task completion"
		approvedTaskLabel.textColor = blackNelpyColor
		approvedTaskLabel.font = UIFont(name: "HelveticaNeue", size: kProgressBarTextFontSize)
		approvedTaskLabel.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(nelperAcceptedLabel.snp_centerY)
			make.centerX.equalTo(approvedTaskImageView.snp_centerX)
		}
		
		var approvedTaskLine = UIView()
		progressContainer.addSubview(approvedTaskLine)
		approvedTaskLine.backgroundColor = blackNelpyColor
		approvedTaskLine.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(approvedTaskImageView.snp_top).offset(-2)
			make.top.equalTo(approvedTaskLabel.snp_bottom)
			make.width.equalTo(1)
			make.centerX.equalTo(approvedTaskImageView.snp_centerX)
		}
		
		
		var lineBetweenAcceptedAndPayment = UIView()
		progressContainer.addSubview(lineBetweenAcceptedAndPayment)
		lineBetweenAcceptedAndPayment.backgroundColor = progressGreen
		lineBetweenAcceptedAndPayment.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(nelperAcceptedImageView.snp_centerY)
			make.left.equalTo(nelperAcceptedImageView.snp_right)
			make.right.equalTo(paymentImageView.snp_left)
			make.height.equalTo(2)
		}
		
		var lineBetweenPaymentAndApprove = UIView()
		progressContainer.addSubview(lineBetweenPaymentAndApprove)
		lineBetweenPaymentAndApprove.backgroundColor = pendingYellow
		lineBetweenPaymentAndApprove.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(paymentImageView.snp_centerY)
			make.left.equalTo(paymentImageView.snp_right)
			make.right.equalTo(approvedTaskImageView.snp_left)
			make.height.equalTo(2)
		}
		
		var lineBetweenApproveAndRating = UIView()
		progressContainer.addSubview(lineBetweenApproveAndRating)
		lineBetweenApproveAndRating.backgroundColor = blackNelpyColor
		lineBetweenApproveAndRating.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(paymentImageView.snp_centerY)
			make.left.equalTo(approvedTaskImageView.snp_right)
			make.right.equalTo(leaveFeedbackImageView.snp_left).offset(5)
			make.height.equalTo(2)
		}
		
		//Payment Button
		
		var paymentButton = UIButton()
		progressContainer.addSubview(paymentButton)
		paymentButton.setTitle("Proceed to Payment", forState: UIControlState.Normal)
		paymentButton.addTarget(self, action: "didTapPaymentButton:", forControlEvents: UIControlEvents.TouchUpInside)
		paymentButton.setTitleColor(whiteGrayColor, forState: UIControlState.Normal)
		paymentButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: kButtonFontSize)
		paymentButton.backgroundColor = nelperRedColor
		paymentButton.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(progressContainer.snp_bottom).offset(-60)
			make.centerX.equalTo(progressContainer.snp_centerX)
			make.width.equalTo(progressContainer.snp_width).dividedBy(1.6)
			make.height.equalTo(40)
		}
		
		//About Nelper Pay
		
		var aboutNelperPayLabel = UILabel()
		progressContainer.addSubview(aboutNelperPayLabel)
		aboutNelperPayLabel.text = "About NelperPay"
		aboutNelperPayLabel.textColor = blackNelpyColor
		aboutNelperPayLabel.backgroundColor = navBarColor
		aboutNelperPayLabel.font = UIFont(name: "HelveticaNeue", size: kProgressBarTextFontSize)
		aboutNelperPayLabel.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(progressContainer.snp_bottom).offset(-20)
			make.centerX.equalTo(progressContainer.snp_centerX).offset(10)
		}
		
		var aboutNelperPayButton = UIButton()
		progressContainer.addSubview(aboutNelperPayButton)
		aboutNelperPayButton.setBackgroundImage(UIImage(named: "interrogation"), forState: UIControlState.Normal)
		aboutNelperPayButton.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(aboutNelperPayLabel.snp_centerY)
			make.right.equalTo(aboutNelperPayLabel.snp_left).offset(-2)
			make.height.equalTo(20)
			make.width.equalTo(20)
		}
		
		//NelperPayLogo
		
		var nelperPayLine = UIView()
		progressContainer.addSubview(nelperPayLine)
		nelperPayLine.backgroundColor = grayDetails
		nelperPayLine.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(paymentButton.snp_top).offset(-55)
			make.centerX.equalTo(progressContainer.snp_centerX)
			make.width.equalTo(progressContainer.snp_width).dividedBy(1.3)
			make.height.equalTo(1)
		}
		
		var nelperPayLogo = UIImageView()
		progressContainer.addSubview(nelperPayLogo)
		nelperPayLogo.image = UIImage(named: "nelperpay")
		nelperPayLogo.contentMode = UIViewContentMode.ScaleAspectFill
		nelperPayLogo.snp_makeConstraints { (make) -> Void in
			make.center.equalTo(nelperPayLine.snp_center)
			make.width.equalTo(60)
			make.height.equalTo(60)
		}
		
		// Accepted Nelper Container
		
		var applicantContainer = UIView()
		contentView.addSubview(applicantContainer)
		applicantContainer.backgroundColor = navBarColor
		applicantContainer.layer.borderColor = grayDetails.CGColor
		applicantContainer.layer.borderWidth = 1
		applicantContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(progressContainer.snp_bottom).offset(30)
			make.width.equalTo(contentView.snp_width)
			make.height.equalTo(backgroundView.snp_height).dividedBy(1.5)
			make.bottom.equalTo(self.contentView.snp_bottom).offset(-20)
		}
		
		//Header
		
		var headerContainer = UIView()
		applicantContainer.addSubview(headerContainer)
		headerContainer.backgroundColor = navBarColor
		headerContainer.layer.borderWidth = 1
		headerContainer.layer.borderColor = grayDetails.CGColor
		headerContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(applicantContainer.snp_top)
			make.width.equalTo(applicantContainer.snp_width)
			make.height.equalTo(applicantContainer.snp_height).dividedBy(7)
		}
		
		var acceptedIcon = UIImageView()
		headerContainer.addSubview(acceptedIcon)
		acceptedIcon.image = UIImage(named: "accepted")
		acceptedIcon.contentMode = UIViewContentMode.ScaleAspectFill
		acceptedIcon.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(headerContainer.snp_centerY)
			make.left.equalTo(headerContainer.snp_left).offset(16)
			make.width.equalTo(30)
			make.height.equalTo(30)
		}
		
		var acceptedApplicantLabel = UILabel()
		headerContainer.addSubview(acceptedApplicantLabel)
		acceptedApplicantLabel.text = "Accepted Nelper"
		acceptedApplicantLabel.textColor = blackNelpyColor
		acceptedApplicantLabel.font = UIFont(name: "HelveticaNeue", size: kSubtitleFontSize)
		acceptedApplicantLabel.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(acceptedIcon.snp_centerY)
			make.left.equalTo(acceptedIcon.snp_right).offset(12)
		}
		
		//Applicant
		
		var profileContainer = UIView()
		applicantContainer.addSubview(profileContainer)
		applicantContainer.backgroundColor = navBarColor
		applicantContainer.layer.borderColor = grayDetails.CGColor
		applicantContainer.layer.borderWidth = 1
		profileContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(headerContainer.snp_bottom)
			make.width.equalTo(applicantContainer.snp_width)
			make.height.equalTo(applicantContainer.snp_height).dividedBy(2.1)
		}
		
		var applicantName = UILabel()
		profileContainer.addSubview(applicantName)
		applicantName.text = self.acceptedApplicant.name
		applicantName.textColor = blackNelpyColor
		applicantName.font = UIFont(name: "HelveticaNeue", size: kTextFontSize)
		applicantName.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(profileContainer.snp_top).offset(18)
			make.left.equalTo(profileContainer.snp_left).offset(20)
			make.right.equalTo(profileContainer.snp_right).offset(-10)
		}
		
		var profilePicture = UIImageView()
		self.picture = profilePicture
		profileContainer.addSubview(profilePicture)
		var pictureSize: CGFloat = 100
		profilePicture.layer.cornerRadius = pictureSize / 2
		profilePicture.clipsToBounds = true
		profilePicture.contentMode = UIViewContentMode.ScaleAspectFill
		profilePicture.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(applicantName.snp_left)
			make.top.equalTo(applicantName.snp_bottom).offset(20)
			make.height.equalTo(pictureSize)
			make.width.equalTo(pictureSize)
		}
		
		//FeedBack Stars
		
		var firstStar = UIImageView()
		self.firstStar = firstStar
		profileContainer.addSubview(firstStar)
		firstStar.contentMode = UIViewContentMode.ScaleAspectFill
		firstStar.image = UIImage(named: "empty_star")
		firstStar.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(picture.snp_right).offset(30)
			make.top.equalTo(picture.snp_top).offset(10)
			make.height.equalTo(20)
			make.width.equalTo(20)
		}
		
		var secondStar = UIImageView()
		self.secondStar = secondStar
		profileContainer.addSubview(secondStar)
		secondStar.contentMode = UIViewContentMode.ScaleAspectFill
		secondStar.image = UIImage(named: "empty_star")
		secondStar.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(firstStar.snp_bottom)
			make.left.equalTo(firstStar.snp_right).offset(4)
			make.width.equalTo(20)
			make.height.equalTo(20)
		}
		
		var thirdStar = UIImageView()
		self.thirdStar = thirdStar
		profileContainer.addSubview(thirdStar)
		thirdStar.contentMode = UIViewContentMode.ScaleAspectFill
		thirdStar.image = UIImage(named: "empty_star")
		thirdStar.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(secondStar.snp_bottom)
			make.left.equalTo(secondStar.snp_right).offset(4)
			make.width.equalTo(20)
			make.height.equalTo(20)
		}
		
		var fourthStar = UIImageView()
		self.fourthStar = fourthStar
		profileContainer.addSubview(fourthStar)
		fourthStar.contentMode = UIViewContentMode.ScaleAspectFill
		fourthStar.image = UIImage(named: "empty_star")
		fourthStar.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(thirdStar.snp_bottom)
			make.left.equalTo(thirdStar.snp_right).offset(4)
			make.width.equalTo(20)
			make.height.equalTo(20)
		}
		
		var fifthStar = UIImageView()
		self.fifthStar = fifthStar
		profileContainer.addSubview(fifthStar)
		fifthStar.contentMode = UIViewContentMode.ScaleAspectFill
		fifthStar.image = UIImage(named: "empty_star")
		fifthStar.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(fourthStar.snp_bottom)
			make.left.equalTo(fourthStar.snp_right).offset(4)
			make.width.equalTo(20)
			make.height.equalTo(20)
		}
		
		var numberOfTasksCompletedLabel = UILabel()
		profileContainer.addSubview(numberOfTasksCompletedLabel)
		numberOfTasksCompletedLabel.textColor = blackNelpyColor
		numberOfTasksCompletedLabel.text = "8 tasks completed"
		numberOfTasksCompletedLabel.font = UIFont(name: "HelveticaNeue", size: kProgressBarTextFontSize)
		numberOfTasksCompletedLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(firstStar.snp_bottom).offset(4)
			make.left.equalTo(firstStar.snp_left)
		}
		
		var arrow = UIButton()
		profileContainer.addSubview(arrow)
		arrow.setBackgroundImage(UIImage(named: "arrow_applicant_cell.png"), forState: UIControlState.Normal)
		arrow.contentMode = UIViewContentMode.ScaleAspectFill
		arrow.alpha = 0.5
		arrow.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(profileContainer.snp_right).offset(-20)
			make.centerY.equalTo(profileContainer.snp_centerY)
			make.height.equalTo(35)
			make.width.equalTo(20)
		}
		
		var moneyTag = UIImageView()
		profileContainer.addSubview(moneyTag)
		moneyTag.contentMode = UIViewContentMode.ScaleAspectFill
		moneyTag.image = UIImage(named: "moneytag")
		moneyTag.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(thirdStar.snp_centerX)
			make.bottom.equalTo(profilePicture.snp_bottom).offset(-10)
			make.width.equalTo(70)
			make.height.equalTo(30)
		}
		
		var priceToPay = UILabel()
		priceToPay.textAlignment = NSTextAlignment.Center
		profileContainer.addSubview(priceToPay)
		priceToPay.text = "$\(self.acceptedApplication.price!)"
		priceToPay.textColor = whiteNelpyColor
		priceToPay.font = UIFont(name: "HelveticaNeue", size: kButtonFontSize)
		priceToPay.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(moneyTag.snp_centerX).offset(2)
			make.centerY.equalTo(moneyTag.snp_centerY)
		}
		
		var profileUnderline = UIView()
		applicantContainer.addSubview(profileUnderline)
		profileUnderline.backgroundColor = grayDetails
		profileUnderline.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(profileContainer.snp_bottom)
			make.width.equalTo(applicantContainer.snp_width)
			make.centerX.equalTo(applicantContainer.snp_centerX)
			make.height.equalTo(1)
		}
		
		var profileTapAction = UITapGestureRecognizer(target: self, action: "didTapProfile:")
		profileContainer.addGestureRecognizer(profileTapAction)
		
		var informationContainer = UIView()
		applicantContainer.addSubview(informationContainer)
		informationContainer.backgroundColor = navBarColor
		informationContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(profileUnderline.snp_bottom)
			make.bottom.equalTo(applicantContainer.snp_bottom)
			make.width.equalTo(applicantContainer.snp_width)
		}
		
		var emailLabel = UILabel()
		informationContainer.addSubview(emailLabel)
		emailLabel.text = "cvinette@nelper.ca"
		emailLabel.textColor = blackNelpyColor
		emailLabel.font = UIFont(name: "HelveticaNeue", size: kTextFontSize)
		emailLabel.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(informationContainer.snp_centerX).offset(15)
			make.centerY.equalTo(informationContainer.snp_centerY).offset(-30)
		}
	
		var emailIcon = UIImageView()
		informationContainer.addSubview(emailIcon)
		emailIcon.image = UIImage(named: "at")
		emailIcon.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(emailLabel.snp_left).offset(-15)
			make.centerY.equalTo(emailLabel.snp_centerY)
			make.height.equalTo(30)
			make.width.equalTo(30)
		}
		
		var phoneLabel = UILabel()
		informationContainer.addSubview(phoneLabel)
		phoneLabel.text = "000-000-000"
		phoneLabel.textColor = blackNelpyColor
		phoneLabel.font = UIFont(name: "HelveticaNeue", size: kTextFontSize)
		phoneLabel.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(informationContainer.snp_centerX).offset(15)
			make.top.equalTo(emailLabel.snp_bottom).offset(30)
		}
		
		var phoneIcon = UIImageView()
		informationContainer.addSubview(phoneIcon)
		phoneIcon.image = UIImage(named: "phone")
		phoneIcon.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(phoneLabel.snp_left).offset(-15)
			make.centerY.equalTo(phoneLabel.snp_centerY)
			make.height.equalTo(30)
			make.width.equalTo(30)
		}
		
		//Chat Button
		
		var chatButton = UIButton()
		self.chatButton = chatButton
		self.view.addSubview(chatButton)
		chatButton.backgroundColor = grayBlueColor
		chatButton.setImage(UIImage(named: "chat_icon"), forState: UIControlState.Normal)
		chatButton.setImage(UIImage(named: "down_arrow"), forState: UIControlState.Selected)
		chatButton.addTarget(self, action: "chatButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		chatButton.imageView!.contentMode = UIViewContentMode.Center
		chatButton.clipsToBounds = true
		chatButton.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(self.view.snp_right)
			make.bottom.equalTo(self.view.snp_bottom)
			make.width.equalTo(100)
			make.height.equalTo(40)
		}
		
		//Fake button for animation
		var fakeButton = UIButton()
		self.fakeButton = fakeButton
		self.view.addSubview(fakeButton)
		fakeButton.backgroundColor = grayBlueColor
		fakeButton.setImage(UIImage(named: "chat_icon"), forState: UIControlState.Normal)
		fakeButton.setImage(UIImage(named: "collapse_chat"), forState: UIControlState.Selected)
		fakeButton.imageView!.contentMode = UIViewContentMode.Center
		fakeButton.clipsToBounds = true
		fakeButton.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(self.view.snp_right)
			make.bottom.equalTo(self.view.snp_bottom)
			make.width.equalTo(100)
			make.height.equalTo(40)
		}
		
		fakeButton.hidden = true
		
	}
	
	// MARK: DATA
	func setImages(applicant:User){
		if(applicant.profilePictureURL != nil){
			var fbProfilePicture = applicant.profilePictureURL
			request(.GET,fbProfilePicture!).response(){
				(_, _, data, _) in
				var image = UIImage(data: data as NSData!)
				self.picture.image = image
			}
		}
	}
	
	// MARK: Setters
	func setApplicant(){
		for application in self.task.applications{
			if application.state == .Accepted{
				self.acceptedApplicant = application.user!
				self.acceptedApplication = application
			}
		}
	}
	
	func setFeedback(applicant:User){
		
		self.fifthStar.alpha = 0.5
		
	}
	
	// MARK: View Delegate
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		self.scrollView.contentSize = self.contentView.frame.size
		
		var maskPath = UIBezierPath(roundedRect: chatButton.bounds, byRoundingCorners: UIRectCorner.TopLeft, cornerRadii: CGSizeMake(20.0, 20.0))
		var maskLayer = CAShapeLayer()
		maskLayer.frame = self.chatButton.bounds
		maskLayer.path = maskPath.CGPath
		
		var maskPathFake = UIBezierPath(roundedRect: self.fakeButton.bounds, byRoundingCorners: UIRectCorner.TopLeft, cornerRadii: CGSizeMake(20.0, 20.0))
		var maskLayerFake = CAShapeLayer()
		maskLayerFake.frame = self.fakeButton.bounds
		maskLayerFake.path = maskPath.CGPath
		
		self.chatButton.layer.mask = maskLayer
		self.fakeButton.layer.mask = maskLayerFake
	}
	
	//MARK:Applicant's profile delegate methods
	
	func didTapDenyButton(applicant: User) {
		
	}
	
	//MARK:Actions
	
	func backButtonTapped(sender:UIButton){
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func didTapPaymentButton(sender:UIButton){
		var nextVC = STRPPaymentViewController()
		nextVC.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
		nextVC.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
		self.presentViewController(nextVC, animated: true, completion: nil)
	}
	
	func didTapProfile(gesture:UITapGestureRecognizer){
		var acceptedApplication: NelpTaskApplication!
		for application in self.task.applications {
			if application.state == .Accepted{
				acceptedApplication = application
			}
		}
		var nextVC = ApplicantProfileViewController(applicant: self.acceptedApplicant, application: acceptedApplication )
		nextVC.isAccepted = true
		nextVC.delegate = self
		nextVC.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
		self.presentViewController(nextVC, animated: true, completion: nil)
	}
	
	func chatButtonTapped(sender:UIButton){
		
		self.chatButton.selected = !self.chatButton.selected
		
		if self.conversationController == nil{
			var error:NSError?
			var participants = Set([self.acceptedApplicant.objectId])
			println(participants)
			
			
			var conversation = LayerManager.sharedInstance.layerClient.newConversationWithParticipants(Set([self.acceptedApplicant.objectId]), options: nil, error: nil)
			
			//		var nextVC = ATLConversationViewController(layerClient: LayerManager.sharedInstance.layerClient)
			var nextVC = ApplicantChatViewController(layerClient: LayerManager.sharedInstance.layerClient)
			nextVC.displaysAddressBar = false
			if conversation != nil{
				nextVC.conversation = conversation
			}else{
				var query:LYRQuery = LYRQuery(queryableClass: LYRConversation.self)
				query.predicate = LYRPredicate(property: "participants", predicateOperator: LYRPredicateOperator.IsEqualTo, value: participants)
				var result = LayerManager.sharedInstance.layerClient.executeQuery(query, error: nil)
				nextVC.conversation = result.firstObject as! LYRConversation
			}
			var conversationNavController = UINavigationController(rootViewController: nextVC)
			self.conversationController = conversationNavController
		}
		
		if self.chatButton.selected{
			
			var tempVC = UIViewController()
			self.tempVC = tempVC
			self.addChildViewController(tempVC)
			self.view.addSubview(tempVC.view)
			//		tempVC.view.backgroundColor = UIColor.yellowColor()
			tempVC.didMoveToParentViewController(self)
			tempVC.view.backgroundColor = UIColor.clearColor()
			tempVC.view.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(self.navBar.snp_bottom)
				make.bottom.equalTo(self.view.snp_bottom)
				make.width.equalTo(self.view.snp_width)
			}
			
			tempVC.addChildViewController(self.conversationController!)
			var distanceToMove = UIScreen.mainScreen().bounds.height -  (UIScreen.mainScreen().bounds.height)
			self.conversationController!.view.frame = CGRectMake(0, tempVC.view.frame.height, tempVC.view.frame.width, tempVC.view.frame.height)
			tempVC.view.addSubview(self.conversationController!.view)
			
			self.view.layoutIfNeeded()
			UIView.animateWithDuration(0.5, animations: { () -> Void in
				self.fakeButton.hidden = false
				self.conversationController!.view.addSubview(self.chatButton)
				self.chatButton.snp_remakeConstraints(closure: { (make) -> Void in
					make.right.equalTo(self.view.snp_right).offset(2)
					make.bottom.equalTo(self.conversationController!.view.snp_top)
					make.width.equalTo(100)
					make.height.equalTo(40)
				})
				self.conversationController!.view.frame = CGRectMake(0, 0, tempVC.view.frame.width, tempVC.view.frame.height)
				}) { (didFinish) -> Void in
					self.chatButton.snp_remakeConstraints(closure: { (make) -> Void in
						self.view.addSubview(self.chatButton)
						make.right.equalTo(self.view.snp_right).offset(2)
						make.bottom.equalTo(self.navBar.snp_bottom)
						make.width.equalTo(100)
						make.height.equalTo(40)
					})
					self.conversationController!.didMoveToParentViewController(tempVC)
			}
		}else{
			
			
			UIView.animateWithDuration(0.5, animations: { () -> Void in
				
				self.conversationController!.view.addSubview(self.chatButton)
				self.chatButton.snp_remakeConstraints(closure: { (make) -> Void in
					make.right.equalTo(self.view.snp_right).offset(2)
					make.bottom.equalTo(self.self.conversationController!.view.snp_top)
					make.width.equalTo(100)
					make.height.equalTo(40)
				})
				self.conversationController!.view.frame = CGRectMake(0, self.tempVC.view.frame.height, self.tempVC.view.frame.width, self.tempVC.view.frame.height)
				}) { (didFinish) -> Void in
					self.view.addSubview(self.chatButton)
					self.chatButton.snp_remakeConstraints(closure: { (make) -> Void in
						make.right.equalTo(self.view.snp_right)
						make.bottom.equalTo(self.view.snp_bottom)
						make.width.equalTo(100)
						make.height.equalTo(40)
					})
					self.conversationController!.view.removeFromSuperview()
					self.conversationController!.removeFromParentViewController()
					self.tempVC.view.removeFromSuperview()
					self.tempVC.removeFromParentViewController()
					self.fakeButton.hidden = true
			}
		}
	}
	
}