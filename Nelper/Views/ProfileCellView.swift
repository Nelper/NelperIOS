//
//  ProfileCellView.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-11-16.
//  Copyright © 2015 Nelper. All rights reserved.
//

import UIKit

class ProfileCellView: UIView {
	
	var picture: UIImageView!
	var button: UIButton!
	
	var userName: String!
	var rating: Double!
	var completedTasks: Int!

	init(user: User) {
		super.init(frame: CGRectZero)

		self.createView(user)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	func createView(user: User) {
		
		let profileContainer = UIButton()
		self.button = profileContainer
		self.addSubview(profileContainer)
		profileContainer.layer.borderColor = Color.grayDetails.CGColor
		profileContainer.layer.borderWidth = 1
		profileContainer.backgroundColor = Color.whitePrimary
		profileContainer.setBackgroundColor(Color.grayDetails, forState: .Highlighted)
		profileContainer.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self)
		}
		
		let profilePicture = UIImageView()
		self.picture = profilePicture
		profileContainer.addSubview(profilePicture)
		let pictureSize:CGFloat = 70
		profilePicture.contentMode = UIViewContentMode.ScaleAspectFill
		profilePicture.layer.cornerRadius = pictureSize / 2
		profilePicture.clipsToBounds = true
		profilePicture.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(profileContainer.snp_centerY)
			make.left.equalTo(20)
			make.height.equalTo(pictureSize)
			make.width.equalTo(pictureSize)
		}
		
		let spacing = 6
		
		let nameLabel = UILabel()
		profileContainer.addSubview(nameLabel)
		nameLabel.text = user.name
		nameLabel.textColor = Color.blackPrimary
		nameLabel.font = UIFont(name: "Lato-Regular", size: kTitle17)
		nameLabel.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(profilePicture.snp_centerY).offset(-spacing)
			make.left.equalTo(profilePicture.snp_right).offset(18)
		}
		
		let ratingStarsView = RatingStars()
		ratingStarsView.style = "dark"
		ratingStarsView.starHeight = 15
		ratingStarsView.starWidth = 15
		ratingStarsView.starPadding = 5
		ratingStarsView.textSize = kText15
		profileContainer.addSubview(ratingStarsView)
		ratingStarsView.userRating = user.rating
		ratingStarsView.userCompletedTasks = user.completedTasks
		ratingStarsView.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(nameLabel.snp_left)
			make.top.equalTo(picture.snp_centerY).offset(spacing)
			make.width.equalTo((ratingStarsView.starWidth + ratingStarsView.starPadding) * 6)
			make.height.equalTo(ratingStarsView.starHeight)
		}
		
		let arrow = UIImageView()
		profileContainer.addSubview(arrow)
		arrow.image = UIImage(named: "arrow_applicant_cell")
		arrow.contentMode = .ScaleAspectFit
		arrow.alpha = 0.3
		arrow.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(profileContainer.snp_right).offset(-20)
			make.centerY.equalTo(profileContainer.snp_centerY)
			make.height.equalTo(30)
			make.width.equalTo(30)
		}
	}
}
