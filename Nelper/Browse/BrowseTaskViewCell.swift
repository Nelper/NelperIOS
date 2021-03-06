//
//  BrowseTaskViewCell.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-07-29.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Alamofire

class BrowseTaskViewCell: UITableViewCell {
	
	var cellView: UIView!
	var title: UILabel!
	var author: UILabel!
	var price: UILabel!
	var picture: UIImageView!
	var categoryPicture: UIImageView!
	var creationDate: UILabel!
	var moneyBackground: UIView!
	var task: Task!
	var cellIndexPath: NSIndexPath!
	var moneyContainer: UIView!
	var appliedContainer: UIView!
	var appliedNotice: UILabel!
	
	//MARK: Initialization
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		self.clipsToBounds = true
		
		let cellView = UIView(frame: self.bounds)
		self.cellView = cellView
		cellView.backgroundColor = Color.whitePrimary
		cellView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight];
		
		let pictureSize: CGFloat = 70
		let picture = UIImageView()
		self.picture = picture
		self.picture.layer.cornerRadius = pictureSize / 2
		self.picture.layer.masksToBounds = true
		self.picture.clipsToBounds = true
		self.picture.contentMode = UIViewContentMode.ScaleAspectFill
		cellView.addSubview(picture)
		picture.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(cellView.snp_left).offset(10)
			make.centerY.equalTo(cellView.snp_centerY)
			make.width.equalTo(pictureSize)
			make.height.equalTo(pictureSize)
		}
		
		let categoryPicture = UIImageView()
		self.categoryPicture = categoryPicture
		self.categoryPicture.layer.cornerRadius = self.categoryPicture.frame.size.width / 2
		self.categoryPicture.clipsToBounds = true
		cellView.addSubview(categoryPicture)
		categoryPicture.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(picture.snp_bottom)
			make.left.equalTo(picture.snp_right).offset(-25)
			make.width.equalTo(30)
			make.height.equalTo(30)
		}
		
		let title = UILabel()
		self.title = title
		cellView.addSubview(title)
		title.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(picture.snp_top).offset(2)
			make.left.equalTo(picture.snp_right).offset(18)
			make.right.equalTo(cellView.snp_right).offset(-10)
		}
		
		let author = UILabel()
		self.author = author
		cellView.addSubview(author)
		author.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(title.snp_bottom).offset(8)
			make.left.equalTo(title.snp_left)
		}
		
		let creationDate = UILabel()
		creationDate.adjustsFontSizeToFitWidth = true
		self.creationDate = creationDate
		cellView.addSubview(creationDate)
		self.creationDate.font = UIFont(name: "Lato-Light", size: kText13)
		self.creationDate.textColor = Color.blackTextColor
		
		let moneyContainer = UIView()
		self.moneyContainer = moneyContainer
		cellView.addSubview(moneyContainer)
		moneyContainer.backgroundColor = Color.whiteBackground
		moneyContainer.layer.cornerRadius = 3
		moneyContainer.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(cellView.snp_right).offset(-20)
			make.centerY.equalTo(picture.snp_centerY).offset(pictureSize / 5)
			make.width.equalTo(55)
			make.height.equalTo(35)
		}
		
		creationDate.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(author.snp_bottom).offset(4)
			make.left.equalTo(author.snp_left)
			make.right.equalTo(moneyContainer.snp_left).offset(6)
		}
		
		let moneyLabel = UILabel()
		self.price = moneyLabel
		moneyContainer.addSubview(moneyLabel)
		moneyLabel.textAlignment = NSTextAlignment.Center
		moneyLabel.textColor = Color.blackPrimary
		moneyLabel.font = UIFont(name: "Lato-Light", size: kText15)
		moneyLabel.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(moneyContainer.snp_edges)
		}
		
		let appliedContainer = UIView()
		self.appliedContainer = appliedContainer
		cellView.addSubview(appliedContainer)
		appliedContainer.backgroundColor = Color.redPrimarySelected
		appliedContainer.layer.cornerRadius = 3
		appliedContainer.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(moneyContainer.snp_top).offset(-5)
			make.left.equalTo(moneyContainer.snp_left)
			make.right.equalTo(moneyContainer.snp_right)
			make.height.equalTo(25)
		}
		
		let appliedNotice = UILabel()
		self.appliedNotice = appliedNotice
		appliedContainer.addSubview(appliedNotice)
		appliedNotice.text = "Applied"
		appliedNotice.textAlignment = NSTextAlignment.Center
		appliedNotice.font = UIFont(name: "Lato-Regular", size: kText13)
		appliedNotice.textColor = Color.whitePrimary
		appliedNotice.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(appliedContainer.snp_edges).inset(UIEdgeInsetsMake(0, 0, 0, 0))
		}
		
		/*let rightArrow = UIImageView()
		cellView.addSubview(rightArrow)
		rightArrow.image = UIImage(named: "arrow_applicant_cell")
		rightArrow.alpha = 0.2
		rightArrow.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(moneyContainer.snp_right).offset(24)
			make.centerY.equalTo(cellView.snp_centerY)
			make.width.equalTo(15)
			make.height.equalTo(25)
		}*/
		
		let separatorLine = UIView()
		cellView.addSubview(separatorLine)
		separatorLine.backgroundColor = Color.grayDetails
		separatorLine.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(cellView.snp_right)
			make.left.equalTo(cellView.snp_left)
			make.bottom.equalTo(cellView.snp_bottom)
			make.height.equalTo(0.5)
		}
		
		self.addSubview(cellView)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func setSelected(selected: Bool, animated: Bool) {
	}
	
	override func setHighlighted(highlighted: Bool, animated: Bool) {
	}
	
	static var reuseIdentifier: String {
		get {
			return "BrowseTaskViewCell"
		}
	}
	
	//MARK: Setters
	
	
	/**
	Sets the cell Task
	
	- parameter task: The Task
	*/
	func setNelpTask(task:Task) {
		self.task = task
		self.title.text = task.title
		self.title.font = UIFont(name: "Lato-Regular", size: kText15)
		self.title.textColor = Color.blackTextColor
		
		let price = String(format: "%.0f", task.priceOffered!)
		self.price.font = UIFont(name: "Lato-Regular", size: kText15)
		self.price.text = price+"$"
		
		self.author.text = "\(task.user.name)"
		self.author.font = UIFont(name: "Lato-Light", size: kText13)
		self.author.textColor = Color.blackTextColor
		
		let dateHelper = DateHelper()
		self.creationDate.text = "Posted \(dateHelper.timeAgoSinceDate(self.task.createdAt!, numericDates: true))"
		
		self.categoryPicture.image = UIImage(named: task.category!)
		
		if self.task.application != nil && self.task.application!.state != .Canceled {
			self.appliedContainer.hidden = false
			self.title.snp_remakeConstraints(closure: { (make) -> Void in
				make.top.equalTo(self.picture.snp_top).offset(2)
				make.left.equalTo(self.picture.snp_right).offset(18)
				make.right.equalTo(self.appliedNotice.snp_left).offset(-10)
			})
		} else {
			self.appliedContainer.hidden = true
		}
	}
	
	/**
	Set profile image on the cell
	
	- parameter task: Task
	*/
	func setImages(task: Task) {
		if (task.user.profilePictureURL != nil) {
			let fbProfilePicture = task.user.profilePictureURL
			request(.GET,fbProfilePicture!).response() {
				(_, _, data, _) in
				let image = UIImage(data: data as NSData!)
				self.picture.image = image
			}
		}
		
		let image = UIImage(named: "noProfilePicture")
		self.picture.image = image
	}
	
	func setLocation(){
		let taskLocation = CLLocation(latitude: self.task.location!.latitude, longitude: self.task.location!.longitude)
		let userLocation = CLLocation(latitude: LocationHelper.sharedInstance.currentCLLocation.latitude, longitude: LocationHelper.sharedInstance.currentCLLocation.longitude)
		self.creationDate.text = LocationHelper().calculateDistanceBetweenTwoLocations(userLocation, destination: taskLocation)
	}
	
	func cellSelected() {
		self.cellView.backgroundColor = UIColor.whiteColor()
	}
	
	func cellDeselected() {
		self.cellView.backgroundColor = Color.whitePrimary
	}
	
}



