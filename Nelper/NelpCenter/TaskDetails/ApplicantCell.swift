//
//  ApplicantCell.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-08-25.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation
import Alamofire

protocol ApplicantCellDelegate{
	func didTapRevertButton(applicant:User)
}

class ApplicantCell: UITableViewCell{
	
	var applicant: User!
	var picture: UIImageView!
	var name: UILabel!
	var completedTasks: Int!
	var moneyLabel: UILabel!
	var applicationPrice: Int!
	var rightButton: UIButton!
	var revertButton: UIButton?
	var delegate: ApplicantCellDelegate?
	var index: Int!
	var cellView: UIView!
	var ratingStarsView: RatingStars!
	
	//MARK: Initialization
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		self.clipsToBounds = true
		
		let cellView = UIView(frame: self.bounds)
		self.cellView = cellView
		cellView.backgroundColor = whitePrimary
		cellView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight];
		
		
		//Profile Picture
		let pictureSize: CGFloat = 70
		let picture = UIImageView()
		self.picture = picture
		self.picture.layer.cornerRadius = pictureSize / 2;
		self.picture.layer.masksToBounds = true
		self.picture.clipsToBounds = true
		self.picture.contentMode = UIViewContentMode.ScaleAspectFill
		
		cellView.addSubview(picture)
		
		picture.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(cellView.snp_left).offset(16)
			make.centerY.equalTo(cellView.snp_centerY)
			make.width.equalTo(pictureSize)
			make.height.equalTo(pictureSize)
		}
		
		//Name Label
		
		let name = UILabel()
		self.name = name
		cellView.addSubview(name)
		name.textColor = blackPrimary
		name.textAlignment = NSTextAlignment.Left
		name.font = UIFont(name: "Lato-Regular", size: kTitle17)
		name.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(picture.snp_centerY).offset(-15)
			make.left.equalTo(picture.snp_right).offset(15)
			make.right.equalTo(cellView.snp_right).offset(-10)
		}
		
		//Rating
		
		ratingStarsView = RatingStars()
		ratingStarsView.style = "dark"
		ratingStarsView.starHeight = 15
		ratingStarsView.starWidth = 15
		ratingStarsView.starPadding = 5
		ratingStarsView.textSize = kText15
		cellView.addSubview(ratingStarsView)
		ratingStarsView.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(name.snp_left)
			make.centerY.equalTo(picture.snp_centerY).offset(15)
			make.width.equalTo((ratingStarsView.starWidth + ratingStarsView.starPadding) * 6)
			make.height.equalTo(ratingStarsView.starHeight)
		}
		
		//Money View
		
		let moneyView = UIView()
		moneyView.contentMode = UIViewContentMode.ScaleAspectFill
		moneyView.backgroundColor = whiteBackground
		moneyView.layer.cornerRadius = 3
		cellView.addSubview(moneyView)
		moneyView.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(ratingStarsView.snp_right).offset(28)
			make.centerY.equalTo(ratingStarsView.snp_centerY)
			make.height.equalTo(35)
			make.width.equalTo(55)
		}
		
		//Money Label
		
		let moneyLabel = UILabel()
		self.moneyLabel = moneyLabel
		moneyView.addSubview(moneyLabel)
		moneyLabel.textAlignment = NSTextAlignment.Center
		moneyLabel.textColor = blackPrimary
		moneyLabel.font = UIFont(name: "Lato-Light", size: kText15)
		moneyLabel.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(moneyView.snp_edges)
		}
		
		//Arrow
		
		let arrow = UIButton()
		self.rightButton = arrow
		cellView.addSubview(arrow)
		arrow.setBackgroundImage(UIImage(named: "arrow_applicant_cell.png"), forState: UIControlState.Normal)
		arrow.alpha = 0.2
		arrow.contentMode = UIViewContentMode.ScaleAspectFill
		arrow.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(cellView.snp_right).offset(-18)
			make.centerY.equalTo(cellView.snp_centerY)
			make.height.equalTo(25)
			make.width.equalTo(15)
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
			return "ApplicantCell"
		}
	}
	
	//MARK: Setters
	
	func replaceArrowImage() {
		self.rightButton.setBackgroundImage(UIImage(named: "revert"), forState: UIControlState.Normal)
		self.rightButton.addTarget(self, action: "revertButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		self.rightButton.snp_updateConstraints{ (make) -> Void in
			make.height.equalTo(50)
			make.width.equalTo(50)
			make.centerY.equalTo(self.cellView.snp_centerY)
			make.right.equalTo(self.cellView.snp_right).offset(-8)
		}
	}
	
	func setApplicant(applicant: User) {
		self.applicant = applicant
		self.setImages(applicant)
		self.name.text = applicant.name
		self.ratingStarsView.userCompletedTasks = applicant.completedTasks
		self.ratingStarsView.userRating = applicant.rating
	}
	
	func setApplication(application: NelpTaskApplication){
		self.applicationPrice = application.price!
		moneyLabel.text = "$\(applicationPrice)"
	}
	
	func setImages(applicant:User) {
		if(applicant.profilePictureURL != nil) {
			let fbProfilePicture = applicant.profilePictureURL
			request(.GET,fbProfilePicture!).response() {
				(_, _, data, _) in
				let image = UIImage(data: data as NSData!)
				self.picture.image = image
			}
		}
	}
	
	func revertButtonTapped(sender:UIButton) {
		self.delegate!.didTapRevertButton(self.applicant)
	}
}