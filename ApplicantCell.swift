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
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		self.clipsToBounds = true
		
		let cellView = UIView(frame: self.bounds)
		cellView.backgroundColor = navBarColor
		cellView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight;
		
		
		//Profile Picture
		let pictureSize: CGFloat = 60
		let picture = UIImageView()
		self.picture = picture
		self.picture.layer.cornerRadius = pictureSize / 2;
		self.picture.layer.masksToBounds = true
		self.picture.clipsToBounds = true
		self.picture.layer.borderWidth = 3;
		self.picture.layer.borderColor = blackNelpyColor.CGColor
		self.picture.contentMode = UIViewContentMode.ScaleAspectFill
		
		cellView.addSubview(picture)
		
		picture.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(cellView.snp_left).offset(16)
			make.centerY.equalTo(cellView.snp_centerY)
			make.width.equalTo(pictureSize)
			make.height.equalTo(pictureSize)
		}
		
		//Name Label
		var name = UILabel()
		self.name = name
		cellView.addSubview(name)
		name.textColor = blackNelpyColor
		name.textAlignment = NSTextAlignment.Left
		name.font = UIFont(name: "ABeeZee-Regular", size: kCellTitleFontSize)
		name.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(cellView.snp_top).offset(2)
			make.left.equalTo(picture.snp_left)
			make.right.equalTo(cellView.snp_right).offset(-10)
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
	
	func setApplicant(applicant:User){
		self.applicant = applicant
		self.setImages(applicant)
		self.name.text = applicant.name
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