//
//  NelpApplicationsTableViewCell.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-08-16.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class NelpApplicationsTableViewCell: UITableViewCell {
	
	var titleLabel: UILabel!
	var price:UILabel!
	var category:UILabel!
	var categoryIcon:UIImageView!
	//	var categoryLabel:UILabel!
	var topContainer:UIImageView!
	var appliedDate: UILabel!
	var applicationStateIcon: UIImageView!
	var applicationStateLabel: UILabel!
	var distanceLabel: UILabel!
	var cityLabel: UILabel!
	var nelpApplication: TaskApplication!
	
	//MARK: Initialization

	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.clipsToBounds = true
		let backView = UIView(frame: self.bounds)
		backView.clipsToBounds = true
		backView.backgroundColor = whiteBackground
		backView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight];
		
		//CellContainer (hackForSpacing)
		let cellView = UIView()
		cellView.backgroundColor = whitePrimary
		backView.addSubview(cellView)
		cellView.layer.borderWidth = 1
		cellView.layer.borderColor = grayDetails.CGColor
		cellView.layer.masksToBounds = true
		cellView.clipsToBounds = true
		cellView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(backView).offset(12)
			make.left.equalTo(backView).offset(12)
			make.right.equalTo(backView).offset(-12)
			make.bottom.equalTo(backView).offset(-4)
		}
		
		//Top container
		let topContainer = UIImageView()
		self.topContainer = topContainer
		self.topContainer.clipsToBounds = true
		self.topContainer.layer.masksToBounds = true
		topContainer.layer.borderWidth = 1
		topContainer.layer.borderColor = grayDetails.CGColor
		cellView.addSubview(topContainer)
		topContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(cellView.snp_top)
			make.right.equalTo(cellView.snp_right)
			make.left.equalTo(cellView.snp_left)
			make.height.equalTo(85)
		}
		topContainer.backgroundColor = whitePrimary
		
		//Category Icon
		let categoryIcon = UIImageView()
		self.categoryIcon = categoryIcon
		topContainer.addSubview(categoryIcon)
		categoryIcon.snp_makeConstraints { (make) -> Void in
			make.center.equalTo(topContainer.snp_center)
			make.height.equalTo(60)
			make.width.equalTo(60)
		}
		
		//		var categoryLabel = UILabel()
		//		self.categoryLabel = categoryLabel
		//		categoryLabel.textColor = blackPrimary
		//		categoryLabel.font = UIFont(name: "ABeeZee-Regular", size: kText15)
		//		topContainer.addSubview(categoryLabel)
		//		categoryLabel.snp_makeConstraints { (make) -> Void in
		//			make.left.equalTo(categoryIcon.snp_right).offset(4)
		//			make.centerY.equalTo(categoryIcon.snp_centerY)
		//		}
		
		//Title Label
		let titleLabel = UILabel()
		self.titleLabel = titleLabel
		titleLabel.textColor = blackPrimary
		titleLabel.font = UIFont(name: "Lato-Regular", size: kText15)
		cellView.addSubview(titleLabel)
		titleLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(topContainer.snp_bottom).offset(4)
			make.left.equalTo(cellView.snp_left).offset(12)
			make.height.equalTo(40)
		}
		
		//Application State Icon + Label
		let applicationStateIcon = UIImageView()
		self.applicationStateIcon = applicationStateIcon
		cellView.addSubview(applicationStateIcon)
		applicationStateIcon.contentMode = UIViewContentMode.ScaleAspectFill
		applicationStateIcon.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(titleLabel.snp_bottom).offset(6)
			make.left.equalTo(cellView.snp_left).offset(30)
			make.height.equalTo(30)
			make.width.equalTo(30)
		}
		
		let applicationLabel = UILabel()
		self.applicationStateLabel = applicationLabel
		cellView.addSubview(applicationLabel)
		applicationLabel.font = UIFont(name: "Lato-Light", size: kText14)
		applicationLabel.textColor = blackPrimary
		
		applicationLabel.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(applicationStateIcon.snp_right).offset(10)
			make.centerY.equalTo(applicationStateIcon.snp_centerY)
		}
		
		//Price tag
		
		/*let moneyTag = UIImageView()
		cellView.addSubview(moneyTag)
		moneyTag.image = UIImage(named: "moneytag")
		moneyTag.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(applicationLabel.snp_centerY)
			make.right.equalTo(cellView.snp_right).offset(-40)
			make.width.equalTo(70)
			make.height.equalTo(35)
		}*/
		
		let moneyContainer = UIView()
		cellView.addSubview(moneyContainer)
		moneyContainer.backgroundColor = whiteBackground
		moneyContainer.layer.cornerRadius = 3
		moneyContainer.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(applicationLabel.snp_centerY)
			make.right.equalTo(cellView.snp_right).offset(-30)
			make.width.equalTo(65)
			make.height.equalTo(38)
		}
		
		let moneyLabel = UILabel()
		self.price = moneyLabel
		moneyContainer.addSubview(moneyLabel)
		moneyLabel.textAlignment = NSTextAlignment.Center
		moneyLabel.textColor = blackPrimary
		moneyLabel.font = UIFont(name: "Lato-Light", size: kText15)
		moneyLabel.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(moneyContainer.snp_edges)
		}
		self.addSubview(backView)
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
			return "NelpApplicationsTableViewCell"
		}
	}
	
	//MARK: Setters
	
	func setImages(nelpApplication:TaskApplication) {
		self.categoryIcon.layer.cornerRadius = self.categoryIcon.frame.size.width / 2
		self.categoryIcon.clipsToBounds = true
		self.categoryIcon.image = UIImage(named: nelpApplication.task.category!)
		
		setStateInformation(nelpApplication)
		
		if(nelpApplication.task.pictures != nil) {
			if(!nelpApplication.task.pictures!.isEmpty){
				getPictures(nelpApplication.task.pictures![0].url! , block: { (imageReturned:UIImage) -> Void in
					self.topContainer.image = imageReturned.blurredImageWithRadius(14, iterations: 2, tintColor: nil)
				})}} else {
			self.topContainer.image = UIImage(named: "square_\(nelpApplication.task.category!)")!.blurredImageWithRadius(14, iterations: 2, tintColor: nil)
		}
		self.topContainer.contentMode = .ScaleAspectFill
		self.topContainer.clipsToBounds = true
	}
	
	func setStateInformation(nelpApplication:TaskApplication) {
		
		if nelpApplication.state.rawValue == 0 {
			self.applicationStateIcon.image = UIImage(named: "pending.png")!
			self.applicationStateLabel.text = "Pending"
		} else if nelpApplication.state.rawValue == 2 {
			self.applicationStateIcon.image = UIImage(named: "accepted.png")!
			self.applicationStateLabel.text = "Accepted"
		} else if nelpApplication.state.rawValue == 3 {
			self.applicationStateIcon.image = UIImage(named: "denied.png")!
			self.applicationStateLabel.text = "Denied"
		}
		
	}
	
	func getPictures(imageURL: String, block: (UIImage) -> Void) -> Void {
		var image: UIImage!
		request(.GET,imageURL).response() {
			(_, _, data, error) in
			if(error != nil) {
				print(error)
			}
			image = UIImage(data: data as NSData!)
			block(image)
		}
	}
	
	
	func setNelpApplication(nelpApplication: TaskApplication) {
		self.nelpApplication = nelpApplication
		//		self.categoryLabel.text = task.category!.uppercaseString
		self.titleLabel.text = nelpApplication.task.title
		let price = String(format: "%.0f", nelpApplication.task.priceOffered!)
		self.price.text = "$"+price
	}
}
	
	