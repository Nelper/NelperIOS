//
//  TaskInfoView.swift
//  Nelper
//
//  Created by Pierre-Luc Benoit on 2015-11-16.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation
import UIKit
import iCarousel

class TaskInfoView: UIView, MKMapViewDelegate, iCarouselDataSource, iCarouselDelegate {
	
	var application: TaskApplication!
	var accepted: Bool!
	
	var mapView: MKMapView!
	
	var carousel: iCarousel!
	var pictures: NSArray?
	
	init(application: TaskApplication, accepted: Bool) {
		super.init(frame: CGRectZero)
		
		self.application = application
		self.accepted = accepted
		self.pictures = application.task.pictures
		
		self.createView(application, accepted: accepted)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func createView(application: TaskApplication, accepted: Bool) {
		
		let taskContainer = UIView()
		self.addSubview(taskContainer)
		taskContainer.layer.borderWidth = 1
		taskContainer.layer.borderColor = Color.grayDetails.CGColor
		taskContainer.backgroundColor = Color.whitePrimary
		taskContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.snp_top)
			make.left.equalTo(self.snp_left)
			make.right.equalTo(self.snp_right)
		}
		
		let taskNameLabel = UILabel()
		taskContainer.addSubview(taskNameLabel)
		taskNameLabel.text = application.task.title
		taskNameLabel.textAlignment = NSTextAlignment.Center
		taskNameLabel.numberOfLines = 0
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
		categoryIcon.image = UIImage(named: application.task.category!)
		let categoryIconSize:CGFloat = 40
		categoryIcon.contentMode = UIViewContentMode.ScaleAspectFill
		categoryIcon.layer.cornerRadius = categoryIconSize / 2
		categoryIcon.snp_makeConstraints { (make) -> Void in
			make.center.equalTo(taskNameLabelUnderline)
			make.height.equalTo(categoryIconSize)
			make.width.equalTo(categoryIconSize)
		}
		
