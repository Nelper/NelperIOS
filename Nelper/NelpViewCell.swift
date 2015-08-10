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
	var distance:UILabel?
	var task: NelpTask!
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		self.clipsToBounds = true
		
		let cellView = UIView(frame: self.bounds)
		cellView.backgroundColor = whiteNelpyColor
		cellView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight;
		
		let picture = UIImageView()
		self.picture = picture
		self.picture.layer.cornerRadius = self.picture.frame.size.width / 2;
		self.picture.layer.masksToBounds = true
		self.picture.clipsToBounds = true
		
		cellView.addSubview(picture)
		
		picture.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(cellView.snp_left).offset(10)
			make.centerY.equalTo(cellView.snp_centerY)
			make.width.equalTo(60)
			make.height.equalTo(60)
		}
		
		let categoryPicture = UIImageView()
		self.categoryPicture = categoryPicture
		
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
			make.top.equalTo(cellView.snp_top).offset(10)
			make.left.equalTo(picture.snp_right).offset(15)
			}
		
		let author = UILabel()
		self.author = author
		cellView.addSubview(author)
		
		author.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(title.snp_bottom).offset(2)
			make.left.equalTo(picture.snp_right).offset(35)
		}
		
		let distance = UILabel()
		self.distance = distance
		cellView.addSubview(distance)
		
		distance.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(author.snp_bottom).offset(3)
			make.left.equalTo(author.snp_left)
		}
		
		let price = UILabel()
		self.price = price
		self.price.backgroundColor = greenPriceButton
		self.price.layer.cornerRadius = 6
		cellView.addSubview(price)
		
		price.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(cellView.snp_right).offset(-10)
			make.bottom.equalTo(distance.snp_bottom).offset(-2)
			make.width.equalTo(70)
			make.height.equalTo(30)
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
		self.task = nelpTask
		self.title.text = nelpTask.title
		self.title.font = UIFont(name: "ABeeZee-Regular", size: kCellTitleFontSize)
		self.title.textColor = blackNelpyColor
		
		self.author.text = "By \(nelpTask.user.name)"
		self.author.font = UIFont(name: "ABeeZee-Regular", size: kCellTextFontSize)
		self.author.textColor = blackNelpyColor
		
		var price = nelpTask.priceOffered
		
		if(price != nil){
		self.price.text = "$" + price!
		}
		self.price.font = UIFont(name: "ABeeZee-Regular", size: kCellPriceFontSize)
		self.price.textColor = whiteNelpyColor
		self.price.layer.cornerRadius = 6
		self.price.clipsToBounds = true
		self.price.textAlignment = NSTextAlignment.Center
		
	}
	
	func setImages(nelpTask:NelpTask){
		if(nelpTask.user.profilePictureURL != nil){
		var fbProfilePicture = nelpTask.user.profilePictureURL
		request(.GET,fbProfilePicture!).response(){
			(_, _, data, _) in
			var image = UIImage(data: data as NSData!)
			self.picture.image = image
			self.picture.layer.cornerRadius = self.picture.frame.size.width / 2;
			self.picture.clipsToBounds = true;
			self.picture.layer.borderWidth = 3;
			self.picture.layer.borderColor = blackNelpyColor.CGColor
			self.picture.contentMode = UIViewContentMode.ScaleAspectFill
			
			self.categoryPicture.layer.cornerRadius = self.categoryPicture.frame.size.width / 2;
			self.categoryPicture.clipsToBounds = true;
			self.categoryPicture.image = UIImage(named: nelpTask.category!)
			}
		}
		var image = UIImage(named: "noProfilePicture")
		self.picture.image = image
		self.picture.layer.cornerRadius = self.picture.frame.size.width / 2;
		self.picture.clipsToBounds = true;
		self.picture.layer.borderWidth = 3;
		self.picture.layer.borderColor = blackNelpyColor.CGColor
		self.picture.contentMode = UIViewContentMode.ScaleAspectFill
		
		self.categoryPicture.layer.cornerRadius = self.categoryPicture.frame.size.width / 2;
		self.categoryPicture.clipsToBounds = true;
		self.categoryPicture.image = UIImage(named: nelpTask.category!)
	}
	
	func setLocation(userLocation:CLLocation){
		var taskLocation = CLLocation(latitude: self.task.location!.latitude, longitude: self.task.location!.longitude)
		var distance: String = self.calculateDistanceBetweenTwoLocations(userLocation, destination: taskLocation)
		
		self.distance!.text = distance
		self.distance!.font = UIFont(name: "ABeeZee-Regular", size: kCellTextFontSize)
		self.distance!.textColor = blackNelpyColor
		
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

}



