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
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		self.clipsToBounds = true
		
		let backView = UIView(frame: self.bounds)
		backView.clipsToBounds = true
		backView.backgroundColor = whiteNelpyColor
		backView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight;
		
		//CellContainer (hackForSpacing)
		let cellView = UIView();
		cellView.backgroundColor = whiteNelpyColor
		backView.addSubview(cellView)
		cellView.backgroundColor = whiteNelpyColor
		cellView.layer.cornerRadius = 6
		cellView.layer.borderWidth = 2
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
		
		topContainer.backgroundColor = orangeTextColor
		//Category Icon + label
		
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
		titleLabel.font = UIFont(name: "ABeeZee-Regular", size: kSubtitleFontSize)
		cellView.addSubview(titleLabel)
		titleLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(topContainer.snp_bottom).offset(4)
			make.left.equalTo(cellView.snp_left).offset(12)
			make.height.equalTo(40)
		}
		
		//Price tag
		var price = UILabel()
		self.price = price
		cellView.addSubview(price)
		price.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(titleLabel.snp_bottom)
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
			make.bottom.equalTo(cellView.snp_bottom).offset(-10)
			make.left.equalTo(cellView.snp_left).offset(20)
			make.width.equalTo(40)
			make.height.equalTo(40)
		}
		
		var postedDate = UILabel()
		self.appliedDate = postedDate
		cellView.addSubview(postedDate)
		postedDate.font = UIFont(name: "ABeeZee-Regular", size: kTextFontSize)
		
		postedDate.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(calendarImage.snp_right).offset(4)
			make.centerY.equalTo(calendarImage.snp_centerY)
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
			return "NelpViewCell"
		}
	}
	
	func setImages(nelpApplication:NelpTaskApplication){
		self.categoryIcon.layer.cornerRadius = self.categoryIcon.frame.size.width / 2;
		self.categoryIcon.clipsToBounds = true
		self.categoryIcon.image = UIImage(named: nelpApplication.task.category!)
		
		if(nelpApplication.task.pictures != nil){
			if(!nelpApplication.task.pictures!.isEmpty){
				getPictures(nelpApplication.task.pictures![0].url! , block: { (imageReturned:UIImage) -> Void in
					self.topContainer.image = imageReturned
				})}}
		self.topContainer.contentMode = .ScaleAspectFill
		self.topContainer.clipsToBounds = true
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
		self.price.text = "$\(nelpApplication.task.priceOffered!)"
		self.appliedDate.text = "Applied \(timeAgoSinceDate(nelpApplication.createdAt!, numericDates: true))"
		
		
	}
	
	//UTILITIES
	
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