		let descriptionLabel = UILabel()
		taskContainer.addSubview(descriptionLabel)
		descriptionLabel.text = application.task.desc!
		descriptionLabel.textColor = Color.textFieldTextColor
		descriptionLabel.numberOfLines = 0
		descriptionLabel.font = UIFont(name: "Lato-Regular", size: kText14)
		descriptionLabel.textAlignment = NSTextAlignment.Center
		descriptionLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(taskNameLabelUnderline.snp_bottom).offset(40)
			make.left.equalTo(taskContainer.snp_left).offset(12)
			make.right.equalTo(taskContainer.snp_right).offset(-12)
		}
		
		let taskPosterOffer = UILabel()
		taskContainer.addSubview(taskPosterOffer)
		if application.task.user.firstName != nil {
			taskPosterOffer.text = "\(application.task.user.firstName!)'s offer"
		} else {
			taskPosterOffer.text = "Offer"
		}
		taskPosterOffer.textColor = Color.darkGrayDetails
		taskPosterOffer.font = UIFont(name: "Lato-Regular", size: kText14)
		taskPosterOffer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(descriptionLabel.snp_bottom).offset(40)
			make.centerX.equalTo(taskContainer.snp_centerX).offset(-40)
		}
		
		let moneyTagPoster = UIView()
		taskPosterOffer.addSubview(moneyTagPoster)
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
		moneyLabelPoster.text = "$\(Int(application.task.priceOffered!))"
		moneyLabelPoster.textColor = Color.blackPrimary
		moneyLabelPoster.font = UIFont(name: "Lato-Light", size: kText15)
		moneyLabelPoster.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(moneyTagPoster.snp_edges)
		}
		
		let postDateLabel = UILabel()
		taskContainer.addSubview(postDateLabel)
		let dateHelper = DateHelper()
		postDateLabel.text = "Posted \(dateHelper.timeAgoSinceDate(application.task.createdAt!, numericDates: true))"
		postDateLabel.textColor = Color.darkGrayDetails
		postDateLabel.font = UIFont(name: "Lato-Regular", size: kText14)
		
		//Show/Hide price view
		if !(accepted) {
			taskPosterOffer.hidden = false
			postDateLabel.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(moneyTagPoster.snp_bottom).offset(30)
				make.centerX.equalTo(taskContainer.snp_centerX).offset(19)
			}
		} else {
			taskPosterOffer.hidden = true
			postDateLabel.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(descriptionLabel.snp_bottom).offset(30)
				make.centerX.equalTo(taskContainer.snp_centerX).offset(19)
			}
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
		cityLabel.font = UIFont(name: "Lato-Regular", size: kText14)
		cityLabel.text = application.task.city!
		cityLabel.textColor = Color.darkGrayDetails
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
		self.addSubview(mapContainer)
		mapContainer.layer.borderColor = Color.grayDetails.CGColor
		mapContainer.layer.borderWidth = 1
		mapContainer.backgroundColor = Color.whitePrimary
		mapContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(pinIcon.snp_bottom).offset(45)
			make.left.equalTo(taskContainer.snp_left)
			make.right.equalTo(taskContainer.snp_right)
			make.height.equalTo(180)
		}
		
		taskContainer.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(mapContainer.snp_bottom)
		}
		
		let locationNoticeLabel = UILabel()
		taskContainer.addSubview(locationNoticeLabel)
		locationNoticeLabel.text = "Exact location in this 400m area"
		locationNoticeLabel.textColor = Color.darkGrayDetails
		locationNoticeLabel.font = UIFont(name: "Lato-Regular", size: kText13)
		locationNoticeLabel.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(taskContainer.snp_left).offset(8)
			make.bottom.equalTo(mapContainer.snp_top).offset(-2)
		}
		
		let mapView = MKMapView()
		self.mapView = mapView
		mapView.delegate = self
		mapView.scrollEnabled = false
		mapView.zoomEnabled = false
		mapView.userInteractionEnabled = false
		mapContainer.addSubview(mapView)
		mapView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(mapContainer.snp_edges)
		}
		
		if !(accepted) {
			let taskLocation = CLLocationCoordinate2DMake(application.task.location!.latitude, application.task.location!.longitude)
			let span: MKCoordinateSpan = MKCoordinateSpanMake(0.015 , 0.015)
			let locationToZoom: MKCoordinateRegion = MKCoordinateRegionMake(taskLocation, span)
			mapView.setRegion(locationToZoom, animated: true)
			mapView.setCenterCoordinate(taskLocation, animated: true)
			
			let circle = MKCircle(centerCoordinate: taskLocation, radius: 400)
			mapView.addOverlay(circle)
		}
			
		//Task Image Container
		
		let taskImageContainer = UIView()
		self.addSubview(taskImageContainer)
		
		if application.task.pictures != nil {
			if self.pictures!.count > 0 {
				
				taskImageContainer.backgroundColor = Color.whitePrimary
				taskImageContainer.layer.borderWidth = 1
				taskImageContainer.layer.borderColor = Color.grayDetails.CGColor
				taskImageContainer.snp_makeConstraints { (make) -> Void in
					make.top.equalTo(taskContainer.snp_bottom).offset(20)
					make.left.equalTo(taskContainer.snp_left)
					make.right.equalTo(taskContainer.snp_right)
				}
				
				let carousel = iCarousel()
				self.carousel = carousel
				self.carousel.delegate = self
				self.carousel.clipsToBounds = true
				self.carousel.type = .Linear
				self.carousel.bounces = false
				self.carousel.dataSource = self
				
				let carouselContainer = UIView()
				taskImageContainer.addSubview(carouselContainer)
				carouselContainer.backgroundColor = Color.whitePrimary
				carouselContainer.snp_makeConstraints { (make) -> Void in
					make.top.equalTo(taskImageContainer.snp_top).offset(20)
					make.centerX.equalTo(taskImageContainer.snp_centerX)
					make.height.equalTo(300)
					make.width.equalTo(taskContainer.snp_width).offset(-30)
				}
				
				carouselContainer.addSubview(carousel)
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
		
		self.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(taskImageContainer.snp_bottom)
		}
	}
	
	//MARK: MKMapView Delegate Methods
	
	func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
		if self.accepted == true {
			return MKCircleRenderer()
		}
		
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
	
	func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
		
		let reuseId = "taskPin"
		var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
		
		if pinView == nil {
			
			pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
			
			pinView!.canShowCallout = false
			
			let pinCategory = self.application.task.category
			pinView!.image = UIImage(named: "\(pinCategory!)-pin")
			pinView!.layer.zPosition = -1
			pinView!.centerOffset = CGPointMake(0, -25)
			
		} else {
			pinView!.annotation = annotation
		}
		
		return pinView
		
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
}