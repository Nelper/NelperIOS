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
	var distance:UILabel!
	var price:UILabel!
	var picture:UIImageView!
	var categoryPicture:UIImageView!
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		self.clipsToBounds = true
		
		let cellView = UIView(frame: self.bounds)
		cellView.backgroundColor = whiteNelpyColor
		cellView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight;
		
		let picture = UIImageView()
		self.picture = picture
		
		cellView.addSubview(picture)
		
		picture.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(cellView.snp_left).offset(0)
			make.centerY.equalTo(cellView.snp_centerY)
			make.width.equalTo(70)
			make.height.equalTo(70)
		}
		
		let categoryPicture = UIImageView()
		self.categoryPicture = categoryPicture
		self.categoryPicture.image = UIImage(named: "technologyIcon.png")
		
		cellView.addSubview(categoryPicture)
		
		categoryPicture.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(picture.snp_bottom)
			make.left.equalTo(picture.snp_right).offset(-14)
			make.width.equalTo(40)
			make.height.equalTo(40)
		}
		
		let title = UILabel()
		self.title = title
		
		cellView.addSubview(title)
		
		title.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(cellView.snp_top).offset(2)
			make.left.equalTo(picture.snp_right).offset(2)
			}
		
		let distance = UILabel()
		self.distance = distance
		cellView.addSubview(distance)
		
		distance.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(title.snp_bottom).offset(2)
			make.centerX.equalTo(cellView.snp_centerX)
		}
		
		let price = UILabel()
		self.price = price
		self.price.backgroundColor = greenPriceButton
		self.price.layer.cornerRadius = 6
		cellView.addSubview(price)
		
		price.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(cellView.snp_right).offset(-4)
			make.centerY.equalTo(distance.snp_centerY)
			make.width.equalTo(70)
			make.height.equalTo(35)
		}
		
		self.addSubview(cellView)
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
	
	func setNelpTask(nelpTask:NelpTask) {
		self.title.text = nelpTask.title
		self.title.font = UIFont(name: "Railway", size: kCellTitleFontSize)
		self.title.textColor = blackNelpyColor
		
		self.distance.text = "Distance: 1.2 km"
		self.distance.font = UIFont(name: "Railway", size: kSubtitleFontSize)
		self.distance.textColor = grayNelpyColor
		
		var price = nelpTask.priceOffered
		
		if(price != nil){
		self.price.text = price! + "$"
		}
		self.price.font = UIFont(name: "Railway", size: kCellPriceFontSize)
		self.price.textColor = whiteNelpyColor
		self.price.layer.cornerRadius = 6
		self.price.clipsToBounds = true
		self.price.textAlignment = NSTextAlignment.Center
		
	}
	
	func setImages(nelpTask:NelpTask){
		
		var fbProfilePicture = nelpTask.user.profilePictureURL
		request(.GET,fbProfilePicture).response(){
			(_, _, data, _) in
			var image = UIImage(data: data as NSData!)
			self.picture.image = image
			self.picture.layer.cornerRadius = self.picture.frame.size.width / 2;
			self.picture.clipsToBounds = true;
			self.picture.layer.borderWidth = 3;
			self.picture.layer.borderColor = whiteNelpyColor.CGColor
			self.picture.contentMode = UIViewContentMode.ScaleAspectFill
			
			self.categoryPicture.layer.cornerRadius = self.categoryPicture.frame.size.width / 2;
			self.categoryPicture.clipsToBounds = true;
			self.categoryPicture.layer.borderWidth = 2;
			self.categoryPicture.layer.borderColor = whiteNelpyColor.CGColor
		}
	}
}



