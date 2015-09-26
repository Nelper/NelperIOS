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
	
	var starWidth = 18
	var starHeight = 18
	var starPadding = 6
	
	var style: String?
	var styleColor: UIColor!
	
	var userRating = Int() {
		didSet {
			
		}
	}
	var userCompletedTasks: Int?

	override init(frame: CGRect) {
		super.init(frame: frame)
		setRatingView()
		adjustUI()
	}
	
	required init(coder: NSCoder) {
		super.init(coder: coder)!
		setRatingView()
		adjustUI()
	}
	
	func adjustUI() {
		if self.style == "light" {
			styleColor = whiteGrayColor
		} else if self.style == "dark" {
			styleColor = blackNelpyColor
		} else {
			styleColor = whiteGrayColor
		}
	}
	
	func setRatingView() {
		//Stars
		for index in 0...4 {
			let starImage = UIImageView(frame: CGRect(x: index * (starWidth + starPadding), y: 0, width: starWidth, height: starWidth))
			starImage.image = UIImage(named: "empty_star")
			
			self.addSubview(starImage)
			
			starImages.append(starImage)
		}
		
		//Number of tasks completed
		let taskCompletedLabel = UILabel(frame: CGRect(x: starImages[4].frame.maxX + 8, y: 0, width: 30, height: 18))
		taskCompletedLabel.text = "(\(userCompletedTasks))"
		taskCompletedLabel.textColor = styleColor
		taskCompletedLabel.font = UIFont(name: "Lato-Light", size: kText14)
		self.addSubview(taskCompletedLabel)
	}
}
