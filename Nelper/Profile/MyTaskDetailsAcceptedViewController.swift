//
//  MyTaskDetailsAcceptedViewController.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-09-07.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation
import UIKit

class MyTaskDetailsAcceptedViewController: UIViewController {

	var contentView:UIView!
	var scrollView:UIScrollView!
	var task:FindNelpTask!
	
//MARK: Initialization
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.createView()
	}

//MARK:Creating the View
	
	func createView(){
	
	var navBar = NavBar()
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
		taskLabel.text = self.task.title
		taskLabelContainer.addSubview(taskLabel)
		taskLabel.textColor = darkGrayDetails
		taskLabel.font = UIFont(name: "HelveticaNeue", size: kTitleFontSize)
		taskLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(taskLabelContainer.snp_top).offset(4)
			make.bottom.equalTo(taskLabelContainer.snp_bottom).offset(-4)
			make.left.equalTo(taskLabelContainer.snp_left).offset(8)
			make.right.equalTo(taskLabelContainer.snp_right).offset(-4)
		}
		
		var progressContainer = UIView()
		contentView.addSubview(progressContainer)
		progressContainer.layer.borderColor = darkGrayDetails.CGColor
		progressContainer.layer.borderWidth = 1
		progressContainer.backgroundColor = navBarColor
		progressContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(taskLabelContainer.snp_bottom)
			make.left.equalTo(contentView.snp_left)
			make.right.equalTo(contentView.snp_right)
			make.height.equalTo(backgroundView.snp_height).dividedBy(2)
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
			make.top.equalTo(progressContainer.snp_top).offset(8)
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
			make.width.equalTo(30)
			make.height.equalTo(30)
		}
		
		var leaveFeedbackLabel = UILabel()
		progressContainer.addSubview(leaveFeedbackLabel)
		leaveFeedbackLabel.numberOfLines = 0
		leaveFeedbackLabel.textAlignment = NSTextAlignment.Center
		leaveFeedbackLabel.text = "Rating\n&\nFeedback"
		leaveFeedbackLabel.textColor = blackNelpyColor
		leaveFeedbackLabel.font = UIFont(name: "HelveticaNeue", size: kProgressBarTextFontSize)
		leaveFeedbackLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(leaveFeedbackImageView.snp_bottom).offset(20)
			make.right.equalTo(progressContainer.snp_right).offset(-12)
		}
		
		var leaveFeedbackLine = UIView()
		progressContainer.addSubview(leaveFeedbackLine)
		leaveFeedbackLine.backgroundColor = blackNelpyColor
		leaveFeedbackLine.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(leaveFeedbackImageView.snp_bottom)
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
		approvedTaskLabel.text = "Approve task completion"
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
		lineBetweenPaymentAndApprove.backgroundColor = blackNelpyColor
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
			make.right.equalTo(leaveFeedbackImageView.snp_left)
			make.height.equalTo(2)
		}
		
	}
	
// MARK: View Delegate
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		self.scrollView.contentSize = self.contentView.frame.size
		
//		var maskPath = UIBezierPath(roundedRect: chatButton.bounds, byRoundingCorners: UIRectCorner.TopLeft, cornerRadii: CGSizeMake(20.0, 20.0))
//		var maskLayer = CAShapeLayer()
//		maskLayer.frame = self.chatButton.bounds
//		maskLayer.path = maskPath.CGPath
//		
//		var maskPathFake = UIBezierPath(roundedRect: self.fakeButton.bounds, byRoundingCorners: UIRectCorner.TopLeft, cornerRadii: CGSizeMake(20.0, 20.0))
//		var maskLayerFake = CAShapeLayer()
//		maskLayerFake.frame = self.fakeButton.bounds
//		maskLayerFake.path = maskPath.CGPath
//		
//		self.chatButton.layer.mask = maskLayer
//		self.fakeButton.layer.mask = maskLayerFake
	}
	
//MARK:Actions
	
	func backButtonTapped(sender:UIButton){
		self.dismissViewControllerAnimated(true, completion: nil)
	}
}