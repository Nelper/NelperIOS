//
//  TableViewCell.swift
//  Nelper
//
//  Created by Janic Duplessis on 2015-07-04.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import UIKit
import Alamofire

class NelpTasksTableViewCell: UITableViewCell {
  
	var titleLabel: UILabel!
	var price:UILabel!
	var numberOfApplicants:UILabel!
	var category:UILabel!
	var categoryIcon:UIImageView!
//	var categoryLabel:UILabel!
	var topContainer:UIImageView!
	var notificationIcon: UIImageView!
	var postedDate: UILabel!
	
	var nelpTask:FindNelpTask!
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		self.clipsToBounds = true
		
		let backView = UIView(frame: self.bounds)
		backView.clipsToBounds = true
		backView.backgroundColor = whiteNelpyColor
		backView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
		
		//CellContainer (hackForSpacing)
		let cellView = UIView()
		cellView.backgroundColor = whiteNelpyColor
		backView.addSubview(cellView)
		cellView.backgroundColor = whiteNelpyColor
		cellView.layer.cornerRadius = 6
		cellView.layer.borderWidth = 2
		cellView.layer.borderColor = grayDetails.CGColor
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
		topContainer.backgroundColor = blueGrayColor		//Category Icon + label
		
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
		
		//Notification Icon
		
		var notificationIcon = UIImageView()
		self.notificationIcon = notificationIcon
		topContainer.addSubview(notificationIcon)
		self.notificationIcon.image = UIImage(named: "exclamation.png")
		self.notificationIcon.hidden = true
		notificationIcon.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(topContainer.snp_top).offset(4)
			make.left.equalTo(topContainer.snp_left).offset(4)
			make.height.equalTo(40)
			make.width.equalTo(40)
		}
		
		
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
		
		
		//Number of applicants
		
		var numberOfApplicantsIcon = UIImageView()
		numberOfApplicantsIcon.image = UIImage(named: "applicants.png")
		cellView.addSubview(numberOfApplicantsIcon)
		numberOfApplicantsIcon.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(titleLabel.snp_bottom)
			make.left.equalTo(cellView.snp_left).offset(12)
			make.height.equalTo(40)
			make.width.equalTo(40)
		}
		
		var numberOfApplicants = UILabel()
		self.numberOfApplicants = numberOfApplicants
		self.numberOfApplicants.font = UIFont(name: "ABeeZee-Regular", size: kCellTextFontSize)
		self.numberOfApplicants.textColor = blackNelpyColor
		cellView.addSubview(numberOfApplicants)
		numberOfApplicants.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(numberOfApplicantsIcon.snp_right).offset(4)
			make.centerY.equalTo(numberOfApplicantsIcon.snp_centerY)
		}
		
		//Price tag
		var price = UILabel()
		self.price = price
		cellView.addSubview(price)
		price.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(numberOfApplicants.snp_centerY)
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
		
		//Posted date
		
		var calendarImage = UIImageView()
		cellView.addSubview(calendarImage)
		calendarImage.image = UIImage(named: "calendar.png")
		calendarImage.contentMode = UIViewContentMode.ScaleAspectFit
		calendarImage.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(cellView.snp_bottom).offset(-10)
			make.left.equalTo(numberOfApplicantsIcon.snp_left)
			make.width.equalTo(40)
			make.height.equalTo(40)
		}
		
		var postedDate = UILabel()
		self.postedDate = postedDate
		cellView.addSubview(postedDate)
		postedDate.font = UIFont(name: "ABeeZee-Regular", size: kCellTextFontSize)
		
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
			return "NelpTasksTableViewCell"
		}
	}
	
	func setImages(nelpTask:FindNelpTask){
		self.categoryIcon.layer.cornerRadius = self.categoryIcon.frame.size.width / 2;
		self.categoryIcon.clipsToBounds = true
		self.categoryIcon.image = UIImage(named: nelpTask.category!)
		self.notificationIcon.layer.cornerRadius = self.notificationIcon.frame.size.width / 2;
		self.notificationIcon.clipsToBounds = true
		self.setNotification(nelpTask)

		if(nelpTask.pictures != nil){
		if(!nelpTask.pictures!.isEmpty){
		getPictures(nelpTask.pictures![0].url! , block: { (imageReturned:UIImage) -> Void in
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
	
	func setNotification(nelpTask:FindNelpTask){
		
		if (nelpTask.applications.count == 0){
			self.numberOfApplicants.text = "0 applicants"
		}else{
			self.numberOfApplicants.text = "\(nelpTask.applications.count) applicants."
		}
		
		for application in nelpTask.applications{
			if(application.isNew){
				self.notificationIcon.hidden = false
			}else {
				self.notificationIcon.hidden = true
			}
			
		ApiHelper.setTaskViewed(nelpTask)
		}
	}
	
	func setNelpTask(nelpTask: FindNelpTask) {
//		self.categoryLabel.text = nelpTask.category!.uppercaseString
		self.titleLabel.text = nelpTask.title
		var price = String(format: "%.0f", nelpTask.priceOffered!)
		self.price.text = "$"+price
		self.postedDate.text = "Posted \(timeAgoSinceDate(nelpTask.createdAt!, numericDates: true))"


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


