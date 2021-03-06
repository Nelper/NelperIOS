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

class MyTaskDetailsAcceptedViewController: UIViewController, STRPPaymentViewControllerDelegate {
	
	var contentView: UIView!
	var scrollView: UIScrollView!
	var task: Task!
	var acceptedApplicant: User!
	var applicationPrice: Int!
	var acceptedApplication: TaskApplication!
	var taskInfoPagingView: TaskInfoPagingView!
	var ratingStarsView: RatingStars!
	var chatButton: UIButton!
	var conversationController: UINavigationController?
	var tempVC: UIViewController!
	var fakeButton: UIButton!
	var navBar: NavBar!
	var leaveFeedbackLine: UIView!
	var leaveFeedbackImageView: UIImageView!
	var paymentImageView: UIImageView!
	var paymentLine: UIView!
	var approvedTaskImageView: UIImageView!
	var approvedTaskLine: UIView!
	var progressButton: UIButton!
	
	//MARK: Initialization
	
	/**
	- parameter task:        the task to load
	- parameter application: only set if an application has just been accepted, else nil
	*/
	convenience init (task: Task, application: TaskApplication?) {
		self.init()
		
		self.task = task
		
		if application != nil {
			self.acceptedApplication = application!
			self.acceptedApplicant = application!.user!
			self.applicationPrice = application!.price!
		} else {
			self.setApplicant()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.createView()
	}
	
	//MARK:Creating the View

	func createView() {
		
		let navBar = NavBar()
		self.navBar = navBar
		self.view.addSubview(navBar)
		let previousBtn = UIButton()
		previousBtn.addTarget(self, action: "backButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		navBar.backButton = previousBtn
		navBar.setTitle("My Task")
		navBar.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.view.snp_top)
			make.right.equalTo(self.view.snp_right)
			make.left.equalTo(self.view.snp_left)
			make.height.equalTo(64)
		}
		
		let backgroundView = UIView()
		self.view.addSubview(backgroundView)
		backgroundView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(navBar.snp_bottom)
			make.width.equalTo(self.view.snp_width)
			make.bottom.equalTo(self.view.snp_bottom)
		}
		backgroundView.backgroundColor = Color.whiteBackground
		
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
		contentView.backgroundColor = Color.whiteBackground
		
		//Task info
		
