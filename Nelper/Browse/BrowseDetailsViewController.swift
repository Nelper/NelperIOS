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

class BrowseDetailsViewController: UIViewController,iCarouselDataSource,iCarouselDelegate, MKMapViewDelegate {
	
	
	var task: Task!
	var pageViewController: UIPageViewController?
	var pictures: NSArray?
	var containerView: UIView!
	var scrollView: UIScrollView!
	var contentView: UIView!
	var postDateLabel: UILabel!
	var cityLabel: UILabel!
	var carousel: iCarousel!
	var taskImageContainer: UIView!
	var carouselContainer: UIView!
	var picture: UIImageView!
	var taskContainer: UIView!
	var	myOfferStepper: UIStepper!
	var myOffer: Double!
	var applyButton: PrimaryActionButton!
	var offerContainer: UIView!
	
	//MARK: Initialization
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.pictures = self.task.pictures
		self.setImages(self.task.user!)
		self.createView()
		self.adjustUI()
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
		navBar.backButton = previousBtn
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
			make.bottom.equalTo(self.containerView.snp_bottom).offset(1)
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
			make.height.greaterThanOrEqualTo(background.snp_height)
			make.width.equalTo(background.snp_width)
		}
		self.contentView.backgroundColor = Color.whiteBackground
		background.backgroundColor = Color.whiteBackground
		
		//Profile Container
		
		let profileContainer = ProfileCellView(user: self.task.user)
		profileContainer.button.addTarget(self, action: "didTapProfile:", forControlEvents: .TouchUpInside)
		self.picture = profileContainer.picture
		self.contentView.addSubview(profileContainer)
		profileContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.contentView.snp_top).offset(20)
			make.left.equalTo(contentView.snp_left).offset(-1)
			make.right.equalTo(contentView.snp_right).offset(1)
			make.height.equalTo(90)
		}
		
		//Task Container
		
		let taskContainer = UIView()
		self.taskContainer = taskContainer
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
		taskNameLabel.text = self.task.title!
		taskNameLabel.textAlignment = NSTextAlignment.Center
		taskNameLabel.textColor = Color.blackPrimary
		taskNameLabel.numberOfLines = 0
		taskNameLabel.font = UIFont(name: "Lato-Regular", size: kTitle17)
		taskNameLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(taskContainer.snp_top).offset(25)
			make.centerX.equalTo(taskContainer.snp_centerX)
			make.left.equalTo(taskContainer.snp_left).offset(12)
			make.right.equalTo(taskContainer.snp_right).offset(-12)
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
		categoryIcon.image = UIImage(named:self.task.category!)
		let categoryIconSize:CGFloat = 40
		categoryIcon.contentMode = UIViewContentMode.ScaleAspectFill
		categoryIcon.layer.cornerRadius = categoryIconSize / 2
		categoryIcon.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(taskContainer.snp_centerX)
			make.centerY.equalTo(taskNameLabelUnderline.snp_centerY)
			make.height.equalTo(categoryIconSize)
			make.width.equalTo(categoryIconSize)
		}
		
		let descriptionLabel = UILabel()
		taskContainer.addSubview(descriptionLabel)
		descriptionLabel.text = self.task.desc!
		descriptionLabel.textColor = Color.textFieldTextColor
		descriptionLabel.numberOfLines = 0
		descriptionLabel.font = UIFont(name: "Lato-Regular", size: kText15)
		descriptionLabel.textAlignment = NSTextAlignment.Center
		descriptionLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(taskNameLabelUnderline.snp_bottom).offset(40)
			make.left.equalTo(taskContainer.snp_left).offset(12)
			make.right.equalTo(taskContainer.snp_right).offset(-12)
		}
		
		let postDateLabel = UILabel()
		taskContainer.addSubview(postDateLabel)
		self.postDateLabel = postDateLabel
		let dateHelper = DateHelper()
		postDateLabel.text = "Posted \(dateHelper.timeAgoSinceDate(self.task.createdAt!, numericDates: true))"
		postDateLabel.textColor = Color.darkGrayDetails
		postDateLabel.font = UIFont(name: "Lato-Regular", size: kText14)
		postDateLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(descriptionLabel.snp_bottom).offset(40)
			make.centerX.equalTo(taskContainer.snp_centerX).offset(19)
		}
		
		let postedIcon = UIImageView()
		taskContainer.addSubview(postedIcon)
		postedIcon.image = UIImage(named:"calendar")
		postedIcon.contentMode = UIViewContentMode.ScaleAspectFill
		postedIcon.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(30)
			make.width.equalTo(30)
			make.centerY.equalTo(postDateLabel.snp_centerY)
			make.right.equalTo(postDateLabel.snp_left).offset(-14)
		}
		
		let cityLabel = UILabel()
		taskContainer.addSubview(cityLabel)
		self.cityLabel = cityLabel
		cityLabel.text = self.task.city!
		cityLabel.textColor = Color.darkGrayDetails
		cityLabel.font = UIFont(name: "Lato-Regular", size: kText14)
		cityLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(postedIcon.snp_bottom).offset(30)
			make.centerX.equalTo(taskContainer.snp_centerX).offset(13)
		}
		
		let pinIcon = UIImageView()
		taskContainer.addSubview(pinIcon)
		pinIcon.image = UIImage(named: "pin")
		pinIcon.contentMode = UIViewContentMode.ScaleAspectFill
		pinIcon.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(30)
			make.width.equalTo(30)
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
			make.top.equalTo(pinIcon.snp_bottom).offset(45)
			make.left.equalTo(self.contentView.snp_left).offset(-1)
			make.right.equalTo(self.contentView.snp_right).offset(1)
			make.height.equalTo(180)
		}
		
		taskContainer.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(mapContainer.snp_bottom)
		}
		
		let locationNoticeLabel = UILabel()
		taskContainer.addSubview(locationNoticeLabel)
		locationNoticeLabel.text = "Exact location inside this 400m area"
		locationNoticeLabel.textColor = Color.darkGrayDetails
		locationNoticeLabel.font = UIFont(name: "Lato-Regular", size: kText13)
		locationNoticeLabel.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(taskContainer.snp_left).offset(8)
			make.bottom.equalTo(mapContainer.snp_top).offset(-2)
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
					make.width.equalTo(self.contentView.snp_width).offset(-30)
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
		
		self.createOfferContainer()
	}
	
	func createOfferContainer() {
		
		let offerContainer = UIView()
		self.offerContainer = offerContainer
		contentView.addSubview(offerContainer)
		offerContainer.layer.borderColor = Color.grayDetails.CGColor
		offerContainer.layer.borderWidth = 1
		offerContainer.backgroundColor = Color.whitePrimary
		offerContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(taskImageContainer.snp_bottom).offset(20)
			make.left.equalTo(self.contentView.snp_left).offset(-1)
			make.right.equalTo(self.contentView.snp_right).offset(1)
			make.bottom.equalTo(self.contentView.snp_bottom).offset(-20)
		}
		
		let offerLabelContainer = UIView()
		offerContainer.addSubview(offerLabelContainer)
		offerLabelContainer.sizeToFit()
		
		let posterNameOffer = UILabel()
		offerLabelContainer.addSubview(posterNameOffer)
		posterNameOffer.textColor = Color.darkGrayDetails
		posterNameOffer.font = UIFont(name: "Lato-Regular", size: kText15)
		if self.task.user.firstName != nil {
			posterNameOffer.text = "\(self.task.user.firstName!)'s offer"
		} else {
			posterNameOffer.text = "Offer"
		}
		posterNameOffer.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(offerLabelContainer.snp_left)
			make.top.equalTo(offerContainer.snp_top).offset(28)
		}
		
		let moneyContainer = UIView()
		offerLabelContainer.addSubview(moneyContainer)
		moneyContainer.backgroundColor = Color.whiteBackground
		moneyContainer.layer.cornerRadius = 3
		moneyContainer.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(posterNameOffer.snp_centerY)
			make.left.equalTo(posterNameOffer.snp_right).offset(12)
			make.width.equalTo(55)
			make.height.equalTo(35)
		}
		
		let moneyLabel = UILabel()
		moneyContainer.addSubview(moneyLabel)
		moneyLabel.textAlignment = NSTextAlignment.Center
		moneyLabel.textColor = Color.blackPrimary
		let price = String(format: "%.0f", self.task.priceOffered!)
		moneyLabel.text = price+"$"
		moneyLabel.font = UIFont(name: "Lato-Light", size: kText15)
		moneyLabel.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(moneyContainer.snp_edges)
		}
		
		offerLabelContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(offerContainer.snp_top)
			make.left.equalTo(posterNameOffer.snp_left)
			make.right.equalTo(moneyContainer.snp_right)
			make.centerX.equalTo(offerContainer.snp_centerX)
		}
		
		let taskPosterOfferUnderline = UIView()
		offerContainer.addSubview(taskPosterOfferUnderline)
		taskPosterOfferUnderline.backgroundColor = Color.grayDetails
		taskPosterOfferUnderline.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(posterNameOffer.snp_bottom).offset(30)
			make.centerX.equalTo(offerContainer.snp_centerX)
			make.width.equalTo(offerContainer.snp_width).dividedBy(1.4)
			make.height.equalTo(0.5)
		}
		
		//Apply Button
		
		let applyButton = PrimaryActionButton()
		self.applyButton = applyButton
		offerContainer.addSubview(applyButton)
		applyButton.setTitle("Confirm Application", forState: UIControlState.Selected)
		applyButton.setBackgroundColor(Color.redPrimarySelected, forState: .Selected)
		applyButton.setTitle("Apply for \(Int(self.task.priceOffered!))$ !", forState: UIControlState.Normal)
		applyButton.addTarget(self, action: "applyButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		applyButton.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(taskPosterOfferUnderline.snp_bottom).offset(30)
			make.centerX.equalTo(offerContainer.snp_centerX)
		}
		
		let myOfferLabel = UILabel()
		offerContainer.addSubview(myOfferLabel)
		myOfferLabel.text = "My offer"
		myOfferLabel.textColor = Color.darkGrayDetails
		myOfferLabel.font = UIFont(name: "Lato-Regular", size: kText15)
		myOfferLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(applyButton.snp_bottom).offset(25)
			make.right.equalTo(applyButton.snp_centerX).offset(-26)
		}
		
		let myOfferStepper = UIStepper()
		self.myOfferStepper = myOfferStepper
		self.myOfferStepper.minimumValue = 10
		self.myOfferStepper.maximumValue = 200
		self.myOfferStepper.value = self.task.priceOffered!
		self.myOfferStepper.stepValue = 1
		myOfferStepper.continuous = true
		myOfferStepper.addTarget(self, action: "didTapMyOfferStepper:", forControlEvents: UIControlEvents.ValueChanged)
		offerContainer.addSubview(myOfferStepper)
		myOfferStepper.tintColor = Color.redPrimary
		myOfferStepper.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(myOfferLabel.snp_centerY)
			make.left.equalTo(myOfferLabel.snp_right).offset(15)
			make.bottom.equalTo(offerContainer.snp_bottom).offset(-20)
		}
	}
	
	func adjustUI() {
		
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
	
	//MARK: Actions
	
	//	/**
	//	Apply for a task
	//
	//	- parameter sender: UIButton
	//	*/
	
	func applyButtonTapped(sender: UIButton) {
		
		let popup = UIAlertController(title: "Apply for \(Int(self.myOfferStepper.value))$ ?", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
		
		popup.addAction(UIAlertAction(title: "Confirm", style: .Default, handler: { (action) -> Void in
			//Saves info and changes the view
			ApiHelper.applyForTask(self.task, price: Int(self.myOfferStepper.value))
			self.navigationController?.popViewControllerAnimated(true)
		}))
		popup.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
		}))
		self.presentViewController(popup, animated: true, completion: nil)
		popup.view.tintColor = Color.redPrimary
	}
	
	func backButtonTapped(sender: UIButton) {
		self.navigationController?.popViewControllerAnimated(true)
		view.endEditing(true)
	}
	
	/**
	My Offer Value Stepper Control
	
	- parameter sender: My Offer Stepper
	*/
	
	func didTapMyOfferStepper(sender: UIStepper) {
		self.myOffer = myOfferStepper.value
		self.applyButton.setTitle("Apply for $\(Int(sender.value))!", forState: UIControlState.Normal)
	}
	
	/**
	When the task poster view is tapped
	
	- parameter sender: Poster Profile View
	*/
	
	func didTapProfile(sender: UIButton) {
		let nextVC = PosterProfileViewController()
		nextVC.removeChatButton()
		nextVC.poster = self.task.user
		nextVC.hidesBottomBarWhenPushed = true
		self.navigationController?.pushViewController(nextVC, animated: true)
	}
	
	func viewApplicationTapped(sender: UIButton) {
		let application = self.task.application
		let nextVC = MyApplicationDetailsAcceptedViewController()
		nextVC.poster = application!.task.user
		nextVC.application = application
		nextVC.hidesBottomBarWhenPushed = true
		dispatch_async(dispatch_get_main_queue()) {
			self.navigationController?.pushViewController(nextVC, animated: true)
		}
	}
	
	//MARK: Utilities

}
