//
//  MyApplicationDetailsView.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-09-01.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation
import Alamofire

protocol MyApplicationDetailsViewDelegate{
	func didCancelApplication(application:NelpTaskApplication)
}

class MyApplicationDetailsView: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
	
	@IBOutlet weak var navBar: NavBar!
	@IBOutlet weak var containerView: UIView!
	
	let kCellHeight:CGFloat = 45
	
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
		self.navBar.setTitle("Application Details")
		self.createView()
		self.setImages(self.poster)
	}
	
	//MARK: View Creation
	
	func createView(){
		
		//Status Header
		var statusContainer = UIView()
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
		statusContainer.backgroundColor = navBarColor
		
		var yourOfferLabel = UILabel()
		statusContainer.addSubview(yourOfferLabel)
		yourOfferLabel.text = "Your offer"
		yourOfferLabel.textColor = darkGrayDetails
		yourOfferLabel.font = UIFont(name: "HelveticaNeue", size: kStatusBarFont)
		yourOfferLabel.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(statusContainer.snp_centerX)
			make.centerY.equalTo(statusContainer.snp_centerY).offset(-20)
		}
		
		var moneyTag = UIImageView()
		statusContainer.addSubview(moneyTag)
		moneyTag.image = UIImage(named: "moneytag")
		moneyTag.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(statusContainer.snp_centerY).offset(20)
			make.centerX.equalTo(statusContainer.snp_centerX)
			make.width.equalTo(60)
			make.height.equalTo(25)
		}
		
		var moneyLabel = UILabel()
		moneyTag.addSubview(moneyLabel)
		moneyLabel.textAlignment = NSTextAlignment.Center
		moneyLabel.text = "$\(self.application.price!)"
		moneyLabel.textColor = whiteNelpyColor
		moneyLabel.font = UIFont(name: "HelveticaNeue", size: kTextFontSize)
		moneyLabel.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(moneyTag.snp_edges)
		}
		
		var applicationStatusLabel = UILabel()
		statusContainer.addSubview(applicationStatusLabel)
		applicationStatusLabel.text = "Application Status"
		applicationStatusLabel.textColor = darkGrayDetails
		applicationStatusLabel.font = UIFont(name: "HelveticaNeue", size: kStatusBarFont)
		applicationStatusLabel.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(statusContainer.snp_left).offset(10)
			make.centerY.equalTo(yourOfferLabel.snp_centerY)
		}
		
		var applicationStatusIcon = UIImageView()
		statusContainer.addSubview(applicationStatusIcon)
		self.applicationStatusIcon = applicationStatusIcon
		applicationStatusIcon.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(moneyTag.snp_centerY)
			make.left.equalTo(applicationStatusLabel.snp_left)
			make.height.equalTo(30)
			make.width.equalTo(30)
		}
		
		var statusLabel = UILabel()
		self.statusLabel = statusLabel
		statusLabel.text = self.fetchStatusText()
		statusContainer.addSubview(statusLabel)
		statusLabel.textColor = blackNelpyColor
		statusLabel.font = UIFont(name: "HelveticaNeue", size: kProgressBarTextFontSize)
		statusLabel.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(applicationStatusIcon.snp_centerY)
			make.left.equalTo(applicationStatusIcon.snp_right).offset(4)
		}
		
		var calendarIcon = UIImageView()
		statusContainer.addSubview(calendarIcon)
		calendarIcon.image = UIImage(named: "calendar")
		calendarIcon.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(applicationStatusIcon.snp_centerY)
			make.right.equalTo(statusContainer.snp_right).offset(-10)
			make.height.equalTo(30)
			make.width.equalTo(30)
		}
		
		var appliedXDaysAgoLabel = UILabel()
		statusContainer.addSubview(appliedXDaysAgoLabel)
		var dateHelpah = DateHelper()
		appliedXDaysAgoLabel.text = "\(dateHelpah.timeAgoSinceDate(self.application.createdAt!, numericDates: true))"
		appliedXDaysAgoLabel.textAlignment = NSTextAlignment.Right
		appliedXDaysAgoLabel.textColor = blackNelpyColor
		appliedXDaysAgoLabel.font = UIFont(name: "HelveticaNeue", size: kProgressBarTextFontSize)
		appliedXDaysAgoLabel.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(calendarIcon.snp_left).offset(-2)
			make.centerY.equalTo(calendarIcon.snp_centerY)
		}
		
		var appliedDate = UILabel()
		statusContainer.addSubview(appliedDate)
		appliedDate.textAlignment  = NSTextAlignment.Center
		appliedDate.text = "Applied"
		appliedDate.textColor = darkGrayDetails
		appliedDate.font = UIFont(name: "HelveticaNeue", size: kStatusBarFont)
		appliedDate.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(yourOfferLabel.snp_centerY)
			make.left.equalTo(appliedXDaysAgoLabel.snp_left)
			make.right.equalTo(calendarIcon.snp_right)
			make.height.equalTo(150)
		}
		
		
		
		//Background View + ScrollView
		
		var background = UIView()
		self.containerView.addSubview(background)
		background.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(statusContainer.snp_bottom)
			make.left.equalTo(self.containerView.snp_left)
			make.right.equalTo(self.containerView.snp_right)
			make.bottom.equalTo(self.containerView.snp_bottom)
		}
		
		var scrollView = UIScrollView()
		self.scrollView = scrollView
		self.containerView.addSubview(scrollView)
		scrollView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(background.snp_edges)
		}
		
		
		scrollView.backgroundColor = whiteNelpyColor
		let backBtn = UIButton()
		backBtn.addTarget(self, action: "backButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		self.navBar.backButton = backBtn
		self.navBar.setImage(UIImage(named: "close_red")!)
		
		var contentView = UIView()
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
		self.contentView.backgroundColor = whiteNelpyColor
		background.backgroundColor = whiteNelpyColor
		
		
		//Profile Container
		
		var profileContainer = UIView()
		var profileTapAction = UITapGestureRecognizer(target: self, action: "didTapProfile:")
		profileContainer.addGestureRecognizer(profileTapAction)
	  contentView.addSubview(profileContainer)
		profileContainer.layer.borderColor = darkGrayDetails.CGColor
		profileContainer.layer.borderWidth = 0.5
		profileContainer.backgroundColor = navBarColor
		profileContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.contentView.snp_top).offset(10)
			make.left.equalTo(contentView.snp_left).offset(-1)
			make.right.equalTo(contentView.snp_right).offset(1)
			make.height.equalTo(130)
		}
		
		var profilePicture = UIImageView()
		profileContainer.addSubview(profilePicture)
		self.picture = profilePicture
		var pictureSize:CGFloat = 100
		profilePicture.contentMode = UIViewContentMode.ScaleAspectFill
		profilePicture.layer.cornerRadius = pictureSize / 2
		profilePicture.clipsToBounds = true
		profilePicture.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(profileContainer.snp_centerY)
			make.left.equalTo(20)
			make.height.equalTo(pictureSize)
			make.width.equalTo(pictureSize)
		}
		
		var nameLabel = UILabel()
		profileContainer.addSubview(nameLabel)
		nameLabel.text = self.poster.name!
		nameLabel.textColor = blackNelpyColor
		nameLabel.font = UIFont(name: "HelveticaNeue", size: kTextFontSize)
		nameLabel.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(profilePicture.snp_centerY)
			make.left.equalTo(profilePicture.snp_right).offset(6)
		}
		
		var arrow = UIButton()
		profileContainer.addSubview(arrow)
		arrow.setBackgroundImage(UIImage(named: "arrow_applicant_cell.png"), forState: UIControlState.Normal)
		arrow.contentMode = UIViewContentMode.ScaleAspectFill
		arrow.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(profileContainer.snp_right).offset(-4)
			make.centerY.equalTo(profileContainer.snp_centerY)
			make.height.equalTo(35)
			make.width.equalTo(20)
		}
		
		//Task Container
		
		var taskContainer = UIView()
		self.contentView.addSubview(taskContainer)
		taskContainer.layer.borderWidth = 0.5
		taskContainer.layer.borderColor = darkGrayDetails.CGColor
		taskContainer.backgroundColor = navBarColor
		taskContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(profileContainer.snp_bottom).offset(10)
			make.left.equalTo(self.contentView.snp_left).offset(-1)
			make.right.equalTo(self.contentView.snp_right).offset(1)
			make.height.equalTo(370)
		}
		
		var categoryIcon = UIImageView()
		taskContainer.addSubview(categoryIcon)
		categoryIcon.image = UIImage(named:self.application.task.category!)
		var categoryIconSize:CGFloat = 60
		categoryIcon.contentMode = UIViewContentMode.ScaleAspectFill
		categoryIcon.layer.cornerRadius = categoryIconSize / 2
		categoryIcon.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(taskContainer.snp_centerX)
			make.top.equalTo(taskContainer.snp_top).offset(10)
			make.height.equalTo(categoryIconSize)
			make.width.equalTo(categoryIconSize)
		}
		
		var taskNameLabel = UILabel()
		taskContainer.addSubview(taskNameLabel)
		taskNameLabel.text = self.application.task.title
		taskNameLabel.textAlignment = NSTextAlignment.Center
		taskNameLabel.textColor = blackNelpyColor
		taskNameLabel.font = UIFont(name: "HelveticaNeue", size: kSubtitleFontSize)
		taskNameLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(categoryIcon.snp_bottom).offset(14)
			make.centerX.equalTo(taskContainer.snp_centerX)
			make.left.equalTo(taskContainer.snp_left)
			make.right.equalTo(taskContainer.snp_right)
		}
		
		var taskNameLabelUnderline = UIView()
		taskContainer.addSubview(taskNameLabelUnderline)
		taskNameLabelUnderline.backgroundColor = darkGrayDetails
		taskNameLabelUnderline.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(taskNameLabel.snp_bottom).offset(10)
			make.centerX.equalTo(taskContainer.snp_centerX)
			make.width.equalTo(taskContainer.snp_width).dividedBy(1.4)
			make.height.equalTo(0.5)
		}
		
		var descriptionTextView = UITextView()
		taskContainer.addSubview(descriptionTextView)
		descriptionTextView.backgroundColor = navBarColor
		descriptionTextView.text = self.application.task.desc!
		descriptionTextView.textColor = blackNelpyColor
		descriptionTextView.scrollEnabled = false
		descriptionTextView.editable = false
		descriptionTextView.font = UIFont(name: "HelveticaNeue", size: kCellSubtitleFontSize)
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
		
		
		var descriptionUnderline = UIView()
		taskContainer.addSubview(descriptionUnderline)
		descriptionUnderline.backgroundColor = darkGrayDetails
		descriptionUnderline.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(descriptionTextView.snp_bottom).offset(10)
			make.centerX.equalTo(taskContainer.snp_centerX)
			make.width.equalTo(taskContainer.snp_width).dividedBy(1.4)
			make.height.equalTo(0.5)
		}
		
		var postedIcon = UIImageView()
		taskContainer.addSubview(postedIcon)
		postedIcon.image = UIImage(named:"calendar")
		postedIcon.contentMode = UIViewContentMode.ScaleAspectFill
		postedIcon.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(35)
			make.width.equalTo(35)
			make.top.equalTo(descriptionUnderline.snp_bottom).offset(16)
			make.centerX.equalTo(taskContainer.snp_centerX).offset(-70)
		}
		
		var postDateLabel = UILabel()
		taskContainer.addSubview(postDateLabel)
		self.postDateLabel = postDateLabel
		var dateHelper = DateHelper()
		postDateLabel.text = "Posted \(dateHelper.timeAgoSinceDate(self.application.task.createdAt!, numericDates: true))"
		postDateLabel.textColor = blackNelpyColor
		postDateLabel.font = UIFont(name: "HelveticaNeue", size: kCellSubtitleFontSize)
		postDateLabel.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(postedIcon.snp_centerY)
			make.left.equalTo(postedIcon.snp_right).offset(4)
		}
		
		var pinIcon = UIImageView()
		taskContainer.addSubview(pinIcon)
		pinIcon.image = UIImage(named: "pin")
		pinIcon.contentMode = UIViewContentMode.ScaleAspectFill
		pinIcon.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(35)
			make.width.equalTo(35)
			make.top.equalTo(postedIcon.snp_bottom).offset(15)
			make.centerX.equalTo(postedIcon.snp_centerX)
		}
		
		var cityLabel = UILabel()
		taskContainer.addSubview(cityLabel)
		self.cityLabel = cityLabel
		cityLabel.text = self.application.task.city!
		cityLabel.textColor = blackNelpyColor
		cityLabel.font = UIFont(name: "HelveticaNeue", size: kCellSubtitleFontSize)
		cityLabel.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(pinIcon.snp_centerY)
			make.left.equalTo(pinIcon.snp_right).offset(4)
		}
		
		var taskPosterOffer = UILabel()
		taskContainer.addSubview(taskPosterOffer)
		taskPosterOffer.text = "Task poster is offering"
		taskPosterOffer.textColor = darkGrayDetails
		taskPosterOffer.font = UIFont(name: "HelveticaNeue", size: kCellSubtitleFontSize)
		taskPosterOffer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(pinIcon.snp_bottom).offset(15)
			make.left.equalTo(pinIcon.snp_left).offset(-20)
		}
		
		var moneyTagPoster = UIImageView()
		taskContainer.addSubview(moneyTagPoster)
		moneyTagPoster.image = UIImage(named: "moneytag")
		moneyTagPoster.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(taskPosterOffer.snp_centerY)
			make.left.equalTo(taskPosterOffer.snp_right).offset(4)
			make.width.equalTo(60)
			make.height.equalTo(25)
		}
		
		var moneyLabelPoster = UILabel()
		moneyTagPoster.addSubview(moneyLabelPoster)
		moneyLabelPoster.textAlignment = NSTextAlignment.Center
		moneyLabelPoster.text = "$\(Int(self.application.task.priceOffered!))"
		moneyLabelPoster.textColor = whiteNelpyColor
		moneyLabelPoster.font = UIFont(name: "HelveticaNeue", size: kTextFontSize)
		moneyLabelPoster.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(moneyTagPoster.snp_edges)
		}
		
		
		var locationNoticeLabel = UILabel()
		taskContainer.addSubview(locationNoticeLabel)
		locationNoticeLabel.text = "Task location within 400m"
		locationNoticeLabel.textColor = darkGrayDetails
		locationNoticeLabel.font = UIFont(name: "HelveticaNeue", size: kProgressBarTextFontSize)
		locationNoticeLabel.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(self.view.snp_left).offset(2)
			make.bottom.equalTo(taskContainer.snp_bottom).offset(-2)
		}
		
		//Map Container
		
		var mapContainer = UIView()
		self.contentView.addSubview(mapContainer)
		mapContainer.layer.borderColor = darkGrayDetails.CGColor
		mapContainer.layer.borderWidth = 0.5
		mapContainer.backgroundColor = navBarColor
		mapContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(taskContainer.snp_bottom)
			make.left.equalTo(self.contentView.snp_left).offset(-1)
			make.right.equalTo(self.contentView.snp_right).offset(1)
			make.height.equalTo(250)
		}
		
		var mapView = MKMapView()
		mapView.delegate = self
		mapContainer.addSubview(mapView)
		mapView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(mapContainer.snp_edges)
		}
		
		self.locationManager.delegate = self;
		self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
		self.locationManager.requestWhenInUseAuthorization()
		self.locationManager.startUpdatingLocation()
		self.locationManager.distanceFilter = 40
		
		var mapview = MKMapView()
		
		var taskLocation = CLLocationCoordinate2DMake(self.application.task.location!.latitude, self.application.task.location!.longitude)
		var span :MKCoordinateSpan = MKCoordinateSpanMake(0.015 , 0.015)
		var locationToZoom: MKCoordinateRegion = MKCoordinateRegionMake(taskLocation, span)
		mapView.setRegion(locationToZoom, animated: true)
		mapView.setCenterCoordinate(taskLocation, animated: true)
		
		var circle = MKCircle(centerCoordinate: taskLocation, radius: 400)
		mapView.addOverlay(circle)
	
		
		var cancelContainer = UIView()
		contentView.addSubview(cancelContainer)
		cancelContainer.backgroundColor = whiteNelpyColor
		cancelContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(mapView.snp_bottom)
			make.width.equalTo(self.contentView.snp_width)
			make.height.equalTo(120)
			make.bottom.equalTo(self.contentView.snp_bottom)
		}
		
		var cancelButton = UIButton()
		cancelContainer.addSubview(cancelButton)
		self.cancelButton = cancelButton
		cancelButton.setTitle("Cancel Application", forState: UIControlState.Normal)
		cancelButton.setTitle("Sure?", forState: UIControlState.Selected)
		cancelButton.setTitleColor(blackNelpyColor, forState: UIControlState.Normal)
		cancelButton.setTitleColor(nelperRedColor, forState: UIControlState.Selected)
		self.cancelButton.addTarget(self, action: "didTapCancelButton:", forControlEvents: UIControlEvents.TouchUpInside)
		cancelButton.layer.borderWidth = 0.5
		cancelButton.layer.borderColor = darkGrayDetails.CGColor
		cancelButton.backgroundColor = navBarColor
		cancelButton.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(mapView.snp_bottom).offset(20)
			make.centerX.equalTo(cancelContainer.snp_centerX)
			make.height.equalTo(45)
			make.width.equalTo(200)
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
			make.right.equalTo(self.contentView.snp_right).offset(2)
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
			make.right.equalTo(self.contentView.snp_right).offset(2)
			make.bottom.equalTo(self.view.snp_bottom)
			make.width.equalTo(100)
			make.height.equalTo(40)
		}
		
		fakeButton.hidden = true
	}

	
	//MARK: DATA
	
	/**
	Sets the Applications images(Category, Task poster profile pic)
	
	- parameter applicant: Task Poster
	*/
	func setImages(applicant:User){
		if(applicant.profilePictureURL != nil){
			var fbProfilePicture = applicant.profilePictureURL
			request(.GET,fbProfilePicture!).response(){
				(_, _, data, _) in
				var image = UIImage(data: data as NSData!)
				self.picture.image = image
			}
		}
		self.applicationStatusIcon.image = self.fetchStatusIcon()
	}
	
	//MARK: MKMapView Delegate Methods
	
	func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer! {
		if overlay is MKCircle {
			let circle = MKCircleRenderer(overlay: overlay)
			circle.strokeColor = UIColor.redColor()
			circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
			circle.lineWidth = 1
			return circle
		} else {
			return nil
		}
	}
	
	//MARK: CLLocation Delegate Methods
	
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		
	}
	
	func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
		
	}
	
	//MARK: View Delegate Methods
	
	/**
	Used to set the Scrollview proper contentsize AND shape the chat button
	*/
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		self.scrollView.contentSize = self.contentView.frame.size
		
		let maskPath = UIBezierPath(roundedRect: chatButton.bounds, byRoundingCorners: UIRectCorner.TopLeft, cornerRadii: CGSizeMake(20.0, 20.0))
		let maskLayer = CAShapeLayer()
		maskLayer.frame = self.chatButton.bounds
		maskLayer.path = maskPath.CGPath
		
		var maskPathFake = UIBezierPath(roundedRect: self.fakeButton.bounds, byRoundingCorners: UIRectCorner.TopLeft, cornerRadii: CGSizeMake(20.0, 20.0))
		let maskLayerFake = CAShapeLayer()
		maskLayerFake.frame = self.fakeButton.bounds
		maskLayerFake.path = maskPath.CGPath
		
		self.chatButton.layer.mask = maskLayer
		self.fakeButton.layer.mask = maskLayerFake
	}
	
	//MARK: Utilities
	
	/**
	Small method to set the correct category icon
	
	- returns: Proper Category Icon
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
	
	/**
	When the task poster view is tapped
	
	- parameter sender: Poster Profile View
	*/
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
			var error:NSError?
			var participants = Set([self.poster.objectId])
			print(participants)
			
			
			var conversation = try? LayerManager.sharedInstance.layerClient.newConversationWithParticipants(Set([self.poster.objectId]), options: nil)
			
			//		var nextVC = ATLConversationViewController(layerClient: LayerManager.sharedInstance.layerClient)
			var nextVC = ApplicantChatViewController(layerClient: LayerManager.sharedInstance.layerClient)
			nextVC.displaysAddressBar = false
			if conversation != nil{
				nextVC.conversation = conversation
			}else{
				var query:LYRQuery = LYRQuery(queryableClass: LYRConversation.self)
				query.predicate = LYRPredicate(property: "participants", predicateOperator: LYRPredicateOperator.IsEqualTo, value: participants)
				var result = try? LayerManager.sharedInstance.layerClient.executeQuery(query)
				nextVC.conversation = result!.firstObject as! LYRConversation
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
				make.top.equalTo(self.statusContainer.snp_bottom)
				make.bottom.equalTo(self.view.snp_bottom)
				make.width.equalTo(self.view.snp_width)
			}
			
			tempVC.addChildViewController(self.conversationController!)
			var distanceToMove = UIScreen.mainScreen().bounds.height -  (UIScreen.mainScreen().bounds.height - self.statusContainer.frame.height)
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

