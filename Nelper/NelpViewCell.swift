//
//  NelpViewCell.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-07-29.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Alamofire

class NelpViewCell: UITableViewCell {
	
	var title: UILabel!
	var author:UILabel!
	var price:UILabel!
	var picture:UIImageView!
	var categoryPicture:UIImageView!
	var creationDate:UILabel!
	var moneyBackground:UIView!
	var task: NelpTask!
	
	//MARK: Initialization
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		self.clipsToBounds = true
		
		
		
		let cellView = UIView(frame: self.bounds)
		cellView.backgroundColor = whiteGrayColor
		cellView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight];
		
		let pictureSize: CGFloat = 70
		let picture = UIImageView()
		self.picture = picture
		self.picture.layer.cornerRadius = pictureSize / 2;
		self.picture.layer.masksToBounds = true
		self.picture.clipsToBounds = true
		self.picture.layer.borderWidth = 1;
		self.picture.layer.borderColor = darkGrayDetails.CGColor
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
		self.categoryPicture.layer.cornerRadius = self.categoryPicture.frame.size.width / 2;
		self.categoryPicture.clipsToBounds = true;
		
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
			make.top.equalTo(picture.snp_top)
			make.left.equalTo(picture.snp_right).offset(12)
		}
		
		let authorIcon = UIImageView()
		cellView.addSubview(authorIcon)
		authorIcon.image = UIImage(named: "profile-red")
		authorIcon.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(picture.snp_right).offset(22)
			make.top.equalTo(title.snp_bottom).offset(5)
			make.width.equalTo(20)
			make.height.equalTo(20)
		}
		
		let author = UILabel()
		self.author = author
		cellView.addSubview(author)
		
		author.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(authorIcon.snp_centerY).offset(-1)
			make.left.equalTo(authorIcon.snp_right).offset(7)
		}
		
		let creationDate = UILabel()
		self.creationDate = creationDate
		cellView.addSubview(creationDate)
		
		self.creationDate.font = UIFont(name: "Lato-Light", size: kText12)
		self.creationDate.textColor = blackTextColor
		
		creationDate.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(author.snp_bottom).offset(10)
			make.left.equalTo(author.snp_left)
		}
		
		let moneyContainer = UIView()
		cellView.addSubview(moneyContainer)
		moneyContainer.backgroundColor = whiteNelpyColor
		moneyContainer.layer.cornerRadius = 3
		moneyContainer.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(cellView.snp_right).offset(-55)
			make.bottom.equalTo(creationDate.snp_bottom).offset(-4)
			make.width.equalTo(55)
			make.height.equalTo(35)
		}
		
		let moneyLabel = UILabel()
		self.price = moneyLabel
		moneyContainer.addSubview(moneyLabel)
		moneyLabel.textAlignment = NSTextAlignment.Center
		moneyLabel.textColor = blackNelpyColor
		moneyLabel.font = UIFont(name: "Lato-Regular", size: kText14)
		moneyLabel.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(moneyContainer.snp_edges)
		}
		
		let rightArrow = UIImageView()
		cellView.addSubview(rightArrow)
		rightArrow.image = UIImage(named: "arrow_applicant_cell")
		rightArrow.alpha = 0.2
		rightArrow.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(moneyContainer.snp_right).offset(18)
			make.centerY.equalTo(moneyContainer.snp_centerY)
			make.width.equalTo(15)
			make.height.equalTo(25)
		}
		
		let separatorLine = UIView()
		cellView.addSubview(separatorLine)
		separatorLine.backgroundColor = grayDetails
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
			return "NelpViewCell"
		}
	}
	
	//MARK: Setters
	
	
	/**
	Sets the cell NelpTask
	
	- parameter nelpTask: The NelpTask
	*/
	func setNelpTask(nelpTask:NelpTask) {
		self.task = nelpTask
		self.title.text = nelpTask.title
		self.title.font = UIFont(name: "Lato-Regular", size: kText14)
		self.title.textColor = blackTextColor
		
		self.author.text = "\(nelpTask.user.name)"
		self.author.font = UIFont(name: "Lato-Light", size: kText12)
		self.author.textColor = blackTextColor
		
		let price = String(format: "%.0f", nelpTask.priceOffered!)
		
		self.price.text = "$"+price
		
		let dateHelper = DateHelper()
		self.creationDate.text = "Posted \(dateHelper.timeAgoSinceDate(self.task.createdAt!, numericDates: true))"
		
		self.categoryPicture.image = UIImage(named: nelpTask.category!)
		
	}
	
	/**
	Set profile image on the cell
	
	- parameter nelpTask: NelpTask
	*/
	func setImages(nelpTask:NelpTask) {
		if(nelpTask.user.profilePictureURL != nil){
			let fbProfilePicture = nelpTask.user.profilePictureURL
			request(.GET,fbProfilePicture!).response(){
				(_, _, data, _) in
				let image = UIImage(data: data as NSData!)
				self.picture.image = image
			}
		}
		
		let image = UIImage(named: "noProfilePicture")
		self.picture.image = image
	}
	
}



