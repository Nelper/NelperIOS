//
//  NelpTaskDetailsViewController.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-08-06.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import iCarousel

class BrowseDetailsViewController: UIViewController,iCarouselDataSource,iCarouselDelegate, CLLocationManagerDelegate, MKMapViewDelegate {
	
	
	var task: NelpTask!
	var pageViewController: UIPageViewController?
	var pictures: NSArray?
	var containerView: UIView!
	var scrollView: UIScrollView!
	var contentView: UIView!
	var postDateLabel: UILabel!
	var cityLabel: UILabel!
	var carousel: iCarousel!
	var locationManager = CLLocationManager()
	var taskImageContainer: UIView!
	var carouselContainer: UIView!
	var picture: UIImageView!
	var taskContainer: UIView!
	var	myOfferStepper: UIStepper!
	var myOfferValueLabel: UILabel!
	var myOffer: Double!
	var applyButton: PrimaryActionButton!
	
	//MARK: Initialization
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.pictures = self.task.pictures
		self.setImages(self.task.user!)
		self.createView()
		
		//		self.startButtonConfig()
	}
	
	//MARK: View Creation
	
	func createView(){
		
		let containerView = UIView()
		self.containerView = containerView
		self.view.addSubview(containerView)
		containerView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self.view)
		}
		
		let navBar = NavBar()
		let previousBtn = UIButton()
		previousBtn.addTarget(self, action: "backButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		self.containerView.addSubview(navBar)
		navBar.closeButton = previousBtn
		navBar.setTitle("Task Details")
		navBar.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.containerView.snp_top)
			make.left.equalTo(self.containerView.snp_left)
			make.right.equalTo(self.containerView.snp_right)
			make.height.equalTo(64)
		}
		
		//Background View + ScrollView
		
		let background = UIView()
		self.containerView.addSubview(background)
		background.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(navBar.snp_bottom)
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
		
		scrollView.backgroundColor = whiteBackground
		
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
		self.contentView.backgroundColor = whiteBackground
		background.backgroundColor = whiteBackground
		
		//Profile Container
		
		let profileContainer = UIView()
		let profileTapAction = UITapGestureRecognizer(target: self, action: "didTapProfile:")
		profileContainer.addGestureRecognizer(profileTapAction)
		contentView.addSubview(profileContainer)
		profileContainer.layer.borderColor = grayDetails.CGColor
		profileContainer.layer.borderWidth = 1
		profileContainer.backgroundColor = whitePrimary
		profileContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.contentView.snp_top).offset(20)
			make.left.equalTo(contentView.snp_left).offset(-1)
			make.right.equalTo(contentView.snp_right).offset(1)
			make.height.equalTo(100)
		}
		
		let profilePicture = UIImageView()
		self.picture = profilePicture
		profileContainer.addSubview(profilePicture)
		let pictureSize:CGFloat = 80
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
		nameLabel.text = self.task.user.name
		nameLabel.textColor = blackPrimary
		nameLabel.font = UIFont(name: "Lato-Regular", size: kTitle17)
		nameLabel.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(profilePicture.snp_centerY)
			make.left.equalTo(profilePicture.snp_right).offset(15)
		}
		
		let arrow = UIImageView()
		profileContainer.addSubview(arrow)
		arrow.image = UIImage(named: "arrow_applicant_cell")
		arrow.alpha = 0.3
		arrow.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(profileContainer.snp_right).offset(-20)
			make.centerY.equalTo(profileContainer.snp_centerY)
			make.height.equalTo(35)
			make.width.equalTo(20)
		}
		
		//Task Container
		
		let taskContainer = UIView()
		self.taskContainer = taskContainer
		self.contentView.addSubview(taskContainer)
		taskContainer.layer.borderWidth = 1
		taskContainer.layer.borderColor = grayDetails.CGColor
		taskContainer.backgroundColor = whitePrimary
		taskContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(profileContainer.snp_bottom).offset(20)
			make.left.equalTo(self.contentView.snp_left).offset(-1)
			make.right.equalTo(self.contentView.snp_right).offset(1)
		}
		
		let categoryIcon = UIImageView()
		taskContainer.addSubview(categoryIcon)
		categoryIcon.image = UIImage(named:self.task.category!)
		let categoryIconSize:CGFloat = 60
		categoryIcon.contentMode = UIViewContentMode.ScaleAspectFill
		categoryIcon.layer.cornerRadius = categoryIconSize / 2
		categoryIcon.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(taskContainer.snp_centerX)
			make.top.equalTo(taskContainer.snp_top).offset(14)
			make.height.equalTo(categoryIconSize)
			make.width.equalTo(categoryIconSize)
		}
		
		let taskNameLabel = UILabel()
		taskContainer.addSubview(taskNameLabel)
		taskNameLabel.text = self.task.title!
		taskNameLabel.textAlignment = NSTextAlignment.Center
		taskNameLabel.textColor = blackPrimary
		taskNameLabel.font = UIFont(name: "Lato-Regular", size: kTitle17)
		taskNameLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(categoryIcon.snp_bottom).offset(14)
			make.centerX.equalTo(taskContainer.snp_centerX)
			make.left.equalTo(taskContainer.snp_left)
			make.right.equalTo(taskContainer.snp_right)
		}
		
		let taskNameLabelUnderline = UIView()
		taskContainer.addSubview(taskNameLabelUnderline)
		taskNameLabelUnderline.backgroundColor = grayDetails
		taskNameLabelUnderline.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(taskNameLabel.snp_bottom).offset(15)
			make.centerX.equalTo(taskContainer.snp_centerX)
			make.width.equalTo(taskContainer.snp_width).dividedBy(1.4)
			make.height.equalTo(0.5)
		}
		
		let descriptionTextView = UITextView()
		taskContainer.addSubview(descriptionTextView)
		descriptionTextView.backgroundColor = whitePrimary
		descriptionTextView.text = self.task.desc!
		descriptionTextView.textColor = blackPrimary
		descriptionTextView.scrollEnabled = false
		descriptionTextView.editable = false
		descriptionTextView.font = UIFont(name: "Lato-Regular", size: kText15)
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
		descriptionUnderline.backgroundColor = grayDetails
		descriptionUnderline.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(descriptionTextView.snp_bottom).offset(10)
			make.centerX.equalTo(taskContainer.snp_centerX)
			make.width.equalTo(taskContainer.snp_width).dividedBy(1.4)
			make.height.equalTo(0.5)
		}
		
		let postDateLabel = UILabel()
		taskContainer.addSubview(postDateLabel)
		self.postDateLabel = postDateLabel
		let dateHelper = DateHelper()
		postDateLabel.text = "Posted \(dateHelper.timeAgoSinceDate(self.task.createdAt!, numericDates: true))"
		postDateLabel.textColor = blackPrimary
		postDateLabel.font = UIFont(name: "Lato-Regular", size: kText14)
		postDateLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(descriptionUnderline.snp_bottom).offset(40)
			make.centerX.equalTo(taskContainer.snp_centerX).offset(23)
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
		cityLabel.text = self.task.city!
		cityLabel.textColor = blackPrimary
		cityLabel.font = UIFont(name: "Lato-Regular", size: kText14)
		cityLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(postDateLabel.snp_bottom).offset(40)
			make.centerX.equalTo(taskContainer.snp_centerX).offset(17)
		}
		
		let pinIcon = UIImageView()
		taskContainer.addSubview(pinIcon)
		pinIcon.image = UIImage(named: "pin")
		pinIcon.contentMode = UIViewContentMode.ScaleAspectFill
		pinIcon.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(35)
			make.width.equalTo(35)
			make.centerY.equalTo(cityLabel.snp_centerY)
			make.right.equalTo(cityLabel.snp_left).offset(-8)
		}
		
		//Map Container
		
		let mapContainer = UIView()
		self.contentView.addSubview(mapContainer)
		mapContainer.layer.borderColor = grayDetails.CGColor
		mapContainer.layer.borderWidth = 1
		mapContainer.backgroundColor = whitePrimary
		mapContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(pinIcon.snp_bottom).offset(42)
			make.left.equalTo(self.contentView.snp_left).offset(-1)
			make.right.equalTo(self.contentView.snp_right).offset(1)
			make.height.equalTo(250)
		}
		taskContainer.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(mapContainer.snp_bottom)
		}
		
		self.locationManager.delegate = self;
		self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
		self.locationManager.requestWhenInUseAuthorization()
		self.locationManager.startUpdatingLocation()
		self.locationManager.distanceFilter = 40
		
		let locationNoticeLabel = UILabel()
		taskContainer.addSubview(locationNoticeLabel)
		locationNoticeLabel.text = "Task location within 400m"
		locationNoticeLabel.textColor = darkGrayDetails
		locationNoticeLabel.font = UIFont(name: "Lato-Regular", size: kText13)
		locationNoticeLabel.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(self.view.snp_left).offset(8)
			make.bottom.equalTo(taskContainer.snp_bottom).offset(-2)
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
		
		let taskLocation = CLLocationCoordinate2DMake(self.task.location!.latitude, self.task.location!.longitude)
		let span :MKCoordinateSpan = MKCoordinateSpanMake(0.015 , 0.015)
		let locationToZoom: MKCoordinateRegion = MKCoordinateRegionMake(taskLocation, span)
		mapView.setRegion(locationToZoom, animated: true)
		mapView.setCenterCoordinate(taskLocation, animated: true)
		
		let circle = MKCircle(centerCoordinate: taskLocation, radius: 400)
		mapView.addOverlay(circle)
		
		//Task Image Container
		
		let taskImageContainer = UIView()
		self.taskImageContainer = taskImageContainer
		contentView.addSubview(taskImageContainer)
		
		if self.task.pictures != nil {
			if self.pictures!.count > 0 {
				
				taskImageContainer.backgroundColor = whitePrimary
				taskImageContainer.layer.borderWidth = 1
				taskImageContainer.layer.borderColor = grayDetails.CGColor
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
				carouselContainer.backgroundColor = whitePrimary
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
		
		//Offer Container
		
		let offerContainer = UIView()
		contentView.addSubview(offerContainer)
		offerContainer.backgroundColor = whiteBackground
		offerContainer.layer.borderColor = grayDetails.CGColor
		offerContainer.layer.borderWidth = 1
		offerContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(taskImageContainer.snp_bottom).offset(20)
			make.left.equalTo(self.contentView.snp_left).offset(-1)
			make.right.equalTo(self.contentView.snp_right).offset(1)
			make.bottom.equalTo(self.contentView.snp_bottom).offset(-20)
		}
		
		let offerLabelContainer = UIView()
		offerContainer.addSubview(offerLabelContainer)
		offerContainer.backgroundColor = whitePrimary
		offerLabelContainer.sizeToFit()
		
		let posterNameOffer = UILabel()
		offerLabelContainer.addSubview(posterNameOffer)
		posterNameOffer.textColor = darkGrayDetails
		posterNameOffer.font = UIFont(name: "Lato-Regular", size: kText15)
		posterNameOffer.text = "\(self.task.user.name) is offering"
		posterNameOffer.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(offerLabelContainer.snp_left)
			make.top.equalTo(offerContainer.snp_top).offset(28)
		}
		
		let moneyTagPoster = UIImageView()
		offerLabelContainer.addSubview(moneyTagPoster)
		moneyTagPoster.image = UIImage(named: "moneytag")
		moneyTagPoster.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(posterNameOffer.snp_centerY)
			make.left.equalTo(posterNameOffer.snp_right).offset(12)
			make.width.equalTo(60)
			make.height.equalTo(25)
		}
		
		offerLabelContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(offerContainer.snp_top)
			make.left.equalTo(posterNameOffer.snp_left)
			make.right.equalTo(moneyTagPoster.snp_right)
			make.centerX.equalTo(offerContainer.snp_centerX)
		}
		
		let moneyLabelPoster = UILabel()
		moneyTagPoster.addSubview(moneyLabelPoster)
		moneyLabelPoster.textAlignment = NSTextAlignment.Center
		moneyLabelPoster.text = "$\(Int(self.task.priceOffered!))"
		moneyLabelPoster.textColor = whitePrimary
		moneyLabelPoster.font = UIFont(name: "Lato-Regular", size: kText15)
		moneyLabelPoster.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(moneyTagPoster.snp_edges)
		}
		
		let taskPosterOfferUnderline = UIView()
		offerContainer.addSubview(taskPosterOfferUnderline)
		taskPosterOfferUnderline.backgroundColor = grayDetails
		taskPosterOfferUnderline.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(posterNameOffer.snp_bottom).offset(30)
			make.centerX.equalTo(offerContainer.snp_centerX)
			make.width.equalTo(offerContainer.snp_width).dividedBy(1.4)
			make.height.equalTo(0.5)
		}
		
		let myOfferLabel = UILabel()
		offerContainer.addSubview(myOfferLabel)
		myOfferLabel.textColor = darkGrayDetails
		myOfferLabel.font = UIFont(name: "Lato-Regular", size: kText14)
		myOfferLabel.text = "My Offer"
		myOfferLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(taskPosterOfferUnderline.snp_bottom).offset(30)
			make.right.equalTo(offerContainer.snp_centerX).offset(-60)
		}
		
		let myOfferValueLabel = UILabel()
		self.myOfferValueLabel = myOfferValueLabel
		offerContainer.addSubview(myOfferValueLabel)
		myOfferValueLabel.font = UIFont(name: "Lato-Regular", size: kText15)
		myOfferValueLabel.textColor = blackPrimary
		myOfferValueLabel.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(myOfferLabel.snp_centerY)
			make.left.equalTo(myOfferLabel.snp_right).offset(22)
		}
		
		let myOfferStepper = UIStepper()
		self.myOfferStepper = myOfferStepper
		self.myOfferStepper.minimumValue = 5
		self.myOfferStepper.maximumValue = 999
		self.myOfferStepper.value = self.task.priceOffered!
		self.myOfferStepper.stepValue = 1
		myOfferStepper.continuous = true
		myOfferStepper.addTarget(self, action: "didTapMyOfferStepper:", forControlEvents: UIControlEvents.ValueChanged)
		offerContainer.addSubview(myOfferStepper)
		myOfferStepper.tintColor = redPrimary
		myOfferStepper.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(30)
			make.width.equalTo(60)
			make.centerY.equalTo(myOfferValueLabel.snp_centerY)
			make.left.equalTo(myOfferValueLabel.snp_right).offset(28)
		}
		
		myOfferValueLabel.text = "$\(Int(self.myOfferStepper.value))"
		
		//Apply Button
		
		let applyButton = PrimaryActionButton()
		self.applyButton = applyButton
		offerContainer.addSubview(applyButton)
		applyButton.setTitle("Apply for $\(Int(self.task.priceOffered!))!", forState: UIControlState.Normal)
		applyButton.addTarget(self, action: "applyButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		applyButton.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(myOfferStepper.snp_bottom).offset(20)
			make.centerX.equalTo(offerContainer.snp_centerX)
			make.bottom.equalTo(offerContainer.snp_bottom).offset(-20)
		}
	}
	
	//MARK: DATA
	
	/**
	Sets the Applications images(Category, Task poster profile pic)
	
	- parameter applicant: Task Poster
	*/
	
	func setImages(poster:User){
		if (poster.profilePictureURL != nil) {
			let fbProfilePicture = poster.profilePictureURL
			request(.GET,fbProfilePicture!).response() {
				(_, _, data, _) in
				let image = UIImage(data: data as NSData!)
				self.picture.image = image
			}
		}
	}
	
	//MARK: View Delegate Methods
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		self.scrollView.contentSize = self.contentView.frame.size
	}
	
	//MARK: iCarousel Delegate
	
	func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
		if self.task.pictures != nil {
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
	let imageURL = self.task.pictures![index].url!
	
	ApiHelper.getPictures(imageURL, block: { (imageReturned:UIImage) -> Void in
		picture.image = imageReturned
	})
	
	picture.contentMode = .ScaleAspectFit
	return picture
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
	
	//MARK: Actions
	
	//	/**
	//	Apply for a task
	//
	//	- parameter sender: UIButton
	//	*/
	
	func applyButtonTapped(sender: AnyObject) {
		if(!self.applyButton.selected){
			ApiHelper.applyForTask(self.task, price: Int(self.myOfferStepper.value))
			self.applyButton.selected = true
			self.updateButton()
		}else{
			ApiHelper.cancelApplyForTask(self.task)
			self.applyButton.selected = false
			self.task.application!.state = .Canceled
			self.updateButton()
		}
	}
	
	func backButtonTapped(sender: UIButton) {
		self.dismissViewControllerAnimated(true, completion: nil)
		view.endEditing(true) // dissmiss keyboard without delay
	}
	
	/**
	My Offer Value Stepper Control
	
	- parameter sender: My Offer Stepper
	*/
	
	func didTapMyOfferStepper(sender:UIStepper){
		self.myOfferValueLabel.text = "$\(Int(sender.value))"
		self.myOffer = myOfferStepper.value
		
		self.applyButton.setTitle("Apply for $\(Int(sender.value))!", forState: UIControlState.Normal)
	}
	
	/**
	When the task poster view is tapped
	
	- parameter sender: Poster Profile View
	*/
	
	func didTapProfile(sender:UIView){
		let nextVC = PosterProfileViewController()
		nextVC.removeChatButton()
		nextVC.poster = self.task.user
		nextVC.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
		self.presentViewController(nextVC, animated: true, completion: nil)
	}
	
	//MARK: Utilities
	
	/**
	Little hack to make the Apply Bottom act right :D
	*/
	func startButtonConfig(){
		if self.task.application != nil && self.task.application!.state != .Canceled {
			self.applyButton.selected = true
			self.updateButton()
		} else {
			self.applyButton.selected = false
			self.updateButton()
		}
	}
	
	/**
	Updates the button appearance
	*/
	
	func updateButton(){
		if self.applyButton.selected {
			self.applyButton.setTitle("#make popup to confirm", forState: UIControlState.Selected)
			self.applyButton.backgroundColor = redPrimary
		} else {
			self.applyButton.setTitle("Apply for $\(Int(self.task.priceOffered!))!", forState: UIControlState.Normal)
			self.applyButton.backgroundColor = redPrimary
		}
	}
}

