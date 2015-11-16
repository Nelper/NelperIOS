//
//  MyApplicationDetailsView.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-09-01.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation
import Alamofire
import iCarousel

protocol MyApplicationDetailsViewDelegate{
	func didCancelApplication(application:TaskApplication)
}

class MyApplicationDetailsView: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, iCarouselDataSource, iCarouselDelegate {
	
	@IBOutlet weak var navBar: NavBar!
	@IBOutlet weak var containerView: UIView!
	
	let kCellHeight: CGFloat = 45
	
	var poster: User!
	var application: TaskApplication!
	var pictures: NSArray?
	var carousel: iCarousel!
	let locationManager = CLLocationManager()
	var picture: UIImageView!
	var scrollView: UIScrollView!
	var delegate: MyApplicationDetailsViewDelegate!
	
	var contentView: UIView!
	var whiteContainer: UIView!
	var statusContainer: UIView!
	var chatButton: UIButton!
	var conversationController: UINavigationController?
	var tempVC: UIViewController!
	var fakeButton: UIButton!
	var cityLabel: UILabel!
	var postDateLabel: UILabel!
	var applicationStatusIcon: UIImageView!
	var statusLabel: UILabel!
	var taskImageContainer: UIView!
	var carouselContainer: UIView!
	var cancelButton: SecondaryActionButton!
	
	
	//MARK: Initialization
	
	convenience init(poster: User, application: TaskApplication){
		self.init(nibName: "MyApplicationDetailsView", bundle: nil)
		self.poster = poster
		self.application = application
		self.pictures = self.application.task.pictures
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let previousBtn = UIButton()
		previousBtn.addTarget(self, action: "backButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		self.navBar.backButton = previousBtn
		self.navBar.setTitle("My Application")
		self.createView()
		self.setImages(self.poster)
	}
	
	//MARK: View Creation
	
	func createView(){
		
		//Status Header
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
		
		//My offer
		
		let yourOfferLabel = UILabel()
		statusContainer.addSubview(yourOfferLabel)
		yourOfferLabel.text = "My offer"
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
			make.centerX.equalTo(moneyTag.snp_centerY).offset(1)
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
		statusLabel.font = UIFont(name: "Lato-Regular", size: kProgressBarTextFontSize)
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
		appliedXDaysAgoLabel.font = UIFont(name: "Lato-Regular", size: kProgressBarTextFontSize)
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
			//make.bottom.equalTo(self.scrollView.snp_bottom)
			make.height.greaterThanOrEqualTo(background.snp_height)
			make.width.equalTo(background.snp_width)
		}
		self.contentView.backgroundColor = Color.whiteBackground
		background.backgroundColor = Color.whiteBackground
		
		
		//Profile Container
		
		let profileContainer = ProfileCellView(task:self.application.task)
		profileContainer.button.addTarget(self, action: "didTapProfile:", forControlEvents: .TouchUpInside)
		self.picture = profileContainer.picture
		self.contentView.addSubview(profileContainer)
		profileContainer.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(90)
			make.top.equalTo(self.contentView.snp_top).offset(20)
			make.left.equalTo(contentView.snp_left).offset(-1)
			make.right.equalTo(contentView.snp_right).offset(1)
		}
	
		
		//Task Container
		
