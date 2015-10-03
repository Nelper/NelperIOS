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
	var applicationPrice: Int!
	var acceptedApplication:NelpTaskApplication!
	var picture:UIImageView!
	var ratingStarsView: RatingStars!
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
	}
	
	//MARK:Creating the View
	
	func createView(){
		
		let navBar = NavBar()
		self.navBar = navBar
		self.view.addSubview(navBar)
		navBar.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.view.snp_top)
			make.right.equalTo(self.view.snp_right)
			make.left.equalTo(self.view.snp_left)
			make.height.equalTo(64)
		}
		
		let previousBtn = UIButton()
		previousBtn.addTarget(self, action: "backButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		navBar.closeButton = previousBtn
		navBar.setTitle("My Task")
		
		let backgroundView = UIView()
		self.view.addSubview(backgroundView)
		backgroundView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(navBar.snp_bottom)
			make.width.equalTo(self.view.snp_width)
			make.bottom.equalTo(self.view.snp_bottom)
		}
		backgroundView.backgroundColor = whiteBackground
		
		let scrollView = UIScrollView()
		self.scrollView = scrollView
		backgroundView.addSubview(scrollView)
		scrollView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(backgroundView)
		}
		
		let contentView = UIView()
		self.contentView = contentView
		scrollView.addSubview(contentView)
		contentView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(scrollView.snp_top)
			make.left.equalTo(scrollView.snp_left)
			make.right.equalTo(scrollView.snp_right)
			make.height.greaterThanOrEqualTo(backgroundView.snp_height)
			make.width.equalTo(backgroundView.snp_width)
		}
		contentView.backgroundColor = whiteBackground
		
		let taskLabelContainer = UIView()
		self.contentView.addSubview(taskLabelContainer)
		taskLabelContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(contentView.snp_top)
			make.width.equalTo(contentView.snp_width)
			make.height.equalTo(65)
		}
		
		let taskLabel = UILabel()
		taskLabel.textAlignment = NSTextAlignment.Center
		taskLabel.numberOfLines = 0
		taskLabel.text = self.task.title
		taskLabelContainer.addSubview(taskLabel)
		taskLabel.textColor = darkGrayDetails
		taskLabel.font = UIFont(name: "Lato-Regular", size: kTitle17)
		taskLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(taskLabelContainer.snp_top).offset(4)
			make.bottom.equalTo(taskLabelContainer.snp_bottom).offset(-4)
			make.left.equalTo(taskLabelContainer.snp_left).offset(8)
			make.right.equalTo(taskLabelContainer.snp_right).offset(-8)
		}
		
		//Progress + Payment Container
		
		let progressContainer = UIView()
		contentView.addSubview(progressContainer)
		progressContainer.layer.borderColor = grayDetails.CGColor
		progressContainer.layer.borderWidth = 1
		progressContainer.backgroundColor = whitePrimary
		progressContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(taskLabelContainer.snp_bottom)
			make.left.equalTo(contentView.snp_left)
			make.right.equalTo(contentView.snp_right)
			make.height.equalTo(backgroundView.snp_height).dividedBy(1.6)
		}
		
		//Progress Bar
		
		//Nelper Accepted
		let nelperAcceptedLabel = UILabel()
		progressContainer.addSubview(nelperAcceptedLabel)
		nelperAcceptedLabel.numberOfLines = 0
		nelperAcceptedLabel.textAlignment = NSTextAlignment.Center
		nelperAcceptedLabel.text = "Nelper \nAccepted"
		nelperAcceptedLabel.textColor = blackPrimary
		nelperAcceptedLabel.font = UIFont(name: "Lato-Regular", size: kProgressBarTextFontSize)
		nelperAcceptedLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(progressContainer.snp_top).offset(20)
			make.left.equalTo(progressContainer.snp_left).offset(12)
		}
		
		let nelperAcceptedImageView = UIImageView()
		progressContainer.addSubview(nelperAcceptedImageView)
		nelperAcceptedImageView.image = UIImage(named: "accepted")
		nelperAcceptedImageView.contentMode = UIViewContentMode.ScaleAspectFill
		nelperAcceptedImageView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(nelperAcceptedLabel.snp_bottom).offset(20)
			make.centerX.equalTo(nelperAcceptedLabel.snp_centerX)
			make.width.equalTo(30)
			make.height.equalTo(30)
		}
		
		let nelperAcceptedLine = UIView()
		progressContainer.addSubview(nelperAcceptedLine)
		nelperAcceptedLine.backgroundColor = blackPrimary
		nelperAcceptedLine.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(nelperAcceptedLabel.snp_bottom)
			make.bottom.equalTo(nelperAcceptedImageView.snp_top).offset(-2)
			make.width.equalTo(1)
			make.centerX.equalTo(nelperAcceptedLabel.snp_centerX)
		}
		
		//Leave Feedback(Last for size)
		
		let leaveFeedbackImageView = UIImageView()
		progressContainer.addSubview(leaveFeedbackImageView)
		leaveFeedbackImageView.image = UIImage(named: "black_circle")
		leaveFeedbackImageView.contentMode = UIViewContentMode.ScaleAspectFill
		leaveFeedbackImageView.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(nelperAcceptedImageView.snp_centerY)
			make.right.equalTo(progressContainer.snp_right).offset(-30)
			make.width.equalTo(40)
			make.height.equalTo(40)
		}
		
		let leaveFeedbackLabel = UILabel()
		progressContainer.addSubview(leaveFeedbackLabel)
		leaveFeedbackLabel.numberOfLines = 0
		leaveFeedbackLabel.textAlignment = NSTextAlignment.Center
		leaveFeedbackLabel.text = "Rating\n&\nFeedback"
		leaveFeedbackLabel.textColor = blackPrimary
		leaveFeedbackLabel.font = UIFont(name: "Lato-Regular", size: kProgressBarTextFontSize)
		leaveFeedbackLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(leaveFeedbackImageView.snp_bottom).offset(10)
			make.right.equalTo(progressContainer.snp_right).offset(-18)
		}
		
		let leaveFeedbackLine = UIView()
		progressContainer.addSubview(leaveFeedbackLine)
		leaveFeedbackLine.backgroundColor = blackPrimary
		leaveFeedbackLine.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(leaveFeedbackImageView.snp_bottom).offset(-2)
			make.bottom.equalTo(leaveFeedbackLabel.snp_top)
			make.width.equalTo(1)
			make.centerX.equalTo(leaveFeedbackImageView.snp_centerX)
		}
		
		let paymentImageView = UIImageView()
		progressContainer.addSubview(paymentImageView)
		paymentImageView.image = UIImage(named: "accepted")
		paymentImageView.contentMode = UIViewContentMode.ScaleAspectFill
		paymentImageView.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(nelperAcceptedImageView.snp_centerY)
			make.left.equalTo(nelperAcceptedImageView.snp_right).offset(40)
			make.height.equalTo(30)
			make.width.equalTo(30)
		}
		
		let paymentLabel = UILabel()
		progressContainer.addSubview(paymentLabel)
		paymentLabel.numberOfLines = 0
		paymentLabel.textAlignment = NSTextAlignment.Center
		paymentLabel.text = "Payment Sent"
		paymentLabel.textColor = blackPrimary
		paymentLabel.font = UIFont(name: "Lato-Regular", size: kProgressBarTextFontSize)
		paymentLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(paymentImageView.snp_bottom).offset(20)
			make.centerX.equalTo(paymentImageView.snp_centerX)
		}
		
		let paymentLine = UIView()
		progressContainer.addSubview(paymentLine)
		paymentLine.backgroundColor = blackPrimary
		paymentLine.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(paymentImageView.snp_bottom).offset(2)
			make.bottom.equalTo(paymentLabel.snp_top)
			make.width.equalTo(1)
			make.centerX.equalTo(paymentImageView.snp_centerX)
		}
		
		let approvedTaskImageView = UIImageView()
		progressContainer.addSubview(approvedTaskImageView)
		approvedTaskImageView.image = UIImage(named: "pending")
		approvedTaskImageView.contentMode = UIViewContentMode.ScaleAspectFill
		approvedTaskImageView.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(nelperAcceptedImageView.snp_centerY)
			make.right.equalTo(leaveFeedbackImageView.snp_left).offset(-40)
			make.height.equalTo(30)
			make.width.equalTo(30)
		}
		
		let approvedTaskLabel = UILabel()
		progressContainer.addSubview(approvedTaskLabel)
		approvedTaskLabel.numberOfLines = 0
		approvedTaskLabel.textAlignment = NSTextAlignment.Center
		approvedTaskLabel.text = "Approved task completion"
		approvedTaskLabel.textColor = blackPrimary
		approvedTaskLabel.font = UIFont(name: "Lato-Regular", size: kProgressBarTextFontSize)
		approvedTaskLabel.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(nelperAcceptedLabel.snp_centerY)
			make.centerX.equalTo(approvedTaskImageView.snp_centerX)
		}
		
		let approvedTaskLine = UIView()
		progressContainer.addSubview(approvedTaskLine)
		approvedTaskLine.backgroundColor = blackPrimary
		approvedTaskLine.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(approvedTaskImageView.snp_top).offset(-2)
			make.top.equalTo(approvedTaskLabel.snp_bottom)
			make.width.equalTo(1)
			make.centerX.equalTo(approvedTaskImageView.snp_centerX)
		}
		
		
		let lineBetweenAcceptedAndPayment = UIView()
		progressContainer.addSubview(lineBetweenAcceptedAndPayment)
		lineBetweenAcceptedAndPayment.backgroundColor = progressGreen
		lineBetweenAcceptedAndPayment.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(nelperAcceptedImageView.snp_centerY)
			make.left.equalTo(nelperAcceptedImageView.snp_right)
			make.right.equalTo(paymentImageView.snp_left)
			make.height.equalTo(2)
		}
		
		let lineBetweenPaymentAndApprove = UIView()
		progressContainer.addSubview(lineBetweenPaymentAndApprove)
		lineBetweenPaymentAndApprove.backgroundColor = pendingYellow
		lineBetweenPaymentAndApprove.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(paymentImageView.snp_centerY)
			make.left.equalTo(paymentImageView.snp_right)
			make.right.equalTo(approvedTaskImageView.snp_left)
			make.height.equalTo(2)
		}
		
		let lineBetweenApproveAndRating = UIView()
		progressContainer.addSubview(lineBetweenApproveAndRating)
		lineBetweenApproveAndRating.backgroundColor = blackPrimary
		lineBetweenApproveAndRating.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(paymentImageView.snp_centerY)
			make.left.equalTo(approvedTaskImageView.snp_right)
			make.right.equalTo(leaveFeedbackImageView.snp_left).offset(5)
			make.height.equalTo(2)
		}
		
		//Payment Button
		
		let paymentButton = PrimaryActionButton()
		progressContainer.addSubview(paymentButton)
		paymentButton.setTitle("Proceed to Payment", forState: UIControlState.Normal)
		paymentButton.addTarget(self, action: "didTapPaymentButton:", forControlEvents: UIControlEvents.TouchUpInside)
		paymentButton.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(progressContainer.snp_bottom).offset(-55)
			make.centerX.equalTo(progressContainer.snp_centerX)
		}
		
		//About Nelper Pay
		
		let aboutNelperPayLabel = UILabel()
		progressContainer.addSubview(aboutNelperPayLabel)
		aboutNelperPayLabel.text = "About NelperPay"
		aboutNelperPayLabel.textColor = blackPrimary
		aboutNelperPayLabel.backgroundColor = whitePrimary
		aboutNelperPayLabel.font = UIFont(name: "Lato-Regular", size: kProgressBarTextFontSize)
		aboutNelperPayLabel.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(progressContainer.snp_bottom).offset(-20)
			make.centerX.equalTo(progressContainer.snp_centerX).offset(10)
		}
		
		let aboutNelperPayButton = UIButton()
		progressContainer.addSubview(aboutNelperPayButton)
		aboutNelperPayButton.setBackgroundImage(UIImage(named: "interrogation"), forState: UIControlState.Normal)
		aboutNelperPayButton.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(aboutNelperPayLabel.snp_centerY)
			make.right.equalTo(aboutNelperPayLabel.snp_left).offset(-2)
			make.height.equalTo(20)
			make.width.equalTo(20)
		}
		
		//NelperPayLogo
		
		let nelperPayLine = UIView()
		progressContainer.addSubview(nelperPayLine)
		nelperPayLine.backgroundColor = grayDetails
		nelperPayLine.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(paymentButton.snp_top).offset(-55)
			make.centerX.equalTo(progressContainer.snp_centerX)
			make.width.equalTo(progressContainer.snp_width).dividedBy(1.2)
			make.height.equalTo(1)
		}
		
		let nelperPayLogo = UIImageView()
		progressContainer.addSubview(nelperPayLogo)
		nelperPayLogo.image = UIImage(named: "nelperpay")
		nelperPayLogo.contentMode = UIViewContentMode.ScaleAspectFill
		nelperPayLogo.snp_makeConstraints { (make) -> Void in
			make.center.equalTo(nelperPayLine.snp_center)
			make.width.equalTo(60)
			make.height.equalTo(60)
		}
		
		// Accepted Nelper Container
		
		let applicantContainer = UIView()
		contentView.addSubview(applicantContainer)
		applicantContainer.backgroundColor = whitePrimary
		applicantContainer.layer.borderColor = grayDetails.CGColor
		applicantContainer.layer.borderWidth = 1
		applicantContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(progressContainer.snp_bottom).offset(20)
			make.width.equalTo(contentView.snp_width)
			make.height.equalTo(backgroundView.snp_height).dividedBy(2)
			make.bottom.equalTo(contentView.snp_bottom).offset(-20)
		}
		
		//Header
		
		let headerContainer = UIView()
		applicantContainer.addSubview(headerContainer)
		headerContainer.backgroundColor = whitePrimary
		headerContainer.layer.borderWidth = 1
		headerContainer.layer.borderColor = grayDetails.CGColor
		headerContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(applicantContainer.snp_top)
			make.width.equalTo(applicantContainer.snp_width)
			make.height.equalTo(applicantContainer.snp_height).dividedBy(5)
		}
		
		let acceptedIcon = UIImageView()
		headerContainer.addSubview(acceptedIcon)
		acceptedIcon.image = UIImage(named: "accepted")
		acceptedIcon.contentMode = UIViewContentMode.ScaleAspectFill
		acceptedIcon.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(headerContainer.snp_centerY)
			make.left.equalTo(headerContainer.snp_left).offset(20)
			make.width.equalTo(30)
			make.height.equalTo(30)
		}
		
		let acceptedApplicantLabel = UILabel()
		headerContainer.addSubview(acceptedApplicantLabel)
		acceptedApplicantLabel.text = "Accepted Nelper"
		acceptedApplicantLabel.textColor = blackPrimary
		acceptedApplicantLabel.font = UIFont(name: "Lato-Regular", size: kTitle17)
		acceptedApplicantLabel.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(acceptedIcon.snp_centerY)
			make.left.equalTo(acceptedIcon.snp_right).offset(12)
		}
		
		//Applicant
		
		let profileContainer = UIView()
		applicantContainer.addSubview(profileContainer)
		applicantContainer.backgroundColor = whitePrimary
		applicantContainer.layer.borderColor = grayDetails.CGColor
		applicantContainer.layer.borderWidth = 1
		profileContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(headerContainer.snp_bottom)
			make.width.equalTo(applicantContainer.snp_width)
			make.height.equalTo(applicantContainer.snp_height).dividedBy(3)
		}
		
		//Profile picture
		
		let profilePicture = UIImageView()
		self.picture = profilePicture
		profileContainer.addSubview(profilePicture)
		let pictureSize: CGFloat = 70
		profilePicture.layer.cornerRadius = pictureSize / 2
		profilePicture.clipsToBounds = true
		profilePicture.contentMode = UIViewContentMode.ScaleAspectFill
		profilePicture.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(profileContainer.snp_left).offset(16)
			make.centerY.equalTo(profileContainer.snp_centerY)
			make.height.equalTo(pictureSize)
			make.width.equalTo(pictureSize)
		}
		
		//Name
		
		let applicantName = UILabel()
		profileContainer.addSubview(applicantName)
		applicantName.text = self.acceptedApplicant.name
		applicantName.textColor = blackPrimary
		applicantName.font = UIFont(name: "Lato-Regular", size: kTitle17)
		applicantName.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(profilePicture.snp_centerY).offset(-15)
			make.left.equalTo(profilePicture.snp_right).offset(15)
			make.right.equalTo(profileContainer.snp_right).offset(-10)
		}
		
		//Rating
		
		let ratingStarsView = RatingStars()
		self.ratingStarsView = ratingStarsView
		self.ratingStarsView.style = "dark"
		self.ratingStarsView.starHeight = 15
		self.ratingStarsView.starWidth = 15
		self.ratingStarsView.starPadding = 5
		self.ratingStarsView.textSize = kText15
		self.ratingStarsView.userCompletedTasks = acceptedApplicant.completedTasks
		self.ratingStarsView.userRating = acceptedApplicant.rating
		profileContainer.addSubview(ratingStarsView)
		ratingStarsView.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(applicantName.snp_left)
			make.centerY.equalTo(profilePicture.snp_centerY).offset(15)
			make.width.equalTo((ratingStarsView.starWidth + ratingStarsView.starPadding) * 6)
			make.height.equalTo(ratingStarsView.starHeight)
		}
		
		//Money View
		
		let moneyView = UIView()
		moneyView.contentMode = UIViewContentMode.ScaleAspectFill
		moneyView.backgroundColor = whiteBackground
		moneyView.layer.cornerRadius = 3
		profileContainer.addSubview(moneyView)
		moneyView.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(ratingStarsView.snp_right).offset(28)
			make.centerY.equalTo(ratingStarsView.snp_centerY)
			make.height.equalTo(35)
			make.width.equalTo(55)
		}
		
		//Money Label
		
		let moneyLabel = UILabel()
		profileContainer.addSubview(moneyLabel)
		moneyLabel.textAlignment = NSTextAlignment.Center
		moneyLabel.textColor = blackPrimary
		moneyLabel.text = "$\(applicationPrice)"
		moneyLabel.font = UIFont(name: "Lato-Light", size: kText15)
		moneyLabel.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(moneyView.snp_edges)
		}
		
		//Arrow
		
		let arrow = UIButton()
		profileContainer.addSubview(arrow)
		arrow.setBackgroundImage(UIImage(named: "arrow_applicant_cell.png"), forState: UIControlState.Normal)
		arrow.alpha = 0.2
		arrow.contentMode = UIViewContentMode.ScaleAspectFill
		arrow.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(profileContainer.snp_right).offset(-18)
			make.centerY.equalTo(profileContainer.snp_centerY)
			make.height.equalTo(25)
			make.width.equalTo(15)
		}
		
		let profileUnderline = UIView()
		applicantContainer.addSubview(profileUnderline)
		profileUnderline.backgroundColor = grayDetails
		profileUnderline.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(profileContainer.snp_bottom)
			make.width.equalTo(applicantContainer.snp_width)
			make.centerX.equalTo(applicantContainer.snp_centerX)
			make.height.equalTo(0.5)
		}
		
		let profileTapAction = UITapGestureRecognizer(target: self, action: "didTapProfile:")
		profileContainer.addGestureRecognizer(profileTapAction)
		
		let informationContainer = UIView()
		applicantContainer.addSubview(informationContainer)
		informationContainer.backgroundColor = whitePrimary
		informationContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(profileUnderline.snp_bottom)
			make.bottom.equalTo(applicantContainer.snp_bottom)
			make.width.equalTo(applicantContainer.snp_width)
		}
		
		let emailLabel = UILabel()
		informationContainer.addSubview(emailLabel)
		emailLabel.text = "cvinette@nelper.ca"
		emailLabel.textColor = blackPrimary
		emailLabel.font = UIFont(name: "Lato-Regular", size: kText15)
		emailLabel.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(informationContainer.snp_centerX).offset(15)
			make.centerY.equalTo(informationContainer.snp_centerY).offset(-30)
		}
	
		let emailIcon = UIImageView()
		informationContainer.addSubview(emailIcon)
		emailIcon.image = UIImage(named: "at")
		emailIcon.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(emailLabel.snp_left).offset(-15)
			make.centerY.equalTo(emailLabel.snp_centerY)
			make.height.equalTo(30)
			make.width.equalTo(30)
		}
		
		let phoneLabel = UILabel()
		informationContainer.addSubview(phoneLabel)
		phoneLabel.text = "000-000-000"
		phoneLabel.textColor = blackPrimary
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
			make.height.equalTo(30)
			make.width.equalTo(30)
		}
		
		//Chat Button
		
		let chatButton = UIButton()
		self.chatButton = chatButton
		self.view.addSubview(chatButton)
		chatButton.backgroundColor = grayBlue
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
		let fakeButton = UIButton()
		self.fakeButton = fakeButton
		self.view.addSubview(fakeButton)
		fakeButton.backgroundColor = grayBlue
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
	
	/**
	Set the Applicant Profile Picture
	
	- parameter applicant: The Applicant
	*/
	
	func setImages(applicant:User){
		if(applicant.profilePictureURL != nil){
			let fbProfilePicture = applicant.profilePictureURL
			request(.GET,fbProfilePicture!).response(){
				(_, _, data, _) in
				let image = UIImage(data: data as NSData!)
				self.picture.image = image
			}
		}
	}
	
	// MARK: Setters
	func setApplicant(){
		for application in self.task.applications{
			if application.state == .Accepted {
				self.acceptedApplicant = application.user!
				self.acceptedApplication = application
				self.applicationPrice = application.price!
			}
		}
	}
	
	/**
	Sets the applicant feedback (Static/Hard coded for now)
	
	- parameter applicant: Applicant
	*/
	
	// MARK: View Delegate
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		self.scrollView.contentSize = self.contentView.frame.size
		
		let maskPath = UIBezierPath(roundedRect: chatButton.bounds, byRoundingCorners: UIRectCorner.TopLeft, cornerRadii: CGSizeMake(20.0, 20.0))
		let maskLayer = CAShapeLayer()
		maskLayer.frame = self.chatButton.bounds
		maskLayer.path = maskPath.CGPath
		
		let maskLayerFake = CAShapeLayer()
		maskLayerFake.frame = self.fakeButton.bounds
		maskLayerFake.path = maskPath.CGPath
		
		self.chatButton.layer.mask = maskLayer
		self.fakeButton.layer.mask = maskLayerFake
	}
	
	//MARK:Applicant's profile delegate methods
	
	func didTapDenyButton(applicant: User) {
	}
	
	func dismissVC(){
	}
	
	//MARK:Actions
	
	func backButtonTapped(sender:UIButton){
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func didTapPaymentButton(sender:UIButton){
		let nextVC = STRPPaymentViewController()
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
		let nextVC = ApplicantProfileViewController(applicant: self.acceptedApplicant, application: acceptedApplication )
		nextVC.isAccepted = true
		nextVC.delegate = self
		nextVC.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
		self.presentViewController(nextVC, animated: true, completion: nil)
	}
	
	/**
	Create the conversation between the two correspondants, hack to properly present the chat view (Fat and ugly method, need refactoring)
	
	- parameter sender: chat button
	*/
	
	func chatButtonTapped(sender:UIButton){
		
		self.chatButton.selected = !self.chatButton.selected
		
		if self.conversationController == nil{
			let participants = Set([self.acceptedApplicant.objectId])
			print(participants)
			
			
			let conversation = try? LayerManager.sharedInstance.layerClient.newConversationWithParticipants(Set([self.acceptedApplicant.objectId]), options: nil)
			
			//		var nextVC = ATLConversationViewController(layerClient: LayerManager.sharedInstance.layerClient)
			let nextVC = ApplicantChatViewController(layerClient: LayerManager.sharedInstance.layerClient)
			nextVC.displaysAddressBar = false
			if conversation != nil{
				nextVC.conversation = conversation
			}else{
				let query:LYRQuery = LYRQuery(queryableClass: LYRConversation.self)
				query.predicate = LYRPredicate(property: "participants", predicateOperator: LYRPredicateOperator.IsEqualTo, value: participants)
				let result = try? LayerManager.sharedInstance.layerClient.executeQuery(query)
				nextVC.conversation = result!.firstObject as! LYRConversation
			}
			let conversationNavController = UINavigationController(rootViewController: nextVC)
			self.conversationController = conversationNavController
			self.conversationController!.setNavigationBarHidden(true, animated: false)

		}
		
		if self.chatButton.selected{
			
			let tempVC = UIViewController()
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
		} else {
			
			
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