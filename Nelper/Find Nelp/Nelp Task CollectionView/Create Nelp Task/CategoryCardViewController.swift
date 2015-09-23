//
//  CategoryCardViewController.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-09-22.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation
import UIKit

class CategoryCardViewController:UIView{
	
	var category:String?
	var kCategoryIconSize:CGFloat = 70
	var kCardHeight:CGFloat = 240
	
	init(frame:CGRect,category:String){
			super.init(frame: frame)
			self.category = category
			self.createView()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func createView(){
		self.layer.borderColor = darkGrayDetails.CGColor
		self.layer.borderWidth = 0.5
		self.backgroundColor = navBarColor
		let categoryIcon = UIImageView()
		self.addSubview(categoryIcon)
		categoryIcon.image = UIImage(named: self.category!)
		categoryIcon.layer.cornerRadius = kCategoryIconSize / 2
		categoryIcon.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self).offset(20)
			make.centerX.equalTo(self.snp_centerX)
			make.width.equalTo(kCategoryIconSize)
			make.height.equalTo(kCategoryIconSize)
		}
	
		if self.category != "other" {
		let title = UILabel()
		title.textColor = blackNelpyColor
		title.font = UIFont(name: "Lato-Regular", size: kFormViewLabelFontSize)
		title.text = self.getTitle()
		self.addSubview(title)
		title.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(categoryIcon.snp_bottom).offset(10)
			make.centerX.equalTo(self.snp_centerX)
		}
		
		let examples = UITextView()
		self.addSubview(examples)
		examples.editable = false
		examples.selectable = false
		examples.scrollEnabled = false
		examples.backgroundColor = navBarColor
		examples.font = UIFont(name: "Lato-Light", size: kFormViewExamplesFontSize)
		examples.textColor = blackNelpyColor
		examples.textAlignment = NSTextAlignment.Center
		examples.text = self.getExamples()
		examples.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(title.snp_bottom).offset(10)
			make.left.equalTo(self.snp_left).offset(20)
			make.right.equalTo(self.snp_right).offset(-20)
			make.bottom.equalTo(self.snp_bottom).offset(-10)
		}
		}
		
	}
	
	//MARK: Utilities
	
	/**
	Returns the proper title based on the category
	*/
	func getTitle() -> String{
		switch self.category!{
			case "technology":
				return "Electronic & IT Support"
			case "business":
				return "Business & Admin"
			case "multimedia":
				return "Multimedia & Design"
			case "gardening":
				return "Gardening"
			case "handywork":
				return "Handyman"
			case "housecleaning":
				return "Cleaning"
			case "other":
				return "Other"
			default:
				return "Oops"
		}
	}
	
	/**
	Returns the proper examples based on the category
	
	- returns: returns the examples string
	*/
	func getExamples() ->String {
		switch self.category!{
		case "technology":
			return "Computer Repair,Internet/Router setup, Printer installation, TV & Sound System Installation, Email setup, Tablets & Phone support and more!"
		case "business":
			return "Accounting,Files Organization, Resume Building, Letters writing & review, Advertisement, Social Media Account Management, Data Entry and more!"
		case "multimedia":
			return "Website & App development, Photo & Video Editing, Graphic Design, Printing, Videography & Photography, Music Production, and more!"
		case "gardening":
			return "Garden Maintenance, Landscaping, Lawn Mowing, Raking Leaves, Outdoor Pest Control, Arborism, Fruit Tree Pruning, Tree Planting, Bushes Pruning and more!"
		case "handywork":
			return "Furniture Assembling, Carpentry, Electrical Work, Painting, Plumbing, Roofing, Window Services, Appliance Repair, Floor Installation and more!"
		case "housecleaning":
			return "House Cleaning, Laundry Services, Waste Removal, Guttering, Pool & Spa Cleaning, Steam Cleaning, Indoor Pest Control, Car Wash, and more!"
		case "other":
			return ""
		default:
			return "Oops"
		}
	}
	
}
