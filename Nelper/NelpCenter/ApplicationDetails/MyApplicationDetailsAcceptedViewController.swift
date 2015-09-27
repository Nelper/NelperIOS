//
//  MyApplicationDetailsAcceptedViewController.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-09-11.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation
import Alamofire


class MyApplicationDetailsAcceptedViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
	
	var poster: User!
	var application: NelpTaskApplication!
	let locationManager = CLLocationManager()
	var picture:UIImageView!
	var firstStar:UIImageView!
	var secondStar:UIImageView!
	var thirdStar:UIImageView!
	var fourthStar:UIImageView!
	var fifthStar:UIImageView!
	var scrollView:UIScrollView!
	var delegate: MyApplicationDetailsViewDelegate!
	
	var navBar:NavBar!
	var containerView:UIView!
	var contentView:UIView!
	var whiteContainer:UIView!
	var statusContainer:UIView!
	var chatButton:UIButton!
	var conversationController:UINavigationController?
	var tempVC:UIViewController!
	var fakeButton:UIButton!
	var cityLabel:UILabel!
	var postDateLabel:UILabel!
	var applicationStatusIcon:UIImageView!
	var statusLabel:UILabel!
	var cancelButton:UIButton!
	
	
	//MARK: Initialization
	
	convenience init(poster:User, application:NelpTaskApplication){
		self.init(nibName: "MyApplicationDetailsView", bundle: nil)
		self.poster = poster
		self.application = application
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.createView()
		self.setImages(self.poster)
	}
	
	//MARK: View Creation
	
	func createView(){
		
		let containerView = UIView()
		self.containerView = containerView
		self.view.addSubview(containerView)
		containerView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self.view.snp_edges)
		}
		
		let navBar = NavBar()
		self.navBar = navBar
		self.containerView.addSubview(navBar)
		navBar.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(64)
			make.top.equalTo(self.containerView.snp_top)
			make.left.equalTo(self.containerView.snp_left)
			make.right.equalTo(self.containerView.snp_right)
		}
		
		//Status Header
		let statusContainer = UIView()
		self.statusContainer = statusContainer
		self.statusContainer.layer.borderColor = darkGrayDetails.CGColor
		self.statusContainer.layer.borderWidth = 0.5
		self.containerView.addSubview(statusContainer)
		statusContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.navBar.snp_bottom)
			make.left.equalTo(self.containerView.snp_left).offset(-1)
			make.right.equalTo(self.containerView.snp_right).offset(1)
			make.height.equalTo(90)
		}
		statusContainer.backgroundColor = whitePrimary
		
		let yourOfferLabel = UILabel()
		statusContainer.addSubview(yourOfferLabel)
		yourOfferLabel.text = "Your offer"
		yourOfferLabel.textColor = darkGrayDetails
		yourOfferLabel.font = UIFont(name: "Lato-Regular", size: kProgressBarTextFontSize)
		yourOfferLabel.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(statusContainer.snp_centerX)
			make.centerY.equalTo(statusContainer.snp_centerY).offset(-20)
		}
		
		let moneyTag = UIImageView()
		statusContainer.addSubview(moneyTag)
		moneyTag.image = UIImage(named: "moneytag")
		moneyTag.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(statusContainer.snp_centerY).offset(20)
			make.centerX.equalTo(statusContainer.snp_centerX)
			make.width.equalTo(60)
			make.height.equalTo(25)
		}
		
		let moneyLabel = UILabel()
		moneyTag.addSubview(moneyLabel)
		moneyLabel.textAlignment = NSTextAlignment.Center
		moneyLabel.text = "$\(self.application.price!)"
		moneyLabel.textColor = whiteBackground
		moneyLabel.font = UIFont(name: "Lato-Regular", size: kText15)
		moneyLabel.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(moneyTag.snp_edges)
		}
		
		let applicationStatusLabel = UILabel()
		statusContainer.addSubview(applicationStatusLabel)
		applicationStatusLabel.text = "Application Status"
		applicationStatusLabel.textColor = darkGrayDetails
		applicationStatusLabel.font = UIFont(name: "Lato-Regular", size: kProgressBarTextFontSize)
		applicationStatusLabel.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(statusContainer.snp_left).offset(10)
			make.centerY.equalTo(yourOfferLabel.snp_centerY)
		}
		
		let applicationStatusIcon = UIImageView()
		statusContainer.addSubview(applicationStatusIcon)
		self.applicationStatusIcon = applicationStatusIcon
		applicationStatusIcon.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(moneyTag.snp_centerY)
			make.left.equalTo(applicationStatusLabel.snp_left)
			make.height.equalTo(30)
			make.width.equalTo(30)
		}
		
		let statusLabel = UILabel()
		self.statusLabel = statusLabel
		statusLabel.text = self.fetchStatusText()
		statusContainer.addSubview(statusLabel)
		statusLabel.textColor = blackPrimary
		statusLabel.font = UIFont(name: "Lato-Regular", size: kProgressBarTextFontSize)
		statusLabel.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(applicationStatusIcon.snp_centerY)
			make.left.equalTo(applicationStatusIcon.snp_right).offset(4)
		}
		
		let calendarIcon = UIImageView()
		statusContainer.addSubview(calendarIcon)
		calendarIcon.image = UIImage(named: "calendar")
		calendarIcon.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(applicationStatusIcon.snp_centerY)
			make.right.equalTo(statusContainer.snp_right).offset(-10)
			make.height.equalTo(30)
			make.width.equalTo(30)
		}
		
		let appliedXDaysAgoLabel = UILabel()
		statusContainer.addSubview(appliedXDaysAgoLabel)
		let dateHelpah = DateHelper()
		appliedXDaysAgoLabel.text = "\(dateHelpah.timeAgoSinceDate(self.application.createdAt!, numericDates: true))"
		appliedXDaysAgoLabel.textAlignment = NSTextAlignment.Right
		appliedXDaysAgoLabel.textColor = blackPrimary
		appliedXDaysAgoLabel.font = UIFont(name: "Lato-Regular", size: kProgressBarTextFontSize)
		appliedXDaysAgoLabel.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(calendarIcon.snp_left).offset(-2)
			make.centerY.equalTo(calendarIcon.snp_centerY)
		}
		
		let appliedDate = UILabel()
		statusContainer.addSubview(appliedDate)
		appliedDate.textAlignment  = NSTextAlignment.Center
		appliedDate.text = "Applied"
		appliedDate.textColor = darkGrayDetails
		appliedDate.font = UIFont(name: "Lato-Regular", size: kProgressBarTextFontSize)
		appliedDate.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(yourOfferLabel.snp_centerY)
			make.left.equalTo(appliedXDaysAgoLabel.snp_left)
			make.right.equalTo(calendarIcon.snp_right)
			make.height.equalTo(150)
		}
		
		
		
		//Background View + ScrollView
		
		let background = UIView()
		self.containerView.addSubview(background)
		background.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(statusContainer.snp_bottom)
			make.left.equalTo(self.containerView.snp_left)
			make.right.equalTo(self.containerView.snp_right)
			make.bottom.equalTo(self.containerView.snp_bottom)
		}
		background.backgroundColor = whiteBackground
		
		let scrollView = UIScrollView()
		self.scrollView = scrollView
		self.containerView.addSubview(scrollView)
		scrollView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(background.snp_edges)
		}
		scrollView.backgroundColor = whiteBackground
		
		
		scrollView.backgroundColor = whiteBackground
		let previousBtn = UIButton()
		previousBtn.addTarget(self, action: "backButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		self.navBar.closeButton = previousBtn
		self.navBar.setTitle("Application Details")
		
		let contentView = UIView()
		self.contentView = contentView
		scrollView.addSubview(contentView)
		contentView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(scrollView.snp_top)
			make.left.equalTo(scrollView.snp_left)
			make.right.equalTo(scrollView.snp_right)
			//            make.bottom.equalTo(self.scrollView.snp_bottom)
			make.height.greaterThanOrEqualTo(background.snp_height)
			make.width.equalTo(background.snp_width)
		}
		self.contentView.backgroundColor = whiteBackground
		background.backgroundColor = whiteBackground
		
		//Progress + Payment Container
		
		let progressContainer = UIView()
		contentView.addSubview(progressContainer)
		progressContainer.layer.borderColor = grayDetails.CGColor
		progressContainer.layer.borderWidth = 1
		progressContainer.backgroundColor = whitePrimary
		progressContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.contentView.snp_top)
			make.left.equalTo(contentView.snp_left)
			make.right.equalTo(contentView.snp_right)
			make.height.equalTo(background.snp_height).dividedBy(2)
		}
		
		//Progress Bar
		
		//Nelper Accepted
		let nelperAcceptedLabel = UILabel()
		progressContainer.addSubview(nelperAcceptedLabel)
		nelperAcceptedLabel.numberOfLines = 0
		nelperAcceptedLabel.textAlignment = NSTextAlignment.Center
		nelperAcceptedLabel.text = "Accepted"
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
		
		let completedTaskButton = UIButton()
		progressContainer.addSubview(completedTaskButton)
		completedTaskButton.setTitle("I have completed the task!", forState: UIControlState.Normal)
		completedTaskButton.addTarget(self, action: "didTapTaskCompleted:", forControlEvents: UIControlEvents.TouchUpInside)
		completedTaskButton.setTitleColor(whitePrimary, forState: UIControlState.Normal)
		completedTaskButton.titleLabel?.font = UIFont(name: "Lato-Regular", size: kTitle17)
		completedTaskButton.backgroundColor = redPrimary
		completedTaskButton.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(progressContainer.snp_bottom).offset(-20)
			make.centerX.equalTo(progressContainer.snp_centerX)
			make.width.equalTo(progressContainer.snp_width).dividedBy(1.6)
			make.height.equalTo(40)
		}

		
		
		//Profile Container
		
		let profileContainer = UIView()
		let profileTapAction = UITapGestureRecognizer(target: self, action: "didTapProfile:")
		profileContainer.addGestureRecognizer(profileTapAction)
		contentView.addSubview(profileContainer)
		profileContainer.layer.borderColor = darkGrayDetails.CGColor
		profileContainer.layer.borderWidth = 0.5
		profileContainer.backgroundColor = whitePrimary
		profileContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(progressContainer.snp_bottom).offset(10)
			make.left.equalTo(contentView.snp_left).offset(-1)
			make.right.equalTo(contentView.snp_right).offset(1)
			make.height.equalTo(130)
		}
		
		let profilePicture = UIImageView()
		profileContainer.addSubview(profilePicture)
		self.picture = profilePicture
		let pictureSize:CGFloat = 100
		profilePicture.contentMode = UIViewContentMode.ScaleAspectFill
		profilePicture.layer.cornerRadius = pictureSize / 2
		profilePicture.clipsToBounds = true
		profilePicture.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(profileContainer.snp_centerY)
			make.left.equalTo(20)
			make.height.equalTo(pictureSize)
			make.width.equalTo(pictureSize)
		}
		
		let nameLabel = UILabel()
		profileContainer.addSubview(nameLabel)
		nameLabel.text = self.poster.name!
		nameLabel.textColor = blackPrimary
		nameLabel.font = UIFont(name: "Lato-Regular", size: kText15)
		nameLabel.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(profilePicture.snp_centerY)
			make.left.equalTo(profilePicture.snp_right).offset(6)
		}
		
		let arrow = UIButton()
		profileContainer.addSubview(arrow)
		arrow.setBackgroundImage(UIImage(named: "arrow_applicant_cell.png"), forState: UIControlState.Normal)
		arrow.contentMode = UIViewContentMode.ScaleAspectFill
		arrow.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(profileContainer.snp_right).offset(-4)
			make.centerY.equalTo(profileContainer.snp_centerY)
			make.height.equalTo(35)
			make.width.equalTo(20)
		}
		
		//Info Container
		
		let infoContainer = UIView()
		contentView.addSubview(infoContainer)
		infoContainer.backgroundColor = whitePrimary
		infoContainer.layer.borderColor = darkGrayDetails.CGColor
		infoContainer.layer.borderWidth = 0.5
		infoContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(profileContainer.snp_bottom)
			make.left.equalTo(contentView.snp_left).offset(-1)
			make.right.equalTo(contentView.snp_right).offset(1)
			make.height.equalTo(130)
		}
		
		let emailLabel = UILabel()
		infoContainer.addSubview(emailLabel)
		emailLabel.text = "cvinette@nelper.ca"
		emailLabel.textColor = blackPrimary
		emailLabel.font = UIFont(name: "Lato-Regular", size: kText15)
		emailLabel.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(infoContainer.snp_centerX).offset(15)
			make.centerY.equalTo(infoContainer.snp_centerY).offset(-30)
		}
		
		let emailIcon = UIImageView()
		infoContainer.addSubview(emailIcon)
		emailIcon.image = UIImage(named: "at")
		emailIcon.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(emailLabel.snp_left).offset(-15)
			make.centerY.equalTo(emailLabel.snp_centerY)
			make.height.equalTo(30)
			make.width.equalTo(30)
		}
		
		let phoneLabel = UILabel()
		infoContainer.addSubview(phoneLabel)
		phoneLabel.text = "000-000-000"
		phoneLabel.textColor = blackPrimary
		phoneLabel.font = UIFont(name: "Lato-Regular", size: kText15)
		phoneLabel.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(infoContainer.snp_centerX).offset(15)
			make.top.equalTo(emailLabel.snp_bottom).offset(30)
		}
		
		let phoneIcon = UIImageView()
		infoContainer.addSubview(phoneIcon)
		phoneIcon.image = UIImage(named: "phone")
		phoneIcon.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(phoneLabel.snp_left).offset(-15)
			make.centerY.equalTo(phoneLabel.snp_centerY)
			make.height.equalTo(30)
			make.width.equalTo(30)
		}
		
		//Task Container
		
		let taskContainer = UIView()
		self.contentView.addSubview(taskContainer)
		taskContainer.layer.borderWidth = 0.5
		taskContainer.layer.borderColor = darkGrayDetails.CGColor
		taskContainer.backgroundColor = whitePrimary
		taskContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(infoContainer.snp_bottom).offset(10)
			make.left.equalTo(self.contentView.snp_left).offset(-1)
			make.right.equalTo(self.contentView.snp_right).offset(1)
			make.height.equalTo(340)
		}
		
		let categoryIcon = UIImageView()
		taskContainer.addSubview(categoryIcon)
		categoryIcon.image = UIImage(named:self.application.task.category!)
		let categoryIconSize:CGFloat = 60
		categoryIcon.contentMode = UIViewContentMode.ScaleAspectFill
		categoryIcon.layer.cornerRadius = categoryIconSize / 2
		categoryIcon.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(taskContainer.snp_centerX)
			make.top.equalTo(taskContainer.snp_top).offset(10)
			make.height.equalTo(categoryIconSize)
			make.width.equalTo(categoryIconSize)
		}
		
		let taskNameLabel = UILabel()
		taskContainer.addSubview(taskNameLabel)
		taskNameLabel.text = self.application.task.title
		taskNameLabel.textAlignment = NSTextAlignment.Center
		taskNameLabel.textColor = blackPrimary
		taskNameLabel.font = UIFont(name: "Lato-Regular", size: kText15)
		taskNameLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(categoryIcon.snp_bottom).offset(14)
			make.centerX.equalTo(taskContainer.snp_centerX)
			make.left.equalTo(taskContainer.snp_left)
			make.right.equalTo(taskContainer.snp_right)
		}
		
		let taskNameLabelUnderline = UIView()
		taskContainer.addSubview(taskNameLabelUnderline)
		taskNameLabelUnderline.backgroundColor = darkGrayDetails
		taskNameLabelUnderline.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(taskNameLabel.snp_bottom).offset(10)
			make.centerX.equalTo(taskContainer.snp_centerX)
			make.width.equalTo(taskContainer.snp_width).dividedBy(1.4)
			make.height.equalTo(0.5)
		}
		
		let descriptionTextView = UITextView()
		taskContainer.addSubview(descriptionTextView)
		descriptionTextView.backgroundColor = whitePrimary
		descriptionTextView.text = self.application.task.desc!
		descriptionTextView.textColor = blackPrimary
		descriptionTextView.scrollEnabled = false
		descriptionTextView.editable = false
		descriptionTextView.font = UIFont(name: "Lato-Regular", size: kText14)
		descriptionTextView.textAlignment = NSTextAlignment.Center
		descriptionTextView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(taskNameLabelUnderline.snp_bottom).offset(10)
			make.left.equalTo(taskContainer.snp_left).offset(10)
			make.right.equalTo(taskContainer.snp_right).offset(-10)
		}
		
		let fixedWidth = descriptionTextView.frame.size.width
		descriptionTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
		let newSize = descriptionTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
		var newFrame = descriptionTextView.frame
		newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
		descriptionTextView.frame = newFrame;
		
		
		let descriptionUnderline = UIView()
		taskContainer.addSubview(descriptionUnderline)
		descriptionUnderline.backgroundColor = darkGrayDetails
		descriptionUnderline.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(descriptionTextView.snp_bottom).offset(10)
			make.centerX.equalTo(taskContainer.snp_centerX)
			make.width.equalTo(taskContainer.snp_width).dividedBy(1.4)
			make.height.equalTo(0.5)
		}
		
		let locationContainer = UIView()
		taskContainer.addSubview(locationContainer)
		locationContainer.backgroundColor = whitePrimary
		locationContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(descriptionUnderline.snp_bottom).offset(16)
			make.centerX.equalTo(categoryIcon.snp_centerX)
			make.width.equalTo(taskContainer.snp_width).dividedBy(2)
		}
		
		let pinIcon = UIImageView()
		locationContainer.addSubview(pinIcon)
		pinIcon.image = UIImage(named: "pin")
		pinIcon.contentMode = UIViewContentMode.ScaleAspectFill
		pinIcon.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(35)
			make.width.equalTo(35)
			make.centerY.equalTo(locationContainer.snp_centerY)
			make.left.equalTo(locationContainer.snp_left).offset(4)
		}
		
		let locationVerticalLine = UIView()
		locationContainer.addSubview(locationVerticalLine)
		locationVerticalLine.backgroundColor = darkGrayDetails
		locationVerticalLine.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(locationContainer.snp_top)
			make.bottom.equalTo(locationContainer.snp_bottom)
			make.width.equalTo(1)
			make.left.equalTo(pinIcon.snp_right).offset(4)
		}
		
		let streetAddressLabel = UILabel()
		locationContainer.addSubview(streetAddressLabel)
		streetAddressLabel.text = "175 Forbin Janson"
		streetAddressLabel.textColor = blackPrimary
		streetAddressLabel.font = UIFont(name: "Lato-Regular", size: kProgressBarTextFontSize)
		streetAddressLabel.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(locationContainer.snp_height).dividedBy(3)
			make.left.equalTo(locationVerticalLine.snp_left).offset(4)
			make.top.equalTo(locationContainer.snp_top)
		}
		
		let cityLabel = UILabel()
		locationContainer.addSubview(cityLabel)
		cityLabel.text = "Mont Saint-Hilaire"
		cityLabel.textColor = blackPrimary
		cityLabel.font = UIFont(name: "Lato-Regular", size: kProgressBarTextFontSize)
		cityLabel.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(locationContainer.snp_height).dividedBy(3)
			make.left.equalTo(locationVerticalLine.snp_left).offset(4)
			make.top.equalTo(streetAddressLabel.snp_bottom)
		}

		let zipcodeLabel = UILabel()
		locationContainer.addSubview(zipcodeLabel)
		zipcodeLabel.text = "J3H5E5"
		zipcodeLabel.textColor = blackPrimary
		zipcodeLabel.font = UIFont(name: "Lato-Regular", size: kProgressBarTextFontSize)
		zipcodeLabel.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(locationContainer.snp_height).dividedBy(3)
			make.left.equalTo(locationVerticalLine.snp_left).offset(4)
			make.top.equalTo(cityLabel.snp_bottom)
		}

		let locationNoticeLabel = UILabel()
		taskContainer.addSubview(locationNoticeLabel)
		locationNoticeLabel.text = "Exact Location Shown"
		locationNoticeLabel.textColor = darkGrayDetails
		locationNoticeLabel.font = UIFont(name: "Lato-Regular", size: kProgressBarTextFontSize)
		locationNoticeLabel.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(self.view.snp_left).offset(2)
			make.bottom.equalTo(taskContainer.snp_bottom).offset(-2)
		}
		
		//Map Container
		
		let mapContainer = UIView()
		self.contentView.addSubview(mapContainer)
		mapContainer.layer.borderColor = darkGrayDetails.CGColor
		mapContainer.layer.borderWidth = 0.5
		mapContainer.backgroundColor = whitePrimary
		mapContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(taskContainer.snp_bottom)
			make.left.equalTo(self.contentView.snp_left).offset(-1)
			make.right.equalTo(self.contentView.snp_right).offset(1)
			make.height.equalTo(250)
			make.bottom.equalTo(self.contentView.snp_bottom)
		}
		
		let mapView = MKMapView()
		mapView.delegate = self
		mapContainer.addSubview(mapView)
		mapView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(mapContainer.snp_edges)
		}
		
		self.locationManager.delegate = self;
		self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
		self.locationManager.requestWhenInUseAuthorization()
		self.locationManager.startUpdatingLocation()
		self.locationManager.distanceFilter = 40
		
		_ = MKMapView()
		
		let taskLocation = CLLocationCoordinate2DMake(self.application.task.location!.latitude, self.application.task.location!.longitude)
		let span :MKCoordinateSpan = MKCoordinateSpanMake(0.015 , 0.015)
		let locationToZoom: MKCoordinateRegion = MKCoordinateRegionMake(taskLocation, span)
		mapView.setRegion(locationToZoom, animated: true)
		mapView.setCenterCoordinate(taskLocation, animated: true)
		let taskPin = MKPointAnnotation()
		taskPin.coordinate = taskLocation
		mapView.addAnnotation(taskPin)
		
		
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
			make.right.equalTo(self.contentView.snp_right).offset(2)
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
			make.right.equalTo(self.contentView.snp_right).offset(2)
			make.bottom.equalTo(self.view.snp_bottom)
			make.width.equalTo(100)
			make.height.equalTo(40)
		}
		
		fakeButton.hidden = true
	}
	
	
	//MARK: DATA
	
	/**
	Set the images
	
	- parameter applicant: Applicant
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
		
		self.applicationStatusIcon.image = self.fetchStatusIcon()
		
	}
	
	//MARK: MKMapView Delegate Methods
	
	func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
		if overlay is MKCircle {
			let circle = MKCircleRenderer(overlay: overlay)
			circle.strokeColor = UIColor.redColor()
			circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
			circle.lineWidth = 1
			return circle
		} else {
			return MKCircleRenderer()
		}
	}
	
	//MARK: CLLocation Delegate Methods
	
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		
	}
	
	func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
		
	}
	
	//MARK: View Delegate Methods
	
	/**
	Layout the view once it's "loaded" to properly set scroll view content size
	*/
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		self.scrollView.contentSize = self.contentView.frame.size
		
		let maskPath = UIBezierPath(roundedRect: chatButton.bounds, byRoundingCorners: UIRectCorner.TopLeft, cornerRadii: CGSizeMake(20.0, 20.0))
		let maskLayer = CAShapeLayer()
		maskLayer.frame = self.chatButton.bounds
		maskLayer.path = maskPath.CGPath
		
		_ = UIBezierPath(roundedRect: self.fakeButton.bounds, byRoundingCorners: UIRectCorner.TopLeft, cornerRadii: CGSizeMake(20.0, 20.0))
		let maskLayerFake = CAShapeLayer()
		maskLayerFake.frame = self.fakeButton.bounds
		maskLayerFake.path = maskPath.CGPath
		
		self.chatButton.layer.mask = maskLayer
		self.fakeButton.layer.mask = maskLayerFake
	}
	
	//MARK: Utilities
	
	/**
	Fetches the Application Status Icon
	
	- returns: Proper Icon
	*/
	func fetchStatusIcon() -> UIImage{
		
		switch self.application.state{
		case .Accepted:
			return UIImage(named: "accepted")!
		case .Pending:
			return UIImage(named: "pending")!
		case .Denied:
			return UIImage(named: "denied")!
		default:
			return UIImage()
		}
	}
	
	func fetchStatusText() -> String{
		switch self.application.state{
		case .Accepted:
			return "Accepted"
		case .Pending:
			return "Pending"
		case .Denied:
			return "Denied"
		default:
			return "Something went wrong :-/"
		}
	}
	
	//MARK: Actions
	
	func backButtonTapped(sender:UIButton){
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func didTapTaskCompleted(sender:UIButton){
		
	}
	
	func didTapCancelButton(sender:UIButton){
		if sender.selected == false {
			sender.selected = true
			
		}else if sender.selected == true{
			ApiHelper.cancelApplyForTaskWithApplication(self.application)
			self.application.state = .Canceled
			self.delegate.didCancelApplication(self.application)
			self.dismissViewControllerAnimated(true, completion: nil)
		}
	}
	
	func didTapProfile(sender:UIView){
		let nextVC = PosterProfileViewController()
		nextVC.poster = self.poster
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
			let _:NSError?
			let participants = Set([self.poster.objectId])
			print(participants)
			
			
			let conversation = try? LayerManager.sharedInstance.layerClient.newConversationWithParticipants(Set([self.poster.objectId]), options: nil)
			
			//		let nextVC = ATLConversationViewController(layerClient: LayerManager.sharedInstance.layerClient)
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
				make.top.equalTo(self.statusContainer.snp_bottom)
				make.bottom.equalTo(self.view.snp_bottom)
				make.width.equalTo(self.view.snp_width)
			}
			
			tempVC.addChildViewController(self.conversationController!)
			_ = UIScreen.mainScreen().bounds.height -  (UIScreen.mainScreen().bounds.height - self.statusContainer.frame.height)
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
						make.bottom.equalTo(self.statusContainer.snp_bottom)
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
						make.right.equalTo(self.view.snp_right).offset(2)
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
