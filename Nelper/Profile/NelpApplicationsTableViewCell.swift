//
//  NelpApplicationsTableViewCell.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-08-16.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class NelpApplicationsTableViewCell: UITableViewCell {
	
	var titleLabel: UILabel!
	var price:UILabel!
	var category:UILabel!
	var categoryIcon:UIImageView!
	//	var categoryLabel:UILabel!
	var topContainer:UIImageView!
	var appliedDate: UILabel!
	var applicationStateIcon: UIImageView!
	var applicationStateLabel: UILabel!
	var distanceLabel: UILabel!
	var cityLabel: UILabel!
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		self.clipsToBounds = true
		
		let backView = UIView(frame: self.bounds)
		backView.clipsToBounds = true
		backView.backgroundColor = navBarColor
		backView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight;
		
		//CellContainer (hackForSpacing)
		let cellView = UIView();
		cellView.backgroundColor = whiteNelpyColor
		backView.addSubview(cellView)
		cellView.backgroundColor = whiteNelpyColor
		cellView.layer.cornerRadius = 6
		cellView.layer.borderWidth = 1
		cellView.layer.borderColor = blackNelpyColor.CGColor
		cellView.layer.masksToBounds = true
		cellView.clipsToBounds = true
		cellView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(backView).offset(4)
			make.left.equalTo(backView).offset(4)
			make.right.equalTo(backView).offset(-4)
			make.bottom.equalTo(backView).offset(-4)
		}
		
		
		//Top container
		var topContainer = UIImageView()
		self.topContainer = topContainer
		self.topContainer.clipsToBounds = true
		self.topContainer.layer.masksToBounds = true
		cellView.addSubview(topContainer)
		topContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(cellView.snp_top)
			make.right.equalTo(cellView.snp_right)
			make.left.equalTo(cellView.snp_left)
			make.height.equalTo(cellView.snp_height).dividedBy(3)
		}
		topContainer.backgroundColor = blueGrayColor
		var blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
		var blurView = UIVisualEffectView(effect: blur)
		topContainer.addSubview(blurView)
		blurView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(topContainer.snp_edges)
		}
		
		//Category Icon
		var categoryIcon = UIImageView()
		self.categoryIcon = categoryIcon
		topContainer.addSubview(categoryIcon)
		categoryIcon.snp_makeConstraints { (make) -> Void in
			make.center.equalTo(topContainer.snp_center)
			make.height.equalTo(60)
			make.width.equalTo(60)
		}
		
		//		var categoryLabel = UILabel()
		//		self.categoryLabel = categoryLabel
		//		categoryLabel.textColor = blackNelpyColor
		//		categoryLabel.font = UIFont(name: "ABeeZee-Regular", size: kTextFontSize)
		//		topContainer.addSubview(categoryLabel)
		//		categoryLabel.snp_makeConstraints { (make) -> Void in
		//			make.left.equalTo(categoryIcon.snp_right).offset(4)
		//			make.centerY.equalTo(categoryIcon.snp_centerY)
		//		}
		
		//Title Label
		var titleLabel = UILabel()
		self.titleLabel = titleLabel
		titleLabel.textColor = blackNelpyColor
		titleLabel.font = UIFont(name: "ABeeZee-Regular", size: kCellTitleFontSize)
		cellView.addSubview(titleLabel)
		titleLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(topContainer.snp_bottom).offset(4)
			make.left.equalTo(cellView.snp_left).offset(12)
			make.height.equalTo(40)
		}
		
		//Application State Icon + Label
		
		var applicationStateIcon = UIImageView()
		self.applicationStateIcon = applicationStateIcon
		cellView.addSubview(applicationStateIcon)
		applicationStateIcon.contentMode = UIViewContentMode.ScaleAspectFill
		applicationStateIcon.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(titleLabel.snp_bottom)
			make.left.equalTo(cellView.snp_left).offset(12)
			make.height.equalTo(40)
			make.width.equalTo(40)
		}
		
		var applicationLabel = UILabel()
		self.applicationStateLabel = applicationLabel
		cellView.addSubview(applicationLabel)
		applicationLabel.font = UIFont(name: "ABeeZee-Regular", size: kCellSubtitleFontSize)
		applicationLabel.textColor = blackNelpyColor
		
		applicationLabel.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(applicationStateIcon.snp_right).offset(4)
			make.centerY.equalTo(applicationStateIcon.snp_centerY)
		}
	
		
		//Price tag
		var price = UILabel()
		self.price = price
		cellView.addSubview(price)
		price.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(applicationLabel.snp_centerY)
			make.right.equalTo(cellView.snp_right).offset(-12)
			make.width.equalTo(70)
			make.height.equalTo(30)
		}
		self.price.backgroundColor = greenPriceButton
		self.price.font = UIFont(name: "ABeeZee-Regular", size: kCellPriceFontSize)
		self.price.textColor = whiteNelpyColor
		self.price.layer.cornerRadius = 6
		self.price.clipsToBounds = true
		self.price.textAlignment = NSTextAlignment.Center
		
		//Applied date
		
		var calendarImage = UIImageView()
		cellView.addSubview(calendarImage)
		calendarImage.image = UIImage(named: "calendar.png")
		calendarImage.contentMode = UIViewContentMode.ScaleAspectFit
		calendarImage.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(applicationStateIcon.snp_bottom).offset(10)
			make.left.equalTo(applicationStateIcon.snp_left)
			make.width.equalTo(40)
			make.height.equalTo(40)
		}
		
		var postedDate = UILabel()
		self.appliedDate = postedDate
		cellView.addSubview(postedDate)
		postedDate.font = UIFont(name: "ABeeZee-Regular", size: kCellTextFontSize)
		postedDate.textColor = blackNelpyColor
		
		postedDate.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(calendarImage.snp_right).offset(4)
			make.centerY.equalTo(calendarImage.snp_centerY)
		}
		
		//Location Icon + City + Distance
		
		var pinImageView = UIImageView()
		cellView.addSubview(pinImageView)
		pinImageView.image = UIImage(named: "pin.png")
		pinImageView.contentMode = UIViewContentMode.ScaleAspectFill
		pinImageView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(calendarImage.snp_bottom).offset(10)
			make.left.equalTo(calendarImage.snp_left)
			make.height.equalTo(40)
			make.width.equalTo(40)
		}
		
		var cityLabel = UILabel()
		self.cityLabel = cityLabel
		cellView.addSubview(cityLabel)
		cityLabel.textColor = blackNelpyColor
		cityLabel.font = UIFont(name: "ABeeZee-Regular", size: kCellTextFontSize)
		cityLabel.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(pinImageView.snp_right).offset(4)
			make.centerY.equalTo(pinImageView.snp_centerY).offset(-10)
		}
		
		var distanceLabel = UILabel()
		self.distanceLabel = distanceLabel
		cellView.addSubview(distanceLabel)
		distanceLabel.textColor = blackNelpyColor
		distanceLabel.font = UIFont(name: "ABeeZee-Regular", size: kCellTextFontSize)
		distanceLabel.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(pinImageView.snp_right).offset(4)
			make.centerY.equalTo(pinImageView.snp_centerY).offset(10)
		}
		
		self.addSubview(backView)
		
	}
	
	
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func setSelected(selected: Bool, animated: Bool) {
	}
	
	override func setHighlighted(highlighted: Bool, animated: Bool) {
	}
	
	static var reuseIdentifier: String {
		get {
			return "NelpApplicationsTableViewCell"
		}
	}
	
	func setImages(nelpApplication:NelpTaskApplication){
		self.categoryIcon.layer.cornerRadius = self.categoryIcon.frame.size.width / 2;
		self.categoryIcon.clipsToBounds = true
		self.categoryIcon.image = UIImage(named: nelpApplication.task.category!)
		
		setStateInformation(nelpApplication)
		
		if(nelpApplication.task.pictures != nil){
			if(!nelpApplication.task.pictures!.isEmpty){
				getPictures(nelpApplication.task.pictures![0].url! , block: { (imageReturned:UIImage) -> Void in
					self.topContainer.image = imageReturned
				})}}
		self.topContainer.contentMode = .ScaleAspectFill
		self.topContainer.clipsToBounds = true
	}
	
	func setStateInformation(nelpApplication:NelpTaskApplication){
		
		if nelpApplication.state.rawValue == 0 {
			self.applicationStateIcon.image = UIImage(named: "pending.png")!
			self.applicationStateLabel.text = "Pending"
		}else if nelpApplication.state.rawValue == 2{
			self.applicationStateIcon.image = UIImage(named:"accepted.png")
			self.applicationStateLabel.text = "Accepted"
		} else if nelpApplication.state.rawValue == 3{
			self.applicationStateIcon.image = UIImage(named: "declined.png")!
			self.applicationStateLabel.text = "Declined"
		}
		
	}
	
	func getPictures(imageURL: String, block: (UIImage) -> Void) -> Void {
		var image: UIImage!
		request(.GET,imageURL).response(){
			(_, _, data, error) in
			if(error != nil){
				println(error)
			}
			image = UIImage(data: data as NSData!)
			block(image)
		}
	}
	

	func setNelpApplication(nelpApplication: NelpTaskApplication) {
		//		self.categoryLabel.text = nelpTask.category!.uppercaseString
		self.titleLabel.text = nelpApplication.task.title
		var price = String(format: "%.0f", nelpApplication.task.priceOffered!)
		self.price.text = "$"+price
		self.appliedDate.text = "Applied \(timeAgoSinceDate(nelpApplication.createdAt!, numericDates: true))"
		if((nelpApplication.task.city) != nil){
		self.cityLabel.text = nelpApplication.task.city
		}
	
		
		
	}
	
	//UTILITIES
	
	func setLocation(userLocation:CLLocation, nelpApplication:NelpTaskApplication){

		var taskLocation = CLLocation(latitude: nelpApplication.task.location!.latitude, longitude: nelpApplication.task.location!.longitude)
		var distance: String = self.calculateDistanceBetweenTwoLocations(userLocation, destination: taskLocation)
		self.distanceLabel.text = distance
	}
	
	func calculateDistanceBetweenTwoLocations(source:CLLocation,destination:CLLocation) -> String{
		
		var distanceMeters = source.distanceFromLocation(destination)
		if(distanceMeters > 1000){
			var distanceKM = distanceMeters / 1000
			return "\(round(distanceKM)) km away from you"
		}else{
			return String(format:"%.0f m away from you", distanceMeters)
		}
	}
	
	func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
		let calendar = NSCalendar.currentCalendar()
		let unitFlags = NSCalendarUnit.CalendarUnitMinute | NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitWeekOfYear | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitSecond
		let now = NSDate()
		let earliest = now.earlierDate(date)
		let latest = (earliest == now) ? date : now
		let components:NSDateComponents = calendar.components(unitFlags, fromDate: earliest, toDate: latest, options: nil)
		if (components.year >= 2) {
			return "\(components.year) years ago"
		} else if (components.year >= 1){
			if (numericDates){
				return "1 year ago"
			} else {
				return "Last year"
			}
		} else if (components.month >= 2) {
			return "\(components.month) months ago"
		} else if (components.month >= 1){
			if (numericDates){
				return "1 month ago"
			} else {
				return "Last month"
			}
		} else if (components.weekOfYear >= 2) {
			return "\(components.weekOfYear) weeks ago"
		} else if (components.weekOfYear >= 1){
			if (numericDates){
				return "1 week ago"
			} else {
				return "Last week"
			}
		} else if (components.day >= 2) {
			return "\(components.day) days ago"
		} else if(components.day >= 1){
			if (numericDates){
				return "1 day ago"
			} else {
				return "Yesterday"
			}
		} else if (components.hour >= 2) {
			return "\(components.hour) hours ago"
		} else if (components.hour >= 1){
			if (numericDates){
				return "1 hour ago"
			} else {
				return "An hour ago"
			}
		} else if (components.minute >= 2) {
			return "\(components.minute) minutes ago"
		} else if (components.minute >= 1){
			if (numericDates){
				return "1 minute ago"
			} else {
				return "A minute ago"
			}
		} else if (components.second >= 3) {
			return "\(components.second) seconds ago"
		} else {
			return "Just now"
		}
	}
}