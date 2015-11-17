//
//  MyApplicationDetailsAcceptedViewController.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-09-11.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation
import Alamofire


class MyApplicationDetailsAcceptedViewController: UIViewController, MKMapViewDelegate{
	
	var poster: User!
	var application: TaskApplication!
	var picture: UIImageView!
	var scrollView: UIScrollView!
	var delegate: MyApplicationDetailsViewDelegate!
	
	var navBar: NavBar!
	var containerView: UIView!
	var contentView: UIView!
	var whiteContainer: UIView!
	var statusContainer: UIView!
	var chatButton: UIButton!
	var conversationController: UINavigationController?
	var tempVC: UIViewController!
	var fakeButton: UIButton!
	var applicationStatusIcon: UIImageView!
	var statusLabel: UILabel!
	var cancelButton: UIButton!
	
	var phoneLabel: UILabel!
	var emailLabel: UILabel!
	
	var mapView: MKMapView!
	
	
	//MARK: Initialization
	
	convenience init(poster:User, application:TaskApplication){
		self.init(nibName: "MyApplicationDetailsView", bundle: nil)
		self.poster = poster
		self.application = application
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.createView()
		self.setImages(self.poster)
		
		
		ApiHelper.getTaskPrivateDataWithId(self.application.task.id) { (taskPrivate) -> Void in
			//TODO
			//self.emailLabel.text = taskPrivate.email
			//self.phoneLabel.text = taskPrivate.phone
			//self.addressLabel.text = taskPrivate.location?.formattedTextLabel
			
			let taskLocation = CLLocationCoordinate2DMake((taskPrivate.location?.coords!["latitude"])!, (taskPrivate.location?.coords!["longitude"])!)
			let span :MKCoordinateSpan = MKCoordinateSpanMake(0.015 , 0.015)
			let locationToZoom: MKCoordinateRegion = MKCoordinateRegionMake(taskLocation, span)
			self.mapView.setRegion(locationToZoom, animated: false)
			self.mapView.setCenterCoordinate(taskLocation, animated: false)
			let taskPin = MKPointAnnotation()
			taskPin.coordinate = taskLocation
			self.mapView.addAnnotation(taskPin)
		}
	}
	
	//MARK: View Creation
	
	func createView() {
		
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
		
		let previousBtn = UIButton()
		previousBtn.addTarget(self, action: "backButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		self.navBar.backButton = previousBtn
		self.navBar.setTitle("My Application")
		
		//Header
		
		let statusContainer = UIView()
		self.statusContainer = statusContainer
		self.statusContainer.layer.borderColor = Color.grayDetails.CGColor
		self.statusContainer.layer.borderWidth = 1
		self.containerView.addSubview(statusContainer)
		statusContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.navBar.snp_bottom)
			make.left.equalTo(self.containerView.snp_left).offset(-1)
			make.right.equalTo(self.containerView.snp_right).offset(1)
			make.height.equalTo(80)
		}
		statusContainer.backgroundColor = Color.whitePrimary
		
		//My Offer
		