		let taskContainer = UIView()
		self.contentView.addSubview(taskContainer)
		taskContainer.layer.borderWidth = 1
		taskContainer.layer.borderColor = Color.grayDetails.CGColor
		taskContainer.backgroundColor = Color.whitePrimary
		taskContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(profileContainer.snp_bottom).offset(20)
			make.left.equalTo(self.contentView.snp_left).offset(-1)
			make.right.equalTo(self.contentView.snp_right).offset(1)
		}
		
		let taskNameLabel = UILabel()
		taskContainer.addSubview(taskNameLabel)
		taskNameLabel.text = self.application.task.title
		taskNameLabel.textAlignment = NSTextAlignment.Center
		taskNameLabel.textColor = Color.blackPrimary
		taskNameLabel.font = UIFont(name: "Lato-Regular", size: kTitle17)
		taskNameLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(taskContainer).offset(20)
			make.centerX.equalTo(taskContainer.snp_centerX)
			make.left.equalTo(taskContainer.snp_left)
			make.right.equalTo(taskContainer.snp_right)
		}
		
		
		let taskNameLabelUnderline = UIView()
		taskContainer.addSubview(taskNameLabelUnderline)
		taskNameLabelUnderline.backgroundColor = Color.grayDetails
		taskNameLabelUnderline.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(taskNameLabel.snp_bottom).offset(40)
			make.centerX.equalTo(taskContainer.snp_centerX)
			make.width.equalTo(taskContainer.snp_width).dividedBy(1.4)
			make.height.equalTo(0.5)
		}
		
		let categoryIcon = UIImageView()
		taskContainer.addSubview(categoryIcon)
		categoryIcon.image = UIImage(named:self.application.task.category!)
		let categoryIconSize:CGFloat = 40
		categoryIcon.contentMode = UIViewContentMode.ScaleAspectFill
		categoryIcon.layer.cornerRadius = categoryIconSize / 2
		categoryIcon.snp_makeConstraints { (make) -> Void in
			make.center.equalTo(taskNameLabelUnderline)
			make.height.equalTo(categoryIconSize)
			make.width.equalTo(categoryIconSize)
		}
		
		let descriptionTextView = UITextView()
		taskContainer.addSubview(descriptionTextView)
		descriptionTextView.backgroundColor = Color.whitePrimary
		descriptionTextView.text = self.application.task.desc!
		descriptionTextView.textColor = Color.blackPrimary
		descriptionTextView.scrollEnabled = false
		descriptionTextView.editable = false
		descriptionTextView.font = UIFont(name: "Lato-Regular", size: kText14)
		descriptionTextView.textAlignment = NSTextAlignment.Center
		descriptionTextView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(taskNameLabelUnderline.snp_bottom).offset(40)
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
		descriptionUnderline.backgroundColor = Color.grayDetails
		descriptionUnderline.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(descriptionTextView.snp_bottom).offset(10)
			make.centerX.equalTo(taskContainer.snp_centerX)
			make.width.equalTo(taskContainer.snp_width).dividedBy(1.4)
			make.height.equalTo(0.5)
		}
		
		let taskPosterOffer = UILabel()
		taskContainer.addSubview(taskPosterOffer)
		if self.application.task.user.firstName != nil{
		taskPosterOffer.text = "\(self.application.task.user.firstName)'s offer"
		}else{
			taskPosterOffer.text = "Offer:"
		}
		taskPosterOffer.textColor = Color.darkGrayDetails
		taskPosterOffer.font = UIFont(name: "Lato-Regular", size: kText14)
		taskPosterOffer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(descriptionUnderline.snp_bottom).offset(40)
			make.centerX.equalTo(taskContainer.snp_centerX).offset(-40)
		}
		
		let moneyTagPoster = UIView()
		taskContainer.addSubview(moneyTagPoster)
		moneyTagPoster.backgroundColor = Color.whiteBackground
		moneyTagPoster.layer.cornerRadius = 3
		moneyTagPoster.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(taskPosterOffer.snp_centerY)
			make.left.equalTo(taskPosterOffer.snp_right).offset(15)
			make.width.equalTo(60)
			make.height.equalTo(30)
		}
		
		let moneyLabelPoster = UILabel()
		moneyTagPoster.addSubview(moneyLabelPoster)
		moneyLabelPoster.textAlignment = NSTextAlignment.Center
		moneyLabelPoster.text = "$\(Int(self.application.task.priceOffered!))"
		moneyLabelPoster.textColor = Color.blackPrimary
		moneyLabelPoster.font = UIFont(name: "Lato-Regular", size: kText15)
		moneyLabelPoster.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(moneyTagPoster.snp_edges)
		}
		
		let postDateLabel = UILabel()
		taskContainer.addSubview(postDateLabel)
		self.postDateLabel = postDateLabel
		let dateHelper = DateHelper()
		postDateLabel.text = "Posted \(dateHelper.timeAgoSinceDate(self.application.task.createdAt!, numericDates: true))"
		postDateLabel.textColor = Color.darkGrayDetails
		postDateLabel.font = UIFont(name: "Lato-Regular", size: kText14)
		postDateLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(moneyTagPoster.snp_bottom).offset(30)
			make.centerX.equalTo(taskContainer.snp_centerX).offset(22)
		}
		
		let postedIcon = UIImageView()
		taskContainer.addSubview(postedIcon)
		postedIcon.image = UIImage(named:"calendar")
		postedIcon.contentMode = UIViewContentMode.ScaleAspectFill
		postedIcon.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(35)
			make.width.equalTo(35)
			make.centerY.equalTo(postDateLabel.snp_centerY)
			make.right.equalTo(postDateLabel.snp_left).offset(-14)
		}
		
		let cityLabel = UILabel()
		taskContainer.addSubview(cityLabel)
		self.cityLabel = cityLabel
		cityLabel.font = UIFont(name: "Lato-Regular", size: kText14)
		cityLabel.text = self.application.task.city!
		cityLabel.textColor = Color.darkGrayDetails
		cityLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(postedIcon.snp_bottom).offset(30)
			make.centerX.equalTo(taskContainer.snp_centerX).offset(15)
		}
		
		let pinIcon = UIImageView()
		taskContainer.addSubview(pinIcon)
		pinIcon.image = UIImage(named: "pin")
		pinIcon.contentMode = UIViewContentMode.ScaleAspectFill
		pinIcon.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(35)
			make.width.equalTo(35)
			make.centerY.equalTo(cityLabel.snp_centerY)
			make.right.equalTo(cityLabel.snp_left).offset(-7)
		}
		
		//Map Container
		
		let mapContainer = UIView()
		self.contentView.addSubview(mapContainer)
		mapContainer.layer.borderColor = Color.grayDetails.CGColor
		mapContainer.layer.borderWidth = 1
		mapContainer.backgroundColor = Color.whitePrimary
		mapContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(pinIcon.snp_bottom).offset(42)
			make.left.equalTo(self.contentView.snp_left).offset(-1)
			make.right.equalTo(self.contentView.snp_right).offset(1)
			make.height.equalTo(250)
		}
		
		taskContainer.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(mapContainer.snp_bottom)
		}
		
		let mapView = MKMapView()
		mapView.delegate = self
		mapView.scrollEnabled = false
		mapView.zoomEnabled = false
		mapView.userInteractionEnabled = false
		mapContainer.addSubview(mapView)
		mapView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(mapContainer.snp_edges)
		}
		
		self.locationManager.delegate = self
		self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
		self.locationManager.requestWhenInUseAuthorization()
		self.locationManager.startUpdatingLocation()
		self.locationManager.distanceFilter = 40
		
		let locationNoticeLabel = UILabel()
		taskContainer.addSubview(locationNoticeLabel)
		locationNoticeLabel.text = "Exact location in this 400m area"
		locationNoticeLabel.textColor = Color.darkGrayDetails
		locationNoticeLabel.font = UIFont(name: "Lato-Regular", size: kText13)
		locationNoticeLabel.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(taskContainer.snp_left).offset(8)
			make.bottom.equalTo(mapContainer.snp_top).offset(-2)
		}
		
		let taskLocation = CLLocationCoordinate2DMake(self.application.task.location!.latitude, self.application.task.location!.longitude)
		let span: MKCoordinateSpan = MKCoordinateSpanMake(0.015 , 0.015)
		let locationToZoom: MKCoordinateRegion = MKCoordinateRegionMake(taskLocation, span)
		mapView.setRegion(locationToZoom, animated: true)
		mapView.setCenterCoordinate(taskLocation, animated: true)
		
		let circle = MKCircle(centerCoordinate: taskLocation, radius: 400)
		mapView.addOverlay(circle)
		
		//Task Image Container
		
		let taskImageContainer = UIView()
		self.taskImageContainer = taskImageContainer
		contentView.addSubview(taskImageContainer)
		
		if self.application.task.pictures != nil {
			if self.pictures!.count > 0 {
				
				taskImageContainer.backgroundColor = Color.whitePrimary
				taskImageContainer.layer.borderWidth = 1
				taskImageContainer.layer.borderColor = Color.grayDetails.CGColor
				taskImageContainer.snp_makeConstraints { (make) -> Void in
					make.top.equalTo(taskContainer.snp_bottom).offset(20)
					make.left.equalTo(self.contentView.snp_left).offset(-1)
					make.right.equalTo(self.contentView.snp_right).offset(1)
				}
				
				let carousel = iCarousel()
				self.carousel = carousel
				self.carousel.delegate = self
				self.carousel.clipsToBounds = true
				self.carousel.type = .Linear
				self.carousel.bounces = false
				self.carousel.dataSource = self
				
				let carouselContainer = UIView()
				self.carouselContainer = carouselContainer
				taskImageContainer.addSubview(carouselContainer)
				carouselContainer.backgroundColor = Color.whitePrimary
				carouselContainer.snp_makeConstraints { (make) -> Void in
					make.top.equalTo(taskImageContainer.snp_top).offset(20)
					make.centerX.equalTo(taskImageContainer.snp_centerX)
					make.height.equalTo(300)
					make.width.equalTo(self.contentView.snp_width)
				}
				
				self.carouselContainer.addSubview(carousel)
				self.carousel.snp_makeConstraints(closure: { (make) -> Void in
					make.edges.equalTo(carouselContainer.snp_edges)
				})
				
				taskImageContainer.snp_updateConstraints(closure: { (make) -> Void in
					make.bottom.equalTo(carouselContainer.snp_bottom).offset(20)
				})
				
			}} else {
			
			taskImageContainer.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(taskContainer.snp_bottom)
				make.bottom.equalTo(taskContainer.snp_bottom)
			}
			
		}

		//Cancel
		
		let cancelContainer = UIView()
		contentView.addSubview(cancelContainer)
		cancelContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(taskImageContainer.snp_bottom).offset(30)
			make.width.equalTo(self.contentView.snp_width)
			make.height.equalTo(120)
			make.bottom.equalTo(self.contentView.snp_bottom)
		}
		
		let cancelButton = SecondaryActionButton()
		cancelContainer.addSubview(cancelButton)
		cancelButton.setTitle("Cancel Application", forState: UIControlState.Normal)
		cancelButton.addTarget(self, action: "didTapCancelButton:", forControlEvents: UIControlEvents.TouchUpInside)
		cancelButton.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(cancelContainer.snp_top)
			make.centerX.equalTo(cancelContainer.snp_centerX)
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
	Sets the Applications images(Category, Task poster profile pic)
	
	- parameter applicant: Task Poster
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
	Used to set the Scrollview proper contentsize AND shape the chat button
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
	
	//MARK: iCarousel Delegate
	
	func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
		if self.application.task.pictures != nil {
			if self.pictures?.count == 1 {
				self.carousel.scrollEnabled = false
			}
			return self.pictures!.count
		}
		return 0
	}
	
	
 func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
	
	let picture = UIImageView(frame: self.carousel.frame)
	picture.clipsToBounds = true
	let imageURL = self.application.task.pictures![index].url!
	
	ApiHelper.getPictures(imageURL, block: { (imageReturned:UIImage) -> Void in
		picture.image = imageReturned
	})
	
	picture.contentMode = .ScaleAspectFit
	return picture
	}
	
	//MARK: Actions
	
	func backButtonTapped(sender:UIButton){
		self.navigationController?.popViewControllerAnimated(true)
	}
	
	func didTapCancelButton(sender:UIButton){
		if sender.selected == false {
			sender.selected = true
			sender.setTitle("Sure?", forState: UIControlState.Selected)
			
		} else if sender.selected == true{
			ApiHelper.cancelApplyForTaskWithApplication(self.application)
			self.application.state = .Canceled
			self.delegate.didCancelApplication(self.application)
			self.navigationController?.popViewControllerAnimated(true)
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
		self.navigationController?.pushViewController(nextVC, animated: true)
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
			
			//		var nextVC = ATLConversationViewController(layerClient: LayerManager.sharedInstance.layerClient)
			let nextVC = ApplicantChatViewController(layerClient: LayerManager.sharedInstance.layerClient)
			nextVC.displaysAddressBar = false
			if conversation != nil{
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
		
		if self.chatButton.selected{
			
			let tempVC = UIViewController()
			self.tempVC = tempVC
			self.addChildViewController(tempVC)
			self.view.addSubview(tempVC.view)
			//		tempVC.view.backgroundColor = UIColor.yellowColor()
			tempVC.didMoveToParentViewController(self)
			tempVC.view.backgroundColor = UIColor.clearColor()
			tempVC.view.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(self.statusContainer.snp_top)
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
						make.bottom.equalTo(self.statusContainer.snp_top)
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