		let taskInfoPagingView = TaskInfoPagingView(task: self.task, acceptedApplication: self.acceptedApplication)
		self.taskInfoPagingView = taskInfoPagingView
		self.addChildViewController(taskInfoPagingView)
		taskInfoPagingView.didMoveToParentViewController(self)
		contentView.addSubview(taskInfoPagingView.view)
		taskInfoPagingView.view.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(contentView.snp_top).offset(20)
			make.left.equalTo(contentView.snp_left)
			make.right.equalTo(contentView.snp_right)
			make.height.equalTo(taskInfoPagingView.height + taskInfoPagingView.pagingContainerHeight)
		}
		
		//Progress + Payment Container
		
		let progressContainer = UIView()
		contentView.addSubview(progressContainer)
		progressContainer.layer.borderColor = Color.grayDetails.CGColor
		progressContainer.layer.borderWidth = 1
		progressContainer.backgroundColor = Color.whitePrimary
		progressContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(taskInfoPagingView.view.snp_bottom).offset(20)
			make.left.equalTo(contentView.snp_left)
			make.right.equalTo(contentView.snp_right)
		}
		
		//Progress Bar
		
		//Nelper Accepted
		let nelperAcceptedLabel = UILabel()
		progressContainer.addSubview(nelperAcceptedLabel)
		nelperAcceptedLabel.numberOfLines = 0
		nelperAcceptedLabel.textAlignment = NSTextAlignment.Center
		nelperAcceptedLabel.text = "Nelper \nAccepted"
		nelperAcceptedLabel.textColor = Color.blackPrimary
		nelperAcceptedLabel.font = UIFont(name: "Lato-Regular", size: kProgressBarTextFontSize)
		nelperAcceptedLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(progressContainer.snp_top).offset(30)
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
		nelperAcceptedLine.backgroundColor = Color.blackPrimary
		nelperAcceptedLine.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(nelperAcceptedLabel.snp_bottom)
			make.bottom.equalTo(nelperAcceptedImageView.snp_top).offset(-2)
			make.width.equalTo(1)
			make.centerX.equalTo(nelperAcceptedLabel.snp_centerX)
		}
		
		//Leave Feedback(Last for size)
		
		let leaveFeedbackImageView = UIImageView()
		self.leaveFeedbackImageView = leaveFeedbackImageView
		progressContainer.addSubview(leaveFeedbackImageView)
		leaveFeedbackImageView.image = UIImage(named: "black_circle")
		leaveFeedbackImageView.contentMode = UIViewContentMode.ScaleAspectFill
		leaveFeedbackImageView.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(nelperAcceptedImageView.snp_centerY)
			make.right.equalTo(progressContainer.snp_right).offset(-30)
			make.width.equalTo(30)
			make.height.equalTo(30)
		}
		
		let leaveFeedbackLabel = UILabel()
		progressContainer.addSubview(leaveFeedbackLabel)
		leaveFeedbackLabel.numberOfLines = 0
		leaveFeedbackLabel.textAlignment = NSTextAlignment.Center
		leaveFeedbackLabel.text = "Rating\n&\nFeedback"
		leaveFeedbackLabel.textColor = Color.blackPrimary
		leaveFeedbackLabel.font = UIFont(name: "Lato-Regular", size: kProgressBarTextFontSize)
		leaveFeedbackLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(leaveFeedbackImageView.snp_bottom).offset(10)
			make.right.equalTo(progressContainer.snp_right).offset(-18)
		}
		
		let leaveFeedbackLine = UIView()
		progressContainer.addSubview(leaveFeedbackLine)
		leaveFeedbackLine.backgroundColor = Color.blackPrimary
		leaveFeedbackLine.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(leaveFeedbackImageView.snp_bottom).offset(2)
			make.bottom.equalTo(leaveFeedbackLabel.snp_top)
			make.width.equalTo(1)
			make.centerX.equalTo(leaveFeedbackImageView.snp_centerX)
		}
		
		let paymentImageView = UIImageView()
		self.paymentImageView = paymentImageView
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
		paymentLabel.textColor = Color.blackPrimary
		paymentLabel.font = UIFont(name: "Lato-Regular", size: kProgressBarTextFontSize)
		paymentLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(paymentImageView.snp_bottom).offset(20)
			make.centerX.equalTo(paymentImageView.snp_centerX)
		}
		
		let paymentLine = UIView()
		progressContainer.addSubview(paymentLine)
		paymentLine.backgroundColor = Color.blackPrimary
		paymentLine.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(paymentImageView.snp_bottom).offset(2)
			make.bottom.equalTo(paymentLabel.snp_top)
			make.width.equalTo(1)
			make.centerX.equalTo(paymentImageView.snp_centerX)
		}
		
		let approvedTaskImageView = UIImageView()
		self.approvedTaskImageView = approvedTaskImageView
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
		approvedTaskLabel.textColor = Color.blackPrimary
		approvedTaskLabel.font = UIFont(name: "Lato-Regular", size: kProgressBarTextFontSize)
		approvedTaskLabel.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(nelperAcceptedLabel.snp_centerY)
			make.centerX.equalTo(approvedTaskImageView.snp_centerX)
		}
		
		let approvedTaskLine = UIView()
		progressContainer.addSubview(approvedTaskLine)
		approvedTaskLine.backgroundColor = Color.blackPrimary
		approvedTaskLine.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(approvedTaskImageView.snp_top).offset(-2)
			make.top.equalTo(approvedTaskLabel.snp_bottom)
			make.width.equalTo(1)
			make.centerX.equalTo(approvedTaskImageView.snp_centerX)
		}
		
		
		let lineBetweenAcceptedAndPayment = UIView()
		self.paymentLine = lineBetweenAcceptedAndPayment
		progressContainer.addSubview(lineBetweenAcceptedAndPayment)
		lineBetweenAcceptedAndPayment.backgroundColor = Color.progressGreen
		lineBetweenAcceptedAndPayment.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(nelperAcceptedImageView.snp_centerY)
			make.left.equalTo(nelperAcceptedImageView.snp_right)
			make.right.equalTo(paymentImageView.snp_left)
			make.height.equalTo(2)
		}
		
		let lineBetweenPaymentAndApprove = UIView()
		self.approvedTaskLine = lineBetweenPaymentAndApprove
		progressContainer.addSubview(lineBetweenPaymentAndApprove)
		lineBetweenPaymentAndApprove.backgroundColor = Color.pendingYellow
		lineBetweenPaymentAndApprove.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(paymentImageView.snp_centerY)
			make.left.equalTo(paymentImageView.snp_right)
			make.right.equalTo(approvedTaskImageView.snp_left)
			make.height.equalTo(2)
		}
		
		let lineBetweenApproveAndRating = UIView()
		self.leaveFeedbackLine = lineBetweenApproveAndRating
		progressContainer.addSubview(lineBetweenApproveAndRating)
		lineBetweenApproveAndRating.backgroundColor = Color.blackPrimary
		lineBetweenApproveAndRating.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(paymentImageView.snp_centerY)
			make.left.equalTo(approvedTaskImageView.snp_right)
			make.right.equalTo(leaveFeedbackImageView.snp_left).offset(5)
			make.height.equalTo(2)
		}
		
		//NelperPayLogo
		
		let nelperPayLine = UIView()
		progressContainer.addSubview(nelperPayLine)
		nelperPayLine.backgroundColor = Color.grayDetails
		nelperPayLine.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(paymentLabel.snp_bottom).offset(60)
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

		let priceLabel = UILabel()
		progressContainer.addSubview(priceLabel)
		priceLabel.text = "\(self.applicationPrice!)$"
		priceLabel.textColor = Color.blackPrimary
		priceLabel.font = UIFont(name: "Lato-Light", size: 30)
		priceLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(nelperPayLogo.snp_bottom).offset(20)
			make.centerX.equalTo(progressContainer.snp_centerX)
		}
		
		//Payment Button
		
		let paymentButton = PrimaryActionButton()
		self.progressButton = paymentButton
		progressContainer.addSubview(paymentButton)
		paymentButton.setTitle("Proceed to Payment", forState: UIControlState.Normal)
		paymentButton.addTarget(self, action: "didTapPaymentButton:", forControlEvents: UIControlEvents.TouchUpInside)
		paymentButton.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(priceLabel.snp_bottom).offset(15)
			make.centerX.equalTo(progressContainer.snp_centerX)
		}
		
		//About Nelper Pay
		
		let aboutNelperPayLabel = UILabel()
		progressContainer.addSubview(aboutNelperPayLabel)
		aboutNelperPayLabel.text = "About NelperPay"
		aboutNelperPayLabel.textColor = Color.blackPrimary
		aboutNelperPayLabel.backgroundColor = Color.whitePrimary
		aboutNelperPayLabel.font = UIFont(name: "Lato-Regular", size: kProgressBarTextFontSize)
		aboutNelperPayLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(paymentButton.snp_bottom).offset(20)
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
		
		progressContainer.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(aboutNelperPayButton.snp_bottom).offset(20)
		}
		
		self.setCompletionState()
		
		
		// Accepted Nelper Container
		
		let applicantContainer = ProfileAcceptedView(user: self.acceptedApplicant!)
		contentView.addSubview(applicantContainer)
		applicantContainer.backgroundColor = Color.whitePrimary
		applicantContainer.layer.borderColor = Color.grayDetails.CGColor
		applicantContainer.layer.borderWidth = 1
		applicantContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(progressContainer.snp_bottom).offset(20)
			make.left.equalTo(contentView.snp_left).offset(-1)
			make.right.equalTo(contentView.snp_right).offset(1)
		}
		applicantContainer.profileContainer.profileContainer.addTarget(self, action: "didTapProfile:", forControlEvents: .TouchUpInside)
		
		contentView.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(applicantContainer.snp_bottom).offset(50)
		}
		
		//Chat Button
		
		let chatButton = UIButton()
		self.chatButton = chatButton
		self.view.addSubview(chatButton)
		chatButton.backgroundColor = Color.redPrimary
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
		fakeButton.backgroundColor = Color.grayBlue
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
	
	/**
	Updates the UI of the progress bar depending on the task completion's state
	*/
	
