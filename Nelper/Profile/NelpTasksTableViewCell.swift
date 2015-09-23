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
	var numberOfApplicantsIcon:UIImageView!
	var numberOfApplicantsLabel:UILabel!
	
	var nelpTask:FindNelpTask!
	
	//MARK: Initialization
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		self.clipsToBounds = true
		
		let backView = UIView(frame: self.bounds)
		backView.clipsToBounds = true
		backView.backgroundColor = whiteNelpyColor
		backView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
		
		//CellContainer (hackForSpacing)
		let cellView = UIView()
		cellView.backgroundColor = whiteGrayColor
		backView.addSubview(cellView)
		cellView.layer.borderWidth = 1
		cellView.layer.borderColor = darkGrayDetails.CGColor
		cellView.layer.masksToBounds = true
		cellView.clipsToBounds = true
		cellView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(backView).offset(12)
			make.left.equalTo(backView).offset(12)
			make.right.equalTo(backView).offset(-12)
			make.bottom.equalTo(backView).offset(-4)
		}
		
		//Top container
		let topContainer = UIImageView()
		self.topContainer = topContainer
		self.topContainer.clipsToBounds = true
		self.topContainer.layer.masksToBounds = true
		cellView.addSubview(topContainer)
		topContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(cellView.snp_top)
			make.right.equalTo(cellView.snp_right)
			make.left.equalTo(cellView.snp_left)
			make.height.equalTo(85)
		}
		topContainer.backgroundColor = nelperRedColor		//Category Icon + label
		

		
		let blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
		let blurView = UIVisualEffectView(effect: blur)
		topContainer.addSubview(blurView)
		blurView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(topContainer.snp_edges)
		}
		
		//Category Icon
		let categoryIcon = UIImageView()
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
		let notificationIcon = UIImageView()
		self.notificationIcon = notificationIcon
		topContainer.addSubview(notificationIcon)
		self.notificationIcon.image = UIImage(named: "exclamation.png")
		self.notificationIcon.hidden = true
		notificationIcon.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(topContainer.snp_top).offset(4)
			make.left.equalTo(topContainer.snp_left).offset(4)
			make.height.equalTo(30)
			make.width.equalTo(30)
		}
		
		//Title Label
		let titleLabel = UILabel()
		self.titleLabel = titleLabel
		titleLabel.textColor = blackNelpyColor
		titleLabel.font = UIFont(name: "Lato-Regular", size: kCellTitleFontSize)
		cellView.addSubview(titleLabel)
		titleLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(topContainer.snp_bottom).offset(4)
			make.left.equalTo(cellView.snp_left).offset(12)
			make.height.equalTo(40)
		}
		
		//Number of applicants
		let numberOfApplicantsIcon = UIImageView()
		self.numberOfApplicantsIcon = numberOfApplicantsIcon
		numberOfApplicantsIcon.image = UIImage(named: "applicants.png")
		cellView.addSubview(numberOfApplicantsIcon)
		numberOfApplicantsIcon.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(titleLabel.snp_bottom).offset(4)
			make.left.equalTo(cellView.snp_left).offset(20)
			make.height.equalTo(30)
			make.width.equalTo(30)
		}
		
		let numberOfApplicants = UILabel()
		self.numberOfApplicantsLabel = numberOfApplicants
		self.numberOfApplicants = numberOfApplicants
		self.numberOfApplicants.font = UIFont(name: "Lato-Light", size: kCellTextFontSize)
		self.numberOfApplicants.textColor = blackNelpyColor
		cellView.addSubview(numberOfApplicants)
		numberOfApplicants.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(numberOfApplicantsIcon.snp_right).offset(6)
			make.centerY.equalTo(numberOfApplicantsIcon.snp_centerY)
		}
		
		//Price tag
		
		let moneyTag = UIImageView()
		cellView.addSubview(moneyTag)
		moneyTag.image = UIImage(named: "moneytag")
		moneyTag.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(numberOfApplicants.snp_centerY)
			make.right.equalTo(cellView.snp_right).offset(-20)
			make.width.equalTo(70)
			make.height.equalTo(35)
		}
		
		let moneyLabel = UILabel()
		self.price = moneyLabel
		moneyTag.addSubview(moneyLabel)
		moneyLabel.textAlignment = NSTextAlignment.Center
		moneyLabel.textColor = whiteNelpyColor
		moneyLabel.font = UIFont(name: "Lato-Regular", size: kTextFontSize)
		moneyLabel.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(moneyTag.snp_edges)
		}
		
		self.addSubview(backView)
		
}
	
	override func setHighlighted(highlighted: Bool, animated: Bool) {
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	static var reuseIdentifier: String {
		get {
			return "NelpTasksTableViewCell"
		}
	}
	
	//MARK: Setters

	/**
	Set images for cell (Category,header image)
	
	- parameter nelpTask: <#nelpTask description#>
	*/
	func setImages(nelpTask:FindNelpTask){
		self.categoryIcon.layer.cornerRadius = self.categoryIcon.frame.size.width / 2;
		self.categoryIcon.clipsToBounds = true
		self.categoryIcon.image = UIImage(named: nelpTask.category!)
		self.notificationIcon.layer.cornerRadius = self.notificationIcon.frame.size.width / 2;
		self.notificationIcon.clipsToBounds = true
		self.setNotification(nelpTask)

		if(nelpTask.pictures != nil){
		if(!nelpTask.pictures!.isEmpty){
		ApiHelper.getPictures(nelpTask.pictures![0].url! , block: { (imageReturned:UIImage) -> Void in
			self.topContainer.image = imageReturned
		})}}else{
			self.topContainer.image = UIImage(named: "square_\(nelpTask.category!)")!
		}
		self.topContainer.contentMode = .ScaleAspectFill
		self.topContainer.clipsToBounds = true
		
		if nelpTask.state == .Accepted {
			self.numberOfApplicantsIcon.image = UIImage(named: "accepted")
			self.numberOfApplicantsLabel.text = "Nelper Accepted"
		}
	}
	
	
	/**
	Sets the number of applicants and new application notification icon
	
	- parameter nelpTask: <#nelpTask description#>
	*/
	func setNotification(nelpTask:FindNelpTask) {
		
		if (nelpTask.applications.count == 0) {
			self.numberOfApplicants.text = "0 Nelper"
		} else if (nelpTask.applications.count == 1) {
			self.numberOfApplicants.text = "1 Nelper"
		} else {
			self.numberOfApplicants.text = "\(nelpTask.applications.count) Nelpers"
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
	
	/**
	Sets the cell task
	
	- parameter nelpTask: Nelp Task
	*/
	func setNelpTask(nelpTask: FindNelpTask) {
//		self.categoryLabel.text = nelpTask.category!.uppercaseString
		self.titleLabel.text = nelpTask.title
		let price = String(format: "%.0f", nelpTask.priceOffered!)
		self.price.text = "$"+price

	}

}


