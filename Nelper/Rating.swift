//
//  Rating.swift
//  Nelper
//
//  Created by Pierre-Luc Benoit on 2015-09-26.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation
import UIKit

class ratingStars: UIView {
	
	private var starImages = [UIImageView]()
	
	var starWidth = 20
	var starHeight = 20
	var starPadding = 10
	
	var rating = Int() {
		didSet {
			setStars()
		}
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		createView()
	}
	
	required init(coder: NSCoder) {
		super.init(coder: coder)!
		createView()
	}
	
	func setStars() {
		for starImage in starImages {
			starImage.image = UIImage(named: "empty_star_white")
			starImage.snp_makeConstraints { (make) -> Void in
				make.width.equalTo(starWidth)
				make.height.equalTo(starHeight)
			}
		}
		
		for index in 0...5 {
			let starImage = UIImageView()
			starImage.snp_makeConstraints { (make) -> Void in
				make.left.equalTo(self.snp_left).offset(index * (starWidth + starPadding))
			}
			self.insertSubview(starImage, atIndex: 0)
			
			starImages.append(starImage)
		}
	}
	
	func createView() {
		
	}
}
