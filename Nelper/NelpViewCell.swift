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
	var task: NelpTask!
	
	//MARK: Initialization
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		self.clipsToBounds = true
		
		let cellView = UIView(frame: self.bounds)
		cellView.backgroundColor = navBarColor
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
			make.left.equalTo(picture.snp_right).offset(-22)
			make.width.equalTo(28)
			make.height.equalTo(28)
		}
		
		let title = UILabel()
		self.title = title
		
		cellView.addSubview(title)
		
		title.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(cellView.snp_centerY).offset(-8)
			make.left.equalTo(picture.snp_right).offset(15)
		}
		
		let author = UILabel()
		self.author = author
		cellView.addSubview(author)
		
		author.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(cellView.snp_centerY) 
			make.left.equalTo(title.snp_left)
		}
		
		let creationDate = UILabel()
		self.creationDate = creationDate
		cellView.addSubview(creationDate)
		
		self.creationDate.font = UIFont(name: "Lato-Light", size: kCellTextFontSize)
		self.creationDate.textColor = blackTextColor
		
		creationDate.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(author.snp_bottom)
			make.left.equalTo(author.snp_left)
		}
		
		var moneyTag = UIImageView()
		cellView.addSubview(moneyTag)
		moneyTag.image = UIImage(named: "moneytag")
		moneyTag.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(cellView.snp_right).offset(-10)
			make.bottom.equalTo(creationDate.snp_bottom).offset(-2)
			make.width.equalTo(70)
			make.height.equalTo(35)
		}
		
		var moneyLabel = UILabel()
		self.price = moneyLabel
		moneyTag.addSubview(moneyLabel)
		moneyLabel.textAlignment = NSTextAlignment.Center
		moneyLabel.textColor = whiteNelpyColor
		moneyLabel.font = UIFont(name: "Lato-Regular", size: kTextFontSize)
		moneyLabel.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(moneyTag.snp_edges)
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
		self.title.font = UIFont(name: "Lato-Regular", size: kCellTitleFontSize)
		self.title.textColor = blackTextColor
		
		self.author.text = "\(nelpTask.user.name)"
		self.author.font = UIFont(name: "Lato-Light", size: kCellTextFontSize)
		self.author.textColor = blackTextColor
		
		let price = String(format: "%.0f", nelpTask.priceOffered!)
		
		self.price.text = "$"+price
		
		self.price.font = UIFont(name: "Lato-Regular", size: kCellPriceFontSize)
		self.price.textColor = whiteNelpyColor
		self.price.layer.cornerRadius = 6
		self.price.clipsToBounds = true
		self.price.textAlignment = NSTextAlignment.Center
		
		let dateHelper = DateHelper()
		self.creationDate.text = "Created \(dateHelper.timeAgoSinceDate(self.task.createdAt!, numericDates: true))"
		
		self.categoryPicture.image = UIImage(named: nelpTask.category!)
		
	}
	
	/**
	Set profile image on the cell
	
	- parameter nelpTask: NelpTask
	*/
	func setImages(nelpTask:NelpTask) {
		if(nelpTask.user.profilePictureURL != nil){
			var fbProfilePicture = nelpTask.user.profilePictureURL
			request(.GET,fbProfilePicture!).response(){
				(_, _, data, _) in
				var image = UIImage(data: data as NSData!)
				self.picture.image = image
			}
		}
		
		var image = UIImage(named: "noProfilePicture")
		self.picture.image = image
	}
	
}