		let yourOfferLabel = UILabel()
		statusContainer.addSubview(yourOfferLabel)
		yourOfferLabel.text = "Agreed price"
		yourOfferLabel.textColor = Color.darkGrayDetails
		yourOfferLabel.font = UIFont(name: "Lato-Regular", size: kText12)
		yourOfferLabel.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(statusContainer.snp_centerX)
			make.centerY.equalTo(statusContainer.snp_centerY).offset(-20)
		}
		
		let moneyTag = UIView()
		statusContainer.addSubview(moneyTag)
		moneyTag.backgroundColor = Color.whiteBackground
		moneyTag.layer.cornerRadius = 3
		moneyTag.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(yourOfferLabel.snp_centerY).offset(32)
			make.centerX.equalTo(statusContainer.snp_centerX)
			make.width.equalTo(52)
			make.height.equalTo(25)
		}
		
		let moneyLabel = UILabel()
		moneyTag.addSubview(moneyLabel)
		moneyLabel.textAlignment = NSTextAlignment.Center
		moneyLabel.text = "$\(self.application.price!)"
		moneyLabel.textColor = Color.blackPrimary
		moneyLabel.font = UIFont(name: "Lato-Regular", size: kText14)
		moneyLabel.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(moneyTag.snp_edges)
		}
		
		//Status
		
		let applicationStatusLabel = UILabel()
		statusContainer.addSubview(applicationStatusLabel)
		applicationStatusLabel.text = "Application Status"
		applicationStatusLabel.textColor = Color.darkGrayDetails
		applicationStatusLabel.font = UIFont(name: "Lato-Regular", size: kText12)
		applicationStatusLabel.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(statusContainer.snp_left).offset(10)
			make.centerY.equalTo(yourOfferLabel.snp_centerY)
		}
		
		let statusLabel = UILabel()
		self.statusLabel = statusLabel
		statusLabel.text = self.fetchStatusText()
		statusContainer.addSubview(statusLabel)
		statusLabel.textColor = Color.blackPrimary
		statusLabel.font = UIFont(name: "Lato-Regular", size: kText14)
		statusLabel.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(moneyTag.snp_centerY)
			make.centerX.equalTo(applicationStatusLabel.snp_centerX).offset(16)
		}
		
		let applicationStatusIcon = UIImageView()
		statusContainer.addSubview(applicationStatusIcon)
		self.applicationStatusIcon = applicationStatusIcon
		applicationStatusIcon.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(statusLabel.snp_centerY)
			make.right.equalTo(statusLabel.snp_left).offset(-6)
			make.height.equalTo(25)
			make.width.equalTo(25)
		}
		
		//Date
		
		let appliedDate = UILabel()
		statusContainer.addSubview(appliedDate)
		appliedDate.textAlignment  = NSTextAlignment.Center
		appliedDate.text = "Applied"
		appliedDate.textColor = Color.darkGrayDetails
		appliedDate.font = UIFont(name: "Lato-Regular", size: kText12)
		appliedDate.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(yourOfferLabel.snp_centerY)
			make.right.equalTo(statusContainer.snp_right).offset(-40)
		}
		
		let appliedXDaysAgoLabel = UILabel()
		statusContainer.addSubview(appliedXDaysAgoLabel)
		let dateHelpah = DateHelper()
		appliedXDaysAgoLabel.text = "\(dateHelpah.timeAgoSinceDate(self.application.createdAt!, numericDates: true))"
		appliedXDaysAgoLabel.textAlignment = NSTextAlignment.Right
		appliedXDaysAgoLabel.textColor = Color.blackPrimary
		appliedXDaysAgoLabel.font = UIFont(name: "Lato-Regular", size: kText14)
		appliedXDaysAgoLabel.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(appliedDate.snp_centerX).offset(10)
			make.centerY.equalTo(moneyTag.snp_centerY)
		}
		
		let calendarIcon = UIImageView()
		statusContainer.addSubview(calendarIcon)
		calendarIcon.image = UIImage(named: "calendar")
		calendarIcon.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(applicationStatusIcon.snp_centerY)
			make.right.equalTo(appliedXDaysAgoLabel.snp_left).offset(-6)
			make.height.equalTo(25)
			make.width.equalTo(25)
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
		background.backgroundColor = Color.whiteBackground
		
		let scrollView = UIScrollView()
		self.scrollView = scrollView
		self.containerView.addSubview(scrollView)
		scrollView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(background.snp_edges)
		}
		scrollView.backgroundColor = Color.whiteBackground
		
		let contentView = UIView()
		self.contentView = contentView
		scrollView.addSubview(contentView)
		contentView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(scrollView.snp_top)
			make.left.equalTo(scrollView.snp_left)
			make.right.equalTo(scrollView.snp_right)
			make.height.greaterThanOrEqualTo(background.snp_height)
			make.width.equalTo(background.snp_width)
		}
		self.contentView.backgroundColor = Color.whiteBackground
		background.backgroundColor = Color.whiteBackground
		
		//Progress + Payment Container
		
		let progressContainer = UIView()
		contentView.addSubview(progressContainer)
		progressContainer.layer.borderColor = Color.grayDetails.CGColor
		progressContainer.layer.borderWidth = 1
		progressContainer.backgroundColor = Color.whitePrimary
		progressContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(contentView.snp_top).offset(20)
			make.left.equalTo(contentView.snp_left)
			make.right.equalTo(contentView.snp_right)
		}
		
		//Progress Bar
		
		//Nelper Accepted
		let nelperAcceptedLabel = UILabel()
		progressContainer.addSubview(nelperAcceptedLabel)
		nelperAcceptedLabel.numberOfLines = 0
		nelperAcceptedLabel.textAlignment = NSTextAlignment.Center
		nelperAcceptedLabel.text = "Accepted"
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
		progressContainer.addSubview(lineBetweenAcceptedAndPayment)
		lineBetweenAcceptedAndPayment.backgroundColor = Color.progressGreen
		lineBetweenAcceptedAndPayment.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(nelperAcceptedImageView.snp_centerY)
			make.left.equalTo(nelperAcceptedImageView.snp_right)
			make.right.equalTo(paymentImageView.snp_left)
			make.height.equalTo(2)
		}
		
		let lineBetweenPaymentAndApprove = UIView()
		progressContainer.addSubview(lineBetweenPaymentAndApprove)
		lineBetweenPaymentAndApprove.backgroundColor = Color.pendingYellow
		lineBetweenPaymentAndApprove.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(paymentImageView.snp_centerY)
			make.left.equalTo(paymentImageView.snp_right)
			make.right.equalTo(approvedTaskImageView.snp_left)
			make.height.equalTo(2)
		}
		
		let lineBetweenApproveAndRating = UIView()
		progressContainer.addSubview(lineBetweenApproveAndRating)
		lineBetweenApproveAndRating.backgroundColor = Color.blackPrimary
		lineBetweenApproveAndRating.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(paymentImageView.snp_centerY)
			make.left.equalTo(approvedTaskImageView.snp_right)
			make.right.equalTo(leaveFeedbackImageView.snp_left).offset(5)
			make.height.equalTo(2)
		}
		
		//Separation Line
		
		let separationLine = UIView()
		progressContainer.addSubview(separationLine)
		separationLine.backgroundColor = Color.grayDetails
		separationLine.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(leaveFeedbackLabel.snp_bottom).offset(30)
			make.centerX.equalTo(progressContainer.snp_centerX)
			make.width.equalTo(progressContainer.snp_width).dividedBy(1.2)
			make.height.equalTo(1)
		}
		
		//Payment Button
		
		let completedTaskButton = PrimaryActionButton()
		progressContainer.addSubview(completedTaskButton)
		completedTaskButton.setTitle("I have completed the task!", forState: UIControlState.Normal)
		completedTaskButton.addTarget(self, action: "didTapTaskCompleted:", forControlEvents: UIControlEvents.TouchUpInside)
		completedTaskButton.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(separationLine.snp_bottom).offset(20)
			make.centerX.equalTo(progressContainer.snp_centerX)
		}

		progressContainer.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(completedTaskButton.snp_bottom).offset(20)
		}
		
		//  Poster Container
		
		let posterContainer = UIView()
		contentView.addSubview(posterContainer)
		posterContainer.backgroundColor = Color.whitePrimary
		posterContainer.layer.borderColor = Color.grayDetails.CGColor
		posterContainer.layer.borderWidth = 1
		posterContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(progressContainer.snp_bottom).offset(20)
			make.left.equalTo(contentView.snp_left).offset(-1)
			make.right.equalTo(contentView.snp_right).offset(1)
		}
		
		//Title header
		
		let headerContainer = UIView()
		posterContainer.addSubview(headerContainer)
		headerContainer.backgroundColor = Color.whitePrimary
		headerContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(posterContainer.snp_top)
			make.left.equalTo(posterContainer.snp_left)
			make.right.equalTo(posterContainer.snp_right)
			make.height.equalTo(50)
		}
		
		let acceptedIcon = UIImageView()
		headerContainer.addSubview(acceptedIcon)
		acceptedIcon.image = UIImage(named: "profile-red")
		acceptedIcon.contentMode = UIViewContentMode.ScaleAspectFill
		acceptedIcon.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(headerContainer.snp_centerY).offset(1)
			make.left.equalTo(headerContainer.snp_left).offset(20)
			make.width.equalTo(25)
			make.height.equalTo(25)
		}
		
		let acceptedApplicantLabel = UILabel()
		headerContainer.addSubview(acceptedApplicantLabel)
		acceptedApplicantLabel.text = "Task Poster"
		acceptedApplicantLabel.textColor = Color.blackPrimary
		acceptedApplicantLabel.font = UIFont(name: "Lato-Regular", size: kTitle17)
		acceptedApplicantLabel.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(acceptedIcon.snp_centerY)
			make.left.equalTo(acceptedIcon.snp_right).offset(12)
		}
		
		//Profile Container
		
		let profileContainer = ProfileCellView(user: self.application.task.user, price: nil)
		profileContainer.button.addTarget(self, action: "didTapProfile:", forControlEvents: .TouchUpInside)
		self.picture = profileContainer.picture
		posterContainer.addSubview(profileContainer)
		profileContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(headerContainer.snp_bottom)
			make.left.equalTo(posterContainer.snp_left)
			make.right.equalTo(posterContainer.snp_right)
			make.height.equalTo(90)
		}
		
		/*let profileUnderline = UIView()
		profileContainer.addSubview(profileUnderline)
		profileUnderline.backgroundColor = Color.grayDetails
		profileUnderline.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(profileContainer.snp_bottom)
			make.width.equalTo(profileContainer.snp_width)
			make.centerX.equalTo(profileContainer.snp_centerX)
			make.height.equalTo(0.5)
		}*/
		
		//Poster info Container
		
		let informationContainer = UIView()
		posterContainer.addSubview(informationContainer)
		informationContainer.backgroundColor = Color.whitePrimary
		informationContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(profileContainer.snp_bottom)
			make.left.equalTo(posterContainer.snp_left)
			make.right.equalTo(posterContainer.snp_right)
		}
		
		let emailLabel = UILabel()
		informationContainer.addSubview(emailLabel)
		emailLabel.textColor = Color.darkGrayDetails
		emailLabel.text = "email@nelper.ca"
		emailLabel.font = UIFont(name: "Lato-Regular", size: kText15)
		emailLabel.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(informationContainer.snp_centerX).offset(15)
			make.top.equalTo(informationContainer.snp_top).offset(20)
		}
		
		let emailIcon = UIImageView()
		informationContainer.addSubview(emailIcon)
		emailIcon.image = UIImage(named: "at")
		emailIcon.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(emailLabel.snp_left).offset(-15)
			make.centerY.equalTo(emailLabel.snp_centerY)
			make.height.equalTo(25)
			make.width.equalTo(25)
		}
		
		let phoneLabel = UILabel()
		informationContainer.addSubview(phoneLabel)
		phoneLabel.textColor = Color.darkGrayDetails
		phoneLabel.text = "514-827-3745"
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
			make.height.equalTo(25)
			make.width.equalTo(25)
		}
		
		informationContainer.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(phoneIcon.snp_bottom).offset(20)
		}
		
		posterContainer.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(informationContainer.snp_bottom)
		}
		
		//Task info container
		
		let taskInfoContainer = TaskInfoView(application: self.application, accepted: true)
		contentView.addSubview(taskInfoContainer)
		taskInfoContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(posterContainer.snp_bottom).offset(20)
			make.left.equalTo(contentView.snp_left).offset(-1)
			make.right.equalTo(contentView.snp_right).offset(1)
		}
		self.mapView = taskInfoContainer.mapView
		
		contentView.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(taskInfoContainer.snp_bottom).offset(50)
		}
		
		//Chat Button
		
		let chatButton = UIButton()
		self.chatButton = chatButton
		self.view.addSubview(chatButton)
		chatButton.backgroundColor = Color.grayBlue
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
		fakeButton.backgroundColor = Color.grayBlue
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
	func setImages(applicant:User) {
		if(applicant.profilePictureURL != nil) {
			let fbProfilePicture = applicant.profilePictureURL
			request(.GET,fbProfilePicture!).response() {
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
	
	func backButtonTapped(sender:UIButton) {
		self.navigationController?.popViewControllerAnimated(true)
	}
	
	func didTapTaskCompleted(sender:UIButton) {
		
	}
	
	func didTapCancelButton(sender:UIButton) {
		if sender.selected == false {
			sender.selected = true
			
		}else if sender.selected == true {
			ApiHelper.cancelApplyForTaskWithApplication(self.application)
			self.application.state = .Canceled
			self.delegate.didCancelApplication(self.application)
			self.dismissViewControllerAnimated(true, completion: nil)
		}
	}
	
	func didTapProfile(sender:UIView) {
		let nextVC = PosterProfileViewController()
		nextVC.poster = self.poster
		nextVC.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
		self.navigationController?.pushViewController(nextVC, animated: true)
	}
	
	/**
	Create the conversation between the two correspondants, hack to properly present the chat view (Fat and ugly method, need refactoring)
	
	- parameter sender: chat button
	*/
	
	func chatButtonTapped(sender:UIButton) {
		
		self.chatButton.selected = !self.chatButton.selected
		
		if self.conversationController == nil{
			let _:NSError?
			let participants = Set([self.poster.objectId])
			print(participants)
			
			
			let conversation = try? LayerManager.sharedInstance.layerClient.newConversationWithParticipants(Set([self.poster.objectId]), options: nil)
			
			//let nextVC = ATLConversationViewController(layerClient: LayerManager.sharedInstance.layerClient)
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
		
		if self.chatButton.selected {
			
			let tempVC = UIViewController()
			self.tempVC = tempVC
			self.addChildViewController(tempVC)
			self.view.addSubview(tempVC.view)
			//tempVC.view.backgroundColor = UIColor.yellowColor()
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
