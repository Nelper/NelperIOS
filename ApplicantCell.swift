//
//  ApplicantCell.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-08-25.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation
import Alamofire

class ApplicantCell: UITableViewCell{
	
	var applicant:User!
	var picture:UIImageView!
	var name:UILabel!
	var firstStar:UIImageView!
	var secondStar:UIImageView!
	var thirdStar:UIImageView!
	var fourthStar:UIImageView!
	var fifthStar:UIImageView!
	var taskCompletedLabel:UILabel!
	var askingForLabel:UILabel!
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		self.clipsToBounds = true
		
		let cellView = UIView(frame: self.bounds)
		cellView.backgroundColor = navBarColor
		cellView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight;
		
		
		//Profile Picture
		let pictureSize: CGFloat = 70
		let picture = UIImageView()
		self.picture = picture
		self.picture.layer.cornerRadius = pictureSize / 2;
		self.picture.layer.masksToBounds = true
		self.picture.clipsToBounds = true
		self.picture.contentMode = UIViewContentMode.ScaleAspectFill
		
		cellView.addSubview(picture)
		
		//Name Label
		var name = UILabel()
		self.name = name
		cellView.addSubview(name)
		name.textColor = blackNelpyColor
		name.textAlignment = NSTextAlignment.Left
		name.font = UIFont(name: "HelveticaNeue", size: kCellTitleFontSize)
		name.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(cellView.snp_top).offset(2)
			make.left.equalTo(picture.snp_left).offset(16)
			make.right.equalTo(cellView.snp_right).offset(-10)
		}
		
		picture.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(cellView.snp_left).offset(16)
			make.top.equalTo(name.snp_bottom).offset(8)
			make.width.equalTo(pictureSize)
			make.height.equalTo(pictureSize)
		}
		
		//FeedBack Stars
		
		var firstStar = UIImageView()
		self.firstStar = firstStar
		cellView.addSubview(firstStar)
		firstStar.contentMode = UIViewContentMode.ScaleAspectFill
		firstStar.image = UIImage(named: "empty_star")
		firstStar.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(picture.snp_right).offset(10)
			make.top.equalTo(picture.snp_top).offset(4)
			make.height.equalTo(20)
			make.width.equalTo(20)
		}
		
		var secondStar = UIImageView()
		self.secondStar = secondStar
		cellView.addSubview(secondStar)
		secondStar.contentMode = UIViewContentMode.ScaleAspectFill
		secondStar.image = UIImage(named: "empty_star")
		secondStar.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(firstStar.snp_bottom)
			make.left.equalTo(firstStar.snp_right).offset(4)
			make.width.equalTo(20)
			make.height.equalTo(20)
		}
		
		var thirdStar = UIImageView()
		self.thirdStar = thirdStar
		cellView.addSubview(thirdStar)
		thirdStar.contentMode = UIViewContentMode.ScaleAspectFill
		thirdStar.image = UIImage(named: "empty_star")
		thirdStar.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(secondStar.snp_bottom)
			make.left.equalTo(secondStar.snp_right).offset(4)
			make.width.equalTo(20)
			make.height.equalTo(20)
		}
		
		var fourthStar = UIImageView()
		self.fourthStar = fourthStar
		cellView.addSubview(fourthStar)
		fourthStar.contentMode = UIViewContentMode.ScaleAspectFill
		fourthStar.image = UIImage(named: "empty_star")
		fourthStar.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(thirdStar.snp_bottom)
			make.left.equalTo(thirdStar.snp_right).offset(4)
			make.width.equalTo(20)
			make.height.equalTo(20)
		}
		
		var fifthStar = UIImageView()
		self.fifthStar = fifthStar
		cellView.addSubview(fifthStar)
		fifthStar.contentMode = UIViewContentMode.ScaleAspectFill
		fifthStar.image = UIImage(named: "empty_star")
		fifthStar.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(fourthStar.snp_bottom)
			make.left.equalTo(fourthStar.snp_right).offset(4)
			make.width.equalTo(20)
			make.height.equalTo(20)
		}
		
		//Task Completed field
		
		var taskCompleted = UILabel()
		cellView.addSubview(taskCompleted)
		self.taskCompletedLabel = taskCompleted
		taskCompleted.textColor = blackNelpyColor
		taskCompleted.font = UIFont(name: "HelveticaNeue", size: kCellTextFontSize)
		taskCompleted.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(firstStar.snp_left)
			make.top.equalTo(firstStar.snp_bottom).offset(4)
			make.right.equalTo(cellView.snp_right).offset(-10)
		}
		
		//Offer
		
		//money icon
		
		var moneyIcon = UIImageView()
		moneyIcon.contentMode = UIViewContentMode.ScaleAspectFill
		moneyIcon.image = UIImage(named: "money_icon.png")
		cellView.addSubview(moneyIcon)
		moneyIcon.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(firstStar.snp_left)
			make.top.equalTo(taskCompleted.snp_bottom).offset(4)
			make.height.equalTo(40)
			make.width.equalTo(40)
		}
		
		//Asking for label
		
		var askingFor = UILabel()
		self.askingForLabel = askingFor
		cellView.addSubview(askingFor)
		askingFor.textColor = blackNelpyColor
		askingFor.font = UIFont(name: "HelveticaNeue", size: kCellTextFontSize)
		askingFor.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(moneyIcon)
			make.left.equalTo(moneyIcon.snp_right).offset(4)

		}
		
		//Arrow
		
		var arrow = UIImageView()
		cellView.addSubview(arrow)
		arrow.image = UIImage(named: "arrow_applicant_cell.png")
		arrow.contentMode = UIViewContentMode.ScaleAspectFill
		arrow.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(cellView.snp_right).offset(-4)
			make.centerY.equalTo(cellView.snp_centerY)
			make.height.equalTo(35)
			make.width.equalTo(20)
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
			return "ApplicantCell"
		}
	}
	
	func setFeedback(applicant:User){
		
		self.firstStar.image = UIImage(named: "star.png")
		self.secondStar.image = UIImage(named: "star.png")
		self.thirdStar.image = UIImage(named: "star.png")
		self.fourthStar.image = UIImage(named: "star.png")

		
	}
	
	func setApplicant(applicant:User){
		self.applicant = applicant
		self.setImages(applicant)
		self.name.text = applicant.name
		self.taskCompletedLabel.text = "8 tasks completed"
		self.setFeedback(applicant)
		self.askingForLabel.text = "Asking 100$"
	}
	
	
	func setImages(applicant:User){
		if(applicant.profilePictureURL != nil){
			var fbProfilePicture = applicant.profilePictureURL
			request(.GET,fbProfilePicture!).response(){
				(_, _, data, _) in
				var image = UIImage(data: data as NSData!)
				self.picture.image = image
			}
		}
	
	}
}