//	case Accepted = 0
//	case PaymentSent
//	case Completed
//	case Rated
	
	func setCompletionState() {
		
		switch (self.task!.completionState) {
		case .Accepted:
			self.setAccepted()
		case .PaymentSent:
			self.setPaymentSent()
		case .Completed:
			self.setCompleted()
		case .Rated:
			self.setRated()
		default:
			self.setAccepted()
		}
	}
	
	func setAccepted(){
		self.paymentImageView.image = UIImage(named: "pending")
		self.paymentLine.backgroundColor = Color.pendingYellow
		self.approvedTaskLine.backgroundColor = Color.pendingYellow
		self.approvedTaskImageView.image = UIImage(named:"pending")
		self.leaveFeedbackLine.backgroundColor = Color.pendingYellow
		self.leaveFeedbackImageView.image = UIImage(named:"pending")
	}
	
	func setPaymentSent(){
		self.paymentImageView.image = UIImage(named: "accepted")
		self.paymentLine.backgroundColor = Color.progressGreen
		self.approvedTaskLine.backgroundColor = Color.pendingYellow
		self.approvedTaskImageView.image = UIImage(named:"pending")
		self.leaveFeedbackLine.backgroundColor = Color.pendingYellow
		self.leaveFeedbackImageView.image = UIImage(named:"pending")
		self.progressButton.setTitle("Approve Task", forState: UIControlState.Normal)
		self.progressButton.setTitle("Sure?", forState: UIControlState.Selected)
		self.progressButton.removeTarget(self, action: "didTapPaymentButton:", forControlEvents: UIControlEvents.TouchUpInside)
		self.progressButton.addTarget(self, action: "didTapApproveTaskButton:", forControlEvents: UIControlEvents.TouchUpInside)
	}
	
	func setCompleted(){
		self.paymentImageView.image = UIImage(named: "accepted")
		self.paymentLine.backgroundColor = Color.progressGreen
		self.approvedTaskLine.backgroundColor = Color.progressGreen
		self.approvedTaskImageView.image = UIImage(named:"accepted")
		self.leaveFeedbackLine.backgroundColor = Color.pendingYellow
		self.leaveFeedbackImageView.image = UIImage(named:"pending")
		self.progressButton.selected = false
		self.progressButton.setTitle("Rate your Nelper", forState: UIControlState.Normal)
		self.progressButton.removeTarget(self, action: "didTapApproveTaskButton:", forControlEvents: UIControlEvents.TouchUpInside)
		self.progressButton.addTarget(self, action: "didTapRateYourNelperButton:", forControlEvents: UIControlEvents.TouchUpInside)
	}
	
	func setRated(){
		self.paymentImageView.image = UIImage(named: "accepted")
		self.paymentLine.backgroundColor = Color.progressGreen
		self.approvedTaskLine.backgroundColor = Color.progressGreen
		self.approvedTaskImageView.image = UIImage(named:"accepted")
		self.leaveFeedbackLine.backgroundColor = Color.progressGreen
		self.leaveFeedbackImageView.image = UIImage(named:"accepted")
		self.progressButton.setTitle("Completed", forState: UIControlState.Normal)
		self.progressButton.removeTarget(self, action: "didTapRateYourNelperButton:", forControlEvents: UIControlEvents.TouchUpInside)
		self.progressButton.setBackgroundColor(Color.progressGreen, forState: UIControlState.Normal)
		self.progressButton.enabled = false
	}
	
	// MARK: Setters
	func setApplicant() {
		for application in self.task.applications {
			if application.state == .Accepted {
				self.acceptedApplicant = application.user!
				self.acceptedApplication = application
				self.applicationPrice = application.price!
			}
		}
	}
	
	// MARK: Stripe Delegate
	
	func didSendPayment() {
		self.setPaymentSent()
	}
	
	func didClosePopup(vc: STRPPaymentViewController) {
		
	}
	
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
	
	//MARK:Actions
	
	func backButtonTapped(sender: UIButton) {
		self.navigationController?.popViewControllerAnimated(true)
	}
	
	func didTapPaymentButton(sender: UIButton) {
		let nextVC = STRPPaymentViewController()
		nextVC.delegate = self
		nextVC.task = self.task
		nextVC.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
		nextVC.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
		self.presentViewController(nextVC, animated: true, completion: nil)
	}
	
	func didTapApproveTaskButton(sender: UIButton) {
		if sender.selected == false {
			sender.selected = true
		} else if sender.selected == true {
			GraphQLClient.mutation("CompleteTask", input: ["taskId":self.task.id], block: nil)
			self.setCompleted()
		}
	}
	
	func didTapRateYourNelperButton(sender: UIButton) {
		GraphQLClient.mutation("SendApplicantFeedback", input: ["taskId":self.task.id, "rating":5,"content":"Charles a été génial"], block: nil)
		self.setRated()
	}
	
	func didTapProfile(gesture: UITapGestureRecognizer) {
		let nextVC = PosterProfileViewController()
		nextVC.poster = self.acceptedApplicant
		nextVC.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
		self.navigationController?.pushViewController(nextVC, animated: true)
	}
	
	/**
	Create the conversation between the two correspondants, hack to properly present the chat view (Fat and ugly method, need refactoring)
	
	- parameter sender: chat button
	*/
	
	func chatButtonTapped(sender: UIButton) {
		
		self.chatButton.selected = !self.chatButton.selected
		
		if self.conversationController == nil {
			let participants = Set([self.acceptedApplicant.objectId])
			print(participants)
			
			let conversation = try? LayerManager.sharedInstance.layerClient.newConversationWithParticipants(Set([self.acceptedApplicant.objectId]), options: nil)
			
			//var nextVC = ATLConversationViewController(layerClient: LayerManager.sharedInstance.layerClient)
			let nextVC = ApplicantChatViewController(layerClient: LayerManager.sharedInstance.layerClient)
			nextVC.displaysAddressBar = false
			if conversation != nil {
				nextVC.conversation = conversation
			} else {
				let query:LYRQuery = LYRQuery(queryableClass: LYRConversation.self)
				query.predicate = LYRPredicate(property: "participants", predicateOperator: LYRPredicateOperator.IsEqualTo, value: participants)
				let result = try? LayerManager.sharedInstance.layerClient.executeQuery(query)
				nextVC.conversation = result!.firstObject as! LYRConversation
			}
			
			let conversationNavController = UINavigationController(rootViewController: nextVC)
			self.conversationController = conversationNavController
			self.conversationController!.setNavigationBarHidden(true, animated: false)
		}
		
		if self.chatButton.selected {
			
			let tempVC = UIViewController()
			self.tempVC = tempVC
			self.addChildViewController(tempVC)
			self.view.addSubview(tempVC.view)
			//tempVC.view.backgroundColor = UIColor.yellowColor()
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