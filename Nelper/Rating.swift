//
//  Rating.swift
//  Nelper
//
//  Created by Pierre-Luc Benoit on 2015-09-26.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation
import UIKit

class RatingStars: UIView {
	
	private var starImages = [UIImageView]()
	private var taskCompletedLabel: UILabel!
	
	var starWidth = 18
	var starHeight = 18
	var starPadding = 6
	
	var style: String?
	var styleColor: UIColor!
	var styleImage: String!
	
	var userRating = Double() {
		didSet {
			setRatingView()
		}
	}
	var userCompletedTasks: Int? {
		didSet {
			taskCompletedLabel.text = "(10)"
		}
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		setRatingView()
	}
	
	required init(coder: NSCoder) {
		super.init(coder: coder)!
		setRatingView()
	}
	
	func setRatingView() {
		for subview in self.subviews {
			subview.removeFromSuperview()
		}
		
		starImages.removeAll(keepCapacity: true)
		
		//Style
		if self.style == "light" {
			styleColor = whitePrimary
			styleImage = "empty_star_white"
		} else if self.style == "dark" {
			styleColor = blackPrimary
			styleImage = "empty_star"
		} else {
			styleColor = whitePrimary
			styleImage = "empty_star_white"
		}
		
		//Stars
		for index in 0...4 {
			let starImage = UIImageView(frame: CGRect(x: index * (starWidth + starPadding), y: 0, width: starWidth, height: starWidth))
			starImage.image = UIImage(named: styleImage)
			
			self.addSubview(starImage)

			if Double(index) >= round(userRating) {
				starImage.alpha = 0.2
			}
			
			starImages.append(starImage)
		}
		
		//Number of tasks completed
		let taskCompletedLabel = UILabel(frame: CGRect(x: starImages[4].frame.maxX + 8, y: 0, width: 30, height: 18))
		taskCompletedLabel.textColor = styleColor
		taskCompletedLabel.font = UIFont(name: "Lato-Light", size: kTitle17)
		self.addSubview(taskCompletedLabel)
	}
}
